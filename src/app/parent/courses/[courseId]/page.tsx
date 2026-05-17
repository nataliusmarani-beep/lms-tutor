import { redirect, notFound } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import ParentCourseAccordion from "@/components/ParentCourseAccordion";
import { t } from "@/lib/i18n";
import { getLang } from "@/lib/getLang";

export default async function ParentCoursePage({ params }: { params: { courseId: string } }) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || profile.role !== "parent") redirect("/login");

  const lang = getLang();

  // Linked student
  const { data: links } = await supabase
    .from("parent_student").select("student_id").eq("parent_id", user.id);
  const studentId = links?.[0]?.student_id;
  if (!studentId) redirect("/parent");

  const { data: student } = await supabase
    .from("profiles").select("id, name").eq("id", studentId).single();

  const { data: course } = await supabase
    .from("courses").select("id, title, title_id, icon, description, description_id").eq("id", params.courseId).single();
  if (!course) notFound();

  // All modules
  const { data: modulesRaw } = await supabase
    .from("course_modules")
    .select("id, title, title_id, focus, focus_id, icon, week_number, sort_order, legacy_module_id")
    .eq("course_id", params.courseId)
    .order("sort_order");
  const modules = modulesRaw ?? [];

  // All checklist items for all modules
  const moduleIds = modules.map((m: { id: string }) => m.id);
  const { data: allItems } = moduleIds.length > 0
    ? await supabase
        .from("module_checklist_items")
        .select("course_module_id, item_key, label, label_id, item_type, sort_order")
        .in("course_module_id", moduleIds)
        .order("sort_order")
    : { data: [] };

  // All checklist completions for student
  const { data: allCompletions } = await supabase
    .from("checklist_completions")
    .select("item_key, course_module_id, module_id")
    .eq("student_id", studentId);

  // All sessions for student in this course
  const { data: allSessions } = await supabase
    .from("learning_sessions")
    .select("id, date, duration_minutes, tutor_notes, tutor_notes_id, student_notes, student_notes_id, course_module_id, module_id, photo_url")
    .eq("student_id", studentId)
    .order("date", { ascending: false });

  // All quizzes for all modules
  const { data: allQuizzes } = moduleIds.length > 0
    ? await supabase
        .from("module_quizzes")
        .select("id, title, description, course_module_id")
        .in("course_module_id", moduleIds)
        .order("sort_order")
    : { data: [] };

  // All quiz attempts for student
  const quizIds = (allQuizzes ?? []).map((q: { id: string }) => q.id);
  const { data: allAttempts } = quizIds.length > 0
    ? await supabase
        .from("quiz_attempts")
        .select("quiz_id, score, max_score, completed_at")
        .eq("student_id", studentId)
        .in("quiz_id", quizIds)
        .order("completed_at", { ascending: false })
    : { data: [] };

  // Build per-module data packages
  const moduleData = modules.map((mod: {
    id: string; title: string; focus: string | null; icon: string;
    week_number: number | null; sort_order: number; legacy_module_id: number | null;
  }) => {
    const legacyId = mod.legacy_module_id ?? null;

    const modItems = (allItems ?? []).filter(
      (i: { course_module_id: string }) => i.course_module_id === mod.id
    );
    const studentItems = modItems.filter((i: { item_type: string }) => i.item_type === "student");
    const tutorItems   = modItems.filter((i: { item_type: string }) => i.item_type === "teacher");

    const modCompletions = (allCompletions ?? []).filter(
      (c: { course_module_id: string | null; module_id: number | null }) =>
        c.course_module_id === mod.id || (legacyId != null && c.module_id === legacyId)
    );

    const modSessions = (allSessions ?? []).filter(
      (s: { course_module_id: string | null; module_id: number | null }) =>
        s.course_module_id === mod.id || (legacyId != null && s.module_id === legacyId)
    );

    const modQuizzes = (allQuizzes ?? []).filter(
      (q: { course_module_id: string }) => q.course_module_id === mod.id
    );

    const modAttempts = (allAttempts ?? []).filter(
      (a: { quiz_id: string }) => modQuizzes.some((q: { id: string }) => q.id === a.quiz_id)
    );

    const studentDone = studentItems.filter(
      (i: { item_key: string }) => modCompletions.some((c: { item_key: string }) => c.item_key === i.item_key)
    ).length;
    const tutorDone = tutorItems.filter(
      (i: { item_key: string }) => modCompletions.some((c: { item_key: string }) => c.item_key === i.item_key)
    ).length;
    const total = modItems.length;
    const done = modCompletions.filter(
      (c: { item_key: string }) => modItems.some((i: { item_key: string }) => i.item_key === c.item_key)
    ).length;

    return {
      id: mod.id,
      title: mod.title,
      title_id: (mod as { title_id?: string | null }).title_id ?? null,
      focus: mod.focus,
      focus_id: (mod as { focus_id?: string | null }).focus_id ?? null,
      icon: mod.icon,
      week_number: mod.week_number,
      pct: total > 0 ? Math.round((done / total) * 100) : 0,
      sessions: modSessions,
      studentItems,
      tutorItems,
      studentDone,
      tutorDone,
      completedKeys: modCompletions.map((c: { item_key: string }) => c.item_key),
      quizzes: modQuizzes.map((q: { id: string; title: string; description: string | null }) => ({
        ...q,
        bestAttempt: (modAttempts as Array<{ quiz_id: string; score: number; max_score: number; completed_at: string }>)
          .filter((a) => a.quiz_id === q.id)
          .sort((a, b) => b.score - a.score)[0] ?? null,
      })),
    };
  });

  return (
    <div className="min-h-screen">
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-6">

        {/* Breadcrumb */}
        <div className="flex items-center gap-2 text-sm text-slate-400 flex-wrap">
          <Link href="/parent" className="hover:text-slate-600">
            {t(lang, "dashboard").replace("← ", "")}
          </Link>
          <span>›</span>
          <span className="text-slate-600">{course.icon} {course.title}</span>
        </div>

        {/* Course Header */}
        <div
          className="rounded-2xl px-6 py-5 shadow-sm"
          style={{ background: "linear-gradient(135deg, #0f1f3d 0%, #1e3a6e 60%, #2563eb 100%)" }}
        >
          <div className="flex items-center gap-4">
            <span className="text-4xl">{course.icon}</span>
            <div className="flex-1">
              <p className="text-blue-200 text-sm">{student?.name}</p>
              <h1 className="text-xl font-bold text-white">
                {(lang === "id" && (course as {title_id?: string|null}).title_id) ? (course as {title_id: string}).title_id : course.title}
              </h1>
              {(course.description || (course as {description_id?: string|null}).description_id) && (
                <p className="text-blue-200 text-sm mt-0.5">
                  {(lang === "id" && (course as {description_id?: string|null}).description_id)
                    ? (course as {description_id: string}).description_id
                    : course.description}
                </p>
              )}
            </div>
            <div className="text-right shrink-0">
              <div className="text-2xl font-bold text-white">
                {modules.length}
              </div>
              <div className="text-blue-200 text-xs">{t(lang, "modules")}</div>
            </div>
          </div>
        </div>

        {/* Per-week accordion */}
        {modules.length === 0 ? (
          <div className="card text-center py-10">
            <div className="text-4xl mb-3">📚</div>
            <p className="text-slate-500">No modules in this course yet.</p>
          </div>
        ) : (
          <ParentCourseAccordion modules={moduleData} lang={lang} />
        )}

      </div>
    </div>
  );
}
