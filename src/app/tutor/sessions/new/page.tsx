import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import SessionForm from "@/components/SessionForm";

export default async function NewSessionPage({
  searchParams,
}: {
  searchParams: { student?: string; courseModule?: string };
}) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: tutor } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!tutor || tutor.role !== "tutor") redirect("/login");

  const { data: students } = await supabase
    .from("profiles")
    .select("id, name")
    .eq("role", "student")
    .order("name");

  const selectedStudent = searchParams.student ?? students?.[0]?.id ?? "";

  // Fetch enrolled courses + modules for this student
  const { data: enrollments } = selectedStudent
    ? await supabase
        .from("course_enrollments")
        .select("course_id")
        .eq("student_id", selectedStudent)
    : { data: [] };

  const courseIds = (enrollments ?? []).map((e: { course_id: string }) => e.course_id);

  const [{ data: courses }, { data: modules }] = await Promise.all([
    courseIds.length > 0
      ? supabase.from("courses").select("id, title, icon").in("id", courseIds).order("title")
      : Promise.resolve({ data: [] }),
    courseIds.length > 0
      ? supabase
          .from("course_modules")
          .select("id, title, icon, week_number, course_id, legacy_module_id")
          .in("course_id", courseIds)
          .order("sort_order")
      : Promise.resolve({ data: [] }),
  ]);

  return (
    <div className="min-h-screen">
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-6">
        <div className="flex items-center gap-2 text-sm text-slate-400">
          <Link href="/tutor">← Dashboard</Link>
        </div>

        <h1 className="text-xl font-bold text-slate-800">⏱️ Log Learning Session</h1>
        <p className="text-slate-500 text-sm">Record a 60–90 minute learning session.</p>

        <div className="card space-y-4">
          <div>
            <label className="label">Student</label>
            <div className="text-sm font-medium text-slate-700 bg-slate-50 rounded-lg px-3 py-2">
              {students?.find((s: { id: string; name: string }) => s.id === selectedStudent)?.name ?? "Select a student"}
            </div>
            {!searchParams.student && students && students.length > 1 && (
              <p className="text-xs text-slate-400 mt-1">
                Use student links to pre-select:{" "}
                {students.map((s: { id: string; name: string }) => (
                  <Link key={s.id} href={`/tutor/sessions/new?student=${s.id}`}
                    className="text-blue-500 underline mr-2">{s.name}</Link>
                ))}
              </p>
            )}
          </div>
          {selectedStudent ? (
            <SessionForm
              studentId={selectedStudent}
              preselectedCourseModuleId={searchParams.courseModule ?? ""}
              courses={(courses ?? []) as { id: string; title: string; icon: string }[]}
              modules={(modules ?? []) as {
                id: string; title: string; icon: string;
                week_number: number | null; course_id: string; legacy_module_id: number | null;
              }[]}
            />
          ) : (
            <p className="text-sm text-slate-400 italic">No students found. Add a student first.</p>
          )}
        </div>
      </div>
    </div>
  );
}
