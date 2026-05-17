import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import Navbar from "@/components/Navbar";
import ProgressRing from "@/components/ProgressRing";
import type { Profile } from "@/types";
import { t } from "@/lib/i18n";
import { getLang } from "@/lib/getLang";

interface CourseRow {
  id: string;
  title: string;
  description: string | null;
  icon: string;
}

const WEEKLY_TARGET_MINUTES = 270;
const MINUTES_PER_SESSION = 90;
const WEEKLY_TARGET_SESSIONS = WEEKLY_TARGET_MINUTES / MINUTES_PER_SESSION; // 3

function getWeekStart(): string {
  const now = new Date();
  const day = now.getDay(); // 0=Sun … 6=Sat
  const diffToMonday = day === 0 ? -6 : 1 - day;
  const monday = new Date(now);
  monday.setDate(now.getDate() + diffToMonday);
  monday.setHours(0, 0, 0, 0);
  return monday.toISOString();
}

async function getStudentProgress(
  supabase: ReturnType<typeof createClient>,
  studentId: string
) {
  const weekStart = getWeekStart();

  const [{ data: sessions }, { data: checks }] = await Promise.all([
    supabase
      .from("learning_sessions")
      .select("module_id, duration_minutes, date")
      .eq("student_id", studentId),
    supabase
      .from("checklist_completions")
      .select("item_key, module_id")
      .eq("student_id", studentId),
  ]);

  const completedChecks = checks?.length ?? 0;
  const totalMinutes =
    sessions?.reduce(
      (a: number, s: { duration_minutes: number }) => a + s.duration_minutes,
      0
    ) ?? 0;

  // This week's sessions — each counts as 90 min toward the 270-min goal
  const weekSessions = sessions?.filter((s: { date: string }) => s.date >= weekStart) ?? [];
  const weekSessionCount = weekSessions.length;
  const weekMinutes = weekSessionCount * MINUTES_PER_SESSION;
  const weekPct = Math.min(100, Math.round((weekSessionCount / WEEKLY_TARGET_SESSIONS) * 100));

  // Count unique modules started
  const modulesStarted = new Set(
    sessions
      ?.filter((s: { module_id: number | null }) => s.module_id)
      .map((s: { module_id: number | null }) => s.module_id) ?? []
  ).size;

  return {
    totalChecks: completedChecks,
    totalMinutes,
    totalHours: Math.round((totalMinutes / 60) * 10) / 10,
    modulesStarted,
    sessionsCount: sessions?.length ?? 0,
    weekMinutes,
    weekSessionCount,
    weekPct,
  };
}

