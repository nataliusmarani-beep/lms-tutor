"use client";
import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";
import { format } from "date-fns";
import { t } from "@/lib/i18n";
import type { Lang } from "@/lib/i18n";
import NotesList from "@/components/NotesList";

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
  max_attempts: number | null;
  attempt_count?: number;
}

interface Resource {
  id: string;
  resource_type: "video" | "pdf" | "doc" | "image" | "link";
  title: string;
  url: string;
  description: string | null;
}

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
  question_type: "single_choice" | "multiple_choice" | "fill_blank" | "homework_upload" | "yes_no";
  question_text: string;
  question_text_id?: string | null;
  attachment_url: string | null;
  attachment_type: "image" | "pdf" | null;
  sort_order: number;
  options: QuizOption[];
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

// Coloured SVG doc thumbnail (same style as ResourcePanel)
const thumbColors: Record<string, { bg: string; fold: string; text: string }> = {
  pdf:   { bg: "#3b9faa", fold: "#2c7a84", text: "#ffffff" },
  doc:   { bg: "#5b7fe8", fold: "#3d5ec4", text: "#ffffff" },
  image: { bg: "#22c55e", fold: "#16a34a", text: "#ffffff" },
  link:  { bg: "#64748b", fold: "#475569", text: "#ffffff" },
};
const thumbLabel: Record<string, string> = {
  pdf: "PDF", doc: "DOC", image: "IMG", link: "LINK",
};

function ResourceThumb({ type }: { type: string }) {
  const c = thumbColors[type] ?? thumbColors.link;
  const label = thumbLabel[type] ?? type.toUpperCase().slice(0, 4);
  return (
    <svg width="40" height="50" viewBox="0 0 40 50" fill="none" xmlns="http://www.w3.org/2000/svg" className="shrink-0">
      <rect x="0" y="0" width="40" height="50" rx="4" fill={c.bg} />
      <path d="M27 0 L40 13 L27 13 Z" fill={c.fold} />
      <path d="M27 0 L40 13 L27 13 Z" fill="rgba(0,0,0,0.12)" />
      <text x="20" y="36" textAnchor="middle" fill={c.text} fontSize="10" fontWeight="700"
        fontFamily="system-ui, sans-serif" letterSpacing="0.5">
        {label}
      </text>
    </svg>
  );
}

type Tab = "sessions" | "checklist" | "resources" | "quizzes";

const TABS: { id: Tab; icon: string; labelEn: string; labelId: string }[] = [
  { id: "sessions",  icon: "📅", labelEn: "Sessions",  labelId: "Sesi" },
  { id: "checklist", icon: "✅", labelEn: "Checklist", labelId: "Checklist" },
  { id: "resources", icon: "📎", labelEn: "Resources", labelId: "Materi" },
  { id: "quizzes",   icon: "📝", labelEn: "Quizzes",   labelId: "Kuis" },
];

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
    img.onerror = () => { URL.revokeObjectURL(url); reject(new Error("Image load failed")); };
    img.src = url;
  });
}

