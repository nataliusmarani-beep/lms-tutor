import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import Navbar from "@/components/Navbar";

interface CourseRow {
  id: string;
  title: string;
  description: string | null;
  icon: string;
  created_at: string;
}

export default async function TutorCoursesPage() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || profile.role !== "tutor") redirect("/login");

  const { data: courses } = await supabase
    .from("courses")
    .select("*")
    .order("created_at");

  const courseList = (courses ?? []) as CourseRow[];

  // For each course, fetch module count and enrolled student count
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
      <Navbar name={profile.name} role="tutor" />
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <div className="flex items-center gap-2 text-sm text-slate-400 mb-1">
              <Link href="/tutor" className="hover:text-slate-600">Dashboard</Link>
              <span>›</span>
              <span className="text-slate-600">Courses</span>
            </div>
            <h1 className="text-2xl font-bold text-slate-800">Courses</h1>
          </div>
          <Link href="/tutor/courses/new" className="btn-primary">+ New Course</Link>
        </div>

        {enriched.length === 0 ? (
          <div className="card text-center py-16">
            <div className="text-5xl mb-4">📚</div>
            <p className="text-slate-500 mb-4">No courses yet. Create your first course to get started.</p>
            <Link href="/tutor/courses/new" className="btn-primary inline-block">Create First Course</Link>
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            {enriched.map((course) => (
              <Link
                key={course.id}
                href={`/tutor/courses/${course.id}`}
                className="card hover:shadow-md transition-shadow flex flex-col gap-3"
              >
                <div className="flex items-start gap-3">
                  <span className="text-3xl">{course.icon}</span>
                  <div className="flex-1">
                    <h2 className="font-semibold text-slate-800 leading-tight">{course.title}</h2>
                    {course.description && (
                      <p className="text-sm text-slate-500 mt-1 line-clamp-2">{course.description}</p>
                    )}
                  </div>
                </div>
                <div className="flex items-center gap-3 pt-1 border-t border-slate-100">
                  <span className="badge-blue">{course.moduleCount} module{course.moduleCount !== 1 ? "s" : ""}</span>
                  <span className="badge-green">{course.studentCount} student{course.studentCount !== 1 ? "s" : ""}</span>
                </div>
              </Link>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
