import { redirect, notFound } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import StudentCourseAccordion from "@/components/StudentCourseAccordion";
import { t } from "@/lib/i18n";
import { getLang } from "@/lib/getLang";

export default async function StudentCoursePage({ params }: { params: { courseId: string } }) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || profile.role !== "student") redirect("/login");

  const lang = getLang();

  const { data: course } = await supabase
    .from("courses")
    .select("id, title, title_id, icon, icon_url, description, description_id, created_by")
    .eq("id", params.courseId)
    .single();
  if (!course) notFound();

  // Fetch tutor info
  const createdBy = (course as { created_by?: string | null }).created_by;
  const { data: tutorRows } = createdBy
    ? await supabase.from("profiles").select("id, name, avatar_url").eq("id", createdBy)
    : await supabase.from("profiles").select("id, name, avatar_url").eq("role", "tutor");
  const tutor = (tutorRows?.[0] as { name: string; avatar_url: string | null } | undefined) ?? null;

  // All modules
  const { data: modulesRaw } = await supabase
    .from("course_modules")
    .select("id, title, title_id, focus, focus_id, icon, week_number, sort_order, legacy_module_id")
    .eq("course_id", params.courseId)
    .order("sort_order");
  const modules = modulesRaw ?? [];

  const moduleIds = modules.map((m: { id: string }) => m.id);

  const { data: allItems } = moduleIds.length > 0
    ? await supabase
        .from("module_checklist_items")
        .select("course_module_id, item_key, label, label_id, item_type, sort_order")
        .in("course_module_id", moduleIds)
        .order("sort_order")
    : { data: [] };

  const { data: allCompletions } = await supabase
    .from("checklist_completions")
    .select("item_key, course_module_id, module_id")
    .eq("student_id", user.id);

  const { data: allSessions } = await supabase
    .from("learning_sessions")
    .select("id, date, duration_minutes, tutor_notes, tutor_notes_id, student_notes, student_notes_id, course_module_id, module_id, photo_url")
    .eq("student_id", user.id)
    .order("date", { ascending: false });

  const { data: allQuizzes } = moduleIds.length > 0
    ? await supabase
        .from("module_quizzes")
        .select("id, title, description, course_module_id")
        .in("course_module_id", moduleIds)
        .order("sort_order")
    : { data: [] };

  const quizIds = (allQuizzes ?? []).map((q: { id: string }) => q.id);
  const { data: allAttempts } = quizIds.length > 0
    ? await supabase
        .from("quiz_attempts")
        .select("quiz_id, score, max_score, completed_at")
        .eq("student_id", user.id)
        .in("quiz_id", quizIds)
        .order("completed_at", { ascending: false })
    : { data: [] };

  const moduleData = modules.map((mod: {
    id: string; title: string; title_id?: string | null; focus: string | null; focus_id?: string | null;
    icon: string; week_number: number | null; sort_order: number; legacy_module_id: number | null;
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
      title_id: mod.title_id ?? null,
      focus: mod.focus,
      focus_id: mod.focus_id ?? null,
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

  const courseTitle = (lang === "id" && (course as { title_id?: string | null }).title_id)
    ? (course as { title_id: string }).title_id
    : course.title;
  const courseDesc = (lang === "id" && (course as { description_id?: string | null }).description_id)
    ? (course as { description_id: string }).description_id
    : course.description;

  const maxWeek = Math.max(0, ...modules.map((m: { week_number: number | null }) => m.week_number ?? 0));
  const overallPct = moduleData.length > 0 ? Math.round(moduleData.reduce((sum, m) => sum + m.pct, 0) / moduleData.length) : 0;
  const completedModules = moduleData.filter(m => m.pct >= 100).length;
  const totalQuizzes = moduleData.reduce((sum, m) => sum + m.quizzes.length, 0);

  return (
    <div className="min-h-screen">
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-6">

        {/* Breadcrumb */}
        <div className="flex items-center gap-2 text-sm text-slate-400 flex-wrap">
          <Link href="/student" className="hover:text-slate-600">{t(lang, "dashboard").replace("← ", "")}</Link>
          <span>›</span>
          <Link href="/student/courses" className="hover:text-slate-600">{t(lang, "courses")}</Link>
          <span>›</span>
          <span className="text-slate-600">{course.icon} {courseTitle}</span>
        </div>

        {/* Course header banner */}
        <div
          className="rounded-2xl px-6 py-5 shadow-sm"
          style={{ background: "linear-gradient(135deg, #0f1f3d 0%, #1e3a6e 60%, #0d9488 100%)" }}
        >
          <div className="flex items-center gap-4">
            {(course as { icon_url?: string | null }).icon_url
              ? <div className="w-14 h-14 rounded-2xl overflow-hidden shrink-0"><img src={(course as { icon_url: string }).icon_url} alt={course.title} className="w-full h-full object-cover" /></div>
              : <span className="text-4xl">{course.icon}</span>}
            <div className="flex-1 min-w-0">
              <h1 className="text-xl font-bold text-white truncate">{courseTitle}</h1>
              {courseDesc && (
                <p className="text-blue-200 text-sm mt-0.5 line-clamp-2">{courseDesc}</p>
              )}
              {tutor && (
                <div className="flex items-center gap-2 mt-2">
                  <div className="w-6 h-6 rounded-full overflow-hidden bg-white/20 flex items-center justify-center shrink-0">
                    {tutor.avatar_url
                      ? <img src={tutor.avatar_url} alt={tutor.name} className="w-full h-full object-cover" />
                      : <span className="text-[10px] font-bold text-white">{tutor.name.charAt(0).toUpperCase()}</span>}
                  </div>
                  <span className="text-xs text-white/70">{lang === "id" ? "Guru:" : "Teacher:"}</span>
                  <span className="text-xs font-semibold text-white">{tutor.name}</span>
                </div>
              )}
            </div>
            <div className="text-right shrink-0">
              <div className="text-2xl font-bold text-white">{modules.length}</div>
              <div className="text-teal-200 text-xs">{t(lang, "modules")}</div>
            </div>
          </div>
        </div>

        {/* Course Overview */}
        {modules.length > 0 && (
          <div className="rounded-2xl overflow-hidden shadow-sm" style={{ background: "linear-gradient(160deg, #0f1f3d 0%, #1a3357 50%, #0f2a2a 100%)" }}>
            <div className="px-5 py-4 border-b border-white/10 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <span className="text-lg">📋</span>
                <h2 className="font-bold text-white">{lang === "id" ? "Ringkasan Kursus" : "Course Overview"}</h2>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-24 bg-white/20 rounded-full h-2">
                  <div className={`h-2 rounded-full transition-all ${overallPct >= 100 ? "bg-green-400" : "bg-teal-400"}`} style={{ width: `${overallPct}%` }} />
                </div>
                <span className={`text-sm font-bold ${overallPct >= 100 ? "text-green-400" : overallPct > 0 ? "text-teal-300" : "text-white/40"}`}>{overallPct}%</span>
              </div>
            </div>

            <div className="p-5 space-y-5">
              {/* Goal */}
              {courseDesc && (
                <div>
                  <p className="text-xs font-semibold text-teal-400 uppercase tracking-wide mb-1.5">
                    🎯 {lang === "id" ? "Tujuan Kursus" : "Course Goal"}
                  </p>
                  <p className="text-sm text-white/80 leading-relaxed">{courseDesc}</p>
                </div>
              )}

              {/* Stats row */}
              <div className="flex items-center gap-5 flex-wrap">
                {maxWeek > 0 && (
                  <div className="flex items-center gap-1.5 text-sm text-white/70">
                    <span>🗓️</span>
                    <span className="font-semibold text-white">{maxWeek}</span>
                    <span>{lang === "id" ? "minggu" : "weeks"}</span>
                  </div>
                )}
                <div className="flex items-center gap-1.5 text-sm text-white/70">
                  <span>📚</span>
                  <span className="font-semibold text-white">{modules.length}</span>
                  <span>{lang === "id" ? "modul" : "modules"}</span>
                </div>
                {totalQuizzes > 0 && (
                  <div className="flex items-center gap-1.5 text-sm text-white/70">
                    <span>📝</span>
                    <span className="font-semibold text-white">{totalQuizzes}</span>
                    <span>{lang === "id" ? "kuis" : "quizzes"}</span>
                  </div>
                )}
              </div>

              {/* Curriculum */}
              <div>
                <p className="text-xs font-semibold text-white/40 uppercase tracking-wide mb-3">
                  {lang === "id" ? "Kurikulum" : "Curriculum"}
                </p>
                <div className="space-y-2.5">
                  {moduleData.map((mod) => {
                    const displayTitle = (lang === "id" && mod.title_id) ? mod.title_id : mod.title;
                    const displayFocus = (lang === "id" && mod.focus_id) ? mod.focus_id : mod.focus;
                    return (
                      <div key={mod.id} className="flex items-start gap-3">
                        <div className="flex items-center justify-center w-7 h-7 rounded-full bg-white/10 shrink-0 mt-0.5 text-base leading-none">
                          {mod.icon}
                        </div>
                        <div className="flex-1 min-w-0">
                          <div className="flex items-center gap-2 flex-wrap">
                            {mod.week_number && (
                              <span className="text-xs font-semibold px-1.5 py-0.5 bg-teal-500/30 text-teal-300 rounded-md shrink-0">
                                {lang === "id" ? "Minggu" : "Wk"} {mod.week_number}
                              </span>
                            )}
                            <span className="text-sm font-medium text-white">{displayTitle}</span>
                          </div>
                          {displayFocus && <p className="text-xs text-white/40 mt-0.5 truncate">{displayFocus}</p>}
                        </div>
                        <div className="shrink-0 flex items-center gap-1.5">
                          <div className="w-10 bg-white/15 rounded-full h-1.5">
                            <div className={`h-1.5 rounded-full ${mod.pct >= 100 ? "bg-green-400" : "bg-teal-400"}`} style={{ width: `${mod.pct}%` }} />
                          </div>
                          <span className="text-xs text-white/50 w-7 text-right">{mod.pct}%</span>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>

              {/* Completion projection */}
              {overallPct < 100 ? (
                <div className="bg-white/10 rounded-xl px-4 py-3 flex items-center gap-3 border border-white/10">
                  <span className="text-2xl shrink-0">🎓</span>
                  <div>
                    <p className="text-sm font-semibold text-white">
                      {lang === "id"
                        ? `${completedModules} dari ${modules.length} modul selesai`
                        : `${completedModules} of ${modules.length} modules complete`}
                    </p>
                    <p className="text-xs text-white/60 mt-0.5">
                      {lang === "id"
                        ? `${modules.length - completedModules} modul lagi untuk menyelesaikan kursus ini`
                        : `${modules.length - completedModules} module${modules.length - completedModules !== 1 ? "s" : ""} remaining to complete this course`}
                    </p>
                  </div>
                </div>
              ) : (
                <div className="bg-green-500/20 rounded-xl px-4 py-3 flex items-center gap-3 border border-green-400/30">
                  <span className="text-2xl shrink-0">🏆</span>
                  <div>
                    <p className="text-sm font-semibold text-green-300">{lang === "id" ? "Kursus Selesai!" : "Course Complete!"}</p>
                    <p className="text-xs text-green-400/80 mt-0.5">{lang === "id" ? "Kamu telah menyelesaikan semua modul." : "You have completed all modules."}</p>
                  </div>
                </div>
              )}
            </div>
          </div>
        )}

        {/* Module accordion */}
        {modules.length === 0 ? (
          <div className="card text-center py-10">
            <div className="text-4xl mb-3">📚</div>
            <p className="text-slate-500">{t(lang, "noModulesYet")}</p>
          </div>
        ) : (
          <StudentCourseAccordion modules={moduleData} lang={lang} studentId={user.id} tutor={tutor} />
        )}

      </div>
    </div>
  );
}
