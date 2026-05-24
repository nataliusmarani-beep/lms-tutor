import { redirect, notFound } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import ResourcePanel from "@/components/ResourcePanel";
import QuizReview from "@/components/QuizReview";
import NotesList from "@/components/NotesList";
import { format } from "date-fns";
import { t } from "@/lib/i18n";
import { getLang } from "@/lib/getLang";

interface PageParams {
  courseId: string;
  moduleId: string;
}

interface ChecklistItem {
  id: string;
  item_key: string;
  label: string;
  label_id?: string | null;
  item_type: string;
  sort_order: number;
}

export default async function ParentModulePage({ params }: { params: PageParams }) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || !["parent", "guardian"].includes(profile.role)) redirect("/login");

  const { data: links } = await supabase
    .from("parent_student").select("student_id").eq("parent_id", user.id);
  const studentId = links?.[0]?.student_id;
  if (!studentId) redirect("/parent");

  const { data: course } = await supabase
    .from("courses").select("id, title, title_id, icon")
    .eq("id", params.courseId).single();
  if (!course) notFound();

  const { data: mod } = await supabase
    .from("course_modules").select("*")
    .eq("id", params.moduleId).single();
  if (!mod) notFound();

  const lang = getLang();

  const legacyModuleId: number | null = mod.legacy_module_id ?? null;
  const sessionFilter = legacyModuleId != null
    ? `course_module_id.eq.${params.moduleId},module_id.eq.${legacyModuleId}`
    : `course_module_id.eq.${params.moduleId}`;
  const completionFilter = legacyModuleId != null
    ? `course_module_id.eq.${params.moduleId},module_id.eq.${legacyModuleId}`
    : `course_module_id.eq.${params.moduleId}`;

  const [{ data: sessions }, { data: checks }, { data: checklistItems }, { data: quizzes }] = await Promise.all([
    supabase
      .from("learning_sessions")
      .select("id, date, duration_minutes, tutor_notes, tutor_notes_id, student_notes, student_notes_id")
      .eq("student_id", studentId)
      .or(sessionFilter)
      .order("date", { ascending: false }),
    supabase
      .from("checklist_completions")
      .select("item_key, item_type")
      .eq("student_id", studentId)
      .or(completionFilter),
    supabase
      .from("module_checklist_items")
      .select("id, item_key, label, label_id, item_type, sort_order")
      .eq("course_module_id", params.moduleId)
      .order("sort_order"),
    supabase
      .from("module_quizzes")
      .select("id, title, description")
      .eq("course_module_id", params.moduleId)
      .order("sort_order"),
  ]);

  const allItems = (checklistItems ?? []) as ChecklistItem[];
  const allChecks = checks ?? [];
  const studentItems = allItems.filter((i) => i.item_type === "student");
  const teacherItems = allItems.filter((i) => i.item_type === "teacher");
  const done = allItems.filter((i) => allChecks.some((c: { item_key: string }) => c.item_key === i.item_key)).length;
  const pct = allItems.length === 0 ? 0 : Math.round((done / allItems.length) * 100);

  const quizIds = (quizzes ?? []).map((q: { id: string }) => q.id);
  const { data: attempts } = quizIds.length > 0
    ? await supabase
        .from("quiz_attempts")
        .select("quiz_id, score, max_score, completed_at")
        .eq("student_id", studentId)
        .in("quiz_id", quizIds)
        .order("completed_at", { ascending: false })
    : { data: [] };

  const bestAttempt = (qId: string) =>
    (attempts ?? [])
      .filter((a: { quiz_id: string }) => a.quiz_id === qId)
      .sort((a: { score: number }, b: { score: number }) => b.score - a.score)[0] ?? null;

  const courseTitle = (lang === "id" && (course as { title_id?: string | null }).title_id)
    ? (course as { title_id: string }).title_id : course.title;
  const modTitle = (lang === "id" && mod.title_id) ? mod.title_id : mod.title;

  return (
    <div className="min-h-screen">
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-6">

        {/* Breadcrumb */}
        <div className="flex items-center gap-2 text-sm text-slate-400 flex-wrap">
          <Link href="/parent" className="hover:text-slate-600">{t(lang, "dashboard").replace("← ", "")}</Link>
          <span>›</span>
          <Link href={`/parent/courses/${params.courseId}`} className="hover:text-slate-600">{course.icon} {courseTitle}</Link>
          <span>›</span>
          <span className="text-slate-600">{modTitle}</span>
        </div>

        {/* Module Header */}
        <div className="card">
          <div className="flex items-start gap-3">
            <span className="text-3xl">{mod.icon}</span>
            <div className="flex-1">
              <div className="flex items-center gap-2 mb-1 flex-wrap">
                {mod.week_number && (
                  <span className="badge-blue">{t(lang, "week")} {mod.week_number}</span>
                )}
                <span className="badge-gray">{course.icon} {courseTitle}</span>
              </div>
              <h1 className="text-xl font-bold text-slate-800">{modTitle}</h1>
              {(mod.focus || mod.focus_id) && (
                <p className="text-slate-500 text-sm mt-1">
                  {(lang === "id" && mod.focus_id) ? mod.focus_id : mod.focus}
                </p>
              )}
            </div>
            <div className="text-right shrink-0">
              <div className={`text-2xl font-bold ${pct >= 100 ? "text-green-600" : "text-teal-600"}`}>{pct}%</div>
              <div className="text-xs text-slate-400">{t(lang, "complete")}</div>
            </div>
          </div>
          <div className="mt-3">
            <div className="w-full bg-slate-200 rounded-full h-2">
              <div
                className={`h-2 rounded-full ${pct >= 100 ? "bg-green-500" : "bg-teal-500"}`}
                style={{ width: `${pct}%` }}
              />
            </div>
          </div>
        </div>

        {/* Sessions */}
        <div>
          <h2 className="font-semibold text-slate-700 mb-3">
            {t(lang, "sessionsLabel")} ({sessions?.length ?? 0})
          </h2>
          {!sessions || sessions.length === 0 ? (
            <p className="text-sm text-slate-400 italic">{t(lang, "noSessionsForModule")}</p>
          ) : (
            <div className="space-y-2">
              {sessions.map((s: {
                id: string; date: string; duration_minutes: number;
                tutor_notes: string | null; tutor_notes_id?: string | null;
                student_notes?: string | null; student_notes_id?: string | null;
              }) => (
                <div key={s.id} className="card py-3">
                  <div className="flex items-center justify-between">
                    <span className="text-sm font-medium text-slate-700">
                      {format(new Date(s.date), "EEEE, MMMM d, yyyy")}
                    </span>
                    <span className="text-xs font-bold bg-teal-100 text-teal-700 px-2 py-0.5 rounded-full">
                      {s.duration_minutes} {t(lang, "min")}
                    </span>
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

        {/* Checklist — read-only */}
        <div>
          <h2 className="font-semibold text-slate-700 mb-3">{t(lang, "checklistProgress")}</h2>
          <div className="space-y-4">
            {studentItems.length > 0 && (
              <div className="card">
                <h3 className="text-sm font-semibold text-slate-600 mb-3">{t(lang, "studentChecklist")}</h3>
                <div className="space-y-2">
                  {studentItems.map((item) => {
                    const completed = allChecks.some((c: { item_key: string }) => c.item_key === item.item_key);
                    return (
                      <div key={item.id} className="flex items-center gap-2">
                        <div className={`w-5 h-5 rounded-full flex items-center justify-center shrink-0 ${completed ? "bg-green-500" : "bg-slate-200"}`}>
                          {completed && <span className="text-white text-xs">✓</span>}
                        </div>
                        <span className={`text-sm ${completed ? "text-slate-400 line-through" : "text-slate-600"}`}>
                          {(lang === "id" && item.label_id) ? item.label_id : item.label}
                        </span>
                      </div>
                    );
                  })}
                </div>
                <div className="mt-3 text-xs text-slate-400">
                  {studentItems.filter((i) => allChecks.some((c: { item_key: string }) => c.item_key === i.item_key)).length}/{studentItems.length} {t(lang, "completed")}
                </div>
              </div>
            )}

            {teacherItems.length > 0 && (
              <div className="card">
                <h3 className="text-sm font-semibold text-slate-600 mb-3">{t(lang, "tutorChecklist")}</h3>
                <div className="space-y-2">
                  {teacherItems.map((item) => {
                    const completed = allChecks.some((c: { item_key: string }) => c.item_key === item.item_key);
                    return (
                      <div key={item.id} className="flex items-center gap-2">
                        <div className={`w-5 h-5 rounded-full flex items-center justify-center shrink-0 ${completed ? "bg-teal-500" : "bg-slate-200"}`}>
                          {completed && <span className="text-white text-xs">✓</span>}
                        </div>
                        <span className={`text-sm ${completed ? "text-slate-400 line-through" : "text-slate-600"}`}>
                          {(lang === "id" && item.label_id) ? item.label_id : item.label}
                        </span>
                      </div>
                    );
                  })}
                </div>
                <div className="mt-3 text-xs text-slate-400">
                  {teacherItems.filter((i) => allChecks.some((c: { item_key: string }) => c.item_key === i.item_key)).length}/{teacherItems.length} {t(lang, "completed")}
                </div>
              </div>
            )}

            {allItems.length === 0 && (
              <p className="text-sm text-slate-400 italic">{t(lang, "noChecklistItems")}</p>
            )}
          </div>
        </div>

        {/* Lesson Resources */}
        <ResourcePanel courseModuleId={params.moduleId} currentUserRole="parent" />

        {/* Quizzes — read-only score + answer review */}
        {quizzes && quizzes.length > 0 && (
          <div>
            <h2 className="font-semibold text-slate-700 mb-3">{t(lang, "quizzes")}</h2>
            <div className="space-y-3">
              {quizzes.map((quiz: { id: string; title: string; description: string | null }) => {
                const best = bestAttempt(quiz.id);
                const isHomeworkOnly = best && best.max_score === 0;
                const scorePct = best && best.max_score > 0 ? Math.round((best.score / best.max_score) * 100) : null;
                return (
                  <div key={quiz.id} className="card">
                    <div className="flex items-center gap-4 mb-3">
                      <span className="text-2xl">📝</span>
                      <div className="flex-1">
                        <div className="font-medium text-slate-800">{quiz.title}</div>
                        {quiz.description && (
                          <p className="text-xs text-slate-500 mt-0.5">{quiz.description}</p>
                        )}
                      </div>
                      <div className="text-right shrink-0">
                        {best && isHomeworkOnly ? (
                          <span className="text-sm font-semibold text-teal-600">
                            {lang === "id" ? "✓ Dikirim" : "✓ Submitted"}
                          </span>
                        ) : best ? (
                          <>
                            <div className={`text-lg font-bold ${scorePct! >= 80 ? "text-green-600" : scorePct! >= 50 ? "text-teal-600" : "text-amber-500"}`}>
                              {best.score}/{best.max_score}
                            </div>
                            <div className="text-xs text-slate-400">{scorePct}%</div>
                          </>
                        ) : (
                          <span className="badge-gray text-xs">{t(lang, "notAttempted")}</span>
                        )}
                      </div>
                    </div>
                    {best && (
                      <QuizReview quizId={quiz.id} studentId={studentId} lang={lang} accentColor="teal" />
                    )}
                  </div>
                );
              })}
            </div>
          </div>
        )}

      </div>
    </div>
  );
}
