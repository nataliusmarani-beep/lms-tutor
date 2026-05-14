import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import Navbar from "@/components/Navbar";
import ProgressRing from "@/components/ProgressRing";
import ModuleCard from "@/components/ModuleCard";
import { COURSE_MODULES } from "@/lib/course-data";
import type { ModuleProgress } from "@/types";
import { format } from "date-fns";

export default async function ParentDashboard() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || profile.role !== "parent") redirect("/login");

  const { data: links } = await supabase
    .from("parent_student")
    .select("student_id")
    .eq("parent_id", user.id);

  const studentIds = links?.map((l: { student_id: string }) => l.student_id) ?? [];

  const { data: students } = await supabase
    .from("profiles")
    .select("*")
    .in("id", studentIds.length > 0 ? studentIds : ["none"]);

  const studentList = students ?? [];
  const studentId = studentList[0]?.id;

  if (!studentId) {
    return (
      <div className="min-h-screen">
        <Navbar name={profile.name} role="parent" />
        <div className="max-w-xl mx-auto px-4 py-16 text-center">
          <div className="text-5xl mb-4">👤</div>
          <h1 className="text-xl font-bold text-slate-700">No student linked yet</h1>
          <p className="text-slate-400 mt-2">Ask your tutor to link your account to your child's profile.</p>
        </div>
      </div>
    );
  }

  const [{ data: sessions }, { data: checks }, { data: submissions }] = await Promise.all([
    supabase.from("learning_sessions").select("*").eq("student_id", studentId).order("date", { ascending: false }),
    supabase.from("checklist_completions").select("*").eq("student_id", studentId),
    supabase.from("submissions").select("*, assignments(title, module_id, grade, feedback, graded_at)").eq("student_id", studentId),
  ]);

  const moduleProgress: Record<number, ModuleProgress> = {};
  for (const mod of COURSE_MODULES) {
    const modSessions = sessions?.filter((s: { module_id: number }) => s.module_id === mod.id) ?? [];
    const modChecks = checks?.filter((c: { module_id: number }) => c.module_id === mod.id) ?? [];
    const studentChecksCompleted = mod.studentChecklist.filter((i) => modChecks.some((c: { item_key: string }) => c.item_key === i.key)).length;
    const teacherChecksCompleted = mod.teacherChecklist.filter((i) => modChecks.some((c: { item_key: string }) => c.item_key === i.key)).length;
    const totalChecks = mod.studentChecklist.length + mod.teacherChecklist.length;

    moduleProgress[mod.id] = {
      moduleId: mod.id,
      sessionsCount: modSessions.length,
      totalMinutes: modSessions.reduce((a: number, s: { duration_minutes: number }) => a + s.duration_minutes, 0),
      studentChecksCompleted,
      studentChecksTotal: mod.studentChecklist.length,
      teacherChecksCompleted,
      teacherChecksTotal: mod.teacherChecklist.length,
      percentComplete: totalChecks > 0 ? Math.round(((studentChecksCompleted + teacherChecksCompleted) / totalChecks) * 100) : 0,
    };
  }

  const overallPct = Math.round(
    Object.values(moduleProgress).reduce((a, m) => a + m.percentComplete, 0) / COURSE_MODULES.length
  );

  const totalHours = Math.round(
    (sessions?.reduce((a: number, s: { duration_minutes: number }) => a + s.duration_minutes, 0) ?? 0) / 60 * 10
  ) / 10;

  const student = studentList[0];
  const gradedSubmissions = submissions?.filter((s: { grade: string | null }) => s.grade) ?? [];

  return (
    <div className="min-h-screen">
      <Navbar name={profile.name} role="parent" />
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-8">

        <div className="card bg-gradient-to-r from-blue-50 to-indigo-50 border-blue-100">
          <div className="flex items-center gap-4">
            <ProgressRing percent={overallPct} size={80} strokeWidth={8} />
            <div className="flex-1">
              <p className="text-slate-500 text-sm">Progress Report for</p>
              <h1 className="text-2xl font-bold text-slate-800">{student.name}</h1>
              <p className="text-slate-500 text-sm mt-1">Microsoft App College Prep Course</p>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
          <div className="card text-center">
            <div className="text-2xl font-bold text-blue-600">{sessions?.length ?? 0}</div>
            <div className="text-sm text-slate-500">Sessions</div>
          </div>
          <div className="card text-center">
            <div className="text-2xl font-bold text-blue-600">{totalHours}h</div>
            <div className="text-sm text-slate-500">Learning time</div>
          </div>
          <div className="card text-center">
            <div className="text-2xl font-bold text-blue-600">
              {Object.values(moduleProgress).filter((m) => m.percentComplete === 100).length}/8
            </div>
            <div className="text-sm text-slate-500">Modules done</div>
          </div>
          <div className="card text-center">
            <div className="text-2xl font-bold text-blue-600">{submissions?.length ?? 0}</div>
            <div className="text-sm text-slate-500">Submitted tasks</div>
          </div>
        </div>

        <div>
          <h2 className="text-lg font-semibold text-slate-700 mb-4">Module Progress</h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
            {COURSE_MODULES.map((mod) => (
              <ModuleCard
                key={mod.id}
                module={mod}
                progress={moduleProgress[mod.id]}
                href="#"
              />
            ))}
          </div>
        </div>

        {gradedSubmissions.length > 0 && (
          <div>
            <h2 className="text-lg font-semibold text-slate-700 mb-4">Graded Assignments</h2>
            <div className="space-y-2">
              {gradedSubmissions.map((s: {
                id: string;
                assignments: { title: string; module_id: number } | null;
                grade: string;
                feedback: string | null;
                graded_at: string | null;
              }) => (
                <div key={s.id} className="card flex items-center gap-3 py-3">
                  <span className="text-xl">
                    {COURSE_MODULES.find((m) => m.id === s.assignments?.module_id)?.icon}
                  </span>
                  <div className="flex-1">
                    <div className="text-sm font-medium text-slate-700">{s.assignments?.title}</div>
                    {s.feedback && <p className="text-xs text-slate-500 mt-0.5">{s.feedback}</p>}
                  </div>
                  <div className="text-right">
                    <span className="badge-green font-bold">{s.grade}</span>
                    {s.graded_at && (
                      <div className="text-xs text-slate-400 mt-1">{format(new Date(s.graded_at), "MMM d")}</div>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        <div>
          <h2 className="text-lg font-semibold text-slate-700 mb-4">Recent Sessions</h2>
          {!sessions || sessions.length === 0 ? (
            <div className="card text-center py-8">
              <p className="text-slate-400">No sessions recorded yet.</p>
            </div>
          ) : (
            <div className="space-y-2">
              {sessions.slice(0, 8).map((s: {
                id: string; date: string; module_id: number; duration_minutes: number; tutor_notes: string | null
              }) => {
                const mod = COURSE_MODULES.find((m) => m.id === s.module_id);
                return (
                  <div key={s.id} className="card flex items-center gap-3 py-3">
                    <span className="text-xl">{mod?.icon}</span>
                    <div className="flex-1">
                      <div className="text-sm font-medium text-slate-700">
                        Module {s.module_id}: {mod?.title}
                      </div>
                      {s.tutor_notes && <p className="text-xs text-slate-500 mt-0.5 line-clamp-1">{s.tutor_notes}</p>}
                    </div>
                    <div className="text-right">
                      <div className="text-sm font-medium text-slate-700">{s.duration_minutes} min</div>
                      <div className="text-xs text-slate-400">{format(new Date(s.date), "MMM d, yyyy")}</div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
