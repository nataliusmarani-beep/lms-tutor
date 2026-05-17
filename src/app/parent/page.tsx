import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import Navbar from "@/components/Navbar";
import ProgressRing from "@/components/ProgressRing";
import { format } from "date-fns";
import { getLang, t } from "@/lib/i18n";

interface CourseModule {
  id: string;
  title: string;
  focus: string | null;
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
  description: string | null;
  modules: CourseModule[];
}

interface SessionRow {
  id: string;
  date: string;
  duration_minutes: number;
  tutor_notes: string | null;
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
      <div className="min-h-screen">
        <Navbar name={profile.name} role="parent" />
        <div className="max-w-xl mx-auto px-4 py-16 text-center">
          <div className="text-5xl mb-4">👤</div>
          <h1 className="text-xl font-bold text-slate-700">{t(lang, "noStudentLinked")}</h1>
          <p className="text-slate-400 mt-2">{t(lang, "noStudentLinkedDesc")}</p>
        </div>
      </div>
    );
  }

  // Enrolled courses
  const { data: enrollments } = await supabase
    .from("course_enrollments")
    .select("course_id, courses(id, title, icon, description)")
    .eq("student_id", studentId);

  const rawCourses = (enrollments ?? []).map((e: { course_id: string; courses: unknown }) => e.courses) as Array<{
    id: string; title: string; icon: string; description: string | null;
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
      .select("id, date, duration_minutes, tutor_notes, course_module_id, module_id")
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

  // Build a map from UUID → legacy_module_id for session matching
  const legacyIdByModuleId: Record<string, number | null> = {};
  for (const course of enrolledCourses) {
    for (const mod of course.modules) {
      legacyIdByModuleId[mod.id] = mod.legacy_module_id ?? null;
    }
  }

  function moduleProgress(moduleId: string) {
    const items = itemsByModule[moduleId] ?? [];
    const studentItems = items.filter((i) => i.item_type === "student");
    const tutorItems = items.filter((i) => i.item_type === "teacher");
    const legacyId = legacyIdByModuleId[moduleId];

    // Match completions by UUID or legacy integer id
    const completedAll = checkList.filter(
      (c) => c.course_module_id === moduleId || (legacyId != null && c.module_id === legacyId)
    );
    const studentDone = completedAll.filter((c) =>
      studentItems.some((i) => i.item_key === c.item_key)
    ).length;
    const tutorDone = completedAll.filter((c) =>
      tutorItems.some((i) => i.item_key === c.item_key)
    ).length;
    const total = items.length;
    const completed = completedAll.length;

    // Match sessions by UUID or legacy integer id
    const sessionCount = sessionList.filter(
      (s) => s.course_module_id === moduleId || (legacyId != null && s.module_id === legacyId)
    ).length;

    return {
      completed,
      total,
      studentDone,
      studentTotal: studentItems.length,
      tutorDone,
      tutorTotal: tutorItems.length,
      pct: total > 0 ? Math.round((completed / total) * 100) : 0,
      sessionCount,
    };
  }

  // Overall stats
  const totalMinutes = sessionList.reduce((a, s) => a + s.duration_minutes, 0);
  const totalHours = Math.round((totalMinutes / 60) * 10) / 10;

  const allPcts = enrolledCourses.flatMap((c) => c.modules.map((m) => moduleProgress(m.id).pct));
  const overallPct = allPcts.length > 0
    ? Math.round(allPcts.reduce((a, b) => a + b, 0) / allPcts.length)
    : 0;
  const completedModules = allPcts.filter((p) => p === 100).length;
  const totalModules = allPcts.length;

  // Module map for session display
  const moduleMap: Record<string, CourseModule> = {};
  for (const course of enrolledCourses) {
    for (const mod of course.modules) moduleMap[mod.id] = mod;
  }

  return (
    <div className="min-h-screen">
      <Navbar name={profile.name} role="parent" />
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-8">

        {/* Header card */}
        <div
          className="rounded-2xl px-6 py-5 shadow-sm"
          style={{ background: "linear-gradient(135deg, #0f1f3d 0%, #1e3a6e 60%, #2563eb 100%)" }}
        >
          <div className="flex items-center gap-4">
            <ProgressRing percent={overallPct} size={80} strokeWidth={8} variant="dark" />
            <div className="flex-1">
              <p className="text-blue-200 text-sm">{t(lang, "progressReport")}</p>
              <h1 className="text-2xl font-bold text-white">{student.name}</h1>
              {enrolledCourses.length > 0 && (
                <p className="text-blue-200 text-sm mt-1">
                  {enrolledCourses.map((c) => c.title).join(" · ")}
                </p>
              )}
            </div>
          </div>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
          <div className="card text-center">
            <div className="text-2xl font-bold text-blue-600">{sessionList.length}</div>
            <div className="text-sm text-slate-500">{t(lang, "sessions")}</div>
          </div>
          <div className="card text-center">
            <div className="text-2xl font-bold text-blue-600">{totalHours}h</div>
            <div className="text-sm text-slate-500">{t(lang, "learningTime")}</div>
          </div>
          <div className="card text-center">
            <div className="text-2xl font-bold text-blue-600">{completedModules}/{totalModules}</div>
            <div className="text-sm text-slate-500">{t(lang, "modulesDone")}</div>
          </div>
          <div className="card text-center">
            <div className="text-2xl font-bold text-blue-600">{overallPct}%</div>
            <div className="text-sm text-slate-500">{t(lang, "overall")}</div>
          </div>
        </div>

        {/* Module Progress */}
        {enrolledCourses.length === 0 ? (
          <div className="card text-center py-10">
            <div className="text-4xl mb-3">📚</div>
            <p className="text-slate-500">Not enrolled in any courses yet.</p>
          </div>
        ) : (
          enrolledCourses.map((course) => (
            <div key={course.id}>
              <div className="flex items-center gap-3 mb-3">
                <span className="text-2xl">{course.icon}</span>
                <h2 className="text-lg font-semibold text-slate-700">{course.title}</h2>
              </div>
              {course.modules.length === 0 ? (
                <p className="text-sm text-slate-400 italic ml-10">No modules yet.</p>
              ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 mb-4">
                  {course.modules.map((mod) => {
                    const mp = moduleProgress(mod.id);
                    return (
                      <Link
                        key={mod.id}
                        href={`/parent/courses/${course.id}`}
                        className="card hover:shadow-md transition-shadow flex items-start gap-3"
                      >
                        <span className="text-2xl mt-0.5">{mod.icon}</span>
                        <div className="flex-1 min-w-0">
                          {mod.week_number && (
                            <span className="badge-gray text-xs">{t(lang, "week")} {mod.week_number}</span>
                          )}
                          <div className="font-medium text-slate-800 text-sm leading-tight mt-0.5">
                            {mod.title}
                          </div>
                          {mod.focus && (
                            <p className="text-xs text-slate-500 mt-0.5 line-clamp-2">{mod.focus}</p>
                          )}
                          <div className="mt-2 flex justify-between text-xs text-slate-400">
                            <span>Student: {mp.studentDone}/{mp.studentTotal}</span>
                            <span>Tutor: {mp.tutorDone}/{mp.tutorTotal}</span>
                          </div>
                          <div className="mt-1">
                            <div className="flex items-center justify-between mb-0.5">
                              <span className="text-xs text-slate-400">{mp.sessionCount} {t(lang, "sessions").toLowerCase()}</span>
                              <span className={`text-xs font-semibold ${
                                mp.pct >= 100 ? "text-green-600" : mp.pct > 0 ? "text-blue-600" : "text-slate-400"
                              }`}>{mp.pct}%</span>
                            </div>
                            <div className="w-full bg-slate-200 rounded-full h-1.5">
                              <div
                                className={`h-1.5 rounded-full ${mp.pct >= 100 ? "bg-green-500" : "bg-blue-500"}`}
                                style={{ width: `${mp.pct}%` }}
                              />
                            </div>
                          </div>
                        </div>
                        <span className="text-slate-300 shrink-0">›</span>
                      </Link>
                    );
                  })}
                </div>
              )}
            </div>
          ))
        )}

        {/* Recent Sessions */}
        <div>
          <h2 className="text-lg font-semibold text-slate-700 mb-4">{t(lang, "recentSessions")}</h2>
          {sessionList.length === 0 ? (
            <div className="card text-center py-8">
              <p className="text-slate-400">{t(lang, "noSessionsYet")}</p>
            </div>
          ) : (
            <div className="space-y-2">
              {sessionList.slice(0, 8).map((s) => {
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
                      <div className="text-xs text-slate-400">{format(new Date(s.date), "MMM d, yyyy")}</div>
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
