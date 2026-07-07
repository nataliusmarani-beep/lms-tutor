"use client";
import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";
import { HOMEWORK_UPLOAD_ACCEPT, HOMEWORK_MAX_DOC_SIZE, HOMEWORK_FILE_ICON, classifyHomeworkFile, fileTypeFromUrl, isDocExt } from "@/lib/homeworkFile";

interface QuizOption {
  id: string;
  question_id: string;
  option_text: string;
  option_text_id?: string | null;
  is_correct: boolean;
  sort_order: number;
}

interface QuizQuestion {
  id: string;
  quiz_id: string;
  question_type: "single_choice" | "multiple_choice" | "fill_blank" | "homework_upload" | "yes_no";
  question_text: string;
  question_text_id?: string | null;
  attachment_url: string | null;
  attachment_type: "image" | "pdf" | null;
  sort_order: number;
  options: QuizOption[];
}

interface Quiz {
  id: string;
  title: string;
  description: string | null;
  sort_order: number;
}

interface QuizAttempt {
  score: number;
  max_score: number;
  completed_at: string;
}

interface QuizViewerProps {
  courseModuleId: string;
  studentId: string;
}

async function compressImage(file: File, maxKB: number): Promise<Blob> {
  return new Promise((resolve, reject) => {
    const img = new Image();
    const url = URL.createObjectURL(file);
    img.onload = () => {
      const MAX = 800;
      let w = img.width, h = img.height;
      if (w > MAX || h > MAX) {
        if (w >= h) { h = Math.round((h * MAX) / w); w = MAX; }
        else        { w = Math.round((w * MAX) / h); h = MAX; }
      }
      const canvas = document.createElement("canvas");
      canvas.width = w; canvas.height = h;
      canvas.getContext("2d")!.drawImage(img, 0, 0, w, h);
      URL.revokeObjectURL(url);
      let quality = 0.85;
      function attempt() {
        canvas.toBlob((blob) => {
          if (!blob) { reject(new Error("Compression failed")); return; }
          if (blob.size <= maxKB * 1024 || quality <= 0.05) { resolve(blob); }
          else { quality = Math.max(0.05, quality - 0.1); attempt(); }
        }, "image/jpeg", quality);
      }
      attempt();
    };
    img.onerror = () => { URL.revokeObjectURL(url); reject(new Error("Load failed")); };
    img.src = url;
  });
}

