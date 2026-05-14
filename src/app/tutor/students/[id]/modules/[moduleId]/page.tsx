import { redirect, notFound } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import Navbar from "@/components/Navbar";
import ChecklistSection from "@/components/ChecklistSection";
import AssignmentPanel from "@/components/AssignmentPanel";
import { getModule } from "@/lib/course-data";
import { format } from "date-fns";

export default async function TutorModuleDetailPage({
  params,
}: {
  params: { id: string; moduleId: string };
}) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: tutor } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!tutor || tutor.role !== "tutor") redirect("/login");

  const { data: student } = await supabase.from("profiles").select("*").eq("id", params.id).single();
  if (!student) notFound();

  const moduleId = parseInt(params.moduleId);
  const mod = getModule(moduleId);
  if (!mod) notFound();

  const [{ data: sessions }, { data: checks }, { data: assignments }, { data: customItems }, { data: customization }] = await Promise.all([
    supabase
      .from("learning_sessions")
      .select("*")
      .eq("student_id", params.id)
      .eq("module_id", moduleId)
      .order("date", { ascending: false }),
    supabase
      .from("checklist_completions")
      .select("*")
      .eq("student_id", params.id)
      .eq("module_id", moduleId),
    supabase
      .from("assignments")
      .select("*, submissions(*, profiles(name))")
      .eq("module_id", moduleId)
      .order("created_at"),
    supabase
      .from("module_checklist_items")
      .select("*")
      .eq("module_id", moduleId)
      .order("sort_order"),
    supabase
      .from("module_customizations")
      .select("*")
      .eq("module_id", moduleId)
      .maybeSingle(),
  ]);

  const displayMod = {
    ...mod,
    title: customization?.custom_title ?? mod.title,
    focus: customization?.custom_focus ?? mod.focus,
  };

  return (
    <div className="min-h-screen">
      <Navbar name={tutor.name} role="tutor" />
      <div className="max-w-3xl mx-auto px-4 py-8 space-y-8">
        <div className="flex items-center gap-2 text-sm text-slate-400">
          <Link href="/tutor">Dashboard</Link>
          <span>›</span>
          <Link href={`/tutor/students/${params.id}`}>{student.name}</Link>
          <span>›</span>
          <span className="text-slate-600">Module {mod.id}</span>
        </div>

        <div className="card">
          <div className="flex items-start gap-3">
            <span className="text-3xl">{mod.icon}</span>
            <div className="flex-1">
              <div className="flex items-center gap-2">
                <span className="badge-blue">Week {mod.week}</span>
                <span className="badge-gray">Month {mod.month}</span>
              </div>
              <h1 className="text-xl font-bold text-slate-800 mt-1">{displayMod.title}</h1>
              <p className="text-slate-500 text-sm mt-1">{displayMod.focus}</p>
              <p className="text-sm text-slate-500 mt-2">
                Student: <strong>{student.name}</strong>
              </p>
            </div>
            <Link
              href={`/tutor/modules/${moduleId}/edit`}
              className="btn-secondary text-sm py-1.5 shrink-0"
            >
              ✏️ Edit Module
            </Link>
          </div>
        </div>

        <div>
          <div className="flex items-center justify-between mb-3">
            <h2 className="text-lg font-semibold text-slate-700">Sessions</h2>
            <Link
              href={`/tutor/sessions/new?student=${params.id}&module=${moduleId}`}
              className="btn-primary text-sm py-1.5"
            >
              + Log Session
            </Link>
          </div>
          {!sessions || sessions.length === 0 ? (
            <p className="text-slate-400 text-sm italic">No sessions for this module yet.</p>
          ) : (
            <div className="space-y-2">
              {sessions.map((s: {
                id: string; date: string; duration_minutes: number; tutor_notes: string | null; student_notes: string | null
              }) => (
                <div key={s.id} className="card py-3">
                  <div className="flex items-center justify-between">
                    <span className="text-sm font-medium text-slate-700">
                      {format(new Date(s.date), "EEEE, MMMM d, yyyy")}
                    </span>
                    <span className="badge-blue">{s.duration_minutes} min</span>
                  </div>
                  {s.tutor_notes && (
                    <p className="text-sm text-slate-600 mt-1">
                      <span className="text-slate-400 text-xs">Tutor: </span>{s.tutor_notes}
                    </p>
                  )}
                  {s.student_notes && (
                    <p className="text-sm text-slate-600 mt-1">
                      <span className="text-slate-400 text-xs">Student: </span>{s.student_notes}
                    </p>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>

        <ChecklistSection
          moduleId={moduleId}
          items={customItems ?? []}
          completions={checks ?? []}
          studentId={params.id}
          currentUserId={user.id}
          currentUserRole="tutor"
        />

        <AssignmentPanel
          moduleId={moduleId}
          assignments={(assignments ?? []) as any}
          currentUserId={user.id}
          currentUserRole="tutor"
          studentId={params.id}
        />
      </div>
    </div>
  );
}
