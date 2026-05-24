"use client";
import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";
import NotesList from "@/components/NotesList";
import { format } from "date-fns";
import { t } from "@/lib/i18n";
import type { Lang } from "@/lib/i18n";
import QuizReview from "@/components/QuizReview";

// ─── Types ──────────────────────────────────────────────────────────────────

interface ChecklistItem {
  item_key: string;
  label: string;
  label_id?: string | null;
  item_type: string;
  sort_order: number;
}

interface Session {
  id: string;
  date: string;
  duration_minutes: number;
  tutor_notes: string | null;
  tutor_notes_id?: string | null;
  student_notes?: string | null;
  student_notes_id?: string | null;
  photo_url?: string | null;
}

interface QuizAttempt {
  quiz_id: string;
  score: number;
  max_score: number;
  completed_at: string;
}

interface Quiz {
  id: string;
  title: string;
  description: string | null;
  bestAttempt: QuizAttempt | null;
}

interface Resource {
  id: string;
  resource_type: "video" | "pdf" | "doc" | "image" | "link";
  title: string;
  url: string;
  description: string | null;
}

interface ModuleData {
  id: string;
  title: string;
  title_id?: string | null;
  focus: string | null;
  focus_id?: string | null;
  icon: string;
  week_number: number | null;
  pct: number;
  sessions: Session[];
  studentItems: ChecklistItem[];
  tutorItems: ChecklistItem[];
  studentDone: number;
  tutorDone: number;
  completedKeys: string[];
  quizzes: Quiz[];
}

interface TutorInfo {
  name: string;
  avatar_url: string | null;
}

interface Props {
  modules: ModuleData[];
  lang: Lang;
  studentId: string;
  courseId: string;
  tutor?: TutorInfo | null;
}

// ─── Resource loader (client-side per module) ────────────────────────────────

function useResources(moduleId: string, active: boolean) {
  const [resources, setResources] = useState<Resource[]>([]);
  const [loading, setLoading] = useState(false);
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    if (!active || loaded) return;
    setLoading(true);
    const supabase = createClient();
    supabase
      .from("module_resources")
      .select("id, resource_type, title, url, description, sort_order")
      .eq("course_module_id", moduleId)
      .order("sort_order")
      .then(({ data }) => {
        setResources((data ?? []) as Resource[]);
        setLoading(false);
        setLoaded(true);
      });
  }, [active, loaded, moduleId]);

  return { resources, loading };
}

// ─── Type icons/badges ────────────────────────────────────────────────────────

const typeIcon: Record<string, string> = {
  video: "🎬", pdf: "📄", doc: "📝", image: "🖼️", link: "🔗",
};

function toEmbedUrl(url: string): string {
  const m = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})/);
  return m ? `https://www.youtube.com/embed/${m[1]}` : url;
}

// ─── Tab types ────────────────────────────────────────────────────────────────

type Tab = "sessions" | "checklist" | "resources" | "quizzes";

const TABS: { id: Tab; icon: string; labelEn: string; labelId: string }[] = [
  { id: "sessions",  icon: "📅", labelEn: "Sessions",   labelId: "Sesi" },
  { id: "checklist", icon: "✅", labelEn: "Checklist",  labelId: "Checklist" },
  { id: "resources", icon: "📎", labelEn: "Resources",  labelId: "Materi" },
  { id: "quizzes",   icon: "📝", labelEn: "Quizzes",    labelId: "Kuis" },
];

// ─── Single module panel ──────────────────────────────────────────────────────

