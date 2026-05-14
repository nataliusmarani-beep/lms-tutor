import { redirect, notFound } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import Navbar from "@/components/Navbar";
import { format } from "date-fns";

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
}

interface ChecklistItemRow {
  course_module_id: string;
  item_key: string;
}

export default async function TutorStudentPage({ params }: { params: { id: string } }) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: tutor } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!tutor || tutor.role !== "tutor") redirect("/login");

  const { data: student } = await supabase.from("profiles").select("*").eq("id", params.id).single();
  if (!student) notFound();

  // Fetch enrolled courses for this student
  const { data: enrollments } = await supabase
    .from("course_enrollments")
    .select("course_id, courses(id, title, icon, description)")
    .eq("student_id", params.id);

  const rawCourses = (enrollments ?? []).map((e: { course_id: string; courses: unknown }) => e.courses) as Array<{
    id: string;
    title: string;
    icon: string;
    description: string | null;
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

  // Sessions and completions
  const [{ data: sessions }, { data: checks }] = await Promise.all([
    supabase
      .from("learning_sessions")
      .select("id, date, duration_minutes, tutor_notes, course_module_id, module_id")
      .eq("student_id", params.id)
      .order("date", { ascending: false }),
    supabase
      .from("checklist_completions")
      .select("item_key, course_module_id")
      .eq("student_id", params.id),
  ]);

  const sessionList = (sessions ?? []) as SessionRow[];
  const checkList = (checks ?? []) as CompletionRow[];

  // Checklist items per module
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

  function moduleProgress(moduleId: string) {
    const items = itemsByModule[moduleId] ?? [];
    const completed = checkList.filter((c) => c.course_module_id === moduleId).length;
    const total = items.length;
    return { completed, total, pct: total > 0 ? Math.round((completed / total) * 100) : 0 };
  }

  // Overall stats
  const totalMinutes = sessionList.reduce((a, s) => a + s.duration_minutes, 0);
  const totalHours = Math.round((totalMinutes / 60) * 10) / 10;

  const allPcts = enrolledCourses.flatMap((c) => c.modules.map((m) => moduleProgress(m.id).pct));
  const overallPct =
    allPcts.length > 0 ? Math.round(allPcts.reduce((a, b) => a + b, 0) / allPcts.length) : 0;
  const completedModules = allPcts.filter((p) => p === 100).length;

  // Module map for session display
  const moduleMap: Record<string, CourseModule> = {};
  for (const course of enrolledCourses) {
    for (const mod of course.modules) {
      moduleMap[mod.id] = mod;
    }
  }

  return (
    <div className="min-h-screen">
      <Navbar name={tutor.name} role="tutor" />
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-8">
        <div className="flex items-center gap-3">
          <Link href="/tutor" className="text-slate-400 hover:text-slate-600 text-sm">← Dashboard</Link>
        </div>

        {/* Student card */}
        <div className="card flex items-center gap-5">
          <div className="w-14 h-14 rounded-full bg-blue-100 flex items-center justify-center text-2xl font-bold text-blue-700">
            {student.name[0]?.toUpperCase()}
          </div>
          <div className="flex-1">
            <h1 className="text-xl font-bold text-slate-800">{student.name}</h1>
            <p className="text-slate-500 text-sm">{student.id}</p>
          </div>
          <div className="text-right">
            <div className="text-2xl font-bold text-blue-600">{overallPct}%</div>
            <div className="text-sm text-slate-500">Overall progress</div>
          </div>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-3 gap-4">
          <div className="card text-center">
            <div className="text-2xl font-bold text-blue-600">{sessionList.length}</div>
            <div className="text-sm text-slate-500">Sessions</div>
          </div>
          <div className="card text-center">
            <div className="text-2xl font-bold text-blue-600">{totalHours}h</div>
            <div className="text-sm text-slate-500">Total time</div>
          </div>
          <div className="card text-center">
            <div className="text-2xl font-bold text-blue-600">{completedModules}</div>
            <div className="text-sm text-slate-500">Modules done</div>
          </div>
        </div>

        {/* Enrolled Courses + Modules */}
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
                <div className="flex-1">
                  <h2 className="text-lg font-semibold text-slate-700">{course.title}</h2>
                </div>
                <Link
                  href={`/tutor/sessions/new?student=${params.id}`}
                  className="btn-primary text-sm py-1.5"
                >
                  + Log Session
                </Link>
              </div>

              {course.modules.length === 0 ? (
                <p className="text-sm text-slate-400 italic ml-10 mb-4">No modules in this course yet.</p>
              ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 mb-4">
                  {course.modules.map((mod) => {
                    const mp = moduleProgress(mod.id);
                    return (
                      <Link
                        key={mod.id}
                        href={`/tutor/students/${params.id}/courses/${course.id}/modules/${mod.id}`}
                        className="card hover:shadow-md transition-shadow flex items-start gap-3"
                      >
                        <span className="text-2xl mt-0.5">{mod.icon}</span>
                        <div className="flex-1 min-w-0">
                          {mod.week_number && (
                            <span className="badge-gray text-xs">Week {mod.week_number}</span>
                          )}
                          <div className="font-medium text-slate-800 text-sm leading-tight mt-0.5">
                            {mod.title}
                          </div>
                          {mod.focus && (
                            <p className="text-xs text-slate-500 mt-0.5 line-clamp-1">{mod.focus}</p>
                          )}
                          <div className="mt-2">
                            <div className="flex items-center justify-between mb-1">
                              <span className="text-xs text-slate-400">
                                {mp.completed}/{mp.total} items
                              </span>
                              <span
                                className={`text-xs font-semibold ${
                                  mp.pct >= 100
                                    ? "text-green-600"
                                    : mp.pct > 0
                                    ? "text-blue-600"
                                    : "text-slate-400"
                                }`}
                              >
                                {mp.pct}%
                              </span>
                            </div>
                            <div className="w-full bg-slate-200 rounded-full h-1.5">
                              <div
                                className={`h-1.5 rounded-full ${
                                  mp.pct >= 100 ? "bg-green-500" : "bg-blue-500"
                                }`}
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
          <h2 className="text-lg font-semibold text-slate-700 mb-4">Recent Sessions</h2>
          {sessionList.length === 0 ? (
            <div className="card text-center py-8">
              <p className="text-slate-400">No sessions recorded yet.</p>
              <Link
                href={`/tutor/sessions/new?student=${params.id}`}
                className="btn-primary mt-3 inline-block text-sm"
              >
                Log First Session
              </Link>
            </div>
          ) : (
            <div className="space-y-2">
              {sessionList.slice(0, 10).map((s) => {
                const mod = s.course_module_id ? moduleMap[s.course_module_id] : null;
                return (
                  <div key={s.id} className="card flex items-center gap-3 py-3">
                    <span className="text-xl">{mod?.icon ?? "📅"}</span>
                    <div className="flex-1">
                      <div className="text-sm font-medium text-slate-700">
                        {mod ? mod.title : s.module_id ? `Module ${s.module_id}` : "Session"}
                      </div>
                      {s.tutor_notes && (
                        <div className="text-xs text-slate-500 mt-0.5 line-clamp-1">{s.tutor_notes}</div>
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
