"use client";
import { useState, useEffect } from "react";
import type { Lang } from "@/lib/i18n";
import { HOMEWORK_FILE_ICON } from "@/lib/homeworkFile";

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
  question_type: "single_choice" | "multiple_choice" | "fill_blank" | "homework_upload" | "yes_no";
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
  file_type: string;
  tutor_grade: number | null;
  tutor_feedback: string | null;
}

interface Props {
  quizId: string;
  studentId: string;
  lang: Lang;
  accentColor?: "blue" | "teal";
  showGrading?: boolean;
}

function GradeForm({
  quizId,
  studentId,
  questionId,
  initialGrade,
  initialFeedback,
  lang,
}: {
  quizId: string;
  studentId: string;
  questionId: string;
  initialGrade: number | null;
  initialFeedback: string | null;
  lang: Lang;
}) {
  const [grade, setGrade] = useState<string>(initialGrade !== null ? String(initialGrade) : "");
  const [feedback, setFeedback] = useState(initialFeedback ?? "");
  const [saving, setSaving] = useState(false);
  const [saved, setSaved] = useState(initialGrade !== null);

  async function handleSave() {
    const gradeNum = Number(grade);
    if (grade === "" || isNaN(gradeNum) || gradeNum < 0) return;
    setSaving(true);
    const res = await fetch("/api/homework-grade", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ questionId, studentId, quizId, grade: gradeNum, feedback: feedback || null }),
    });
    setSaving(false);
    if (res.ok) setSaved(true);
  }

  return (
    <div className="ml-7 mt-2 space-y-2">
      <p className="text-xs font-semibold text-slate-500 uppercase tracking-wide">
        {lang === "id" ? "Penilaian Tutor" : "Tutor Grade"}
      </p>
      <div className="flex items-center gap-2">
        <input
          type="number"
          min={0}
          value={grade}
          onChange={(e) => { setGrade(e.target.value); setSaved(false); }}
          placeholder={lang === "id" ? "Nilai (angka)" : "Score (number)"}
          className="w-28 rounded-lg border border-slate-200 px-2.5 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-purple-300"
        />
        {saved && grade !== "" && (
          <span className="text-xs text-green-600 font-medium">
            ✓ {lang === "id" ? "Tersimpan" : "Saved"}
          </span>
        )}
      </div>
      <textarea
        value={feedback}
        onChange={(e) => { setFeedback(e.target.value); setSaved(false); }}
        placeholder={lang === "id" ? "Komentar (opsional)" : "Feedback (optional)"}
        rows={2}
        className="w-full rounded-lg border border-slate-200 px-2.5 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-purple-300 resize-none"
      />
      <button
        onClick={handleSave}
        disabled={saving || grade === "" || isNaN(Number(grade))}
        className="rounded-lg bg-purple-600 px-3 py-1.5 text-xs font-semibold text-white hover:bg-purple-700 disabled:opacity-50 transition-colors"
      >
        {saving
          ? (lang === "id" ? "Menyimpan…" : "Saving…")
          : (lang === "id" ? "Simpan Nilai" : "Save Grade")}
      </button>
    </div>
  );
}

export default function QuizReview({ quizId, studentId, lang, accentColor = "blue", showGrading = false }: Props) {
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
      const res = await fetch(`/api/quiz-review?quizId=${encodeURIComponent(quizId)}&studentId=${encodeURIComponent(studentId)}`);
      if (cancelled) return;
      if (!res.ok) { setLoading(false); return; }
      const data = await res.json();
      if (cancelled) return;
      setQuestions((data.questions ?? []) as QuizQuestion[]);
      setAttempt(data.attempt ?? null);
      setHomework((data.homework ?? []) as HomeworkSubmission[]);
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

  const hasHomework = homework.length > 0;
  if (!attempt && !hasHomework) {
    return (
      <p className="text-xs text-slate-400 italic text-center py-3">
        {lang === "id" ? "Belum ada percobaan kuis." : "No quiz attempt yet."}
      </p>
    );
  }

  const pct = attempt && attempt.max_score > 0 ? Math.round((attempt.score / attempt.max_score) * 100) : null;
  const answers = attempt?.answers ?? {};
  const hwByQuestion: Record<string, HomeworkSubmission> = {};
  for (const h of homework) hwByQuestion[h.question_id] = h;

  return (
    <div className="space-y-3">
      {/* Score summary — only shown when a formal quiz attempt exists */}
      {attempt && <div className={`flex items-center justify-between rounded-xl border px-4 py-2.5 ${accent.badge}`}>
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
      </div>}

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
                <div>
                  {hw ? (
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
                          <span className="text-lg">{HOMEWORK_FILE_ICON[hw.file_type] ?? "📎"}</span>
                          <span className="text-sm text-purple-700 font-medium">
                            {lang === "id" ? "Lihat file jawaban" : "View submitted file"}
                          </span>
                          <span className="text-xs text-slate-400">↗</span>
                        </a>
                      )}
                      <p className="text-xs text-purple-600 mt-1">✓ {lang === "id" ? "File diunggah" : "File submitted"}</p>

                      {/* Show existing grade (read-only, for non-tutors or already saved) */}
                      {!showGrading && hw.tutor_grade !== null && (
                        <div className="mt-2 flex items-center gap-2">
                          <span className="text-xs font-semibold text-purple-700">
                            {lang === "id" ? "Nilai" : "Grade"}:
                          </span>
                          <span className="text-sm font-bold text-purple-800">{hw.tutor_grade}</span>
                          {hw.tutor_feedback && (
                            <span className="text-xs text-slate-500 italic">— {hw.tutor_feedback}</span>
                          )}
                        </div>
                      )}

                      {/* Tutor grading form */}
                      {showGrading && (
                        <GradeForm
                          quizId={quizId}
                          studentId={studentId}
                          questionId={q.id}
                          initialGrade={hw.tutor_grade}
                          initialFeedback={hw.tutor_feedback}
                          lang={lang}
                        />
                      )}
                    </div>
                  ) : (
                    <p className="ml-7 text-xs text-slate-400 italic">{lang === "id" ? "Belum diunggah" : "Not submitted"}</p>
                  )}
                </div>
              )}

              {/* Yes/No answer */}
              {q.question_type === "yes_no" && (
                <div className="ml-7 flex gap-2">
                  {q.options.map((o) => {
                    const isSelected = o.id === studentAnswerId;
                    const isYes = o.option_text === "Yes";
                    const label = lang === "id" ? (isYes ? "Ya" : "Tidak") : o.option_text;
                    return (
                      <div
                        key={o.id}
                        className={`flex items-center gap-1.5 rounded-xl px-4 py-2 text-sm font-semibold border ${
                          o.is_correct && isSelected
                            ? "bg-green-100 border-green-400 text-green-700"
                            : o.is_correct
                            ? "bg-green-50 border-green-300 text-green-600"
                            : isSelected
                            ? "bg-red-100 border-red-400 text-red-600"
                            : "bg-slate-50 border-slate-200 text-slate-400"
                        }`}
                      >
                        <span>{isYes ? "✅" : "❌"}</span>
                        <span>{label}</span>
                        {o.is_correct && <span className="text-xs ml-1">✓</span>}
                      </div>
                    );
                  })}
                  {!studentAnswerId && (
                    <p className="text-xs text-slate-400 italic">{lang === "id" ? "Tidak dijawab" : "Not answered"}</p>
                  )}
                </div>
              )}

              {/* Choice / fill_blank answer */}
              {q.question_type !== "homework_upload" && q.question_type !== "yes_no" && (
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