export default async function TutorDashboard() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user.id)
    .single();
  if (!profile || profile.role !== "tutor") redirect("/login");

  const lang = getLang();

  const [{ data: students }, { data: courses }] = await Promise.all([
    supabase.from("profiles").select("*").eq("role", "student").order("name"),
    supabase.from("courses").select("*").order("created_at"),
  ]);

  const studentList = (students as Profile[]) ?? [];
  const courseList = (courses ?? []) as CourseRow[];

  // Enrich courses with module & student counts
  const enrichedCourses = await Promise.all(
    courseList.map(async (course) => {
      const [{ count: moduleCount }, { count: studentCount }] = await Promise.all([
        supabase
          .from("course_modules")
          .select("id", { count: "exact", head: true })
          .eq("course_id", course.id),
        supabase
          .from("course_enrollments")
          .select("id", { count: "exact", head: true })
          .eq("course_id", course.id),
      ]);
      return { ...course, moduleCount: moduleCount ?? 0, studentCount: studentCount ?? 0 };
    })
  );

  const progressList = await Promise.all(
    studentList.map(async (s) => ({
      id: s.id,
      progress: await getStudentProgress(supabase, s.id),
    }))
  );
  const progressMap = Object.fromEntries(
    progressList.map((p) => [p.id, p.progress])
  );

  const cardThemes = [
    { bg: "bg-teal-50",   bar: "from-teal-400 to-teal-500",    progress: "bg-teal-500"   },
    { bg: "bg-amber-50",  bar: "from-amber-400 to-amber-500",   progress: "bg-amber-500"  },
    { bg: "bg-yellow-50", bar: "from-yellow-400 to-yellow-500", progress: "bg-yellow-500" },
    { bg: "bg-rose-50",   bar: "from-rose-400 to-rose-500",     progress: "bg-rose-500"   },
    { bg: "bg-violet-50", bar: "from-violet-400 to-violet-500", progress: "bg-violet-500" },
    { bg: "bg-sky-50",    bar: "from-sky-400 to-sky-500",       progress: "bg-sky-500"    },
  ];

  return (
    <div className="min-h-screen">
      <Navbar name={profile.name} role="tutor" />
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-8">

        {/* Welcome banner */}
        <div className="rounded-2xl p-6 text-white shadow-md flex items-center gap-4" style={{ backgroundColor: "#0f1f3d" }}>
          <div className="flex-1">
            <h1 className="text-2xl font-bold">{t(lang, "welcomeBack")}, {profile.name.split(" ")[0]}! 👋</h1>
            <p className="mt-1 text-indigo-200 text-sm">
              {courseList.length} {t(lang, "courses").toLowerCase()} · {studentList.length} {t(lang, "students").toLowerCase()} · {t(lang, "readyToTeach")}
            </p>
          </div>
          <div className="w-16 h-16 rounded-full overflow-hidden bg-teal-500 flex items-center justify-center shrink-0 ring-2 ring-white/40">
            {profile.avatar_url ? (
              <img src={profile.avatar_url} alt={profile.name} className="w-full h-full object-cover" />
            ) : (
              <span className="text-2xl font-bold text-white">{profile.name[0]?.toUpperCase()}</span>
            )}
          </div>
        </div>

        {/* Stat cards */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
          <div className="card text-center">
            <div className="text-3xl mb-1">🎓</div>
            <div className="text-3xl font-bold text-teal-600">{studentList.length}</div>
            <div className="text-sm text-slate-500 mt-1">{t(lang, "students")}</div>
          </div>
          <div className="card text-center">
            <div className="text-3xl mb-1">📚</div>
            <div className="text-3xl font-bold text-teal-600">{courseList.length}</div>
            <div className="text-sm text-slate-500 mt-1">{t(lang, "courses")}</div>
          </div>
          <div className="card text-center">
            <div className="text-3xl mb-1">🗂️</div>
            <div className="text-3xl font-bold text-teal-600">
              {enrichedCourses.reduce((a, c) => a + c.moduleCount, 0)}
            </div>
            <div className="text-sm text-slate-500 mt-1">{t(lang, "modules")}</div>
          </div>
          <div className="card text-center">
            <div className="text-3xl mb-1">🎯</div>
            <div className="text-3xl font-bold text-teal-600">270</div>
            <div className="text-sm text-slate-500 mt-1">{t(lang, "minWeekGoal")}</div>
          </div>
        </div>

        {/* Courses Section */}
        <div>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-slate-700">{t(lang, "courses")}</h2>
            <Link href="/tutor/courses" className="btn-secondary text-sm py-1.5">{t(lang, "viewAll")}</Link>
          </div>
          {enrichedCourses.length === 0 ? (
            <div className="card text-center py-10">
              <div className="text-4xl mb-3">📚</div>
              <p className="text-slate-500 mb-3">No courses yet.</p>
              <Link href="/tutor/courses/new" className="btn-primary inline-block">Create First Course</Link>
            </div>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              {enrichedCourses.map((course, idx) => {
                const t = cardThemes[idx % cardThemes.length];
                return (
                <Link
                  key={course.id}
                  href={`/tutor/courses/${course.id}`}
                  className={`${t.bg} rounded-2xl shadow-sm border border-slate-100 hover:shadow-md transition-shadow flex items-stretch gap-0 overflow-hidden p-0`}
                >
                  {/* Color accent bar */}
                  <div className={`w-1.5 rounded-l-2xl bg-gradient-to-b ${t.bar} shrink-0`} />
                  <div className="flex items-center gap-3 p-4 flex-1 min-w-0">
                    <span className="text-3xl shrink-0">{course.icon}</span>
                    <div className="flex-1 min-w-0">
                      <div className="font-semibold text-slate-800 truncate">{course.title}</div>
                      {course.description && (
                        <p className="text-xs text-slate-500 mt-0.5 truncate">{course.description}</p>
                      )}
                      <div className="flex gap-2 mt-1">
                        <span className="badge-blue text-xs">{course.moduleCount} modules</span>
                        <span className="badge-green text-xs">{course.studentCount} students</span>
                      </div>
                    </div>
                    <span className="text-slate-300 shrink-0">›</span>
                  </div>
                </Link>
                );
              })}
            </div>
          )}
        </div>

        {/* Students Section */}
        <div>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-slate-700">{t(lang, "students")}</h2>
            <Link href="/tutor/students/new" className="btn-primary text-sm py-1.5">{t(lang, "addStudent")}</Link>
          </div>

          {studentList.length === 0 ? (
            <div className="card text-center py-12">
              <div className="text-4xl mb-3">👤</div>
              <p className="text-slate-500">No students yet.</p>
              <Link href="/tutor/students/new" className="btn-primary mt-4 inline-block">
                Add First Student
              </Link>
            </div>
          ) : (
            <div className="space-y-3">
              {studentList.map((student) => {
                const p = progressMap[student.id];
                const sessionsLeft = Math.max(0, WEEKLY_TARGET_SESSIONS - Math.round(p.weekMinutes / MINUTES_PER_SESSION));
                return (
                  <Link
                    key={student.id}
                    href={`/tutor/students/${student.id}`}
                    className="card flex items-center gap-4 hover:shadow-md transition-shadow"
                  >
                    {/* Avatar */}
                    <div className="w-12 h-12 rounded-full overflow-hidden bg-blue-100 flex items-center justify-center shrink-0">
                      {student.avatar_url ? (
                        <img src={student.avatar_url} alt={student.name} className="w-full h-full object-cover" />
                      ) : (
                        <span className="text-xl font-bold text-blue-700">{student.name[0]?.toUpperCase()}</span>
                      )}
                    </div>
                    {/* Weekly ring */}
                    <ProgressRing percent={p.weekPct} size={60} strokeWidth={6} />

                    <div className="flex-1 min-w-0">
                      <h3 className="font-semibold text-slate-800">{student.name}</h3>
                      <p className="text-sm text-slate-500">
                        {p.sessionsCount} {t(lang, "sessions").toLowerCase()} · {p.totalHours}h {t(lang, "totalTimeLabel")}
                      </p>
                      {/* Weekly bar */}
                      <div className="mt-1.5">
                        <div className="flex items-center justify-between mb-0.5">
                          <span className="text-xs text-slate-400">{t(lang, "thisWeek")}</span>
                          <span className={`text-xs font-semibold ${
                            p.weekPct >= 100 ? "text-green-600" : p.weekPct >= 50 ? "text-teal-600" : "text-slate-400"
                          }`}>
                            {p.weekMinutes} / {WEEKLY_TARGET_MINUTES} {t(lang, "min")}
                            {p.weekPct >= 100 ? " ✓" : ` · ${sessionsLeft} ${sessionsLeft !== 1 ? t(lang, "sessionsLeft") : t(lang, "sessionLeft")}`}
                          </span>
                        </div>
                        <div className="w-full bg-slate-100 rounded-full h-1.5">
                          <div
                            className={`h-1.5 rounded-full transition-all ${
                              p.weekPct >= 100 ? "bg-green-500" : p.weekPct >= 50 ? "bg-teal-500" : "bg-amber-400"
                            }`}
                            style={{ width: `${p.weekPct}%` }}
                          />
                        </div>
                      </div>
                    </div>

                    <div className="text-right shrink-0">
                      <span
                        className={`badge ${
                          p.weekPct >= 100
                            ? "badge-green"
                            : p.weekPct >= 50
                            ? "badge-blue"
                            : p.sessionsCount > 0
                            ? "badge-yellow"
                            : "badge-gray"
                        }`}
                      >
                        {p.weekPct >= 100
                          ? t(lang, "goalMet")
                          : p.weekPct >= 50
                          ? t(lang, "onTrack")
                          : p.sessionsCount > 0
                          ? t(lang, "behind")
                          : t(lang, "noSessions")}
                      </span>
                    </div>
                    <span className="text-slate-300">›</span>
                  </Link>
                );
              })}
            </div>
          )}
        </div>

        {/* Quick Actions */}
        <div>
          <h2 className="text-lg font-semibold text-slate-700 mb-4">{t(lang, "quickActions")}</h2>
          <div className="grid grid-cols-1 sm:grid-cols-4 gap-3">
            <Link
              href="/tutor/sessions/new"
              className="card hover:shadow-md transition-shadow flex items-center gap-3"
            >
              <span className="text-2xl">⏱️</span>
              <div>
                <div className="font-medium text-slate-800">{t(lang, "logSession")}</div>
                <div className="text-sm text-slate-500">{t(lang, "logSessionDesc")}</div>
              </div>
            </Link>
            <Link
              href="/tutor/students/new"
              className="card hover:shadow-md transition-shadow flex items-center gap-3"
            >
              <span className="text-2xl">👤</span>
              <div>
                <div className="font-medium text-slate-800">{t(lang, "students")}</div>
                <div className="text-sm text-slate-500">{t(lang, "addStudentDesc")}</div>
              </div>
            </Link>
            <Link
              href="/tutor/courses"
              className="card hover:shadow-md transition-shadow flex items-center gap-3"
            >
              <span className="text-2xl">📚</span>
              <div>
                <div className="font-medium text-slate-800">{t(lang, "courses")}</div>
                <div className="text-sm text-slate-500">{t(lang, "coursesDesc")}</div>
              </div>
            </Link>
            <Link
              href="/tutor/accounts"
              className="card hover:shadow-md transition-shadow flex items-center gap-3"
            >
              <span className="text-2xl">⚙️</span>
              <div>
                <div className="font-medium text-slate-800">{t(lang, "manageAccounts")}</div>
                <div className="text-sm text-slate-500">{t(lang, "manageAccountsDesc")}</div>
              </div>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
