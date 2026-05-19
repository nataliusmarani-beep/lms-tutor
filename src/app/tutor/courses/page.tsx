import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import { t } from "@/lib/i18n";
import { getLang } from "@/lib/getLang";

interface CourseRow {
  id: string;
  title: string;
  description: string | null;
  icon: string;
  icon_url?: string | null;
  created_at: string;
}

export default async function TutorCoursesPage() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || profile.role !== "tutor") redirect("/login");

  const lang = getLang();

  const { data: courses } = await supabase
    .from("courses")
    .select("*")
    .order("created_at");

  const courseList = (courses ?? []) as CourseRow[];

  const enriched = await Promise.all(
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

  return (
    <div className="min-h-screen">
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <div className="flex items-center gap-2 text-sm text-slate-400 mb-1">
              <Link href="/tutor" className="hover:text-slate-600">{t(lang, "dashboard").replace("← ", "")}</Link>
              <span>›</span>
              <span className="text-slate-600">{t(lang, "courses")}</span>
            </div>
            <h1 className="text-2xl font-bold text-slate-800">{t(lang, "courses")}</h1>
          </div>
          <Link href="/tutor/courses/new" className="btn-primary">{t(lang, "newCourse")}</Link>
        </div>

        {enriched.length === 0 ? (
          <div className="card text-center py-16">
            <div className="text-5xl mb-4">📚</div>
            <p className="text-slate-500 mb-4">{t(lang, "noCoursesCreate")}</p>
            <Link href="/tutor/courses/new" className="btn-primary inline-block">{t(lang, "createFirstCourse")}</Link>
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {enriched.map((course) => (
              <Link
                key={course.id}
                href={`/tutor/courses/${course.id}`}
                className="card block hover:shadow-md transition-shadow flex flex-col gap-3"
              >
                <div className="flex items-start gap-3">
                  {course.icon_url
                    ? <div className="w-10 h-10 rounded-2xl overflow-hidden shrink-0"><img src={course.icon_url} alt={course.title} className="w-full h-full object-cover" /></div>
                    : <span className="text-3xl">{course.icon}</span>}
                  <div className="flex-1">
                    <h2 className="font-semibold text-slate-800 leading-tight">{course.title}</h2>
                    {course.description && (
                      <p className="text-sm text-slate-500 mt-1 line-clamp-2">{course.description}</p>
                    )}
                  </div>
                </div>
                <div className="flex items-center gap-3 pt-1 border-t border-slate-100">
                  <span className="badge-blue">{course.moduleCount} {t(lang, "modules").toLowerCase()}</span>
                  <span className="badge-green">{course.studentCount} {t(lang, "students").toLowerCase()}</span>
                </div>
              </Link>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
