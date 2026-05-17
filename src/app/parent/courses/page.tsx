import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import ProgressRing from "@/components/ProgressRing";
import { t } from "@/lib/i18n";
import { getLang } from "@/lib/getLang";

interface CompletionRow {
  item_key: string;
  course_module_id: string | null;
  module_id: number | null;
}

interface ChecklistItemRow {
  course_module_id: string;
  item_key: string;
}

const cardThemes = [
  { gradient: "from-teal-600 to-cyan-700"    },
  { gradient: "from-violet-600 to-purple-700" },
  { gradient: "from-amber-500 to-orange-600"  },
  { gradient: "from-rose-500 to-pink-600"     },
  { gradient: "from-sky-500 to-blue-700"      },
  { gradient: "from-emerald-500 to-green-700" },
];

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
    .select("course_id, courses(id, title, icon, icon_url, description)")
    .eq("student_id", studentId);

  const rawCourses = (enrollments ?? []).map(
    (e: { course_id: string; courses: unknown }) => e.courses
  ) as Array<{ id: string; title: string; icon: string; icon_url?: string | null; description: string | null }>;

  const courseWithModules = await Promise.all(
    rawCourses.map(async (course) => {
      const { data: modules } = await supabase
        .from("course_modules")
        .select("id, legacy_module_id")
        .eq("course_id", course.id);
      return { ...course, modules: (modules ?? []) as { id: string; legacy_module_id: number | null }[] };
    })
  );

  const allModuleIds = courseWithModules.flatMap((c) => c.modules.map((m) => m.id));

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

  const { data: checks } = await supabase
    .from("checklist_completions")
    .select("item_key, course_module_id, module_id")
    .eq("student_id", studentId);
  const checkList = (checks ?? []) as CompletionRow[];

  const legacyMap: Record<string, number | null> = {};
  for (const course of courseWithModules)
    for (const mod of course.modules)
      legacyMap[mod.id] = mod.legacy_module_id ?? null;

  function coursePct(modules: { id: string; legacy_module_id: number | null }[]) {
    const total = modules.reduce((a, m) => a + (itemsByModule[m.id]?.length ?? 0), 0);
    const done  = checkList.filter(
      (c) => modules.some((m) => c.course_module_id === m.id || (m.legacy_module_id != null && c.module_id === m.legacy_module_id))
    ).length;
    return total > 0 ? Math.round((done / total) * 100) : 0;
  }

  const allPcts = courseWithModules.map((c) => coursePct(c.modules));
  const overallPct = allPcts.length > 0 ? Math.round(allPcts.reduce((a, b) => a + b, 0) / allPcts.length) : 0;

  return (
    <div className="max-w-4xl mx-auto px-4 py-8 space-y-6">

      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-slate-800">{t(lang, "courses")}</h1>
          <p className="text-slate-500 text-sm mt-1">
            {studentProfile?.name} · {courseWithModules.length} {t(lang, "courses").toLowerCase()}
          </p>
        </div>
        <div className="text-right">
          <div className="text-2xl font-bold text-teal-600">{overallPct}%</div>
          <div className="text-xs text-slate-500">Overall</div>
        </div>
      </div>

      {courseWithModules.length === 0 ? (
        <div className="card text-center py-16">
          <div className="text-5xl mb-4">📚</div>
          <p className="text-slate-500">Not enrolled in any courses yet.</p>
        </div>
      ) : (
        <div className="space-y-4">
          {courseWithModules.map((course, idx) => {
            const theme = cardThemes[idx % cardThemes.length];
            const pct   = coursePct(course.modules);
            return (
              <Link
                key={course.id}
                href={`/parent/courses/${course.id}`}
                className="block rounded-2xl overflow-hidden shadow-sm hover:shadow-lg transition-shadow"
              >
                <div className={`bg-gradient-to-r ${theme.gradient} px-6 py-5 flex items-center gap-5`}>
                  {/* Icon */}
                  <div className="w-14 h-14 rounded-2xl overflow-hidden bg-white/20 flex items-center justify-center shrink-0">
                    {course.icon_url ? (
                      <img src={course.icon_url} alt={course.title} className="w-full h-full object-cover" />
                    ) : (
                      <span className="text-3xl">{course.icon}</span>
                    )}
                  </div>

                  {/* Info */}
                  <div className="flex-1 min-w-0">
                    <h2 className="text-lg font-bold text-white truncate">{course.title}</h2>
                    {course.description && (
                      <p className="text-white/70 text-sm mt-0.5 line-clamp-1">{course.description}</p>
                    )}
                    <div className="mt-2">
                      <span className="text-xs bg-white/20 text-white px-2 py-0.5 rounded-full">
                        {course.modules.length} {t(lang, "modules")}
                      </span>
                    </div>
                  </div>

                  {/* Progress ring */}
                  <div className="shrink-0">
                    <ProgressRing percent={pct} size={64} strokeWidth={6} variant="dark" />
                  </div>
                </div>
              </Link>
            );
          })}
        </div>
      )}
    </div>
  );
}