function ModulePanel({ mod, lang, studentId, courseId, defaultOpen, tutor }: { mod: ModuleData; lang: Lang; studentId: string; courseId: string; defaultOpen: boolean; tutor?: TutorInfo | null }) {
  const [open, setOpen]   = useState(defaultOpen);
  const [tab, setTab]     = useState<Tab>("sessions");
  const [expandedQuiz, setExpandedQuiz] = useState<string | null>(null);
  // quizGrades: quizId -> questionId -> { grade, feedback }
  const [quizGrades, setQuizGrades] = useState<Record<string, Record<string, { grade: number | null; feedback: string | null }>>>({});
  const { resources, loading: resLoading } = useResources(mod.id, open && tab === "resources");

  useEffect(() => {
    if (!open || tab !== "quizzes" || mod.quizzes.length === 0) return;
    const supabase = createClient();
    const quizIds = mod.quizzes.map((q) => q.id);
    supabase
      .from("homework_submissions")
      .select("quiz_id, question_id, tutor_grade, tutor_feedback")
      .eq("student_id", studentId)
      .in("quiz_id", quizIds)
      .then(({ data }) => {
        if (!data) return;
        const map: Record<string, Record<string, { grade: number | null; feedback: string | null }>> = {};
        for (const row of data as { quiz_id: string; question_id: string; tutor_grade: number | null; tutor_feedback: string | null }[]) {
          if (!map[row.quiz_id]) map[row.quiz_id] = {};
          map[row.quiz_id][row.question_id] = { grade: row.tutor_grade, feedback: row.tutor_feedback };
        }
        setQuizGrades(map);
      });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, tab]);

  const isDone = (key: string) => mod.completedKeys.includes(key);
  const displayTitle = (lang === "id" && mod.title_id) ? mod.title_id : mod.title;
  const displayFocus = (lang === "id" && mod.focus_id) ? mod.focus_id : mod.focus;

  return (
    <div className={`rounded-2xl overflow-hidden border-2 transition-colors ${open ? "border-teal-400 shadow-md" : "border-slate-200"}`}>
      {/* Header row */}
      <button
        onClick={() => setOpen((v) => !v)}
        className={`w-full flex items-center gap-3 px-4 py-4 text-left transition-colors ${
          open ? "bg-teal-50" : "bg-white hover:bg-slate-50"
        }`}
      >
        {/* Chevron */}
        <svg
          className={`w-4 h-4 shrink-0 text-slate-400 transition-transform duration-200 ${open ? "rotate-90" : ""}`}
          fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}
        >
          <path strokeLinecap="round" strokeLinejoin="round" d="M9 5l7 7-7 7" />
        </svg>

        <span className="text-2xl shrink-0">{mod.icon}</span>

        <div className="flex-1 min-w-0">
          {mod.week_number && (
            <span className="text-xs font-semibold px-2 py-0.5 rounded-full bg-slate-100 text-slate-500 mr-1.5">
              {t(lang, "week")} {mod.week_number}
            </span>
          )}
          <span className="font-semibold text-slate-800 text-sm">{displayTitle}</span>
          {displayFocus && (
            <p className="text-xs text-slate-400 mt-0.5 truncate">{displayFocus}</p>
          )}
        </div>

        {/* Progress pill */}
        <div className="shrink-0 flex items-center gap-2">
          <div className="hidden sm:flex items-center gap-1.5">
            <div className="w-20 bg-slate-200 rounded-full h-1.5">
              <div
                className={`h-1.5 rounded-full ${mod.pct >= 100 ? "bg-green-500" : "bg-teal-500"}`}
                style={{ width: `${mod.pct}%` }}
              />
            </div>
          </div>
          <span className={`text-xs font-bold ${mod.pct >= 100 ? "text-green-600" : mod.pct > 0 ? "text-teal-600" : "text-slate-400"}`}>
            {mod.pct}%
          </span>
        </div>
      </button>

      {/* Expanded panel */}
      {open && (
        <div className="border-t border-slate-100">
          {/* About this module */}
          {displayFocus && (
            <div className="px-4 py-3 bg-teal-50 border-b border-teal-100 flex items-start gap-2.5">
              <span className="text-teal-400 shrink-0 mt-0.5">📖</span>
              <div>
                <p className="text-xs font-semibold text-teal-600 uppercase tracking-wide mb-0.5">
                  {lang === "id" ? "Tentang Modul Ini" : "About this Module"}
                </p>
                <p className="text-sm text-teal-800">{displayFocus}</p>
              </div>
            </div>
          )}

          {/* Quick stats bar */}
          <div className="grid grid-cols-4 divide-x divide-slate-100 border-b border-slate-100 bg-slate-50">
            <div className="text-center py-2">
              <div className="text-base font-bold text-teal-600">{mod.sessions.length}</div>
              <div className="text-xs text-slate-400">{t(lang, "sessions")}</div>
            </div>
            <div className="text-center py-2">
              <div className="text-base font-bold text-teal-600">{mod.studentDone}/{mod.studentItems.length}</div>
              <div className="text-xs text-slate-400">{t(lang, "studentLabel")}</div>
            </div>
            <div className="text-center py-2">
              <div className="text-base font-bold text-teal-600">{mod.tutorDone}/{mod.tutorItems.length}</div>
              <div className="text-xs text-slate-400">{t(lang, "tutorLabel")}</div>
            </div>
            <div className="text-center py-2">
              <div className="text-base font-bold text-teal-600">{mod.quizzes.length}</div>
              <div className="text-xs text-slate-400">{t(lang, "quizzes")}</div>
            </div>
          </div>

          {/* Tabs */}
          <div className="grid grid-cols-4 border-b border-slate-100 bg-white">
            {TABS.map((t) => (
              <button
                key={t.id}
                onClick={() => setTab(t.id)}
                className={`flex flex-col items-center gap-0.5 py-2.5 text-xs font-semibold border-b-2 transition-colors ${
                  tab === t.id
                    ? "border-teal-500 text-teal-600 bg-teal-50"
                    : "border-transparent text-slate-400 hover:text-slate-600 hover:bg-slate-50"
                }`}
              >
                <span className="text-base leading-none">{t.icon}</span>
                <span className="leading-tight">{lang === "id" ? t.labelId : t.labelEn}</span>
              </button>
            ))}
          </div>

          {/* Tab content */}
          <div className="p-4 space-y-3">

            {/* ── Sessions ── */}
            {tab === "sessions" && (
              mod.sessions.length === 0 ? (
                <p className="text-sm text-slate-400 italic text-center py-4">
                  {t(lang, "noSessionsForModule")}
                </p>
              ) : (
                mod.sessions.map((s) => (
                  <div key={s.id} className="bg-slate-50 rounded-xl px-4 py-3 space-y-1">
                    <div className="flex items-start gap-3">
                      <div className="flex-1 space-y-1">
                        <div className="flex items-center justify-between gap-2">
                          <span className="text-sm font-semibold text-slate-700">
                            {format(new Date(s.date), "EEEE, MMMM d, yyyy")}
                          </span>
                          <span className="text-xs font-bold bg-teal-100 text-teal-700 px-2 py-0.5 rounded-full shrink-0">
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
                        {!s.student_notes && !s.student_notes_id && (
                          <p className="text-xs text-slate-300 italic mt-1">
                            {lang === "id" ? "Belum ada catatan dari siswa" : "No student notes yet"}
                          </p>
                        )}
                      </div>
                      {s.photo_url && (
                        <a href={s.photo_url} target="_blank" rel="noopener noreferrer" className="shrink-0">
                          <img
                            src={s.photo_url}
                            alt="session"
                            className="w-16 h-12 object-cover rounded-lg border border-slate-200 hover:opacity-80 transition-opacity"
                          />
                        </a>
                      )}
                    </div>
                  </div>
                ))
              )
            )}

            {/* ── Checklist ── */}
            {tab === "checklist" && (
              <div className="space-y-4">
                {mod.studentItems.length > 0 && (
                  <div>
                    <p className="text-xs font-semibold text-slate-400 uppercase tracking-wide mb-2">
                      {t(lang, "studentActivities")}
                    </p>
                    <div className="space-y-2">
                      {mod.studentItems.map((item) => {
                        const done = isDone(item.item_key);
                        return (
                          <div key={item.item_key} className="flex items-start gap-2.5">
                            <div className={`mt-0.5 w-5 h-5 rounded-full shrink-0 flex items-center justify-center text-xs font-bold ${
                              done ? "bg-green-500 text-white" : "border-2 border-slate-300"
                            }`}>
                              {done ? "✓" : ""}
                            </div>
                            <span className={`text-sm leading-relaxed ${done ? "text-slate-400 line-through" : "text-slate-700"}`}>
                              {(lang === "id" && item.label_id) ? item.label_id : item.label}
                            </span>
                          </div>
                        );
                      })}
                    </div>
                    <p className="text-xs text-slate-400 mt-2">{mod.studentDone}/{mod.studentItems.length} {t(lang, "completed")}</p>
                  </div>
                )}

                {mod.tutorItems.length > 0 && (
                  <div>
                    <p className="text-xs font-semibold text-slate-400 uppercase tracking-wide mb-2">
                      {t(lang, "tutorLedTopics")}
                    </p>
                    <div className="space-y-2">
                      {mod.tutorItems.map((item) => {
                        const done = isDone(item.item_key);
                        return (
                          <div key={item.item_key} className="flex items-start gap-2.5">
                            <div className={`mt-0.5 w-5 h-5 rounded-full shrink-0 flex items-center justify-center text-xs font-bold ${
                              done ? "bg-indigo-500 text-white" : "border-2 border-slate-300"
                            }`}>
                              {done ? "✓" : ""}
                            </div>
                            <span className={`text-sm leading-relaxed ${done ? "text-slate-400 line-through" : "text-slate-700"}`}>
                              {(lang === "id" && item.label_id) ? item.label_id : item.label}
                            </span>
                          </div>
                        );
                      })}
                    </div>
                    <p className="text-xs text-slate-400 mt-2">{mod.tutorDone}/{mod.tutorItems.length} {t(lang, "completed")}</p>
                  </div>
                )}

                {mod.studentItems.length === 0 && mod.tutorItems.length === 0 && (
                  <p className="text-sm text-slate-400 italic text-center py-4">
                    {t(lang, "noChecklistItemsYet")}
                  </p>
                )}
              </div>
            )}

            {/* ── Resources ── */}
            {tab === "resources" && (
              resLoading ? (
                <p className="text-sm text-slate-400 text-center py-4">Loading…</p>
              ) : resources.length === 0 ? (
                <p className="text-sm text-slate-400 italic text-center py-4">
                  {t(lang, "noResourcesYet")}
                </p>
              ) : (
                <div className="space-y-3">
                  {resources.map((r) => (
                    r.resource_type === "video" ? (
                      <div key={r.id} className="space-y-2">
                        <div className="flex items-center gap-2">
                          <span className="text-lg">{typeIcon[r.resource_type]}</span>
                          <span className="text-sm font-medium text-slate-700">{r.title}</span>
                        </div>
                        {r.description && <p className="text-xs text-slate-500">{r.description}</p>}
                        <div className="relative w-full rounded-xl overflow-hidden" style={{ paddingBottom: "56.25%" }}>
                          <iframe
                            src={toEmbedUrl(r.url)}
                            title={r.title}
                            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                            allowFullScreen
                            className="absolute inset-0 w-full h-full"
                          />
                        </div>
                      </div>
                    ) : (
                      <div key={r.id} className="flex items-center gap-3 bg-slate-50 rounded-xl px-3 py-2.5">
                        <span className="text-xl shrink-0">{typeIcon[r.resource_type]}</span>
                        <div className="flex-1 min-w-0">
                          <div className="text-sm font-medium text-slate-700 truncate">{r.title}</div>
                          {r.description && <p className="text-xs text-slate-500 mt-0.5">{r.description}</p>}
                        </div>
                        <a
                          href={r.url}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="text-xs font-semibold text-indigo-600 hover:text-indigo-700 shrink-0"
                        >
                          Open ↗
                        </a>
                      </div>
                    )
                  ))}
                </div>
              )
            )}

            {/* ── Quizzes ── */}
            {tab === "quizzes" && (
              mod.quizzes.length === 0 ? (
                <p className="text-sm text-slate-400 italic text-center py-4">
                  {t(lang, "noQuizzesYet")}
                </p>
              ) : (
                <div className="space-y-3">
                  {mod.quizzes.map((quiz) => {
                    const best = quiz.bestAttempt;
                    const isHomeworkOnly = best && best.max_score === 0;
                    const pct = best && best.max_score > 0 ? Math.round((best.score / best.max_score) * 100) : null;
                    const grades = quizGrades[quiz.id];
                    const hasGrades = grades && Object.values(grades).some(g => g.grade !== null);
                    const isExpanded = expandedQuiz === quiz.id;
                    return (
                      <div key={quiz.id} className="bg-slate-50 rounded-xl overflow-hidden border border-slate-200">
                        <div className="flex items-center gap-3 px-4 py-3">
                          <span className="text-2xl shrink-0">📝</span>
                          <div className="flex-1 min-w-0">
                            <div className="text-sm font-semibold text-slate-800">{quiz.title}</div>
                            {quiz.description && <p className="text-xs text-slate-500 mt-0.5">{quiz.description}</p>}
                          </div>
                          <div className="flex items-center gap-3 shrink-0">
                            <div className="text-right">
                              {best && isHomeworkOnly ? (
                                <span className="text-xs text-teal-600 font-semibold">
                                  {lang === "id" ? "✓ Dikirim" : "✓ Submitted"}
                                </span>
                              ) : best ? (
                                <>
                                  <div className={`text-base font-bold ${pct! >= 80 ? "text-green-600" : pct! >= 50 ? "text-teal-600" : "text-amber-500"}`}>
                                    {best.score}/{best.max_score}
                                  </div>
                                  <div className="text-xs text-slate-400">{pct}%</div>
                                </>
                              ) : (
                                <span className="text-xs text-slate-400 italic">
                                  {t(lang, "notAttempted")}
                                </span>
                              )}
                            </div>
                            <button
                              onClick={() => setExpandedQuiz(isExpanded ? null : quiz.id)}
                              className="text-xs text-teal-500 hover:text-teal-700 font-medium whitespace-nowrap"
                            >
                              {isExpanded
                                ? (lang === "id" ? "Tutup ▲" : "Hide ▲")
                                : (lang === "id" ? "Lihat Jawaban ▼" : "View Answers ▼")}
                            </button>
                          </div>
                        </div>
                        {/* Tutor grades for homework quizzes */}
                        {isHomeworkOnly && hasGrades && (
                          <div className="px-4 pb-3 flex flex-wrap gap-2">
                            {Object.entries(grades)
                              .filter(([, g]) => g.grade !== null)
                              .map(([qId, g]) => (
                                <div key={qId} className="flex items-center gap-1.5 bg-purple-50 border border-purple-200 rounded-lg px-2.5 py-1">
                                  <span className="text-xs font-semibold text-purple-700">
                                    {lang === "id" ? "Nilai" : "Grade"}:
                                  </span>
                                  <span className="text-sm font-bold text-purple-800">{g.grade}</span>
                                  {g.feedback && (
                                    <span className="text-xs text-slate-500 italic truncate max-w-[140px]">— {g.feedback}</span>
                                  )}
                                </div>
                              ))}
                          </div>
                        )}
                        {isExpanded && (
                          <div className="border-t border-slate-200 px-4 py-3">
                            <QuizReview quizId={quiz.id} studentId={studentId} lang={lang} accentColor="teal" />
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              )
            )}

          </div>
        </div>
      )}
    </div>
  );
}

// ─── Main export ──────────────────────────────────────────────────────────────

export default function ParentCourseAccordion({ modules, lang, studentId, courseId, tutor }: Props) {
  return (
    <div className="space-y-3">
      {modules.map((mod, i) => (
        <ModulePanel key={mod.id} mod={mod} lang={lang} studentId={studentId} courseId={courseId} defaultOpen={i === 0} tutor={tutor} />
      ))}
    </div>
  );
}
