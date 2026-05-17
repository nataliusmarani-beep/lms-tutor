import { redirect, notFound } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import ResourcePanel from "@/components/ResourcePanel";
import { format } from "date-fns";
import { t } from "@/lib/i18n";
import { getLang } from "@/lib/getLang";
import CurriculumAccordion from "@/components/CurriculumAccordion";

interface PageParams {
  courseId: string;
  moduleId: string;
}

interface ChecklistItem {
  id: string;
  item_key: string;
  label: string;
  item_type: string;
  sort_order: number;
}

export default async function ParentModulePage({ params }: { params: PageParams }) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || profile.role !== "parent") redirect("/login");

  // Get linked student
  const { data: links } = await supabase
    .from("parent_student")
    .select("student_id")
    .eq("parent_id", user.id);
  const studentId = links?.[0]?.student_id;
  if (!studentId) redirect("/parent");

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

  // All modules in this course for curriculum overview
  const { data: allCourseModules } = await supabase
    .from("course_modules")
    .select("id, title, title_id, focus, focus_id, icon, week_number, sort_order")
    .eq("course_id", params.courseId)
    .order("sort_order");

  // Checklist items for ALL modules (for accordion expand)
  const allModIds = (allCourseModules ?? []).map((m: { id: string }) => m.id);
  const { data: allModuleItems } = allModIds.length > 0
    ? await supabase
        .from("module_checklist_items")
        .select("course_module_id, item_key, label, label_id, item_type, sort_order")
        .in("course_module_id", allModIds)
        .order("sort_order")
    : { data: [] };

  // Completions for all modules (to show tick status across curriculum)
  const { data: allCompletions } = await supabase
    .from("checklist_completions")
    .select("item_key, course_module_id, module_id")
    .eq("student_id", studentId);

  const legacyModuleId: number | null = mod.legacy_module_id ?? null;

  // Build OR filter to match both UUID and legacy integer module_id
  const sessionFilter = legacyModuleId != null
    ? `course_module_id.eq.${params.moduleId},module_id.eq.${legacyModuleId}`
    : `course_module_id.eq.${params.moduleId}`;

  const completionFilter = legacyModuleId != null
    ? `course_module_id.eq.${params.moduleId},module_id.eq.${legacyModuleId}`
    : `course_module_id.eq.${params.moduleId}`;

  const [{ data: sessions }, { data: checks }, { data: checklistItems }, { data: quizzes }] = await Promise.all([
    supabase
      .from("learning_sessions")
      .select("id, date, duration_minutes, tutor_notes, student_notes")
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

  const lang = getLang();

  const allItems = (checklistItems ?? []) as ChecklistItem[];
  const allChecks = checks ?? [];
  const studentItems = allItems.filter((i) => i.item_type === "student");
  const teacherItems = allItems.filter((i) => i.item_type === "teacher");
  const done = allItems.filter((i) => allChecks.some((c: { item_key: string }) => c.item_key === i.item_key)).length;
  const pct = allItems.length === 0 ? 0 : Math.round((done / allItems.length) * 100);

  // Quiz attempt summaries
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

  return (
    <div className="min-h-screen">
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-6">

        {/* Breadcrumb */}
        <div className="flex items-center gap-2 text-sm text-slate-400 flex-wrap">
          <Link href="/parent" className="hover:text-slate-600">{t(lang, "dashboard").replace("← ", "")}</Link>
          <span>›</span>
          <span className="text-slate-500">{course.icon} {course.title}</span>
          <span>›</span>
          <span className="text-slate-600">{mod.title}</span>
        </div>

        {/* Module Header */}
        <div className="card">
          <div className="flex items-start gap-3">
            <span className="text-3xl">{mod.icon}</span>
            <div className="flex-1">
              <div className="flex items-center gap-2 mb-1 flex-wrap">
                {mod.week_number && <span className="badge-blue">{t(lang, "week")} {mod.week_number}</span>}
                <span className="badge-gray">{course.icon} {course.title}</span>
              </div>
              <h1 className="text-xl font-bold text-slate-800">{mod.title}</h1>
              {mod.focus && <p className="text-slate-500 text-sm mt-1">{mod.focus}</p>}
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

        {/* Course Curriculum Accordion */}
        {allCourseModules && allCourseModules.length > 0 && (
          <CurriculumAccordion
            courseId={params.courseId}
            currentModuleId={params.moduleId}
            modules={allCourseModules as { id: string; title: string; focus: string | null; icon: string; week_number: number | null }[]}
            allItems={(allModuleItems ?? []) as { course_module_id: string; item_key: string; label: string; item_type: string }[]}
            completions={(allCompletions ?? []) as { item_key: string; course_module_id: string | null; module_id: number | null }[]}
            lang={lang}
          />
        )}

        {/* Module Overview */}
        <div className="card bg-indigo-50 border-indigo-100">
          <h2 className="font-semibold text-indigo-800 mb-3 flex items-center gap-2">
            <span>📋</span>
            {lang === "id" ? "Gambaran Umum Modul" : "Module Overview"}
          </h2>
          <div className="grid grid-cols-2 gap-3 mb-3">
            <div className="bg-white rounded-xl p-3">
              <div className="text-xs text-slate-400 mb-1">{lang === "id" ? "Total Sesi" : "Total Sessions"}</div>
              <div className="text-2xl font-bold text-indigo-600">{sessions?.length ?? 0}</div>
            </div>
            <div className="bg-white rounded-xl p-3">
              <div className="text-xs text-slate-400 mb-1">{lang === "id" ? "Waktu Belajar" : "Learning Time"}</div>
              <div className="text-2xl font-bold text-indigo-600">
                {Math.round(((sessions ?? []).reduce((a: number, s: { duration_minutes: number }) => a + s.duration_minutes, 0) / 60) * 10) / 10}h
              </div>
            </div>
          </div>
          <div className="grid grid-cols-2 gap-3">
            <div className="bg-white rounded-xl p-3">
              <div className="text-xs text-slate-400 mb-1">{lang === "id" ? "Checklist Siswa" : "Student Checklist"}</div>
              <div className="text-lg font-bold text-indigo-600">
                {studentItems.filter((i) => allChecks.some((c: { item_key: string }) => c.item_key === i.item_key)).length}/{studentItems.length}
              </div>
            </div>
            <div className="bg-white rounded-xl p-3">
              <div className="text-xs text-slate-400 mb-1">{lang === "id" ? "Checklist Tutor" : "Tutor Checklist"}</div>
              <div className="text-lg font-bold text-indigo-600">
                {teacherItems.filter((i) => allChecks.some((c: { item_key: string }) => c.item_key === i.item_key)).length}/{teacherItems.length}
              </div>
            </div>
          </div>
        </div>

        {/* Sessions */}
        <div>
          <h2 className="font-semibold text-slate-700 mb-3">
            {t(lang, "sessionsLabel")} ({sessions?.length ?? 0})
          </h2>
          {!sessions || sessions.length === 0 ? (
            <p className="text-sm text-slate-400 italic">{t(lang, "noSessionsModule")}</p>
          ) : (
            <div className="space-y-2">
              {sessions.map((s: { id: string; date: string; duration_minutes: number; tutor_notes: string | null; student_notes?: string | null }) => (
                <div key={s.id} className="card py-3">
                  <div className="flex items-center justify-between">
                    <span className="text-sm font-medium text-slate-700">
                      {format(new Date(s.date), "EEEE, MMMM d, yyyy")}
                    </span>
                    <span className="badge-blue">{s.duration_minutes} {t(lang, "min")}</span>
                  </div>
                  {s.tutor_notes && (
                    <p className="text-xs text-slate-600 mt-1">
                      <span className="text-slate-400">{lang === "id" ? "Catatan tutor: " : "Tutor notes: "}</span>{s.tutor_notes}
                    </p>
                  )}
                  {s.student_notes && (
                    <p className="text-xs text-slate-600 mt-0.5">
                      <span className="text-slate-400">{lang === "id" ? "Catatan siswa: " : "Student notes: "}</span>{s.student_notes}
                    </p>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Checklist — read-only view */}
        <div>
          <h2 className="font-semibold text-slate-700 mb-3">{t(lang, "checklistProgress")}</h2>
          <div className="space-y-4">
            {/* Student items */}
            {studentItems.length > 0 && (
              <div className="card">
                <h3 className="text-sm font-semibold text-slate-600 mb-3">{t(lang, "studentChecklist")}</h3>
                <div className="space-y-2">
                  {studentItems.map((item) => {
                    const completed = allChecks.some((c: { item_key: string }) => c.item_key === item.item_key);
                    return (
                      <div key={item.id} className="flex items-center gap-2">
                        <div className={`w-5 h-5 rounded-full flex items-center justify-center shrink-0 ${
                          completed ? "bg-green-500" : "bg-slate-200"
                        }`}>
                          {completed && <span className="text-white text-xs">✓</span>}
                        </div>
                        <span className={`text-sm ${completed ? "text-slate-700 line-through" : "text-slate-600"}`}>
                          {item.label}
                        </span>
                      </div>
                    );
                  })}
                </div>
                <div className="mt-3 text-xs text-slate-400">
                  {studentItems.filter((i) => allChecks.some((c: { item_key: string }) => c.item_key === i.item_key)).length}/{studentItems.length} completed
                </div>
              </div>
            )}

            {/* Teacher items */}
            {teacherItems.length > 0 && (
              <div className="card">
                <h3 className="text-sm font-semibold text-slate-600 mb-3">{t(lang, "tutorChecklist")}</h3>
                <div className="space-y-2">
                  {teacherItems.map((item) => {
                    const completed = allChecks.some((c: { item_key: string }) => c.item_key === item.item_key);
                    return (
                      <div key={item.id} className="flex items-center gap-2">
                        <div className={`w-5 h-5 rounded-full flex items-center justify-center shrink-0 ${
                          completed ? "bg-indigo-500" : "bg-slate-200"
                        }`}>
                          {completed && <span className="text-white text-xs">✓</span>}
                        </div>
                        <span className={`text-sm ${completed ? "text-slate-700 line-through" : "text-slate-600"}`}>
                          {item.label}
                        </span>
                      </div>
                    );
                  })}
                </div>
                <div className="mt-3 text-xs text-slate-400">
                  {teacherItems.filter((i) => allChecks.some((c: { item_key: string }) => c.item_key === i.item_key)).length}/{teacherItems.length} completed
                </div>
              </div>
            )}

            {allItems.length === 0 && (
              <p className="text-sm text-slate-400 italic">{t(lang, "noChecklistItems")}</p>
            )}
          </div>
        </div>

        {/* Lesson Resources — read-only */}
        <ResourcePanel courseModuleId={params.moduleId} currentUserRole="parent" />

        {/* Quizzes — read-only score summary */}
        {quizzes && quizzes.length > 0 && (
          <div>
            <h2 className="font-semibold text-slate-700 mb-3">{t(lang, "quizzes")}</h2>
            <div className="space-y-3">
              {quizzes.map((quiz: { id: string; title: string; description: string | null }) => {
                const best = bestAttempt(quiz.id);
                const scorePct = best ? Math.round((best.score / best.max_score) * 100) : null;
                return (
                  <div key={quiz.id} className="card flex items-center gap-4">
                    <span className="text-2xl">📝</span>
                    <div className="flex-1">
                      <div className="font-medium text-slate-800">{quiz.title}</div>
                      {quiz.description && (
                        <p className="text-xs text-slate-500 mt-0.5">{quiz.description}</p>
                      )}
                    </div>
                    <div className="text-right shrink-0">
                      {best ? (
                        <>
                          <div className={`text-lg font-bold ${scorePct! >= 80 ? "text-green-600" : scorePct! >= 50 ? "text-blue-600" : "text-amber-500"}`}>
                            {best.score}/{best.max_score}
                          </div>
                          <div className="text-xs text-slate-400">{scorePct}%</div>
                        </>
                      ) : (
                        <span className="badge-gray text-xs">{t(lang, "notAttempted")}</span>
                      )}
                    </div>
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
