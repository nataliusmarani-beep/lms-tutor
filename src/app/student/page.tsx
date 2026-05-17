import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import ProgressRing from "@/components/ProgressRing";
import { format } from "date-fns";
import { t } from "@/lib/i18n";
import { getLang } from "@/lib/getLang";

interface CourseModule {
  id: string;
  title: string;
  focus: string | null;
  icon: string;
  week_number: number | null;
  sort_order: number;
  course_id: string;
}

interface EnrolledCourse {
  id: string;
  title: string;
  icon: string;
  icon_url?: string | null;
  description: string | null;
  modules: CourseModule[];
}

interface SessionRow {
  id: string;
  date: string;
  duration_minutes: number;
  tutor_notes: string | null;
  photo_url: string | null;
  student_notes: string | null;
  course_module_id: string | null;
  module_id: number | null;
}

interface CompletionRow {
  item_key: string;
  course_module_id: string | null;
  module_id: number | null;
}

interface ChecklistItemRow {
  course_module_id: string;
  item_key: string;
}

export default async function StudentDashboard() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || profile.role !== "student") redirect("/login");

  const lang = getLang();

  // Fetch enrollments with course data
  const { data: enrollments } = await supabase
    .from("course_enrollments")
    .select("course_id, courses(id, title, icon, icon_url, description)")
    .eq("student_id", user.id);

  const rawCourses = (enrollments ?? []).map((e: { course_id: string; courses: unknown }) => e.courses) as Array<{
    id: string;
    title: string;
    icon: string;
    icon_url?: string | null;
    description: string | null;
  }>;

  // For each enrolled course, fetch its modules
  const enrolledCourses: EnrolledCourse[] = await Promise.all(
    rawCourses.map(async (course) => {
      const { data: modules } = await supabase
        .from("course_modules")
        .select("*")
        .eq("course_id", course.id)
        .order("sort_order");
      return { ...course, modules: (modules ?? []) as CourseModule[] };
    })
  );

  // Fetch all sessions and completions for this student
  const [{ data: sessions }, { data: checks }] = await Promise.all([
    supabase
      .from("learning_sessions")
      .select("id, date, duration_minutes, tutor_notes, student_notes, course_module_id, module_id")
      .eq("student_id", user.id)
      .order("date", { ascending: false }),
    supabase
      .from("checklist_completions")
      .select("item_key, course_module_id, module_id")
      .eq("student_id", user.id),
  ]);

  const sessionList = (sessions ?? []) as SessionRow[];
  const checkList = (checks ?? []) as CompletionRow[];

  // Fetch checklist item counts per course_module_id (for progress)
  const allModuleIds = enrolledCourses.flatMap((c) => c.modules.map((m) => m.id));
  const { data: itemCounts } = await supabase
    .from("module_checklist_items")
    .select("course_module_id, item_key")
    .in("course_module_id", allModuleIds.length > 0 ? allModuleIds : ["__none__"]);

  const itemsByModule: Record<string, ChecklistItemRow[]> = {};
  for (const item of (itemCounts ?? []) as ChecklistItemRow[]) {
    if (!item.course_module_id) continue;
    if (!itemsByModule[item.course_module_id]) itemsByModule[item.course_module_id] = [];
    itemsByModule[item.course_module_id].push(item);
  }

  // Compute per-module progress
  function moduleProgress(moduleId: string) {
    const items = itemsByModule[moduleId] ?? [];
    const completed = checkList.filter(
      (c) => c.course_module_id === moduleId
    ).length;
    const total = items.length;
    return { completed, total, pct: total > 0 ? Math.round((completed / total) * 100) : 0 };
  }

  // Overall stats
  const totalSessions = sessionList.length;
  const totalMinutes = sessionList.reduce((a, s) => a + s.duration_minutes, 0);
  const totalHours = Math.round((totalMinutes / 60) * 10) / 10;

  const allModuleProgressValues = enrolledCourses
    .flatMap((c) => c.modules.map((m) => moduleProgress(m.id).pct));
  const overallPct =
    allModuleProgressValues.length > 0
      ? Math.round(allModuleProgressValues.reduce((a, b) => a + b, 0) / allModuleProgressValues.length)
      : 0;
  const completedModules = allModuleProgressValues.filter((p) => p === 100).length;

  // Build a map of course_module_id -> module info for sessions display
  const moduleMap: Record<string, CourseModule> = {};
  for (const course of enrolledCourses) {
    for (const mod of course.modules) {
      moduleMap[mod.id] = mod;
    }
  }

  const recentSessions = sessionList.slice(0, 5);

  const cardThemes = [
    { bg: "bg-teal-50",   bar: "from-teal-400 to-teal-500",   progress: "bg-teal-500",   pct: "text-teal-600"   },
    { bg: "bg-amber-50",  bar: "from-amber-400 to-amber-500",  progress: "bg-amber-500",  pct: "text-amber-600"  },
    { bg: "bg-yellow-50", bar: "from-yellow-400 to-yellow-500", progress: "bg-yellow-500", pct: "text-yellow-600" },
    { bg: "bg-rose-50",   bar: "from-rose-400 to-rose-500",    progress: "bg-rose-500",   pct: "text-rose-600"   },
    { bg: "bg-violet-50", bar: "from-violet-400 to-violet-500", progress: "bg-violet-500", pct: "text-violet-600" },
    { bg: "bg-sky-50",    bar: "from-sky-400 to-sky-500",      progress: "bg-sky-500",    pct: "text-sky-600"    },
  ];

  return (
    <div className="min-h-screen">
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-8">

        {/* Welcome banner */}
        <div className="rounded-2xl bg-gradient-to-r from-teal-500 to-cyan-600 p-6 text-white shadow-md flex items-center gap-4">
          <div className="w-16 h-16 rounded-full overflow-hidden bg-teal-500 flex items-center justify-center shrink-0 ring-2 ring-white/40">
            {profile.avatar_url ? (
              <img src={profile.avatar_url} alt={profile.name} className="w-full h-full object-cover" />
            ) : (
              <span className="text-2xl font-bold text-white">{profile.name[0]?.toUpperCase()}</span>
            )}
          </div>
          <div className="flex-1">
            <h1 className="text-2xl font-bold">{t(lang, "hiGreeting")}, {profile.name.split(" ")[0]}! 👋</h1>
            <p className="mt-1 text-teal-100 text-sm">
              {enrolledCourses.length} {t(lang, "coursesEnrolled")}
            </p>
          </div>
          <ProgressRing percent={overallPct} size={72} strokeWidth={7} label="Overall" />
        </div>

        {/* Stat cards */}
        <div className="grid grid-cols-3 gap-4">
          <div className="card text-center">
            <div className="text-2xl mb-1">📅</div>
            <div className="text-2xl font-bold text-teal-600">{totalSessions}</div>
            <div className="text-sm text-slate-500">{t(lang, "sessions")}</div>
          </div>
          <div className="card text-center">
            <div className="text-2xl mb-1">⏱️</div>
            <div className="text-2xl font-bold text-teal-600">{totalHours}h</div>
            <div className="text-sm text-slate-500">{t(lang, "learningTime")}</div>
          </div>
          <div className="card text-center">
            <div className="text-2xl mb-1">✅</div>
            <div className="text-2xl font-bold text-teal-600">{completedModules}</div>
            <div className="text-sm text-slate-500">{t(lang, "modulesDone")}</div>
          </div>
        </div>

        {/* Enrolled Courses */}
        {enrolledCourses.length === 0 ? (
          <div className="card text-center py-16">
            <div className="text-5xl mb-4">📚</div>
            <p className="text-slate-500">{t(lang, "noCoursesYet")}</p>
            <p className="text-slate-400 text-sm mt-2">{t(lang, "askTutorEnroll")}</p>
          </div>
        ) : (
          enrolledCourses.map((course, courseIdx) => {
            const theme = cardThemes[courseIdx % cardThemes.length];
            const courseChecks = checkList.filter((c) =>
              course.modules.some((m) => m.id === c.course_module_id)
            ).length;
            const courseItems = course.modules.reduce(
              (a, m) => a + (itemsByModule[m.id]?.length ?? 0),
              0
            );
            const coursePct =
              courseItems > 0 ? Math.round((courseChecks / courseItems) * 100) : 0;

            return (
              <div key={course.id}>
                {/* Course heading with accent bar */}
                <div className="flex items-center gap-3 mb-3">
                  <div className={`w-1 h-8 rounded-full bg-gradient-to-b ${theme.bar}`} />
                  {course.icon_url
                    ? <div className="w-8 h-8 rounded-xl overflow-hidden shrink-0"><img src={course.icon_url} alt={course.title} className="w-full h-full object-cover" /></div>
                    : <span className="text-2xl">{course.icon}</span>}
                  <div className="flex-1">
                    <h2 className="text-lg font-semibold text-slate-700">{course.title}</h2>
                    {course.description && (
                      <p className="text-sm text-slate-500">{course.description}</p>
                    )}
                  </div>
                  <span className="badge-blue">{coursePct}{t(lang, "percentComplete")}</span>
                </div>

                {course.modules.length === 0 ? (
                  <p className="text-sm text-slate-400 italic ml-10">{t(lang, "noModulesYet")}</p>
                ) : (
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 ml-0">
                    {course.modules.map((mod) => {
                      const mp = moduleProgress(mod.id);
                      return (
                        <Link
                          key={mod.id}
                          href={`/student/courses/${course.id}/modules/${mod.id}`}
                          className={`${theme.bg} rounded-2xl shadow-sm border border-slate-100 hover:shadow-md transition-shadow flex items-stretch gap-0 overflow-hidden p-0`}
                        >
                          {/* Left accent bar */}
                          <div className={`w-1 rounded-l-2xl bg-gradient-to-b ${theme.bar} shrink-0`} />
                          <div className="flex items-start gap-3 p-4 flex-1 min-w-0">
                            <span className="text-2xl mt-0.5 shrink-0">{mod.icon}</span>
                            <div className="flex-1 min-w-0">
                              <div className="flex items-center gap-2 mb-0.5 flex-wrap">
                                {mod.week_number && (
                                  <span className="badge-gray text-xs">{t(lang, "week")} {mod.week_number}</span>
                                )}
                              </div>
                              <div className="font-medium text-slate-800 text-sm leading-tight">
                                {mod.title}
                              </div>
                              {mod.focus && (
                                <p className="text-xs text-slate-500 mt-0.5 line-clamp-1">{mod.focus}</p>
                              )}
                              <div className="mt-2">
                                <div className="flex items-center justify-between mb-1">
                                  <span className="text-xs text-slate-400">
                                    {mp.completed}/{mp.total} {t(lang, "items")}
                                  </span>
                                  <span
                                    className={`text-xs font-semibold ${
                                      mp.pct >= 100
                                        ? "text-emerald-600"
                                        : mp.pct > 0
                                        ? theme.pct
                                        : "text-slate-400"
                                    }`}
                                  >
                                    {mp.pct}%
                                  </span>
                                </div>
                                <div className="w-full bg-slate-200 rounded-full h-1.5">
                                  <div
                                    className={`h-1.5 rounded-full ${
                                      mp.pct >= 100 ? "bg-emerald-500" : theme.progress
                                    }`}
                                    style={{ width: `${mp.pct}%` }}
                                  />
                                </div>
                              </div>
                            </div>
                          </div>
                        </Link>
                      );
                    })}
                  </div>
                )}
              </div>
            );
          })
        )}

        {/* Recent Sessions */}
        <div>
          <h2 className="text-lg font-semibold text-slate-700 mb-4">{t(lang, "recentSessions")}</h2>
          {recentSessions.length === 0 ? (
            <div className="card text-center py-8">
              <p className="text-slate-400">{t(lang, "noSessionsYet")}</p>
            </div>
          ) : (
            <div className="space-y-2">
              {recentSessions.map((s) => {
                const mod = s.course_module_id ? moduleMap[s.course_module_id] : null;
                return (
                  <div key={s.id} className="card flex items-center gap-3 py-3">
                    <span className="text-xl">{mod?.icon ?? "📅"}</span>
                    <div className="flex-1">
                      <div className="text-sm font-medium text-slate-700">
                        {mod ? mod.title : s.module_id ? `Module ${s.module_id}` : "Session"}
                      </div>
                      {s.tutor_notes && (
                        <p className="text-xs text-slate-500 mt-0.5 line-clamp-1">{s.tutor_notes}</p>
                      )}
                    </div>
                    <div className="text-right">
                      <div className="text-sm font-medium text-slate-700">{s.duration_minutes} min</div>
                      <div className="text-xs text-slate-400">{format(new Date(s.date), "MMM d")}</div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
