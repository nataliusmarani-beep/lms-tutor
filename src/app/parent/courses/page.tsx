import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import ProgressRing from "@/components/ProgressRing";
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
  description: string | null;
  modules: CourseModule[];
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

export default async function ParentCoursesPage() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || profile.role !== "parent") redirect("/login");

  const lang = getLang();

  const { data: links } = await supabase.from("parent_student").select("student_id").eq("parent_id", user.id);
  const studentId = links?.[0]?.student_id;
  if (!studentId) redirect("/parent");

  const { data: studentProfile } = await supabase.from("profiles").select("*").eq("id", studentId).single();

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
        .from("course_modules").select("*").eq("course_id", course.id).order("sort_order");
      return { ...course, modules: (modules ?? []) as CourseModule[] };
    })
  );

  const allModuleIds = enrolledCourses.flatMap((c) => c.modules.map((m) => m.id));
  const { data: itemCounts } = await supabase
    .from("module_checklist_items").select("course_module_id, item_key")
    .in("course_module_id", allModuleIds.length > 0 ? allModuleIds : ["__none__"]);

  const itemsByModule: Record<string, ChecklistItemRow[]> = {};
  for (const item of (itemCounts ?? []) as ChecklistItemRow[]) {
    if (!item.course_module_id) continue;
    if (!itemsByModule[item.course_module_id]) itemsByModule[item.course_module_id] = [];
    itemsByModule[item.course_module_id].push(item);
  }

  const { data: checks } = await supabase
    .from("checklist_completions").select("item_key, course_module_id, module_id").eq("student_id", studentId);
  const checkList = (checks ?? []) as CompletionRow[];

  const legacyIdByModuleId: Record<string, number | null> = {};
  for (const course of enrolledCourses)
    for (const mod of course.modules)
      legacyIdByModuleId[mod.id] = mod.legacy_module_id ?? null;

  function moduleProgress(moduleId: string) {
    const items = itemsByModule[moduleId] ?? [];
    const legacyId = legacyIdByModuleId[moduleId];
    const completed = checkList.filter(
      (c) => c.course_module_id === moduleId || (legacyId != null && c.module_id === legacyId)
    ).length;
    const total = items.length;
    return { completed, total, pct: total > 0 ? Math.round((completed / total) * 100) : 0 };
  }

  const allPcts = enrolledCourses.flatMap((c) => c.modules.map((m) => moduleProgress(m.id).pct));
  const overallPct = allPcts.length > 0 ? Math.round(allPcts.reduce((a, b) => a + b, 0) / allPcts.length) : 0;

  const cardThemes = [
    { bg: "bg-teal-50",   bar: "from-teal-400 to-teal-500",    progress: "bg-teal-500"   },
    { bg: "bg-amber-50",  bar: "from-amber-400 to-amber-500",   progress: "bg-amber-500"  },
    { bg: "bg-yellow-50", bar: "from-yellow-400 to-yellow-500", progress: "bg-yellow-500" },
    { bg: "bg-rose-50",   bar: "from-rose-400 to-rose-500",     progress: "bg-rose-500"   },
    { bg: "bg-violet-50", bar: "from-violet-400 to-violet-500", progress: "bg-violet-500" },
    { bg: "bg-sky-50",    bar: "from-sky-400 to-sky-500",       progress: "bg-sky-500"    },
  ];

  return (
    <div className="max-w-4xl mx-auto px-4 py-8 space-y-8">

      {/* Header */}
      <div className="flex items-center gap-4">
        <div className="flex-1">
          <h1 className="text-2xl font-bold text-slate-800">{t(lang, "courses")}</h1>
          <p className="text-slate-500 text-sm mt-1">
            {studentProfile?.name} · {enrolledCourses.length} {t(lang, "courses").toLowerCase()}
          </p>
        </div>
        <div className="text-right">
          <div className="text-2xl font-bold text-teal-600">{overallPct}%</div>
          <div className="text-xs text-slate-500">{t(lang, "overall") || "Overall"}</div>
        </div>
      </div>

      {enrolledCourses.length === 0 ? (
        <div className="card text-center py-16">
          <div className="text-5xl mb-4">📚</div>
          <p className="text-slate-500">Not enrolled in any courses yet.</p>
        </div>
      ) : (
        enrolledCourses.map((course, courseIdx) => {
          const theme = cardThemes[courseIdx % cardThemes.length];
          const courseChecks = checkList.filter((c) =>
            course.modules.some((m) => m.id === c.course_module_id)
          ).length;
          const courseItems = course.modules.reduce((a, m) => a + (itemsByModule[m.id]?.length ?? 0), 0);
          const coursePct = courseItems > 0 ? Math.round((courseChecks / courseItems) * 100) : 0;

          return (
            <div key={course.id}>
              <div className="flex items-center gap-3 mb-3">
                <div className={`w-1 h-8 rounded-full bg-gradient-to-b ${theme.bar}`} />
                <span className="text-2xl">{course.icon}</span>
                <div className="flex-1">
                  <h2 className="text-lg font-semibold text-slate-700">{course.title}</h2>
                  {course.description && <p className="text-sm text-slate-500">{course.description}</p>}
                </div>
                <span className="badge-blue">{coursePct}%</span>
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                {course.modules.map((mod) => {
                  const mp = moduleProgress(mod.id);
                  return (
                    <Link
                      key={mod.id}
                      href={`/parent/courses/${course.id}`}
                      className={`${theme.bg} rounded-2xl shadow-sm border border-slate-100 hover:shadow-md transition-shadow flex items-stretch overflow-hidden p-0`}
                    >
                      <div className={`w-1 rounded-l-2xl bg-gradient-to-b ${theme.bar} shrink-0`} />
                      <div className="flex items-start gap-3 p-4 flex-1 min-w-0">
                        <span className="text-2xl mt-0.5 shrink-0">{mod.icon}</span>
                        <div className="flex-1 min-w-0">
                          {mod.week_number && (
                            <span className="badge-gray text-xs">{t(lang, "week")} {mod.week_number}</span>
                          )}
                          <div className="font-medium text-slate-800 text-sm leading-tight mt-0.5">
                            {(lang === "id" && mod.title_id) ? mod.title_id : mod.title}
                          </div>
                          {mod.focus && (
                            <p className="text-xs text-slate-500 mt-0.5 line-clamp-1">
                              {(lang === "id" && mod.focus_id) ? mod.focus_id : mod.focus}
                            </p>
                          )}
                          <div className="mt-2">
                            <div className="flex items-center justify-between mb-1">
                              <span className="text-xs text-slate-400">{mp.completed}/{mp.total} {t(lang, "items")}</span>
                              <span className={`text-xs font-semibold ${mp.pct >= 100 ? "text-emerald-600" : mp.pct > 0 ? "text-teal-600" : "text-slate-400"}`}>
                                {mp.pct}%
                              </span>
                            </div>
                            <div className="w-full bg-slate-200 rounded-full h-1.5">
                              <div
                                className={`h-1.5 rounded-full ${mp.pct >= 100 ? "bg-emerald-500" : theme.progress}`}
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
            </div>
          );
        })
      )}
    </div>
  );
}
