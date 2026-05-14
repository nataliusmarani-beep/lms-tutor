import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import Navbar from "@/components/Navbar";
import SessionForm from "@/components/SessionForm";

export default async function NewSessionPage({
  searchParams,
}: {
  searchParams: { student?: string; module?: string };
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
  const selectedModule = searchParams.module ? parseInt(searchParams.module) : undefined;

  return (
    <div className="min-h-screen">
      <Navbar name={tutor.name} role="tutor" />
      <div className="max-w-xl mx-auto px-4 py-8 space-y-6">
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
              preselectedModuleId={selectedModule}
            />
          ) : (
            <p className="text-sm text-slate-400 italic">No students found. Add a student first.</p>
          )}
        </div>
      </div>
    </div>
  );
}
