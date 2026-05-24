import { redirect, notFound } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import ChecklistSection from "@/components/ChecklistSection";
import ResourcePanel from "@/components/ResourcePanel";
import QuizViewer from "@/components/QuizViewer";
import NotesList from "@/components/NotesList";
import { format } from "date-fns";
import { t } from "@/lib/i18n";
import { getLang } from "@/lib/getLang";

interface PageParams {
  courseId: string;
  moduleId: string;
}

export default async function StudentCourseModulePage({
  params,
}: {
  params: PageParams;
}) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || profile.role !== "student") redirect("/login");

  const lang = getLang();

  const { data: course } = await supabase
    .from("courses")
    .select("id, title, title_id, icon")
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
      .select("id, date, duration_minutes, tutor_notes, tutor_notes_id, student_notes, student_notes_id, course_module_id")
      .eq("student_id", user.id)
      .eq("course_module_id", params.moduleId)
      .order("date", { ascending: false }),
    supabase
      .from("checklist_completions")
      .select("*")
      .eq("student_id", user.id)
      .eq("course_module_id", params.moduleId),
    supabase
      .from("module_checklist_items")
      .select("*")
      .eq("course_module_id", params.moduleId)
      .order("sort_order"),
  ]);

  const allItems = checklistItems ?? [];
  const allChecks = checks ?? [];
  const done = allItems.filter((i: { item_key: string }) =>
    allChecks.some((c: { item_key: string }) => c.item_key === i.item_key)
  ).length;
  const pct = allItems.length === 0 ? 0 : Math.round((done / allItems.length) * 100);

  return (
    <div className="min-h-screen">
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-6">
        {/* Breadcrumb */}
        <div className="flex items-center gap-2 text-sm text-slate-400 flex-wrap">
          <Link href="/student" className="hover:text-slate-600">{t(lang, "dashboard").replace("← ", "")}</Link>
          <span>›</span>
          <span className="text-slate-500">{course.icon} {(lang === "id" && (course as {title_id?: string|null}).title_id) ? (course as {title_id: string}).title_id : course.title}</span>
          <span>›</span>
          <span className="text-slate-600">{(lang === "id" && mod.title_id) ? mod.title_id : mod.title}</span>
        </div>

        {/* Module Header */}
        <div className="card">
          <div className="flex items-start gap-3">
            <span className="text-3xl">{mod.icon}</span>
            <div className="flex-1">
              <div className="flex items-center gap-2 mb-1 flex-wrap">
                {mod.week_number && <span className="badge-blue">{t(lang, "week")} {mod.week_number}</span>}
                <span className="badge-gray">{course.icon} {(lang === "id" && (course as {title_id?: string|null}).title_id) ? (course as {title_id: string}).title_id : course.title}</span>
              </div>
              <h1 className="text-xl font-bold text-slate-800">{(lang === "id" && mod.title_id) ? mod.title_id : mod.title}</h1>
              {(mod.focus || mod.focus_id) && <p className="text-slate-500 text-sm mt-1">{(lang === "id" && mod.focus_id) ? mod.focus_id : mod.focus}</p>}
            </div>
            <div className="text-right shrink-0">
              <div className={`text-2xl font-bold ${pct >= 100 ? "text-green-600" : "text-blue-600"}`}>{pct}%</div>
              <div className="text-xs text-slate-400">{t(lang, "complete")}</div>
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

        {/* Sessions */}
        <div>
          <h2 className="font-semibold text-slate-700 mb-3">{t(lang, "sessionsLabel")}</h2>
          {!sessions || sessions.length === 0 ? (
            <p className="text-sm text-slate-400 italic">{t(lang, "noSessionsForModule")}</p>
          ) : (
            <div className="space-y-2">
              {sessions.map((s: {
                id: string;
                date: string;
                duration_minutes: number;
                tutor_notes: string | null;
                tutor_notes_id?: string | null;
                student_notes: string | null;
                student_notes_id?: string | null;
              }) => (
                <div key={s.id} className="card py-3">
                  <div className="flex items-center justify-between">
                    <span className="text-sm font-medium text-slate-700">
                      {format(new Date(s.date), "EEEE, MMMM d, yyyy")}
                    </span>
                    <span className="badge-blue">{s.duration_minutes} {t(lang, "min")}</span>
                  </div>
                  <NotesList
                    label={t(lang, "tutorNotes")}
                    text={(lang === "id" && s.tutor_notes_id) ? s.tutor_notes_id : s.tutor_notes}
                    variant="tutor"
                  />
                  <NotesList
                    label={t(lang, "studentNotes")}
                    text={(lang === "id" && s.student_notes_id) ? s.student_notes_id : s.student_notes}
                    variant="student"
                  />
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Checklist */}
        <ChecklistSection
          moduleId={0}
          courseModuleId={params.moduleId}
          items={allItems}
          completions={allChecks}
          studentId={user.id}
          currentUserId={user.id}
          currentUserRole="student"
          lang={lang}
        />

        {/* Lesson Resources */}
        <ResourcePanel courseModuleId={params.moduleId} currentUserRole="student" />

        {/* Quiz */}
        <QuizViewer courseModuleId={params.moduleId} studentId={user.id} />
      </div>
    </div>
  );
}
