import { redirect, notFound } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import SessionEditForm from "@/components/SessionEditForm";
import { t } from "@/lib/i18n";
import { getLang } from "@/lib/getLang";

export default async function EditSessionPage({ params }: { params: { id: string } }) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: tutor } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!tutor || tutor.role !== "tutor") redirect("/login");

  const lang = getLang();

  const { data: session } = await supabase
    .from("learning_sessions")
    .select("*")
    .eq("id", params.id)
    .single();
  if (!session) notFound();

  const { data: student } = await supabase
    .from("profiles")
    .select("id, name")
    .eq("id", session.student_id)
    .single();

  // Fetch enrolled courses + modules for this student
  const { data: enrollments } = await supabase
    .from("course_enrollments")
    .select("course_id, courses(id, title, icon)")
    .eq("student_id", session.student_id);

  const courseIds = (enrollments ?? []).map((e: { course_id: string }) => e.course_id);
  const { data: modules } = courseIds.length > 0
    ? await supabase
        .from("course_modules")
        .select("id, title, icon, week_number, course_id, legacy_module_id")
        .in("course_id", courseIds)
        .order("sort_order")
    : { data: [] };

  return (
    <div className="min-h-screen">
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-6">
        <div className="flex items-center gap-2 text-sm text-slate-400">
          <Link href={`/tutor/students/${session.student_id}`}>← {lang === "id" ? "Kembali ke" : "Back to"} {student?.name ?? t(lang, "studentLabel")}</Link>
        </div>

        <h1 className="text-xl font-bold text-slate-800">✏️ {lang === "id" ? "Edit Sesi" : "Edit Session"}</h1>

        <div className="card space-y-4">
          <div className="text-sm text-slate-500">
            {t(lang, "studentLabel")}: <span className="font-medium text-slate-700">{student?.name}</span>
          </div>
          <SessionEditForm
            sessionId={params.id}
            studentId={session.student_id}
            initialData={{
              course_module_id: session.course_module_id ?? "",
              module_id: session.module_id ?? 0,
              date: session.date,
              duration_minutes: session.duration_minutes,
              tutor_notes: session.tutor_notes ?? "",
              tutor_notes_id: session.tutor_notes_id ?? "",
              student_notes: session.student_notes ?? "",
              student_notes_id: session.student_notes_id ?? "",
              photo_url: session.photo_url ?? null,
            }}
            modules={(modules ?? []) as {
              id: string; title: string; icon: string;
              week_number: number | null; legacy_module_id: number | null;
            }[]}
          />
        </div>
      </div>
    </div>
  );
}
