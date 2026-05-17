import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import ProgressRing from "@/components/ProgressRing";
import { t } from "@/lib/i18n";
import { getLang } from "@/lib/getLang";

interface CompletionRow {
  item_key: string;
  course_module_id: string | null;
}

interface ChecklistItemRow {
  course_module_id: string;
  item_key: string;
}

const cardThemes = [
  { gradient: "from-teal-600 to-cyan-700",    ring: "from-teal-400 to-teal-500"    },
  { gradient: "from-violet-600 to-purple-700", ring: "from-violet-400 to-violet-500" },
  { gradient: "from-amber-500 to-orange-600",  ring: "from-amber-400 to-amber-500"  },
  { gradient: "from-rose-500 to-pink-600",     ring: "from-rose-400 to-rose-500"    },
  { gradient: "from-sky-500 to-blue-700",      ring: "from-sky-400 to-sky-500"      },
  { gradient: "from-emerald-500 to-green-700", ring: "from-emerald-400 to-emerald-500" },
];

export default async function StudentCoursesPage() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || profile.role !== "student") redirect("/login");

  const lang = getLang();

  const { data: enrollments } = await supabase
    .from("course_enrollments")
    .select("course_id, courses(id, title, icon, icon_url, description, created_by)")
    .eq("student_id", user.id);

  const rawCourses = (enrollments ?? []).map(
    (e: { course_id: string; courses: unknown }) => e.courses
  ) as Array<{ id: string; title: string; icon: string; icon_url?: string | null; description: string | null; created_by?: string | null }>;

  // Fetch module ids per course
  const courseWithModules = await Promise.all(
    rawCourses.map(async (course) => {
      const { data: modules } = await supabase
        .from("course_modules")
        .select("id")
        .eq("course_id", course.id);
      return { ...course, moduleIds: (modules ?? []).map((m: { id: string }) => m.id) };
    })
  );

  // Fetch tutor profiles (by created_by, fallback to all tutors)
  const tutorIds = Array.from(new Set(courseWithModules.map((c) => c.created_by).filter(Boolean))) as string[];
  const { data: tutorProfiles } = tutorIds.length > 0
    ? await supabase.from("profiles").select("id, name, avatar_url").in("id", tutorIds)
    : await supabase.from("profiles").select("id, name, avatar_url").eq("role", "tutor");
  const tutors = (tutorProfiles ?? []) as { id: string; name: string; avatar_url: string | null }[];
  const tutorMap: Record<string, { name: string; avatar_url: string | null }> = {};
  for (const tp of tutors) tutorMap[tp.id] = { name: tp.name, avatar_url: tp.avatar_url };
  const defaultTutor = tutors[0] ?? null;

  const allModuleIds = courseWithModules.flatMap((c) => c.moduleIds);

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
    .select("item_key, course_module_id")
    .eq("student_id", user.id);
  const checkList = (checks ?? []) as CompletionRow[];

  function coursePct(moduleIds: string[]) {
    const total = moduleIds.reduce((a, id) => a + (itemsByModule[id]?.length ?? 0), 0);
    const done  = checkList.filter((c) => c.course_module_id && moduleIds.includes(c.course_module_id)).length;
    return total > 0 ? Math.round((done / total) * 100) : 0;
  }

  return (
    <div className="max-w-4xl mx-auto px-4 py-8 space-y-6">

      <div>
        <h1 className="text-2xl font-bold text-slate-800">My Courses</h1>
        <p className="text-slate-500 text-sm mt-1">
          {courseWithModules.length} {t(lang, "coursesEnrolled")}
          {courseWithModules.length > 0 && " · Keep it up!"}
        </p>
      </div>

      {courseWithModules.length === 0 ? (
        <div className="card text-center py-16">
          <div className="text-5xl mb-4">📚</div>
          <p className="text-slate-500">{t(lang, "noCoursesYet")}</p>
          <p className="text-slate-400 text-sm mt-2">{t(lang, "askTutorEnroll")}</p>
        </div>
      ) : (
        <div className="space-y-4">
          {courseWithModules.map((course, idx) => {
            const theme = cardThemes[idx % cardThemes.length];
            const pct   = coursePct(course.moduleIds);
            return (
              <Link
                key={course.id}
                href={`/student/courses/${course.id}`}
                className="block rounded-2xl overflow-hidden shadow-sm hover:shadow-lg transition-shadow"
              >
                <div
                  className={`bg-gradient-to-r ${theme.gradient} px-6 py-5 flex items-center gap-5`}
                >
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
                    <div className="mt-2 flex items-center gap-2 flex-wrap">
                      <span className="text-xs bg-white/20 text-white px-2 py-0.5 rounded-full">
                        {course.moduleIds.length} {t(lang, "modules")}
                      </span>
                      {(() => {
                        const tutor = (course.created_by && tutorMap[course.created_by]) || defaultTutor;
                        return tutor ? (
                          <span className="flex items-center gap-1.5">
                            <span className="w-5 h-5 rounded-full overflow-hidden bg-white/30 flex items-center justify-center shrink-0">
                              {tutor.avatar_url ? (
                                <img src={tutor.avatar_url} alt="" className="w-full h-full object-cover" />
                              ) : (
                                <span className="text-[10px] text-white font-bold">
                                  {tutor.name.charAt(0).toUpperCase()}
                                </span>
                              )}
                            </span>
                            <span className="text-xs text-white/80">{tutor.name}</span>
                          </span>
                        ) : null;
                      })()}
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
