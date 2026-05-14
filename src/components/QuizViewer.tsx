"use client";
import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

interface QuizOption {
  id: string;
  question_id: string;
  option_text: string;
  is_correct: boolean;
  sort_order: number;
}

interface QuizQuestion {
  id: string;
  quiz_id: string;
  question_type: "single_choice" | "multiple_choice" | "fill_blank";
  question_text: string;
  sort_order: number;
  options: QuizOption[];
}

interface Quiz {
  id: string;
  title: string;
  description: string | null;
}

interface QuizAttempt {
  id: string;
  score: number;
  max_score: number;
  completed_at: string;
}

interface QuizViewerProps {
  courseModuleId: string;
  studentId: string;
}

export default function QuizViewer({ courseModuleId, studentId }: QuizViewerProps) {
  const supabase = createClient();
  const [quiz, setQuiz] = useState<Quiz | null>(null);
  const [questions, setQuestions] = useState<QuizQuestion[]>([]);
  const [loading, setLoading] = useState(true);
  const [lastAttempt, setLastAttempt] = useState<QuizAttempt | null>(null);
  const [retaking, setRetaking] = useState(false);

  // Quiz state
  const [currentIdx, setCurrentIdx] = useState(0);
  const [answers, setAnswers] = useState<Record<string, string | string[]>>({});
  const [submitting, setSubmitting] = useState(false);
  const [result, setResult] = useState<{ score: number; maxScore: number } | null>(null);

  useEffect(() => {
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [courseModuleId, studentId]);

  async function load() {
    setLoading(true);
    // Fetch quiz for this module
    const { data: quizData } = await supabase
      .from("module_quizzes")
      .select("id, title, description")
      .eq("course_module_id", courseModuleId)
      .order("sort_order")
      .limit(1)
      .maybeSingle();

    if (!quizData) {
      setLoading(false);
      return;
    }

    setQuiz(quizData as Quiz);

    // Check for existing attempt
    const { data: attemptData } = await supabase
      .from("quiz_attempts")
      .select("id, score, max_score, completed_at")
      .eq("quiz_id", quizData.id)
      .eq("student_id", studentId)
      .order("completed_at", { ascending: false })
      .limit(1)
      .maybeSingle();

    if (attemptData) {
      setLastAttempt(attemptData as QuizAttempt);
    }

    // Fetch questions + options
    const { data: qData } = await supabase
      .from("quiz_questions")
      .select("*")
      .eq("quiz_id", quizData.id)
      .order("sort_order");

    if (!qData || qData.length === 0) {
      setLoading(false);
      return;
    }

    const qIds = qData.map((q: { id: string }) => q.id);
    const { data: optData } = await supabase
      .from("quiz_options")
      .select("*")
      .in("question_id", qIds)
      .order("sort_order");

    const optsByQuestion: Record<string, QuizOption[]> = {};
    for (const opt of (optData ?? []) as QuizOption[]) {
      if (!optsByQuestion[opt.question_id]) optsByQuestion[opt.question_id] = [];
      optsByQuestion[opt.question_id].push(opt);
    }

    setQuestions(
      (qData as Omit<QuizQuestion, "options">[]).map((q) => ({
        ...q,
        options: optsByQuestion[q.id] ?? [],
      }))
    );

    setLoading(false);
  }

  function handleStartRetake() {
    setLastAttempt(null);
    setResult(null);
    setCurrentIdx(0);
    setAnswers({});
    setRetaking(true);
  }

  function handleSingleChoice(questionId: string, optionId: string) {
    setAnswers((prev) => ({ ...prev, [questionId]: optionId }));
  }

  function handleMultipleChoice(questionId: string, optionId: string, checked: boolean) {
    setAnswers((prev) => {
      const current = (prev[questionId] as string[]) ?? [];
      if (checked) {
        return { ...prev, [questionId]: [...current, optionId] };
      } else {
        return { ...prev, [questionId]: current.filter((id) => id !== optionId) };
      }
    });
  }

  function handleFillBlank(questionId: string, value: string) {
    setAnswers((prev) => ({ ...prev, [questionId]: value }));
  }

  function isAnswered(q: QuizQuestion): boolean {
    const ans = answers[q.id];
    if (!ans) return false;
    if (Array.isArray(ans)) return ans.length > 0;
    return ans.trim() !== "";
  }

  async function handleSubmit() {
    if (!quiz) return;
    setSubmitting(true);

    let score = 0;
    const maxScore = questions.length;

    for (const q of questions) {
      const ans = answers[q.id];
      if (q.question_type === "single_choice") {
        const chosen = ans as string | undefined;
        const correct = q.options.find((o) => o.is_correct);
        if (chosen && correct && chosen === correct.id) score++;
      } else if (q.question_type === "multiple_choice") {
        const chosen = (ans as string[] | undefined) ?? [];
        const correctIds = q.options.filter((o) => o.is_correct).map((o) => o.id);
        const isCorrect =
          chosen.length === correctIds.length &&
          chosen.every((id) => correctIds.includes(id)) &&
          correctIds.every((id) => chosen.includes(id));
        if (isCorrect) score++;
      } else if (q.question_type === "fill_blank") {
        const typed = ((ans as string) ?? "").trim().toLowerCase();
        const correctOpt = q.options.find((o) => o.is_correct);
        if (correctOpt && typed === correctOpt.option_text.trim().toLowerCase()) score++;
      }
    }

    const { error } = await supabase.from("quiz_attempts").insert({
      quiz_id: quiz.id,
      student_id: studentId,
      score,
      max_score: maxScore,
      answers: answers,
    });

    setSubmitting(false);

    if (error) {
      toast.error("Failed to save attempt: " + error.message);
      return;
    }

    setResult({ score, maxScore });
    setRetaking(false);
    toast.success("Quiz submitted!");
  }

  if (loading) {
    return (
      <div className="card">
        <p className="text-sm text-slate-400">Loading quiz…</p>
      </div>
    );
  }

  // No quiz for this module
  if (!quiz) return null;

  // No questions yet
  if (questions.length === 0) {
    return (
      <div className="card">
        <h2 className="font-semibold text-slate-700 mb-1 flex items-center gap-2">
          <span>🧠</span> {quiz.title}
        </h2>
        <p className="text-sm text-slate-400">No questions added yet.</p>
      </div>
    );
  }

  // Show result or last attempt
  if ((lastAttempt && !retaking) || result) {
    const score = result?.score ?? lastAttempt!.score;
    const maxScore = result?.maxScore ?? lastAttempt!.max_score;
    const pct = maxScore > 0 ? Math.round((score / maxScore) * 100) : 0;
    const badgeClass = pct >= 80 ? "badge-green" : pct >= 50 ? "badge-yellow" : "badge-red";
    const message = pct >= 80 ? "Great work!" : pct >= 50 ? "Good effort!" : "Keep practicing!";

    return (
      <div className="card space-y-4">
        <h2 className="font-semibold text-slate-700 flex items-center gap-2">
          <span>🧠</span> {quiz.title}
        </h2>
        <div className="text-center py-4 space-y-3">
          <div className="text-4xl font-bold text-slate-800">
            {score}/{maxScore}
          </div>
          <span className={`${badgeClass} text-sm px-3 py-1`}>{pct}% — {message}</span>
          {!result && lastAttempt && (
            <p className="text-xs text-slate-400">
              Last attempt: {new Date(lastAttempt.completed_at).toLocaleDateString()}
            </p>
          )}
        </div>
        <button onClick={handleStartRetake} className="btn-secondary text-sm w-full">
          Retake Quiz
        </button>
      </div>
    );
  }

  // Quiz in progress
  const currentQuestion = questions[currentIdx];
  const total = questions.length;
  const isLast = currentIdx === total - 1;
  const answered = isAnswered(currentQuestion);

  return (
    <div className="card space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="font-semibold text-slate-700 flex items-center gap-2">
          <span>🧠</span> {quiz.title}
        </h2>
        <span className="badge-gray">
          Question {currentIdx + 1}/{total}
        </span>
      </div>

      {/* Progress bar */}
      <div className="w-full bg-slate-200 rounded-full h-1.5">
        <div
          className="h-1.5 rounded-full bg-indigo-500 transition-all"
          style={{ width: `${((currentIdx + 1) / total) * 100}%` }}
        />
      </div>

      {/* Question */}
      <div className="space-y-3">
        <p className="text-slate-800 font-medium">{currentQuestion.question_text}</p>

        {currentQuestion.question_type === "single_choice" && (
          <div className="space-y-2">
            {currentQuestion.options.map((opt) => (
              <label
                key={opt.id}
                className={`flex items-center gap-3 p-3 rounded-xl border cursor-pointer transition-colors ${
                  answers[currentQuestion.id] === opt.id
                    ? "border-indigo-400 bg-indigo-50"
                    : "border-slate-200 hover:bg-slate-50"
                }`}
              >
                <input
                  type="radio"
                  name={`q_${currentQuestion.id}`}
                  value={opt.id}
                  checked={answers[currentQuestion.id] === opt.id}
                  onChange={() => handleSingleChoice(currentQuestion.id, opt.id)}
                  className="shrink-0"
                />
                <span className="text-sm text-slate-700">{opt.option_text}</span>
              </label>
            ))}
          </div>
        )}

        {currentQuestion.question_type === "multiple_choice" && (
          <div className="space-y-2">
            <p className="text-xs text-slate-400">Select all that apply.</p>
            {currentQuestion.options.map((opt) => {
              const selected = ((answers[currentQuestion.id] as string[]) ?? []).includes(opt.id);
              return (
                <label
                  key={opt.id}
                  className={`flex items-center gap-3 p-3 rounded-xl border cursor-pointer transition-colors ${
                    selected ? "border-indigo-400 bg-indigo-50" : "border-slate-200 hover:bg-slate-50"
                  }`}
                >
                  <input
                    type="checkbox"
                    value={opt.id}
                    checked={selected}
                    onChange={(e) =>
                      handleMultipleChoice(currentQuestion.id, opt.id, e.target.checked)
                    }
                    className="shrink-0"
                  />
                  <span className="text-sm text-slate-700">{opt.option_text}</span>
                </label>
              );
            })}
          </div>
        )}

        {currentQuestion.question_type === "fill_blank" && (
          <input
            className="input"
            value={(answers[currentQuestion.id] as string) ?? ""}
            onChange={(e) => handleFillBlank(currentQuestion.id, e.target.value)}
            placeholder="Type your answer…"
          />
        )}
      </div>

      {/* Navigation */}
      <div className="flex justify-between items-center pt-1">
        <button
          onClick={() => setCurrentIdx((i) => Math.max(0, i - 1))}
          disabled={currentIdx === 0}
          className="btn-secondary text-sm disabled:opacity-40"
        >
          ← Back
        </button>

        {isLast ? (
          <button
            onClick={handleSubmit}
            disabled={submitting || !answered}
            className="btn-primary text-sm disabled:opacity-40"
          >
            {submitting ? "Submitting…" : "Submit Quiz"}
          </button>
        ) : (
          <button
            onClick={() => setCurrentIdx((i) => Math.min(total - 1, i + 1))}
            disabled={!answered}
            className="btn-primary text-sm disabled:opacity-40"
          >
            Next →
          </button>
        )}
      </div>
    </div>
  );
}
