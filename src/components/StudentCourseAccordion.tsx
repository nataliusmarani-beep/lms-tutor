"use client";
import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";
import { format } from "date-fns";
import { t } from "@/lib/i18n";
import type { Lang } from "@/lib/i18n";

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
  tutor?: TutorInfo | null;
}

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

const typeIcon: Record<string, string> = {
  video: "🎬", pdf: "📄", doc: "📝", image: "🖼️", link: "🔗",
};

function toEmbedUrl(url: string): string {
  const m = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})/);
  return m ? `https://www.youtube.com/embed/${m[1]}` : url;
}

type Tab = "sessions" | "checklist" | "resources" | "quizzes";

const TABS: { id: Tab; icon: string; labelEn: string; labelId: string }[] = [
  { id: "sessions",  icon: "📅", labelEn: "Sessions",  labelId: "Sesi" },
  { id: "checklist", icon: "✅", labelEn: "Checklist", labelId: "Checklist" },
  { id: "resources", icon: "📎", labelEn: "Resources", labelId: "Materi" },
  { id: "quizzes",   icon: "📝", labelEn: "Quizzes",   labelId: "Kuis" },
];

function ModulePanel({
  mod, lang, studentId, defaultOpen, tutor,
}: {
  mod: ModuleData; lang: Lang; studentId: string; defaultOpen: boolean; tutor?: TutorInfo | null;
}) {
  const [open, setOpen] = useState(defaultOpen);
  const [tab, setTab]   = useState<Tab>("sessions");
  const [completedKeys, setCompletedKeys] = useState<string[]>(mod.completedKeys);
  const { resources, loading: resLoading } = useResources(mod.id, open && tab === "resources");

  const isDone = (key: string) => completedKeys.includes(key);

  async function toggleItem(key: string, itemType: string) {
    const supabase = createClient();
    if (isDone(key)) {
      await supabase
        .from("checklist_completions")
        .delete()
        .eq("student_id", studentId)
        .eq("item_key", key);
      setCompletedKeys((prev) => prev.filter((k) => k !== key));
    } else {
      await supabase.from("checklist_completions").insert({
        student_id: studentId,
        course_module_id: mod.id,
        item_key: key,
        item_type: itemType,
        confirmed_by: studentId,
      });
      setCompletedKeys((prev) => [...prev, key]);
    }
  }

  const studentDone = mod.studentItems.filter((i) => isDone(i.item_key)).length;
  const tutorDone   = mod.tutorItems.filter((i) => isDone(i.item_key)).length;

  const displayTitle = (lang === "id" && mod.title_id) ? mod.title_id : mod.title;
  const displayFocus = (lang === "id" && mod.focus_id) ? mod.focus_id : mod.focus;

  return (
    <div className="border border-slate-200 rounded-2xl overflow-hidden">
      {/* Header */}
      <button
        onClick={() => setOpen((v) => !v)}
        className={`w-full flex items-center gap-3 px-4 py-4 text-left transition-colors ${
          open ? "bg-slate-50" : "bg-white hover:bg-slate-50"
        }`}
      >
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

      {/* Expanded */}
      {open && (
        <div className="border-t border-slate-100">
          {/* Stats bar */}
          <div className="grid grid-cols-4 divide-x divide-slate-100 border-b border-slate-100 bg-slate-50">
            <div className="text-center py-2">
              <div className="text-base font-bold text-teal-600">{mod.sessions.length}</div>
              <div className="text-xs text-slate-400">{t(lang, "sessions")}</div>
            </div>
            <div className="text-center py-2">
              <div className="text-base font-bold text-teal-600">{studentDone}/{mod.studentItems.length}</div>
              <div className="text-xs text-slate-400">{t(lang, "studentLabel")}</div>
            </div>
            <div className="text-center py-2">
              <div className="text-base font-bold text-teal-600">{tutorDone}/{mod.tutorItems.length}</div>
              <div className="text-xs text-slate-400">{t(lang, "tutorLabel")}</div>
            </div>
            <div className="text-center py-2">
              <div className="text-base font-bold text-teal-600">{mod.quizzes.length}</div>
              <div className="text-xs text-slate-400">{t(lang, "quizzes")}</div>
            </div>
          </div>

          {/* Full-width tabs */}
          <div className="grid grid-cols-4 border-b border-slate-100 bg-white">
            {TABS.map((tabItem) => (
              <button
                key={tabItem.id}
                onClick={() => setTab(tabItem.id)}
                className={`flex flex-col items-center gap-0.5 py-2.5 text-xs font-semibold border-b-2 transition-colors ${
                  tab === tabItem.id
                    ? "border-teal-500 text-teal-600 bg-teal-50"
                    : "border-transparent text-slate-400 hover:text-slate-600 hover:bg-slate-50"
                }`}
              >
                <span className="text-base leading-none">{tabItem.icon}</span>
                <span className="leading-tight">{lang === "id" ? tabItem.labelId : tabItem.labelEn}</span>
              </button>
            ))}
          </div>

          {/* Tab content */}
          <div className="p-4 space-y-3">

            {/* Sessions */}
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
                        {(s.tutor_notes || s.tutor_notes_id) && (
                          <p className="text-xs text-slate-600">
                            <span className="text-slate-400 font-medium">{t(lang, "tutorNotes")} </span>
                            {(lang === "id" && s.tutor_notes_id) ? s.tutor_notes_id : s.tutor_notes}
                          </p>
                        )}
                        {(s.student_notes || s.student_notes_id) && (
                          <p className="text-xs text-slate-600">
                            <span className="text-slate-400 font-medium">{t(lang, "studentNotes")} </span>
                            {(lang === "id" && s.student_notes_id) ? s.student_notes_id : s.student_notes}
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

            {/* Checklist — student items are interactive */}
            {tab === "checklist" && (
              <div className="space-y-4">
                {mod.studentItems.length > 0 && (
                  <div>
                    <p className="text-xs font-semibold text-slate-400 uppercase tracking-wide mb-2">
                      🙋 {t(lang, "studentActivities")}
                    </p>
                    <div className="space-y-2">
                      {mod.studentItems.map((item) => {
                        const done = isDone(item.item_key);
                        return (
                          <label key={item.item_key} className="flex items-start gap-2.5 cursor-pointer group">
                            <input
                              type="checkbox"
                              checked={done}
                              onChange={() => toggleItem(item.item_key, item.item_type)}
                              className="mt-0.5 w-4 h-4 rounded accent-teal-600 shrink-0 cursor-pointer"
                            />
                            <span className={`text-sm leading-relaxed select-none ${
                              done ? "text-slate-400 line-through" : "text-slate-700 group-hover:text-slate-900"
                            }`}>
                              {(lang === "id" && item.label_id) ? item.label_id : item.label}
                            </span>
                            {done && <span className="text-teal-500 text-xs ml-auto shrink-0">✓</span>}
                          </label>
                        );
                      })}
                    </div>
                    <p className="text-xs text-slate-400 mt-2">
                      {studentDone}/{mod.studentItems.length} {t(lang, "completed")}
                    </p>
                  </div>
                )}

                {mod.tutorItems.length > 0 && (
                  <div>
                    <p className="text-xs font-semibold text-slate-400 uppercase tracking-wide mb-2">
                      👨‍🏫 {t(lang, "tutorLedTopics")}
                    </p>
                    <div className="space-y-2">
                      {mod.tutorItems.map((item) => {
                        const done = isDone(item.item_key);
                        return (
                          <div key={item.item_key} className="flex items-start gap-2.5">
                            <div className={`mt-0.5 w-4 h-4 rounded shrink-0 flex items-center justify-center text-xs ${
                              done ? "bg-teal-500 text-white" : "border-2 border-slate-300"
                            }`}>
                              {done ? "✓" : ""}
                            </div>
                            <span className={`text-sm leading-relaxed ${done ? "text-slate-400 line-through" : "text-slate-600"}`}>
                              {(lang === "id" && item.label_id) ? item.label_id : item.label}
                            </span>
                          </div>
                        );
                      })}
                    </div>
                    <p className="text-xs text-slate-400 mt-2">
                      {tutorDone}/{mod.tutorItems.length} {t(lang, "completed")}
                    </p>
                  </div>
                )}

                {mod.studentItems.length === 0 && mod.tutorItems.length === 0 && (
                  <p className="text-sm text-slate-400 italic text-center py-4">
                    {t(lang, "noChecklistItemsYet")}
                  </p>
                )}
              </div>
            )}

            {/* Resources */}
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
                          className="text-xs font-semibold text-teal-600 hover:text-teal-700 shrink-0"
                        >
                          Open ↗
                        </a>
                      </div>
                    )
                  ))}
                </div>
              )
            )}

            {/* Quizzes */}
            {tab === "quizzes" && (
              mod.quizzes.length === 0 ? (
                <p className="text-sm text-slate-400 italic text-center py-4">
                  {t(lang, "noQuizzesYet")}
                </p>
              ) : (
                <div className="space-y-3">
                  {mod.quizzes.map((quiz) => {
                    const best = quiz.bestAttempt;
                    const pct = best ? Math.round((best.score / best.max_score) * 100) : null;
                    return (
                      <div key={quiz.id} className="flex items-center gap-3 bg-slate-50 rounded-xl px-4 py-3">
                        <span className="text-2xl shrink-0">📝</span>
                        <div className="flex-1">
                          <div className="text-sm font-semibold text-slate-800">{quiz.title}</div>
                          {quiz.description && <p className="text-xs text-slate-500 mt-0.5">{quiz.description}</p>}
                        </div>
                        <div className="text-right shrink-0">
                          {best ? (
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

export default function StudentCourseAccordion({ modules, lang, studentId, tutor }: Props) {
  return (
    <div className="space-y-3">
      {modules.map((mod, i) => (
        <ModulePanel key={mod.id} mod={mod} lang={lang} studentId={studentId} defaultOpen={i === 0} tutor={tutor} />
      ))}
    </div>
  );
}
