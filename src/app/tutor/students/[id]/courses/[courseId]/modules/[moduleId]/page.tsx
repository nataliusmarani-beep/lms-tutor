import { redirect, notFound } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import Navbar from "@/components/Navbar";
import ChecklistSection from "@/components/ChecklistSection";
import { format } from "date-fns";

interface PageParams {
  id: string;        // student id
  courseId: string;
  moduleId: string;
}

export default async function TutorCourseModuleDetailPage({
  params,
}: {
  params: PageParams;
}) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: tutor } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!tutor || tutor.role !== "tutor") redirect("/login");

  const { data: student } = await supabase.from("profiles").select("*").eq("id", params.id).single();
  if (!student) notFound();

  const { data: course } = await supabase
    .from("courses")
    .select("id, title, icon")
    .eq("id", params.courseId)
    .single();
  if (!course) notFound();

  const { data: mod } = await supabase
    .from("course_modules")
    .select("*")
    .eq("id", params.moduleId)
    .single();
  if (!mod) notFound();

  const [{ data: sessions }, { data: checks }, { data: checklistItems }] = await Promise.all([
    supabase
      .from("learning_sessions")
      .select("*")
      .eq("student_id", params.id)
      .eq("course_module_id", params.moduleId)
      .order("date", { ascending: false }),
    supabase
      .from("checklist_completions")
      .select("*")
      .eq("student_id", params.id)
      .eq("course_module_id", params.moduleId),
    supabase
      .from("module_checklist_items")
      .select("*")
      .eq("course_module_id", params.moduleId)
      .order("sort_order"),
  ]);

  return (
    <div className="min-h-screen">
      <Navbar name={tutor.name} role="tutor" />
      <div className="max-w-3xl mx-auto px-4 py-8 space-y-8">
        {/* Breadcrumb */}
        <div className="flex items-center gap-2 text-sm text-slate-400 flex-wrap">
          <Link href="/tutor" className="hover:text-slate-600">Dashboard</Link>
          <span>›</span>
          <Link href={`/tutor/students/${params.id}`} className="hover:text-slate-600">{student.name}</Link>
          <span>›</span>
          <span className="text-slate-600">{mod.title}</span>
        </div>

        {/* Module Header */}
        <div className="card">
          <div className="flex items-start gap-3">
            <span className="text-3xl">{mod.icon}</span>
            <div className="flex-1">
              <div className="flex items-center gap-2 flex-wrap">
                {mod.week_number && <span className="badge-blue">Week {mod.week_number}</span>}
                <span className="badge-gray">{course.icon} {course.title}</span>
              </div>
              <h1 className="text-xl font-bold text-slate-800 mt-1">{mod.title}</h1>
              {mod.focus && <p className="text-slate-500 text-sm mt-1">{mod.focus}</p>}
              <p className="text-sm text-slate-500 mt-2">
                Student: <strong>{student.name}</strong>
              </p>
            </div>
            <Link
              href={`/tutor/courses/${params.courseId}/modules/${params.moduleId}/edit`}
              className="btn-secondary text-sm py-1.5 shrink-0"
            >
              Edit Module
            </Link>
          </div>
        </div>

        {/* Sessions */}
        <div>
          <div className="flex items-center justify-between mb-3">
            <h2 className="text-lg font-semibold text-slate-700">Sessions</h2>
            <Link
              href={`/tutor/sessions/new?student=${params.id}&courseModule=${params.moduleId}`}
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
                id: string;
                date: string;
                duration_minutes: number;
                tutor_notes: string | null;
                student_notes: string | null;
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

        {/* Checklist */}
        <ChecklistSection
          moduleId={0}
          courseModuleId={params.moduleId}
          items={checklistItems ?? []}
          completions={checks ?? []}
          studentId={params.id}
          currentUserId={user.id}
          currentUserRole="tutor"
        />

        {/* Assignments placeholder */}
        <div className="card">
          <h3 className="font-semibold text-slate-700 mb-2">Assignments</h3>
          <p className="text-sm text-slate-400 italic">Assignments for course-based modules coming soon.</p>
        </div>
      </div>
    </div>
  );
}
