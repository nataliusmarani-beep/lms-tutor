"use client";
import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";
import type { Lang } from "@/lib/i18n";

interface QuizOption {
  id: string;
  question_id: string;
  option_text: string;
  option_text_id: string | null;
  is_correct: boolean;
  sort_order: number;
}

interface QuizQuestion {
  id: string;
  question_type: "single_choice" | "multiple_choice" | "fill_blank" | "homework_upload";
  question_text: string;
  question_text_id: string | null;
  attachment_url: string | null;
  attachment_type: "image" | "pdf" | null;
  sort_order: number;
  options: QuizOption[];
}

interface Attempt {
  score: number;
  max_score: number;
  completed_at: string;
  answers: Record<string, string>;
}

interface HomeworkSubmission {
  question_id: string;
  file_url: string;
  file_type: "image" | "pdf";
}

interface Props {
  quizId: string;
  studentId: string;
  lang: Lang;
  accentColor?: "blue" | "teal";
}

export default function QuizReview({ quizId, studentId, lang, accentColor = "blue" }: Props) {
  const [loading, setLoading] = useState(true);
  const [questions, setQuestions] = useState<QuizQuestion[]>([]);
  const [attempt, setAttempt] = useState<Attempt | null>(null);
  const [homework, setHomework] = useState<HomeworkSubmission[]>([]);

  const accent = accentColor === "teal"
    ? { badge: "bg-teal-50 border-teal-200 text-teal-700", dot: "bg-teal-500" }
    : { badge: "bg-blue-50 border-blue-200 text-blue-700", dot: "bg-blue-500" };

  useEffect(() => {
    let cancelled = false;
    (async () => {
      const supabase = createClient();
      const [{ data: qs }, { data: att }, { data: hw }] = await Promise.all([
        supabase
          .from("quiz_questions")
          .select("id, question_type, question_text, question_text_id, attachment_url, attachment_type, sort_order")
          .eq("quiz_id", quizId)
          .order("sort_order"),
        supabase
          .from("quiz_attempts")
          .select("score, max_score, completed_at, answers")
          .eq("quiz_id", quizId)
          .eq("student_id", studentId)
          .order("completed_at", { ascending: false })
          .limit(1)
          .maybeSingle(),
        supabase
          .from("homework_submissions")
          .select("question_id, file_url, file_type")
          .eq("quiz_id", quizId)
          .eq("student_id", studentId)
          .order("created_at", { ascending: false }),
      ]);

      if (cancelled) return;

      const questionList = (qs ?? []) as Omit<QuizQuestion, "options">[];
      if (questionList.length > 0) {
        const { data: opts } = await supabase
          .from("quiz_options")
          .select("id, question_id, option_text, option_text_id, is_correct, sort_order")
          .in("question_id", questionList.map((q) => q.id))
          .order("sort_order");

        const optsByQ: Record<string, QuizOption[]> = {};
        for (const o of (opts ?? []) as QuizOption[]) {
          if (!optsByQ[o.question_id]) optsByQ[o.question_id] = [];
          optsByQ[o.question_id].push(o);
        }
        setQuestions(questionList.map((q) => ({ ...q, options: optsByQ[q.id] ?? [] })));
      }

      // Deduplicate homework: keep latest per question
      const hwMap: Record<string, HomeworkSubmission> = {};
      for (const h of (hw ?? []) as HomeworkSubmission[]) {
        if (!hwMap[h.question_id]) hwMap[h.question_id] = h;
      }
      setHomework(Object.values(hwMap));
      setAttempt(att ? (att as Attempt) : null);
      setLoading(false);
    })();
    return () => { cancelled = true; };
  }, [quizId, studentId]);

  if (loading) {
    return <p className="text-xs text-slate-400 text-center py-3">Loading…</p>;
  }

  if (questions.length === 0) {
    return <p className="text-xs text-slate-400 italic text-center py-3">{lang === "id" ? "Belum ada soal." : "No questions yet."}</p>;
  }

  if (!attempt) {
    return (
      <p className="text-xs text-slate-400 italic text-center py-3">
        {lang === "id" ? "Belum ada percobaan kuis." : "No quiz attempt yet."}
      </p>
    );
  }

  const pct = attempt.max_score > 0 ? Math.round((attempt.score / attempt.max_score) * 100) : null;
  const answers = attempt.answers ?? {};
  const hwByQuestion: Record<string, HomeworkSubmission> = {};
  for (const h of homework) hwByQuestion[h.question_id] = h;

  return (
    <div className="space-y-3">
      {/* Score summary */}
      <div className={`flex items-center justify-between rounded-xl border px-4 py-2.5 ${accent.badge}`}>
        <div className="flex items-center gap-2">
          <span className="text-base">📊</span>
          <span className="text-sm font-semibold">
            {lang === "id" ? "Skor Terbaik" : "Best Score"}
          </span>
        </div>
        <div className="text-right">
          {pct !== null ? (
            <span className={`text-base font-bold ${pct >= 80 ? "text-green-600" : pct >= 50 ? "text-amber-500" : "text-red-500"}`}>
              {attempt.score}/{attempt.max_score} ({pct}%)
            </span>
          ) : (
            <span className="text-sm text-slate-400">{attempt.score}/{attempt.max_score}</span>
          )}
        </div>
      </div>

      {/* Per-question breakdown */}
      <div className="space-y-2">
        {questions.map((q, i) => {
          const studentAnswerId = answers[q.id];
          const correct = q.options.find((o) => o.is_correct);
          const selectedOpt = q.options.find((o) => o.id === studentAnswerId);
          const isRight = q.question_type !== "homework_upload" && selectedOpt?.is_correct === true;
          const isWrong = q.question_type !== "homework_upload" && studentAnswerId && !isRight;
          const hw = hwByQuestion[q.id];
          const qText = (lang === "id" && q.question_text_id) ? q.question_text_id : q.question_text;

          return (
            <div
              key={q.id}
              className={`rounded-xl border px-3 py-3 space-y-2 text-sm ${
                q.question_type === "homework_upload"
                  ? "bg-purple-50 border-purple-200"
                  : isRight
                  ? "bg-green-50 border-green-200"
                  : studentAnswerId
                  ? "bg-red-50 border-red-200"
                  : "bg-slate-50 border-slate-200"
              }`}
            >
              {/* Question header */}
              <div className="flex items-start gap-2">
                <span className="text-xs font-bold text-slate-400 mt-0.5 shrink-0 w-5">{i + 1}.</span>
                <div className="flex-1">
                  <p className="text-sm text-slate-800 font-medium leading-snug">{qText}</p>
                  {q.attachment_url && (
                    <div className="mt-1.5">
                      {q.attachment_type === "image" ? (
                        <a href={q.attachment_url} target="_blank" rel="noopener noreferrer">
                          <img src={q.attachment_url} alt="attachment" className="max-w-xs w-full rounded-lg border border-slate-200 hover:opacity-90" />
                        </a>
                      ) : (
                        <a href={q.attachment_url} target="_blank" rel="noopener noreferrer" className="inline-flex items-center gap-1.5 text-xs text-blue-600 underline">
                          <span>📄</span>{lang === "id" ? "Lihat PDF soal" : "View question PDF"}
                        </a>
                      )}
                    </div>
                  )}
                </div>
                <span className="shrink-0 text-base">
                  {q.question_type === "homework_upload" ? "📎" : isRight ? "✅" : studentAnswerId ? "❌" : "—"}
                </span>
              </div>

              {/* Homework upload answer */}
              {q.question_type === "homework_upload" && (
                hw ? (
                  <div className="ml-7">
                    {hw.file_type === "image" ? (
                      <a href={hw.file_url} target="_blank" rel="noopener noreferrer">
                        <img src={hw.file_url} alt="homework" className="max-w-xs w-full rounded-xl border border-purple-200 hover:opacity-90 transition-opacity" />
                      </a>
                    ) : (
                      <a
                        href={hw.file_url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-2 bg-white border border-purple-200 rounded-xl px-3 py-2 hover:bg-purple-50 transition-colors"
                      >
                        <span className="text-lg">📄</span>
                        <span className="text-sm text-purple-700 font-medium">
                          {lang === "id" ? "Lihat file jawaban" : "View submitted file"}
                        </span>
                        <span className="text-xs text-slate-400">↗</span>
                      </a>
                    )}
                    <p className="text-xs text-purple-600 mt-1">✓ {lang === "id" ? "File diunggah" : "File submitted"}</p>
                  </div>
                ) : (
                  <p className="ml-7 text-xs text-slate-400 italic">{lang === "id" ? "Belum diunggah" : "Not submitted"}</p>
                )
              )}

              {/* Choice / fill_blank answer */}
              {q.question_type !== "homework_upload" && (
                <div className="ml-7 space-y-1">
                  {q.options.map((o) => {
                    const isSelected = o.id === studentAnswerId;
                    return (
                      <div
                        key={o.id}
                        className={`flex items-center gap-2 text-xs rounded-lg px-2.5 py-1.5 ${
                          o.is_correct
                            ? "bg-green-100 text-green-700 font-semibold"
                            : isSelected
                            ? "bg-red-100 text-red-600"
                            : "text-slate-400"
                        }`}
                      >
                        <span className="shrink-0 w-3">
                          {o.is_correct ? "✓" : isSelected ? "✗" : "○"}
                        </span>
                        <span>{(lang === "id" && o.option_text_id) ? o.option_text_id : o.option_text}</span>
                        {isSelected && !o.is_correct && correct && (
                          <span className="ml-auto text-green-600 font-medium hidden sm:inline">
                            {lang === "id" ? `(benar: ${(lang === "id" && correct.option_text_id) ? correct.option_text_id : correct.option_text})` : `(correct: ${correct.option_text})`}
                          </span>
                        )}
                      </div>
                    );
                  })}
                  {!studentAnswerId && (
                    <p className="text-xs text-slate-400 italic">
                      {lang === "id" ? "Tidak dijawab" : "Not answered"}
                    </p>
                  )}
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}
