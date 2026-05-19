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
  title_id?: string | null;
  focus: string | null;
  focus_id?: string | null;
  icon: string;
  week_number: number | null;
  sort_order: number;
  course_id: string;
  legacy_module_id: number | null;
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
  item_type: string;
}

export default async function ParentDashboard() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || profile.role !== "parent") redirect("/login");

  const lang = getLang();

  const { data: links } = await supabase
    .from("parent_student")
    .select("student_id")
    .eq("parent_id", user.id);

  const studentIds = links?.map((l: { student_id: string }) => l.student_id) ?? [];

  const { data: students } = await supabase
    .from("profiles")
    .select("*")
    .in("id", studentIds.length > 0 ? studentIds : ["none"]);

  const studentList = students ?? [];
  const student = studentList[0];
  const studentId = student?.id;

  if (!studentId) {
    return (
      <div className="max-w-2xl mx-auto px-4 py-16 text-center">
        <div className="text-5xl mb-4">👤</div>
        <h1 className="text-xl font-bold text-slate-700">{t(lang, "noStudentLinked")}</h1>
        <p className="text-slate-400 mt-2">{t(lang, "noStudentLinkedDesc")}</p>
      </div>
    );
  }

  // Enrolled courses
  const { data: enrollments } = await supabase
    .from("course_enrollments")
    .select("course_id, courses(id, title, icon, icon_url, description)")
    .eq("student_id", studentId);

  const rawCourses = (enrollments ?? []).map((e: { course_id: string; courses: unknown }) => e.courses) as Array<{
    id: string; title: string; icon: string; icon_url?: string | null; description: string | null;
  }>;

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

  // Sessions & completions
  const [{ data: sessions }, { data: checks }] = await Promise.all([
    supabase
      .from("learning_sessions")
      .select("id, date, duration_minutes, tutor_notes, photo_url, course_module_id, module_id")
      .eq("student_id", studentId)
      .order("date", { ascending: false }),
    supabase
      .from("checklist_completions")
      .select("item_key, course_module_id, module_id, item_type")
      .eq("student_id", studentId),
  ]);

  const sessionList = (sessions ?? []) as SessionRow[];
  const checkList = (checks ?? []) as CompletionRow[];

  // Checklist items per module
  const allModuleIds = enrolledCourses.flatMap((c) => c.modules.map((m) => m.id));
  const { data: itemCounts } = await supabase
    .from("module_checklist_items")
    .select("course_module_id, item_key, item_type")
    .in("course_module_id", allModuleIds.length > 0 ? allModuleIds : ["__none__"]);

  const itemsByModule: Record<string, ChecklistItemRow[]> = {};
  for (const item of (itemCounts ?? []) as ChecklistItemRow[]) {
    if (!item.course_module_id) continue;
    if (!itemsByModule[item.course_module_id]) itemsByModule[item.course_module_id] = [];
    itemsByModule[item.course_module_id].push(item);
  }

  const legacyIdByModuleId: Record<string, number | null> = {};
  for (const course of enrolledCourses) {
    for (const mod of course.modules) legacyIdByModuleId[mod.id] = mod.legacy_module_id ?? null;
  }

  function moduleProgress(moduleId: string) {
    const items = itemsByModule[moduleId] ?? [];
    const legacyId = legacyIdByModuleId[moduleId];
    const completedAll = checkList.filter(
      (c) => c.course_module_id === moduleId || (legacyId != null && c.module_id === legacyId)
    );
    const total = items.length;
    const completed = completedAll.length;
    return { completed, total, pct: total > 0 ? Math.round((completed / total) * 100) : 0 };
  }

  function courseProgress(course: EnrolledCourse) {
    const totalItems = course.modules.reduce((a, m) => a + (itemsByModule[m.id]?.length ?? 0), 0);
    const doneItems = checkList.filter((c) =>
      course.modules.some((m) => {
        const legacyId = legacyIdByModuleId[m.id];
        return c.course_module_id === m.id || (legacyId != null && c.module_id === legacyId);
      })
    ).length;
    const completedModules = course.modules.filter((m) => moduleProgress(m.id).pct === 100).length;
    const pct = totalItems > 0 ? Math.round((doneItems / totalItems) * 100) : 0;
    return { pct, completedModules, totalModules: course.modules.length };
  }

  // Overall stats
  const totalMinutes = sessionList.reduce((a, s) => a + s.duration_minutes, 0);
  const totalHours = Math.round((totalMinutes / 60) * 10) / 10;
  const allPcts = enrolledCourses.map((c) => courseProgress(c).pct);
  const overallPct = allPcts.length > 0 ? Math.round(allPcts.reduce((a, b) => a + b, 0) / allPcts.length) : 0;

  // Module map for session labels
  const moduleMap: Record<string, CourseModule> = {};
  for (const course of enrolledCourses) {
    for (const mod of course.modules) moduleMap[mod.id] = mod;
  }

  const recentSessions = sessionList.slice(0, 5);

  const courseColors = [
    { bar: "from-teal-400 to-teal-500", progress: "bg-teal-500", text: "text-teal-600" },
    { bar: "from-amber-400 to-amber-500", progress: "bg-amber-500", text: "text-amber-600" },
    { bar: "from-violet-400 to-violet-500", progress: "bg-violet-500", text: "text-violet-600" },
    { bar: "from-rose-400 to-rose-500", progress: "bg-rose-500", text: "text-rose-600" },
    { bar: "from-sky-400 to-sky-500", progress: "bg-sky-500", text: "text-sky-600" },
  ];

  return (
    <div className="min-h-screen">
      <div className="max-w-2xl mx-auto px-4 py-8 space-y-6">

        {/* Header — student info + overall progress */}
        <div
          className="rounded-2xl px-5 py-5 shadow-sm"
          style={{ background: "linear-gradient(135deg, #0f1f3d 0%, #134e5e 60%, #0d9488 100%)" }}
        >
          <div className="flex items-center gap-4">
            <div className="w-14 h-14 rounded-full overflow-hidden bg-blue-400 flex items-center justify-center shrink-0 ring-2 ring-white/40">
              {student.avatar_url
                ? <img src={student.avatar_url} alt={student.name} className="w-full h-full object-cover" />
                : <span className="text-xl font-bold text-white">{student.name[0]?.toUpperCase()}</span>}
            </div>
            <div className="flex-1">
              <p className="text-blue-200 text-xs">{t(lang, "progressReport")}</p>
              <h1 className="text-xl font-bold text-white">{student.name}</h1>
              <p className="text-blue-200 text-xs mt-0.5">
                {sessionList.length} {t(lang, "sessions").toLowerCase()} · {totalHours}h {t(lang, "learningTime").toLowerCase()}
              </p>
            </div>
            <ProgressRing percent={overallPct} size={60} strokeWidth={6} variant="dark" />
          </div>
        </div>

        {/* Courses */}
        <div>
          <h2 className="text-base font-semibold text-slate-700 mb-3">{t(lang, "courses")}</h2>
          {enrolledCourses.length === 0 ? (
            <div className="card text-center py-12">
              <div className="text-4xl mb-3">📚</div>
              <p className="text-slate-500 text-sm">{t(lang, "noCoursesYet")}</p>
            </div>
          ) : (
            <div className="space-y-3">
              {enrolledCourses.map((course, idx) => {
                const color = courseColors[idx % courseColors.length];
                const cp = courseProgress(course);
                return (
                  <Link
                    key={course.id}
                    href={`/parent/courses/${course.id}`}
                    className="flex items-stretch gap-0 rounded-2xl bg-white border border-slate-100 shadow-sm hover:shadow-md transition-shadow overflow-hidden"
                  >
                    <div className={`w-1.5 shrink-0 bg-gradient-to-b ${color.bar}`} />
                    <div className="flex items-center gap-3 p-4 flex-1 min-w-0">
                      {course.icon_url
                        ? <div className="w-12 h-12 rounded-xl overflow-hidden shrink-0"><img src={course.icon_url} alt={course.title} className="w-full h-full object-cover" /></div>
                        : <span className="text-3xl shrink-0">{course.icon}</span>}
                      <div className="flex-1 min-w-0">
                        <div className="font-semibold text-slate-800 leading-tight">{course.title}</div>
                        {course.description && (
                          <p className="text-xs text-slate-500 mt-0.5 line-clamp-2">{course.description}</p>
                        )}
                        <div className="mt-2 flex items-center gap-2">
                          <div className="flex-1 bg-slate-100 rounded-full h-1.5">
                            <div
                              className={`h-1.5 rounded-full ${cp.pct >= 100 ? "bg-emerald-500" : color.progress}`}
                              style={{ width: `${cp.pct}%` }}
                            />
                          </div>
                          <span className={`text-xs font-semibold shrink-0 ${cp.pct >= 100 ? "text-emerald-600" : color.text}`}>
                            {cp.pct}%
                          </span>
                        </div>
                        <p className="text-xs text-slate-400 mt-1">
                          {cp.completedModules} / {cp.totalModules} {t(lang, "modulesDone")}
                        </p>
                      </div>
                      <span className="text-slate-300 shrink-0 ml-1">›</span>
                    </div>
                  </Link>
                );
              })}
            </div>
          )}
        </div>

        {/* Recent Sessions */}
        <div>
          <h2 className="text-base font-semibold text-slate-700 mb-3">{t(lang, "recentSessions")}</h2>
          {recentSessions.length === 0 ? (
            <div className="card text-center py-8">
              <p className="text-slate-400 text-sm">{t(lang, "noSessionsYet")}</p>
            </div>
          ) : (
            <div className="space-y-2">
              {recentSessions.map((s) => {
                const mod = s.course_module_id ? moduleMap[s.course_module_id] : null;
                return (
                  <div key={s.id} className="card py-3 flex items-start gap-3">
                    {s.photo_url ? (
                      <a href={s.photo_url} target="_blank" rel="noopener noreferrer" className="shrink-0">
                        <img
                          src={s.photo_url}
                          alt="session"
                          className="w-16 h-12 object-cover rounded-xl border border-slate-200 hover:opacity-80 transition-opacity"
                        />
                      </a>
                    ) : (
                      <div className="w-10 h-10 rounded-xl bg-slate-100 flex items-center justify-center shrink-0 text-xl">
                        {mod?.icon ?? "📅"}
                      </div>
                    )}
                    <div className="flex-1 min-w-0">
                      <div className="text-sm font-semibold text-slate-800 leading-tight">
                        {mod
                          ? ((lang === "id" && mod.title_id) ? mod.title_id : mod.title)
                          : s.module_id ? `${t(lang, "modules")} ${s.module_id}` : t(lang, "sessions")}
                      </div>
                      {s.tutor_notes && (
                        <p className="text-xs text-slate-500 mt-0.5 line-clamp-2">{s.tutor_notes}</p>
                      )}
                    </div>
                    <div className="text-right shrink-0">
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