function SessionNoteEditor({ sessionId, initialNote, lang }: { sessionId: string; initialNote: string | null; lang: Lang }) {
  const [editing, setEditing] = useState(false);
  const [draft, setDraft] = useState(initialNote ?? "");
  const [saved, setSaved] = useState(!!initialNote);
  const [saving, setSaving] = useState(false);

  async function handleSave() {
    setSaving(true);
    const supabase = createClient();
    await supabase
      .from("learning_sessions")
      .update({ student_notes: draft.trim() || null })
      .eq("id", sessionId);
    setSaving(false);
    setSaved(true);
    setEditing(false);
  }

  if (editing) {
    return (
      <div className="space-y-1.5 mt-1">
        <textarea
          value={draft}
          onChange={(e) => { setDraft(e.target.value); setSaved(false); }}
          rows={3}
          autoFocus
          placeholder={lang === "id" ? "Tulis catatan sesimu…" : "Write your session notes…"}
          className="w-full text-xs rounded-lg border border-teal-300 px-2.5 py-1.5 focus:outline-none focus:ring-2 focus:ring-teal-300 resize-none"
        />
        <div className="flex gap-2">
          <button
            onClick={handleSave}
            disabled={saving}
            className="text-xs bg-teal-500 text-white px-3 py-1 rounded-lg hover:bg-teal-600 disabled:opacity-50 transition-colors"
          >
            {saving ? (lang === "id" ? "Menyimpan…" : "Saving…") : (lang === "id" ? "Simpan" : "Save")}
          </button>
          <button
            onClick={() => { setDraft(initialNote ?? ""); setEditing(false); }}
            className="text-xs text-slate-400 hover:text-slate-600 px-2 py-1"
          >
            {lang === "id" ? "Batal" : "Cancel"}
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="mt-1">
      {saved && draft ? (
        <div className="flex items-start gap-1 group">
          <p className="text-xs text-teal-700 flex-1 leading-relaxed">
            <span className="text-slate-400 font-medium">{lang === "id" ? "Catatan saya: " : "My notes: "}</span>
            {draft}
          </p>
          <button
            onClick={() => setEditing(true)}
            className="text-xs text-slate-300 hover:text-teal-500 shrink-0 opacity-0 group-hover:opacity-100 transition-opacity ml-1"
          >
            ✏️
          </button>
        </div>
      ) : (
        <button
          onClick={() => setEditing(true)}
          className="text-xs text-teal-500 hover:text-teal-700 transition-colors"
        >
          + {lang === "id" ? "Tambah catatan" : "Add note"}
        </button>
      )}
    </div>
  );
}

function QuizPlayer({
  quiz, studentId, lang, onClose, onComplete,
}: {
  quiz: Quiz; studentId: string; lang: Lang;
  onClose: () => void;
  onComplete: (score: number, max: number) => void;
}) {
  const [questions, setQuestions] = useState<QuizQuestion[]>([]);
  const [loading, setLoading]     = useState(true);
  const [answers, setAnswers]     = useState<Record<string, string>>({});
  const [uploadPreviews, setUploadPreviews] = useState<Record<string, string>>({});
  const [uploading, setUploading] = useState<Record<string, boolean>>({});
  const [submitted, setSubmitted] = useState(false);
  const [score, setScore]         = useState(0);
  const [submitting, setSubmitting] = useState(false);
  const [homeworkGrades, setHomeworkGrades] = useState<Record<string, { grade: number | null; feedback: string | null }>>({});

  useEffect(() => {
    (async () => {
      const supabase = createClient();
      const [{ data: qs }, { data: existingHw }, { data: existingAttempt }] = await Promise.all([
        supabase
          .from("quiz_questions")
          .select("id, question_type, question_text, question_text_id, attachment_url, attachment_type, sort_order")
          .eq("quiz_id", quiz.id)
          .order("sort_order"),
        supabase
          .from("homework_submissions")
          .select("question_id, file_url, file_type, tutor_grade, tutor_feedback")
          .eq("quiz_id", quiz.id)
          .eq("student_id", studentId),
        supabase
          .from("quiz_attempts")
          .select("answers")
          .eq("quiz_id", quiz.id)
          .eq("student_id", studentId)
          .order("completed_at", { ascending: false })
          .limit(1)
          .maybeSingle(),
      ]);
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

      // Pre-populate answers from previous attempt and homework submissions
      const preAnswers: Record<string, string> = { ...(existingAttempt?.answers ?? {}) };
      const prePreviews: Record<string, string> = {};
      const hwSeen = new Set<string>();
      const hwGrades: Record<string, { grade: number | null; feedback: string | null }> = {};
      for (const hw of (existingHw ?? []) as { question_id: string; file_url: string; file_type: string; tutor_grade: number | null; tutor_feedback: string | null }[]) {
        if (!hwSeen.has(hw.question_id)) {
          preAnswers[hw.question_id] = hw.file_url;
          prePreviews[hw.question_id] = hw.file_type === "image" ? hw.file_url : "pdf";
          hwGrades[hw.question_id] = { grade: hw.tutor_grade ?? null, feedback: hw.tutor_feedback ?? null };
          hwSeen.add(hw.question_id);
        }
      }
      setHomeworkGrades(hwGrades);
      if (Object.keys(preAnswers).length > 0) setAnswers(preAnswers);
      if (Object.keys(prePreviews).length > 0) setUploadPreviews(prePreviews);
      setLoading(false);
    })();
  }, [quiz.id, studentId]);

  async function handleFileUpload(questionId: string, file: File) {
    const isImage = file.type.startsWith("image/");
    const isPdf   = file.type === "application/pdf";
    if (!isImage && !isPdf) { alert("Only images or PDF files are allowed."); return; }
    if (isPdf && file.size > 500 * 1024) { alert("PDF must be under 500 KB."); return; }

    setUploading((p) => ({ ...p, [questionId]: true }));
    const supabase = createClient();
    try {
      let uploadFile: File | Blob = file;
      let ext = isPdf ? "pdf" : "jpg";
      if (isImage) {
        uploadFile = await compressImage(file, 200);
        ext = "jpg";
      }
      const path = `${studentId}/${questionId}/${Date.now()}.${ext}`;
      const { error: upErr } = await supabase.storage
        .from("homework-submissions")
        .upload(path, uploadFile, { upsert: true });
      if (upErr) { alert("Upload failed: " + upErr.message); return; }
      const { data } = supabase.storage.from("homework-submissions").getPublicUrl(path);
      setAnswers((p) => ({ ...p, [questionId]: data.publicUrl }));
      setUploadPreviews((p) => ({ ...p, [questionId]: isImage ? URL.createObjectURL(uploadFile as Blob) : "pdf" }));
    } finally {
      setUploading((p) => ({ ...p, [questionId]: false }));
    }
  }

  async function handleSubmit() {
    setSubmitting(true);
    const supabase = createClient();
    const scorableQuestions = questions.filter((q) => q.question_type !== "homework_upload");
    let s = 0;
    for (const q of scorableQuestions) {
      const correct = q.options.find((o) => o.is_correct);
      if (correct && answers[q.id] === correct.id) s++;
    }
    // Save homework submissions
    const hwQuestions = questions.filter((q) => q.question_type === "homework_upload");
    for (const q of hwQuestions) {
      if (answers[q.id]) {
        const fileUrl = answers[q.id];
        const isPdfUrl = fileUrl.includes(".pdf") || fileUrl.includes("%2Epdf");
        const { error: hwErr } = await supabase.from("homework_submissions").insert({
          student_id: studentId,
          question_id: q.id,
          quiz_id: quiz.id,
          file_url: fileUrl,
          file_type: isPdfUrl ? "pdf" : "image",
        });
        if (hwErr) console.error("homework_submissions insert error:", hwErr.message);
      }
    }
    await supabase.from("quiz_attempts").insert({
      quiz_id: quiz.id, student_id: studentId,
      score: s, max_score: scorableQuestions.length, answers,
    });
    setScore(s);
    setSubmitted(true);
    setSubmitting(false);
    onComplete(s, scorableQuestions.length);
  }

  if (loading) return <p className="text-sm text-slate-400 text-center py-6">Loading quiz…</p>;
  if (!questions.length) return <p className="text-sm text-slate-400 text-center py-6">No questions found.</p>;

  if (submitted) {
    const scorableCount = questions.filter((q) => q.question_type !== "homework_upload").length;
    const isHomeworkOnly = scorableCount === 0;
    const pct = scorableCount > 0 ? Math.round((score / scorableCount) * 100) : null;
    return (
      <div className="space-y-4">
        <div className={`rounded-2xl p-5 text-center ${isHomeworkOnly ? "bg-teal-50 border border-teal-200" : pct! >= 80 ? "bg-green-50 border border-green-200" : pct! >= 50 ? "bg-teal-50 border border-teal-200" : "bg-amber-50 border border-amber-200"}`}>
          {isHomeworkOnly ? (
            <div className="text-4xl font-bold text-teal-600">✓</div>
          ) : (
            <div className={`text-4xl font-bold ${pct! >= 80 ? "text-green-600" : pct! >= 50 ? "text-teal-600" : "text-amber-500"}`}>{pct}%</div>
          )}
          <div className="text-slate-600 text-sm mt-1">
            {isHomeworkOnly
              ? (lang === "id" ? "File berhasil dikirim!" : "File submitted successfully!")
              : `${score}/${scorableCount} ${lang === "id" ? "benar" : "correct"}`}
          </div>
          {!isHomeworkOnly && pct !== null && (
            <div className="text-slate-400 text-xs mt-1">
              {pct >= 80 ? (lang === "id" ? "Luar biasa! 🎉" : "Excellent! 🎉") : pct >= 50 ? (lang === "id" ? "Bagus! Terus berlatih." : "Good job! Keep practising.") : (lang === "id" ? "Pelajari lagi materinya ya!" : "Review the material and try again.")}
            </div>
          )}
        </div>
        <div className="space-y-3">
          {questions.map((q, i) => {
            const correct = q.options.find((o) => o.is_correct);
            const isRight = answers[q.id] === correct?.id;
            return (
              <div key={q.id} className={`rounded-xl px-4 py-3 border ${q.question_type === "homework_upload" ? "bg-purple-50 border-purple-200" : isRight ? "bg-green-50 border-green-200" : "bg-red-50 border-red-200"}`}>
                <p className="text-sm font-semibold text-slate-800 mb-2">{i + 1}. {(lang === "id" && q.question_text_id) ? q.question_text_id : q.question_text}</p>
                {q.attachment_url && q.attachment_type === "image" && (
                  <img src={q.attachment_url} alt="question" className="w-full max-w-xs rounded-lg border border-slate-200 mb-2 object-cover" />
                )}
                {q.question_type === "homework_upload" && answers[q.id] && (
                  <div className="mt-1 space-y-0.5">
                    <p className="text-xs text-purple-600">✓ {lang === "id" ? "File diunggah" : "File submitted"}</p>
                    {homeworkGrades[q.id]?.grade !== null && homeworkGrades[q.id]?.grade !== undefined && (
                      <div className="flex items-center gap-2">
                        <span className="text-xs font-semibold text-purple-700">{lang === "id" ? "Nilai" : "Grade"}:</span>
                        <span className="text-sm font-bold text-purple-800">{homeworkGrades[q.id].grade}</span>
                        {homeworkGrades[q.id].feedback && (
                          <span className="text-xs text-slate-500 italic">— {homeworkGrades[q.id].feedback}</span>
                        )}
                      </div>
                    )}
                  </div>
                )}
                <div className="space-y-1">
                  {q.options.map((o) => (
                    <div key={o.id} className={`text-xs rounded-lg px-3 py-1.5 flex items-center gap-2 ${
                      o.is_correct ? "bg-green-100 text-green-700 font-semibold" :
                      answers[q.id] === o.id ? "bg-red-100 text-red-600" : "text-slate-400"
                    }`}>
                      <span className="shrink-0">{o.is_correct ? "✓" : answers[q.id] === o.id ? "✗" : "○"}</span>
                      <span>{(lang === "id" && o.option_text_id) ? o.option_text_id : o.option_text}</span>
                    </div>
                  ))}
                </div>
              </div>
            );
          })}
        </div>
        <button onClick={onClose} className="btn-secondary w-full text-sm">
          {lang === "id" ? "Kembali ke Kuis" : "Back to Quizzes"}
        </button>
      </div>
    );
  }

  const allAnswered = questions.every((q) => answers[q.id]);
  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="font-semibold text-slate-800">{quiz.title}</h3>
          {quiz.description && <p className="text-xs text-slate-500 mt-0.5">{quiz.description}</p>}
        </div>
        <button onClick={onClose} className="text-xs text-slate-400 hover:text-slate-600 shrink-0">✕ {lang === "id" ? "Batal" : "Cancel"}</button>
      </div>
      <div className="space-y-4">
        {questions.map((q, i) => (
          <div key={q.id} className="bg-slate-50 rounded-xl px-4 py-4 space-y-3">
            <p className="text-sm font-semibold text-slate-800">{i + 1}. {(lang === "id" && q.question_text_id) ? q.question_text_id : q.question_text}</p>

            {/* Question attachment — image or PDF from tutor */}
            {q.attachment_url && (
              q.attachment_type === "image" ? (
                <a href={q.attachment_url} target="_blank" rel="noopener noreferrer">
                  <img
                    src={q.attachment_url}
                    alt="question"
                    className="w-full rounded-xl border border-slate-200 object-cover hover:opacity-90 transition-opacity cursor-zoom-in"
                  />
                </a>
              ) : (
                <a
                  href={q.attachment_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center gap-2 bg-white border border-slate-200 rounded-xl px-3 py-2.5 hover:bg-slate-50 transition-colors"
                >
                  <span className="text-xl">📄</span>
                  <span className="text-sm text-blue-600 font-medium flex-1">
                    {lang === "id" ? "Buka PDF soal" : "Open question PDF"}
                  </span>
                  <span className="text-xs text-slate-400">↗</span>
                </a>
              )
            )}

            {q.question_type === "homework_upload" ? (
              <div>
                {answers[q.id] ? (
                  <div className="space-y-2">
                    {uploadPreviews[q.id] === "pdf" ? (
                      <a href={answers[q.id]} target="_blank" rel="noopener noreferrer"
                        className="flex items-center gap-2 bg-white border border-slate-200 rounded-xl px-3 py-2 hover:bg-slate-50">
                        <span className="text-xl">📄</span>
                        <span className="text-sm text-blue-600 flex-1 truncate">{lang === "id" ? "Lihat file PDF" : "View PDF file"}</span>
                        <span className="text-xs text-slate-400">↗</span>
                      </a>
                    ) : (
                      <a href={answers[q.id]} target="_blank" rel="noopener noreferrer" className="block">
                        <img
                          src={uploadPreviews[q.id]}
                          alt="homework"
                          className="w-full max-w-xs rounded-xl border border-slate-200 object-cover hover:opacity-90"
                          onError={(e) => {
                            // If image fails to load, replace with a file link
                            const parent = (e.target as HTMLImageElement).closest("a");
                            if (parent) {
                              parent.innerHTML = `<div class="flex items-center gap-2 bg-white border border-slate-200 rounded-xl px-3 py-2"><span>📎</span><span class="text-sm text-blue-600">${lang === "id" ? "Lihat file jawaban" : "View submitted file"}</span><span class="text-xs text-slate-400">↗</span></div>`;
                            }
                          }}
                        />
                      </a>
                    )}
                    {homeworkGrades[q.id]?.grade !== null && homeworkGrades[q.id]?.grade !== undefined && (
                      <div className="flex items-center gap-2 mt-1">
                        <span className="text-xs font-semibold text-purple-700">
                          {lang === "id" ? "Nilai" : "Grade"}:
                        </span>
                        <span className="text-sm font-bold text-purple-800">{homeworkGrades[q.id].grade}</span>
                        {homeworkGrades[q.id].feedback && (
                          <span className="text-xs text-slate-500 italic">— {homeworkGrades[q.id].feedback}</span>
                        )}
                      </div>
                    )}
                    <button
                      type="button"
                      onClick={() => {
                        setAnswers((p) => { const n = {...p}; delete n[q.id]; return n; });
                        setUploadPreviews((p) => { const n = {...p}; delete n[q.id]; return n; });
                      }}
                      className="text-xs text-red-400 hover:text-red-600"
                    >
                      {lang === "id" ? "Ganti file" : "Change file"}
                    </button>
                  </div>
                ) : (
                  <label className={`flex flex-col items-center gap-2 border-2 border-dashed rounded-xl p-5 cursor-pointer transition-colors ${uploading[q.id] ? "border-slate-200 opacity-50" : "border-slate-200 hover:border-teal-400 hover:bg-teal-50"}`}>
                    <span className="text-2xl">{uploading[q.id] ? "⏳" : "📎"}</span>
                    <span className="text-sm font-medium text-slate-600">
                      {uploading[q.id]
                        ? (lang === "id" ? "Mengunggah…" : "Uploading…")
                        : (lang === "id" ? "Klik untuk unggah PDF atau gambar" : "Click to upload PDF or image")}
                    </span>
                    <span className="text-xs text-slate-400">PDF ≤ 500 KB · Image auto-compressed to ≤ 200 KB</span>
                    <input
                      type="file"
                      accept="image/*,.pdf"
                      className="hidden"
                      disabled={uploading[q.id]}
                      onChange={(e) => {
                        const f = e.target.files?.[0];
                        if (f) handleFileUpload(q.id, f);
                      }}
                    />
                  </label>
                )}
              </div>
            ) : q.question_type === "yes_no" ? (
              <div className="flex gap-3">
                {q.options.map((o) => {
                  const isYes = o.option_text === "Yes";
                  const selected = answers[q.id] === o.id;
                  return (
                    <button
                      key={o.id}
                      type="button"
                      onClick={() => setAnswers((prev) => ({ ...prev, [q.id]: o.id }))}
                      className={`flex-1 flex items-center justify-center gap-2 py-4 rounded-xl border-2 font-semibold text-sm transition-all ${
                        selected
                          ? (isYes ? "bg-green-100 border-green-500 text-green-700" : "bg-red-100 border-red-400 text-red-600")
                          : "bg-white border-slate-200 text-slate-500 hover:bg-slate-50"
                      }`}
                    >
                      <span className="text-xl">{isYes ? "✅" : "❌"}</span>
                      <span>{lang === "id" ? (isYes ? "Ya" : "Tidak") : o.option_text}</span>
                    </button>
                  );
                })}
              </div>
            ) : (
              <div className="space-y-2">
                {q.options.map((o) => (
                  <label key={o.id} className={`flex items-center gap-3 cursor-pointer rounded-lg px-3 py-2.5 border transition-colors ${
                    answers[q.id] === o.id ? "bg-teal-50 border-teal-400" : "bg-white border-slate-200 hover:bg-slate-50"
                  }`}>
                    <input
                      type="radio" name={q.id} value={o.id}
                      checked={answers[q.id] === o.id}
                      onChange={() => setAnswers((prev) => ({ ...prev, [q.id]: o.id }))}
                      className="accent-teal-600 shrink-0"
                    />
                    <span className="text-sm text-slate-700">{(lang === "id" && o.option_text_id) ? o.option_text_id : o.option_text}</span>
                  </label>
                ))}
              </div>
            )}
          </div>
        ))}
      </div>
      <button onClick={handleSubmit} disabled={!allAnswered || submitting || Object.values(uploading).some(Boolean)} className="btn-primary w-full">
        {submitting ? (lang === "id" ? "Mengirim…" : "Submitting…") : (lang === "id" ? "Kirim Jawaban" : "Submit Quiz")}
      </button>
      {!allAnswered && (
        <p className="text-xs text-slate-400 text-center">
          {lang === "id" ? "Jawab semua pertanyaan untuk mengirim." : "Answer all questions to submit."}
        </p>
      )}
    </div>
  );
}

function ModulePanel({
  mod, lang, studentId, defaultOpen, tutor,
}: {
  mod: ModuleData; lang: Lang; studentId: string; defaultOpen: boolean; tutor?: TutorInfo | null;
}) {
  const [open, setOpen] = useState(defaultOpen);
  const [tab, setTab]   = useState<Tab>("sessions");
  const [completedKeys, setCompletedKeys] = useState<string[]>(mod.completedKeys);
  const [activeQuizId, setActiveQuizId]   = useState<string | null>(null);
  const [localBest, setLocalBest]         = useState<Record<string, { score: number; max_score: number }>>({});
  // quizGrades: quizId -> questionId -> { grade, feedback }
  const [quizGrades, setQuizGrades]       = useState<Record<string, Record<string, { grade: number | null; feedback: string | null }>>>({});
  const { resources, loading: resLoading } = useResources(mod.id, open && tab === "resources");

  // Load homework grades when quizzes tab is opened
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
    <div className={`rounded-2xl overflow-hidden border-2 transition-colors ${open ? "border-teal-400 shadow-md" : "border-slate-200"}`}>
      {/* Header */}
      <button
        onClick={() => setOpen((v) => !v)}
        className={`w-full flex items-center gap-3 px-4 py-4 text-left transition-colors ${
          open ? "bg-teal-50" : "bg-white hover:bg-slate-50"
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
          {/* About this module */}
          {displayFocus && (
            <div className="px-4 py-3 bg-teal-50 border-b border-teal-100 flex items-start gap-2.5">
              <span className="text-teal-500 shrink-0 mt-0.5">📖</span>
              <div>
                <p className="text-xs font-semibold text-teal-700 uppercase tracking-wide mb-0.5">
                  {lang === "id" ? "Tentang Modul Ini" : "About this Module"}
                </p>
                <p className="text-sm text-teal-800">{displayFocus}</p>
              </div>
            </div>
          )}

          {/* Stats bar */}
          <div className="grid grid-cols-4 divide-x divide-slate-100 border-b border-slate-100 bg-slate-50">
            <div className="text-center py-2">
              <div className="text-base font-bold text-teal-600">{mod.sessions.length}</div>
              <div className="text-xs text-slate-400">{t(lang, "sessions")}</div>
            </div>
            <div className="text-center py-2">
              <div className="text-base font-bold text-teal-600">{studentDone}/{mod.studentItems.length} ✓</div>
              <div className="text-xs text-slate-400">{t(lang, "studentLabel")}</div>
            </div>
            <div className="text-center py-2">
              <div className="text-base font-bold text-teal-600">{tutorDone}/{mod.tutorItems.length} ✓</div>
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
                        <NotesList
                          label={t(lang, "tutorNotes")}
                          text={(lang === "id" && s.tutor_notes_id) ? s.tutor_notes_id : s.tutor_notes}
                          variant="tutor"
                        />
                        <SessionNoteEditor
                          sessionId={s.id}
                          initialNote={s.student_notes ?? null}
                          lang={lang}
                        />
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
                    ) : r.resource_type === "image" ? (
                      /* ── Large image card ── */
                      <div key={r.id} className="rounded-xl overflow-hidden border border-slate-100 bg-white hover:shadow-md transition-shadow">
                        <a href={r.url} target="_blank" rel="noopener noreferrer" className="block">
                          {/* eslint-disable-next-line @next/next/no-img-element */}
                          <img
                            src={r.url}
                            alt={r.title}
                            className="w-full object-cover max-h-64"
                            onError={(e) => {
                              const el = e.currentTarget;
                              el.style.display = "none";
                              const fb = el.nextElementSibling as HTMLElement | null;
                              if (fb) fb.style.display = "flex";
                            }}
                          />
                          <div className="hidden items-center justify-center h-32 bg-slate-100 text-slate-400 text-sm gap-2">
                            <span>🖼️</span> Image could not be loaded
                          </div>
                        </a>
                        <div className="px-3 py-2.5">
                          <div className="text-sm font-semibold text-slate-800">{r.title}</div>
                          {r.description && <p className="text-xs text-slate-500 mt-0.5">{r.description}</p>}
                          <a
                            href={r.url}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="mt-1 inline-flex items-center gap-1 text-xs font-semibold text-teal-600 hover:text-teal-700 transition-colors"
                          >
                            Open full size ↗
                          </a>
                        </div>
                      </div>
                    ) : (
                      /* ── PDF / DOC / Link card ── */
                      <div key={r.id} className="flex items-center gap-4 bg-white border border-slate-100 rounded-xl px-3 py-3 hover:shadow-sm transition-shadow">
                        <a href={r.url} target="_blank" rel="noopener noreferrer" className="shrink-0">
                          <ResourceThumb type={r.resource_type} />
                        </a>
                        <div className="flex-1 min-w-0">
                          <div className="text-sm font-semibold text-slate-800 truncate">{r.title}</div>
                          {r.description && <p className="text-xs text-slate-500 mt-0.5 line-clamp-2">{r.description}</p>}
                          <a
                            href={r.url}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="mt-1 inline-flex items-center gap-1 text-xs font-semibold text-teal-600 hover:text-teal-700 transition-colors"
                          >
                            Open ↗
                          </a>
                        </div>
                      </div>
                    )
                  ))}
                </div>
              )
            )}

            {/* Quizzes */}
            {tab === "quizzes" && (
              activeQuizId ? (
                <QuizPlayer
                  quiz={mod.quizzes.find((q) => q.id === activeQuizId)!}
                  studentId={studentId}
                  lang={lang}
                  onClose={() => setActiveQuizId(null)}
                  onComplete={(score, max) => {
                    setLocalBest((prev) => {
                      const existing = prev[activeQuizId] ?? (mod.quizzes.find((q) => q.id === activeQuizId)?.bestAttempt ?? null);
                      if (!existing || score > existing.score) return { ...prev, [activeQuizId]: { score, max_score: max } };
                      return prev;
                    });
                  }}
                />
              ) : mod.quizzes.length === 0 ? (
                <p className="text-sm text-slate-400 italic text-center py-4">
                  {t(lang, "noQuizzesYet")}
                </p>
              ) : (
                <div className="space-y-3">
                  {mod.quizzes.map((quiz) => {
                    const best = localBest[quiz.id] ?? quiz.bestAttempt;
                    const isHomeworkOnly = best && best.max_score === 0;
                    const pct  = best && best.max_score > 0 ? Math.round((best.score / best.max_score) * 100) : null;
                    const attemptsUsed = quiz.attempt_count ?? (best ? 1 : 0);
                    const attemptsLeft = quiz.max_attempts ? quiz.max_attempts - attemptsUsed : null;
                    const limitReached = attemptsLeft !== null && attemptsLeft <= 0;
                    return (
                      <div key={quiz.id} className="bg-slate-50 rounded-xl px-4 py-3 space-y-3">
                        <div className="flex items-start gap-3">
                          <span className="text-2xl shrink-0 mt-0.5">📝</span>
                          <div className="flex-1 min-w-0">
                            <div className="text-sm font-semibold text-slate-800">{quiz.title}</div>
                            {quiz.description && <p className="text-xs text-slate-500 mt-0.5">{quiz.description}</p>}
                            {quiz.max_attempts && (
                              <p className={`text-xs mt-0.5 font-medium ${limitReached ? "text-red-400" : attemptsLeft === 1 ? "text-amber-500" : "text-slate-400"}`}>
                                {limitReached
                                  ? (lang === "id" ? "Batas percobaan tercapai" : "Attempt limit reached")
                                  : (lang === "id" ? `${attemptsLeft} percobaan tersisa` : `${attemptsLeft} attempt${attemptsLeft !== 1 ? "s" : ""} left`)}
                              </p>
                            )}
                          </div>
                          {best && !isHomeworkOnly && (
                            <div className="text-right shrink-0">
                              <div className={`text-base font-bold ${pct! >= 80 ? "text-green-600" : pct! >= 50 ? "text-teal-600" : "text-amber-500"}`}>
                                {best.score}/{best.max_score}
                              </div>
                              <div className="text-xs text-slate-400">{pct}%</div>
                            </div>
                          )}
                          {isHomeworkOnly && (
                            <span className="text-xs text-teal-600 font-semibold shrink-0">
                              {lang === "id" ? "✓ Dikirim" : "✓ Submitted"}
                            </span>
                          )}
                        </div>
                        {/* Tutor grades for homework questions */}
                        {isHomeworkOnly && quizGrades[quiz.id] && Object.values(quizGrades[quiz.id]).some(g => g.grade !== null) && (
                          <div className="flex flex-wrap gap-2">
                            {Object.entries(quizGrades[quiz.id])
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
                        <button
                          onClick={() => !limitReached && setActiveQuizId(quiz.id)}
                          disabled={limitReached && !isHomeworkOnly}
                          className={`w-full text-sm font-semibold py-2 rounded-lg transition-colors ${
                            limitReached && !isHomeworkOnly
                              ? "bg-slate-100 text-slate-400 cursor-not-allowed border border-slate-200"
                              : best
                              ? "bg-white border border-teal-300 text-teal-600 hover:bg-teal-50"
                              : "bg-teal-500 text-white hover:bg-teal-600"
                          }`}
                        >
                          {best
                            ? (isHomeworkOnly
                                ? (lang === "id" ? "Lihat / Unggah Ulang" : "View / Re-upload")
                                : limitReached
                                ? (lang === "id" ? "Tidak Bisa Coba Lagi" : "No More Retakes")
                                : (lang === "id" ? "Coba Lagi" : "Retake Quiz"))
                            : (lang === "id" ? "Mulai Kuis" : "Start Quiz")}
                        </button>
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