// ── Single quiz card (questions + submit) ──────────────────────────────────────
function QuizCard({
  quiz, studentId, initialAttempt,
}: {
  quiz: Quiz; studentId: string; initialAttempt: QuizAttempt | null;
}) {
  const supabase = createClient();
  const [questions, setQuestions] = useState<QuizQuestion[]>([]);
  const [loading, setLoading] = useState(false);
  const [open, setOpen] = useState(false);
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [uploadPreviews, setUploadPreviews] = useState<Record<string, string>>({});
  const [uploading, setUploading] = useState<Record<string, boolean>>({});
  const [submitting, setSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [score, setScore] = useState(0);
  const [attempt, setAttempt] = useState<QuizAttempt | null>(initialAttempt);

  async function loadQuestions() {
    if (questions.length > 0) return;
    setLoading(true);
    const { data: qs } = await supabase
      .from("quiz_questions")
      .select("id, quiz_id, question_type, question_text, question_text_id, attachment_url, attachment_type, sort_order")
      .eq("quiz_id", quiz.id)
      .order("sort_order");
    if (!qs?.length) { setLoading(false); return; }
    const { data: opts } = await supabase
      .from("quiz_options")
      .select("id, question_id, option_text, option_text_id, is_correct, sort_order")
      .in("question_id", qs.map((q) => q.id))
      .order("sort_order");
    setQuestions(qs.map((q) => ({
      ...q,
      options: (opts ?? []).filter((o) => o.question_id === q.id),
    })) as QuizQuestion[]);
    setLoading(false);
  }

  function handleOpen() {
    setOpen(true);
    loadQuestions();
  }

  async function handleFileUpload(questionId: string, file: File) {
    const { isImage, isDoc, ext } = classifyHomeworkFile(file);
    if (!isImage && !isDoc) { toast.error("Only images, PDF, Word, Excel, or PowerPoint files allowed."); return; }
    if (!isImage && file.size > HOMEWORK_MAX_DOC_SIZE) { toast.error("File must be under 500 KB."); return; }
    setUploading((p) => ({ ...p, [questionId]: true }));
    try {
      let uploadFile: File | Blob = file;
      const uploadExt = isImage ? "jpg" : ext;
      if (isImage) uploadFile = await compressImage(file, 200);
      const path = `${studentId}/${questionId}/${Date.now()}.${uploadExt}`;
      const { error: upErr } = await supabase.storage
        .from("homework-submissions")
        .upload(path, uploadFile, { upsert: true });
      if (upErr) { toast.error("Upload failed: " + upErr.message); return; }
      const { data } = supabase.storage.from("homework-submissions").getPublicUrl(path);
      setAnswers((p) => ({ ...p, [questionId]: data.publicUrl }));
      setUploadPreviews((p) => ({ ...p, [questionId]: isImage ? URL.createObjectURL(uploadFile as Blob) : ext }));
    } finally {
      setUploading((p) => ({ ...p, [questionId]: false }));
    }
  }

  async function handleSubmit() {
    setSubmitting(true);
    const scorableQs = questions.filter((q) => q.question_type !== "homework_upload");
    let s = 0;
    for (const q of scorableQs) {
      const correct = q.options.find((o) => o.is_correct);
      if (correct && answers[q.id] === correct.id) s++;
    }
    // Save homework submissions
    for (const q of questions.filter((q) => q.question_type === "homework_upload")) {
      if (answers[q.id]) {
        const fileUrl = answers[q.id];
        const { error: hwErr } = await supabase.from("homework_submissions").insert({
          student_id: studentId, question_id: q.id, quiz_id: quiz.id,
          file_url: fileUrl,
          file_type: fileTypeFromUrl(fileUrl),
        });
        if (hwErr) console.error("homework_submissions insert error:", hwErr.message);
      }
    }
    await supabase.from("quiz_attempts").insert({
      quiz_id: quiz.id, student_id: studentId,
      score: s, max_score: scorableQs.length, answers,
    });
    setScore(s);
    setAttempt({ score: s, max_score: scorableQs.length, completed_at: new Date().toISOString() });
    setSubmitted(true);
    setSubmitting(false);
    toast.success("Quiz submitted!");
  }

  const allAnswered = questions.length > 0 && questions.every((q) => answers[q.id]);
  const pct = attempt ? (attempt.max_score > 0 ? Math.round((attempt.score / attempt.max_score) * 100) : null) : null;

  return (
    <div className="card space-y-3">
      {/* Quiz header + score */}
      <div className="flex items-center gap-3">
        <span className="text-xl shrink-0">🧠</span>
        <div className="flex-1 min-w-0">
          <h3 className="font-semibold text-slate-800 text-sm">{quiz.title}</h3>
          {quiz.description && <p className="text-xs text-slate-500 mt-0.5">{quiz.description}</p>}
        </div>
        {attempt && !open && (
          <div className="text-right shrink-0">
            <div className={`text-base font-bold ${pct !== null && pct >= 80 ? "text-green-600" : pct !== null && pct >= 50 ? "text-teal-600" : "text-amber-500"}`}>
              {attempt.score}/{attempt.max_score}
            </div>
            {pct !== null && <div className="text-xs text-slate-400">{pct}%</div>}
          </div>
        )}
      </div>

      {/* Submitted result */}
      {submitted && (
        <div className={`rounded-xl p-4 text-center border ${score / questions.filter(q => q.question_type !== "homework_upload").length >= 0.8 ? "bg-green-50 border-green-200" : "bg-teal-50 border-teal-200"}`}>
          <div className="text-3xl font-bold text-slate-800">{score}/{questions.filter(q => q.question_type !== "homework_upload").length}</div>
          <div className="text-sm text-slate-500 mt-1">Quiz submitted!</div>
        </div>
      )}

      {/* Open / retake button */}
      {!open && !submitted && (
        <button
          onClick={handleOpen}
          className={`w-full text-sm font-semibold py-2 rounded-lg transition-colors ${
            attempt
              ? "bg-white border border-teal-300 text-teal-600 hover:bg-teal-50"
              : "bg-teal-500 text-white hover:bg-teal-600"
          }`}
        >
          {attempt ? "Retake Quiz" : "Start Quiz"}
        </button>
      )}

      {/* Questions */}
      {open && !submitted && (
        <div className="space-y-3">
          {loading ? (
            <p className="text-sm text-slate-400 text-center py-4">Loading questions…</p>
          ) : questions.length === 0 ? (
            <p className="text-sm text-slate-400 italic text-center">No questions yet.</p>
          ) : (
            <>
              {questions.map((q, i) => (
                <div key={q.id} className="bg-slate-50 rounded-xl px-4 py-3 space-y-2">
                  <p className="text-sm font-semibold text-slate-800">{i + 1}. {q.question_text}</p>

                  {q.attachment_url && (
                    q.attachment_type === "image" ? (
                      <a href={q.attachment_url} target="_blank" rel="noopener noreferrer">
                        <img src={q.attachment_url} alt="question" className="w-full rounded-xl border border-slate-200 object-cover hover:opacity-90" />
                      </a>
                    ) : (
                      <a href={q.attachment_url} target="_blank" rel="noopener noreferrer" className="inline-flex items-center gap-2 bg-white border border-slate-200 rounded-xl px-3 py-2 hover:bg-slate-50 text-sm text-blue-600">
                        <span>📄</span> Open question PDF ↗
                      </a>
                    )
                  )}

                  {q.question_type === "homework_upload" ? (
                    answers[q.id] ? (
                      <div className="space-y-1">
                        {isDocExt(uploadPreviews[q.id] ?? "") ? (
                          <div className="flex items-center gap-2 bg-white border border-slate-200 rounded-xl px-3 py-2 text-sm">
                            <span>{HOMEWORK_FILE_ICON[uploadPreviews[q.id]] ?? "📎"}</span><span className="flex-1">{uploadPreviews[q.id].toUpperCase()} file uploaded</span>
                            <a href={answers[q.id]} target="_blank" rel="noopener noreferrer" className="text-xs text-blue-500">View</a>
                          </div>
                        ) : (
                          <img src={uploadPreviews[q.id]} alt="homework" className="max-w-xs w-full rounded-xl border border-slate-200 object-cover" />
                        )}
                        <button type="button" onClick={() => { setAnswers((p) => { const n = {...p}; delete n[q.id]; return n; }); setUploadPreviews((p) => { const n = {...p}; delete n[q.id]; return n; }); }} className="text-xs text-red-400 hover:text-red-600">Change file</button>
                      </div>
                    ) : (
                      <label className={`flex flex-col items-center gap-2 border-2 border-dashed rounded-xl p-4 cursor-pointer transition-colors ${uploading[q.id] ? "border-slate-200 opacity-50" : "border-slate-200 hover:border-teal-400 hover:bg-teal-50"}`}>
                        <span className="text-2xl">{uploading[q.id] ? "⏳" : "📎"}</span>
                        <span className="text-sm font-medium text-slate-600">{uploading[q.id] ? "Uploading…" : "Click to upload a file"}</span>
                        <span className="text-xs text-slate-400">PDF/Word/Excel/PowerPoint ≤ 500 KB · Image auto-compressed to ≤ 200 KB</span>
                        <input type="file" accept={HOMEWORK_UPLOAD_ACCEPT} className="hidden" disabled={uploading[q.id]} onChange={(e) => { const f = e.target.files?.[0]; if (f) handleFileUpload(q.id, f); }} />
                      </label>
                    )
                  ) : q.question_type === "yes_no" ? (
                    <div className="flex gap-3">
                      {q.options.map((o) => {
                        const isYes = o.option_text === "Yes";
                        const selected = answers[q.id] === o.id;
                        return (
                          <button
                            key={o.id}
                            type="button"
                            onClick={() => setAnswers((p) => ({ ...p, [q.id]: o.id }))}
                            className={`flex-1 flex items-center justify-center gap-2 py-4 rounded-xl border-2 font-semibold text-sm transition-all ${
                              selected
                                ? (isYes ? "bg-green-100 border-green-500 text-green-700" : "bg-red-100 border-red-400 text-red-600")
                                : "bg-white border-slate-200 text-slate-500 hover:bg-slate-50"
                            }`}
                          >
                            <span className="text-xl">{isYes ? "✅" : "❌"}</span>
                            <span>{o.option_text}</span>
                          </button>
                        );
                      })}
                    </div>
                  ) : (
                    <div className="space-y-2">
                      {q.options.map((o) => (
                        <label key={o.id} className={`flex items-center gap-3 cursor-pointer rounded-lg px-3 py-2.5 border transition-colors ${answers[q.id] === o.id ? "bg-teal-50 border-teal-400" : "bg-white border-slate-200 hover:bg-slate-50"}`}>
                          <input type="radio" name={q.id} value={o.id} checked={answers[q.id] === o.id} onChange={() => setAnswers((p) => ({ ...p, [q.id]: o.id }))} className="accent-teal-600 shrink-0" />
                          <span className="text-sm text-slate-700">{o.option_text}</span>
                        </label>
                      ))}
                    </div>
                  )}
                </div>
              ))}

              <div className="flex gap-2 pt-1">
                <button
                  onClick={handleSubmit}
                  disabled={!allAnswered || submitting || Object.values(uploading).some(Boolean)}
                  className="btn-primary flex-1 disabled:opacity-50"
                >
                  {submitting ? "Submitting…" : "Submit Quiz"}
                </button>
                <button onClick={() => setOpen(false)} className="btn-secondary text-sm px-4">Cancel</button>
              </div>
              {!allAnswered && <p className="text-xs text-slate-400 text-center">Answer all questions to submit.</p>}
            </>
          )}
        </div>
      )}
    </div>
  );
}

// ── Main exported component ───────────────────────────────────────────────────
export default function QuizViewer({ courseModuleId, studentId }: QuizViewerProps) {
  const supabase = createClient();
  const [quizzes, setQuizzes] = useState<Quiz[]>([]);
  const [attempts, setAttempts] = useState<Record<string, QuizAttempt | null>>({});
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    (async () => {
      const { data: quizData } = await supabase
        .from("module_quizzes")
        .select("id, title, description, sort_order")
        .eq("course_module_id", courseModuleId)
        .order("sort_order");

      const loaded = (quizData ?? []) as Quiz[];
      setQuizzes(loaded);

      if (loaded.length > 0) {
        const { data: attData } = await supabase
          .from("quiz_attempts")
          .select("quiz_id, score, max_score, completed_at")
          .eq("student_id", studentId)
          .in("quiz_id", loaded.map((q) => q.id))
          .order("completed_at", { ascending: false });

        const attMap: Record<string, QuizAttempt | null> = {};
        for (const quiz of loaded) attMap[quiz.id] = null;
        for (const a of (attData ?? []) as (QuizAttempt & { quiz_id: string })[]) {
          if (attMap[a.quiz_id] === null) {
            attMap[a.quiz_id] = { score: a.score, max_score: a.max_score, completed_at: a.completed_at };
          }
        }
        setAttempts(attMap);
      }
      setLoading(false);
    })();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [courseModuleId, studentId]);

  if (loading) {
    return (
      <div className="card">
        <p className="text-sm text-slate-400">Loading quizzes…</p>
      </div>
    );
  }

  if (quizzes.length === 0) return null;

  return (
    <div className="space-y-3">
      <h2 className="font-semibold text-slate-700 flex items-center gap-2">
        <span>🧠</span> Quizzes
      </h2>
      {quizzes.map((quiz) => (
        <QuizCard
          key={quiz.id}
          quiz={quiz}
          studentId={studentId}
          initialAttempt={attempts[quiz.id] ?? null}
        />
      ))}
    </div>
  );
}
