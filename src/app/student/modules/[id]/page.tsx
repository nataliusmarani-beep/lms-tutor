import { redirect, notFound } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import Navbar from "@/components/Navbar";
import ChecklistSection from "@/components/ChecklistSection";
import AssignmentPanel from "@/components/AssignmentPanel";
import { getModule } from "@/lib/course-data";
import { format } from "date-fns";

export default async function StudentModulePage({ params }: { params: { id: string } }) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || profile.role !== "student") redirect("/login");

  const moduleId = parseInt(params.id);
  const mod = getModule(moduleId);
  if (!mod) notFound();

  const [{ data: sessions }, { data: checks }, { data: assignments }, { data: customItems }, { data: customization }] = await Promise.all([
    supabase
      .from("learning_sessions")
      .select("*")
      .eq("student_id", user.id)
      .eq("module_id", moduleId)
      .order("date", { ascending: false }),
    supabase
      .from("checklist_completions")
      .select("*")
      .eq("student_id", user.id)
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

  const allChecks = checks ?? [];
  const allItems = customItems ?? [];
  const done = allItems.filter((i: { item_key: string }) => allChecks.some((c: { item_key: string }) => c.item_key === i.item_key)).length;
  const pct = allItems.length === 0 ? 0 : Math.round((done / allItems.length) * 100);

  return (
    <div className="min-h-screen">
      <Navbar name={profile.name} role="student" />
      <div className="max-w-2xl mx-auto px-4 py-8 space-y-6">
        <div className="flex items-center gap-2 text-sm text-slate-400">
          <Link href="/student">← Dashboard</Link>
          <span>›</span>
          <span className="text-slate-600">Module {mod.id}</span>
        </div>

        <div className="card">
          <div className="flex items-start gap-3">
            <span className="text-3xl">{mod.icon}</span>
            <div className="flex-1">
              <div className="flex items-center gap-2 mb-1">
                <span className="badge-blue">Week {mod.week}</span>
              </div>
              <h1 className="text-xl font-bold text-slate-800">{displayMod.title}</h1>
              <p className="text-slate-500 text-sm mt-1">{displayMod.focus}</p>
            </div>
            <div className="text-right shrink-0">
              <div className={`text-2xl font-bold ${pct >= 100 ? "text-green-600" : "text-blue-600"}`}>{pct}%</div>
              <div className="text-xs text-slate-400">complete</div>
            </div>
          </div>
          <div className="mt-3">
            <div className="w-full bg-slate-200 rounded-full h-2">
              <div
                className={`h-2 rounded-full ${pct >= 100 ? "bg-green-500" : "bg-blue-500"}`}
                style={{ width: `${pct}%` }}
              />
            </div>
          </div>
        </div>

        <div>
          <h2 className="font-semibold text-slate-700 mb-3">📅 Sessions</h2>
          {!sessions || sessions.length === 0 ? (
            <p className="text-sm text-slate-400 italic">No sessions logged for this module yet.</p>
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
                    <p className="text-xs text-slate-600 mt-1">
                      <span className="text-slate-400">Tutor: </span>{s.tutor_notes}
                    </p>
                  )}
                  {s.student_notes && (
                    <p className="text-xs text-slate-600 mt-1">
                      <span className="text-slate-400">My notes: </span>{s.student_notes}
                    </p>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>

        <ChecklistSection
          moduleId={moduleId}
          items={allItems}
          completions={allChecks}
          studentId={user.id}
          currentUserId={user.id}
          currentUserRole="student"
        />

        <AssignmentPanel
          moduleId={moduleId}
          assignments={(assignments ?? []) as any}
          currentUserId={user.id}
          currentUserRole="student"
        />
      </div>
    </div>
  );
}
