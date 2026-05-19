"use client";
import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

interface Quiz {
  id: string;
  course_module_id: string;
  title: string;
  description: string | null;
  sort_order: number;
}

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
  question_type: "single_choice" | "multiple_choice" | "fill_blank" | "homework_upload";
  question_text: string;
  attachment_url: string | null;
  attachment_type: "image" | "pdf" | null;
  sort_order: number;
  options: QuizOption[];
}

interface QuizBuilderProps {
  courseModuleId: string;
}

const questionTypeLabel: Record<string, string> = {
  single_choice: "Single",
  multiple_choice: "Multiple",
  fill_blank: "Fill in",
  homework_upload: "Homework Upload",
};

const questionTypeBadge: Record<string, string> = {
  single_choice: "badge-blue",
  multiple_choice: "badge-yellow",
  fill_blank: "badge-green",
  homework_upload: "badge-purple",
};

export default function QuizBuilder({ courseModuleId }: QuizBuilderProps) {
  const supabase = createClient();
  const [quizzes, setQuizzes] = useState<Quiz[]>([]);
  const [questionsMap, setQuestionsMap] = useState<Record<string, QuizQuestion[]>>({});
  const [loading, setLoading] = useState(true);
  const [creatingQuiz, setCreatingQuiz] = useState(false);

  // Per-quiz UI state
  const [collapsed, setCollapsed] = useState<Record<string, boolean>>({});
  const [editingTitle, setEditingTitle] = useState<Record<string, boolean>>({});
  const [titleDraft, setTitleDraft] = useState<Record<string, string>>({});
  const [showAddQuestion, setShowAddQuestion] = useState<Record<string, boolean>>({});

  // Add-question form state (one open at a time, keyed by quizId)
  const [activeQuizId, setActiveQuizId] = useState<string | null>(null);
  const [newQType, setNewQType] = useState<QuizQuestion["question_type"]>("single_choice");
  const [newQText, setNewQText] = useState("");
  const [newOptions, setNewOptions] = useState([
    { text: "", correct: false },
    { text: "", correct: false },
  ]);
  const [fillAnswer, setFillAnswer] = useState("");
  const [attachmentFile, setAttachmentFile] = useState<File | null>(null);
  const [attachmentPreview, setAttachmentPreview] = useState<string | null>(null);
  const [attachmentType, setAttachmentType] = useState<"image" | "pdf" | null>(null);
  const [uploadingAttachment, setUploadingAttachment] = useState(false);
  const [savingQ, setSavingQ] = useState(false);

  async function compressImage(file: File, maxKB: number): Promise<Blob> {
    return new Promise((resolve, reject) => {
      const img = new Image();
      const url = URL.createObjectURL(file);
      img.onload = () => {
        const MAX = 1200;
        let w = img.width, h = img.height;
        if (w > MAX || h > MAX) {
          if (w >= h) { h = Math.round((h * MAX) / w); w = MAX; }
          else        { w = Math.round((w * MAX) / h); h = MAX; }
        }
        const canvas = document.createElement("canvas");
        canvas.width = w; canvas.height = h;
        canvas.getContext("2d")!.drawImage(img, 0, 0, w, h);
        URL.revokeObjectURL(url);
        let quality = 0.9;
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

  async function handleAttachmentChange(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    const isImage = file.type.startsWith("image/");
    const isPdf   = file.type === "application/pdf";
    if (!isImage && !isPdf) { toast.error("Only images or PDFs allowed"); return; }
    if (isPdf && file.size > 2 * 1024 * 1024) { toast.error("PDF must be under 2 MB"); return; }
    setUploadingAttachment(true);
    try {
      if (isImage) {
        const blob = await compressImage(file, 500);
        const compressed = new File([blob], "attachment.jpg", { type: "image/jpeg" });
        setAttachmentFile(compressed);
        setAttachmentPreview(URL.createObjectURL(blob));
        setAttachmentType("image");
        toast.success(`Image ready — ${Math.round(blob.size / 1024)} KB`);
      } else {
        setAttachmentFile(file);
        setAttachmentPreview(null);
        setAttachmentType("pdf");
        toast.success(`PDF ready — ${Math.round(file.size / 1024)} KB`);
      }
    } catch { toast.error("Could not process file"); }
    setUploadingAttachment(false);
  }

  function resetAttachment() {
    setAttachmentFile(null);
    if (attachmentPreview) URL.revokeObjectURL(attachmentPreview);
    setAttachmentPreview(null);
    setAttachmentType(null);
  }

  useEffect(() => {
    loadQuizzes();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [courseModuleId]);

  async function loadQuizzes() {
    setLoading(true);
    const { data: quizData } = await supabase
      .from("module_quizzes")
      .select("*")
      .eq("course_module_id", courseModuleId)
      .order("sort_order");

    const loaded = (quizData ?? []) as Quiz[];
    setQuizzes(loaded);

    if (loaded.length > 0) {
      const allQuizIds = loaded.map((q) => q.id);
      const { data: qData } = await supabase
        .from("quiz_questions")
        .select("*")
        .in("quiz_id", allQuizIds)
        .order("sort_order");

      const questionList = (qData ?? []) as Omit<QuizQuestion, "options">[];
      const questionIds = questionList.map((q) => q.id);
      let optData: QuizOption[] = [];
      if (questionIds.length > 0) {
        const { data } = await supabase
          .from("quiz_options")
          .select("*")
          .in("question_id", questionIds)
          .order("sort_order");
        optData = (data ?? []) as QuizOption[];
      }

      const optsByQuestion: Record<string, QuizOption[]> = {};
      for (const opt of optData) {
        if (!optsByQuestion[opt.question_id]) optsByQuestion[opt.question_id] = [];
        optsByQuestion[opt.question_id].push(opt);
      }

      const map: Record<string, QuizQuestion[]> = {};
      for (const quiz of loaded) map[quiz.id] = [];
      for (const q of questionList) {
        const full: QuizQuestion = { ...q, options: optsByQuestion[q.id] ?? [] };
        if (!map[q.quiz_id]) map[q.quiz_id] = [];
        map[q.quiz_id].push(full);
      }
      setQuestionsMap(map);
    }
    setLoading(false);
  }

  async function handleCreateQuiz() {
    setCreatingQuiz(true);
    const maxOrder = quizzes.reduce((m, q) => Math.max(m, q.sort_order ?? 0), 0);
    const title = quizzes.length === 0 ? "Module Quiz" : `Quiz ${quizzes.length + 1}`;
    const { data, error } = await supabase
      .from("module_quizzes")
      .insert({ course_module_id: courseModuleId, title, sort_order: maxOrder + 1 })
      .select()
      .single();
    setCreatingQuiz(false);
    if (error) { toast.error(error.message); return; }
    const newQuiz = data as Quiz;
    setQuizzes((prev) => [...prev, newQuiz]);
    setQuestionsMap((prev) => ({ ...prev, [newQuiz.id]: [] }));
    toast.success("Quiz created!");
  }

  async function handleSaveTitle(quizId: string) {
    const draft = titleDraft[quizId];
    if (!draft?.trim()) return;
    const { error } = await supabase
      .from("module_quizzes")
      .update({ title: draft.trim() })
      .eq("id", quizId);
    if (error) { toast.error(error.message); return; }
    setQuizzes((prev) => prev.map((q) => (q.id === quizId ? { ...q, title: draft.trim() } : q)));
    setEditingTitle((prev) => ({ ...prev, [quizId]: false }));
    toast.success("Title updated");
  }

  async function handleDeleteQuestion(quizId: string, qId: string) {
    const { error } = await supabase.from("quiz_questions").delete().eq("id", qId);
    if (error) { toast.error(error.message); return; }
    setQuestionsMap((prev) => ({
      ...prev,
      [quizId]: (prev[quizId] ?? []).filter((q) => q.id !== qId),
    }));
    toast.success("Question removed");
  }

  function openAddQuestion(quizId: string) {
    setActiveQuizId(quizId);
    setShowAddQuestion((prev) => ({ ...prev, [quizId]: true }));
    setNewQText("");
    setNewQType("single_choice");
    setNewOptions([{ text: "", correct: false }, { text: "", correct: false }]);
    setFillAnswer("");
    resetAttachment();
  }

  function closeAddQuestion(quizId: string) {
    setShowAddQuestion((prev) => ({ ...prev, [quizId]: false }));
    if (activeQuizId === quizId) setActiveQuizId(null);
    resetAttachment();
  }

  async function handleSaveQuestion() {
    if (!activeQuizId || !newQText.trim()) {
      toast.error("Question text is required");
      return;
    }
    if (newQType === "homework_upload") {
      // no options needed
    } else if (newQType !== "fill_blank") {
      const validOptions = newOptions.filter((o) => o.text.trim());
      if (validOptions.length < 2) { toast.error("Add at least 2 options"); return; }
      if (!validOptions.some((o) => o.correct)) { toast.error("Mark at least one correct answer"); return; }
    } else {
      if (!fillAnswer.trim()) { toast.error("Provide the correct answer"); return; }
    }

    setSavingQ(true);

    let attachment_url: string | null = null;
    if (attachmentFile && attachmentType) {
      const ext = attachmentType === "pdf" ? "pdf" : "jpg";
      const path = `${courseModuleId}/${Date.now()}.${ext}`;
      const { error: upErr } = await supabase.storage
        .from("quiz-attachments")
        .upload(path, attachmentFile, { upsert: false });
      if (upErr) { toast.error("Attachment upload failed: " + upErr.message); setSavingQ(false); return; }
      const { data: urlData } = supabase.storage.from("quiz-attachments").getPublicUrl(path);
      attachment_url = urlData.publicUrl;
    }

    const currentQuestions = questionsMap[activeQuizId] ?? [];
    const maxOrder = currentQuestions.reduce((m, q) => Math.max(m, q.sort_order), 0);
    const { data: qData, error: qError } = await supabase
      .from("quiz_questions")
      .insert({
        quiz_id: activeQuizId,
        question_type: newQType,
        question_text: newQText.trim(),
        attachment_url,
        attachment_type: attachmentType,
        sort_order: maxOrder + 1,
      })
      .select()
      .single();

    if (qError) { toast.error(qError.message); setSavingQ(false); return; }

    let opts: QuizOption[] = [];
    if (newQType === "homework_upload") {
      // no options
    } else if (newQType !== "fill_blank") {
      const validOptions = newOptions.filter((o) => o.text.trim());
      const optInserts = validOptions.map((o, i) => ({
        question_id: qData.id,
        option_text: o.text.trim(),
        is_correct: o.correct,
        sort_order: i,
      }));
      const { data: optData, error: optError } = await supabase
        .from("quiz_options")
        .insert(optInserts)
        .select();
      if (optError) { toast.error(optError.message); setSavingQ(false); return; }
      opts = (optData ?? []) as QuizOption[];
    } else {
      const { data: optData, error: optError } = await supabase
        .from("quiz_options")
        .insert({ question_id: qData.id, option_text: fillAnswer.trim(), is_correct: true, sort_order: 0 })
        .select();
      if (optError) { toast.error(optError.message); setSavingQ(false); return; }
      opts = (optData ?? []) as QuizOption[];
    }

    const newQuestion: QuizQuestion = { ...(qData as Omit<QuizQuestion, "options">), options: opts };
    setQuestionsMap((prev) => ({
      ...prev,
      [activeQuizId]: [...(prev[activeQuizId] ?? []), newQuestion],
    }));

    setNewQText("");
    setNewQType("single_choice");
    setNewOptions([{ text: "", correct: false }, { text: "", correct: false }]);
    setFillAnswer("");
    resetAttachment();
    setShowAddQuestion((prev) => ({ ...prev, [activeQuizId]: false }));
    setActiveQuizId(null);
    setSavingQ(false);
    toast.success("Question added!");
  }

  function updateOption(idx: number, field: "text" | "correct", value: string | boolean) {
    setNewOptions((prev) =>
      prev.map((o, i) => (i === idx ? { ...o, [field]: value } : o))
    );
  }

  function addOption() {
    if (newOptions.length >= 6) return;
    setNewOptions((prev) => [...prev, { text: "", correct: false }]);
  }

  function removeOption(idx: number) {
    if (newOptions.length <= 2) return;
    setNewOptions((prev) => prev.filter((_, i) => i !== idx));
  }

  if (loading) {
    return (
      <div className="card">
        <p className="text-sm text-slate-400">Loading quizzes…</p>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h2 className="font-semibold text-slate-700 flex items-center gap-2">
          <span>🧠</span> Module Quizzes
        </h2>
        <span className="text-xs text-slate-400">{quizzes.length} quiz{quizzes.length !== 1 ? "zes" : ""}</span>
      </div>

      {quizzes.length === 0 && (
        <div className="card text-center py-8">
          <p className="text-slate-400 text-sm mb-3">No quizzes for this module yet.</p>
          <button onClick={handleCreateQuiz} disabled={creatingQuiz} className="btn-primary text-sm">
            {creatingQuiz ? "Creating…" : "+ Create Quiz"}
          </button>
        </div>
      )}

      {quizzes.map((quiz, qi) => {
        const questions = questionsMap[quiz.id] ?? [];
        const isCollapsed = collapsed[quiz.id] ?? false;
        const isEditingTitle = editingTitle[quiz.id] ?? false;
        const isShowingAdd = showAddQuestion[quiz.id] ?? false;

        return (
          <div key={quiz.id} className="card space-y-4">
            {/* Quiz header */}
            <div className="flex items-center gap-2">
              <span className="text-xs font-bold text-slate-400 bg-slate-100 rounded-full w-5 h-5 flex items-center justify-center shrink-0">{qi + 1}</span>
              {isEditingTitle ? (
                <div className="flex items-center gap-2 flex-1">
                  <input
                    className="input flex-1 py-1 text-sm"
                    value={titleDraft[quiz.id] ?? quiz.title}
                    onChange={(e) => setTitleDraft((prev) => ({ ...prev, [quiz.id]: e.target.value }))}
                    onKeyDown={(e) => {
                      if (e.key === "Enter") { e.preventDefault(); handleSaveTitle(quiz.id); }
                      if (e.key === "Escape") setEditingTitle((prev) => ({ ...prev, [quiz.id]: false }));
                    }}
                    autoFocus
                  />
                  <button onClick={() => handleSaveTitle(quiz.id)} className="btn-primary text-xs py-1 px-2">Save</button>
                  <button onClick={() => setEditingTitle((prev) => ({ ...prev, [quiz.id]: false }))} className="text-slate-400 text-xs">Cancel</button>
                </div>
              ) : (
                <>
                  <h3 className="font-medium text-slate-800 flex-1">{quiz.title}</h3>
                  <button
                    onClick={() => { setEditingTitle((prev) => ({ ...prev, [quiz.id]: true })); setTitleDraft((prev) => ({ ...prev, [quiz.id]: quiz.title })); }}
                    className="text-xs text-indigo-400 hover:text-indigo-600 transition-colors"
                  >
                    Edit title
                  </button>
                  <button
                    onClick={() => setCollapsed((prev) => ({ ...prev, [quiz.id]: !isCollapsed }))}
                    className="text-xs text-slate-400 hover:text-slate-600 transition-colors"
                  >
                    {isCollapsed ? "Expand ▼" : "Collapse ▲"}
                  </button>
                </>
              )}
            </div>

            {!isCollapsed && (
              <>
                {/* Questions list */}
                {questions.length === 0 ? (
                  <p className="text-sm text-slate-400 italic">No questions yet. Add your first question below.</p>
                ) : (
                  <div className="space-y-3">
                    {questions.map((q, qi2) => (
                      <div key={q.id} className="bg-slate-50 rounded-xl p-3 space-y-2">
                        <div className="flex items-start justify-between gap-2">
                          <div className="flex items-start gap-2 flex-1">
                            <span className="text-xs text-slate-400 font-semibold mt-0.5 shrink-0">Q{qi2 + 1}</span>
                            <div className="flex-1">
                              <div className="flex items-center gap-2 mb-1 flex-wrap">
                                <span className={questionTypeBadge[q.question_type]}>
                                  {questionTypeLabel[q.question_type]}
                                </span>
                              </div>
                              <p className="text-sm text-slate-700">{q.question_text}</p>
                              {q.attachment_url && (
                                <div className="mt-2">
                                  {q.attachment_type === "image" ? (
                                    <img src={q.attachment_url} alt="attachment" className="max-w-xs rounded-lg border border-slate-200" />
                                  ) : (
                                    <a href={q.attachment_url} target="_blank" rel="noreferrer" className="text-xs text-blue-500 underline flex items-center gap-1">
                                      <span>📄</span> View PDF attachment
                                    </a>
                                  )}
                                </div>
                              )}
                              {q.options.length > 0 && (
                                <ul className="mt-2 space-y-1">
                                  {q.options.map((opt) => (
                                    <li
                                      key={opt.id}
                                      className={`text-xs flex items-center gap-1.5 ${
                                        opt.is_correct ? "text-emerald-700 font-medium" : "text-slate-500"
                                      }`}
                                    >
                                      <span>{opt.is_correct ? "✓" : "○"}</span>
                                      <span>{opt.option_text}</span>
                                    </li>
                                  ))}
                                </ul>
                              )}
                            </div>
                          </div>
                          <button
                            onClick={() => handleDeleteQuestion(quiz.id, q.id)}
                            className="text-xs text-red-400 hover:text-red-600 transition-colors shrink-0"
                          >
                            Delete
                          </button>
                        </div>
                      </div>
                    ))}
                  </div>
                )}

                {/* Add question */}
                {!isShowingAdd ? (
                  <button onClick={() => openAddQuestion(quiz.id)} className="btn-secondary text-sm w-full">
                    + Add Question
                  </button>
                ) : activeQuizId === quiz.id ? (
                  <div className="border border-slate-200 rounded-xl p-4 space-y-3 bg-slate-50">
                    <h4 className="font-semibold text-slate-700 text-sm">New Question</h4>

                    <div>
                      <label className="label">Question Type</label>
                      <select
                        className="input"
                        value={newQType}
                        onChange={(e) => {
                          setNewQType(e.target.value as QuizQuestion["question_type"]);
                          setNewOptions([{ text: "", correct: false }, { text: "", correct: false }]);
                          setFillAnswer("");
                        }}
                      >
                        <option value="single_choice">Single Choice (one correct)</option>
                        <option value="multiple_choice">Multiple Choice (many correct)</option>
                        <option value="fill_blank">Fill in the Blank</option>
                        <option value="homework_upload">Homework Upload (PDF / Image)</option>
                      </select>
                    </div>

                    <div>
                      <label className="label">Question Text</label>
                      <textarea
                        className="input resize-none"
                        rows={2}
                        value={newQText}
                        onChange={(e) => setNewQText(e.target.value)}
                        placeholder="Type your question here…"
                      />
                    </div>

                    <div>
                      <label className="label">Question Attachment <span className="text-slate-400 font-normal">(optional — image or PDF shown to student)</span></label>
                      {attachmentFile ? (
                        <div className="space-y-2">
                          {attachmentType === "image" && attachmentPreview ? (
                            <img src={attachmentPreview} alt="attachment" className="w-full max-w-xs rounded-xl border border-slate-200 object-cover" />
                          ) : (
                            <div className="flex items-center gap-2 bg-slate-50 border border-slate-200 rounded-xl px-3 py-2">
                              <span className="text-xl">📄</span>
                              <span className="text-sm text-slate-700 flex-1 truncate">{attachmentFile.name}</span>
                              <span className="text-xs text-slate-400">{Math.round(attachmentFile.size / 1024)} KB</span>
                            </div>
                          )}
                          <button type="button" onClick={resetAttachment} className="text-xs text-red-400 hover:text-red-600">Remove attachment</button>
                        </div>
                      ) : (
                        <label className={`flex items-center gap-2 border-2 border-dashed border-slate-200 rounded-xl px-4 py-3 cursor-pointer hover:border-teal-400 hover:bg-teal-50 transition-colors ${uploadingAttachment ? "opacity-50" : ""}`}>
                          <span className="text-lg">{uploadingAttachment ? "⏳" : "📎"}</span>
                          <span className="text-sm text-slate-500">{uploadingAttachment ? "Processing…" : "Click to attach image or PDF"}</span>
                          <input type="file" accept="image/*,.pdf" className="hidden" disabled={uploadingAttachment} onChange={handleAttachmentChange} />
                        </label>
                      )}
                    </div>

                    {newQType === "homework_upload" ? (
                      <p className="text-xs text-slate-400 bg-purple-50 border border-purple-100 rounded-lg px-3 py-2">
                        📎 Students will upload a PDF (≤500 KB) or image (auto-compressed to ≤200 KB) as their answer.
                      </p>
                    ) : newQType !== "fill_blank" ? (
                      <div className="space-y-2">
                        <label className="label">Answer Options</label>
                        {newOptions.map((opt, i) => (
                          <div key={i} className="flex items-center gap-2">
                            <input
                              type={newQType === "single_choice" ? "radio" : "checkbox"}
                              name="correct_option"
                              checked={opt.correct}
                              onChange={(e) => {
                                if (newQType === "single_choice") {
                                  setNewOptions((prev) =>
                                    prev.map((o, j) => ({ ...o, correct: j === i ? e.target.checked : false }))
                                  );
                                } else {
                                  updateOption(i, "correct", e.target.checked);
                                }
                              }}
                              className="shrink-0"
                            />
                            <input
                              className="input flex-1 py-1 text-sm"
                              value={opt.text}
                              onChange={(e) => updateOption(i, "text", e.target.value)}
                              placeholder={`Option ${i + 1}`}
                            />
                            {newOptions.length > 2 && (
                              <button
                                type="button"
                                onClick={() => removeOption(i)}
                                className="text-red-400 hover:text-red-600 text-xs shrink-0"
                              >
                                ✕
                              </button>
                            )}
                          </div>
                        ))}
                        {newOptions.length < 6 && (
                          <button type="button" onClick={addOption} className="text-xs text-indigo-500 hover:text-indigo-700 transition-colors">
                            + Add option
                          </button>
                        )}
                        <p className="text-xs text-slate-400">
                          {newQType === "single_choice" ? "Select the radio button for the correct answer." : "Check all correct answers."}
                        </p>
                      </div>
                    ) : (
                      <div>
                        <label className="label">Correct Answer</label>
                        <input
                          className="input"
                          value={fillAnswer}
                          onChange={(e) => setFillAnswer(e.target.value)}
                          placeholder="The correct answer text"
                        />
                      </div>
                    )}

                    <div className="flex gap-2 pt-1">
                      <button type="button" onClick={handleSaveQuestion} disabled={savingQ} className="btn-primary text-sm">
                        {savingQ ? "Saving…" : "Save Question"}
                      </button>
                      <button type="button" onClick={() => closeAddQuestion(quiz.id)} className="btn-secondary text-sm">
                        Cancel
                      </button>
                    </div>
                  </div>
                ) : null}
              </>
            )}
          </div>
        );
      })}

      {/* Create new quiz button (always visible if at least one quiz exists) */}
      {quizzes.length > 0 && (
        <button
          onClick={handleCreateQuiz}
          disabled={creatingQuiz}
          className="btn-secondary text-sm w-full"
        >
          {creatingQuiz ? "Creating…" : "+ Create New Quiz"}
        </button>
      )}
    </div>
  );
}
