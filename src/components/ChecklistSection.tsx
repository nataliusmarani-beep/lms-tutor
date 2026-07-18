"use client";
import { useState, useTransition } from "react";
import type { ChecklistCompletion } from "@/types";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

interface ChecklistItem {
  id: string;
  item_key: string;
  item_type: "student" | "teacher";
  label: string;
  label_id?: string | null;
  video_url?: string | null;
  video_url_id?: string | null;
  practice_task?: string | null;
  practice_task_id?: string | null;
}

interface ChecklistSectionProps {
  moduleId: number;
  courseModuleId?: string;
  items: ChecklistItem[];
  completions: ChecklistCompletion[];
  studentId: string;
  currentUserId: string;
  currentUserRole: string;
  lang?: "en" | "id";
  readonly?: boolean;
}

// Convert a YouTube watch/short/youtu.be URL to an embeddable URL.
function toEmbedUrl(url: string): string {
  const m = url.match(/(?:youtube\.com\/(?:watch\?v=|embed\/|shorts\/)|youtu\.be\/)([a-zA-Z0-9_-]{11})/);
  if (m) return `https://www.youtube.com/embed/${m[1]}`;
  return url;
}

// Clips are stored as "Watched & practiced: <topic>" — strip that prefix for a clean title.
function clipTitle(label: string): string {
  return label.replace(/^(Watched & practiced:|Menonton & berlatih:)\s*/i, "").trim();
}

export default function ChecklistSection({
  moduleId, courseModuleId, items, completions, studentId, currentUserId, currentUserRole, lang = "en", readonly = false,
}: ChecklistSectionProps) {
  const [localCompletions, setLocalCompletions] = useState<ChecklistCompletion[]>(completions);
  const [isPending, startTransition] = useTransition();
  const supabase = createClient();

  const isChecked = (key: string) => localCompletions.some((c) => c.item_key === key);

  async function toggleItem(key: string, itemType: "student" | "teacher") {
    if (readonly) return;
    const checked = isChecked(key);
    if (checked) {
      startTransition(async () => {
        const { error } = await supabase
          .from("checklist_completions")
          .delete()
          .eq("student_id", studentId)
          .eq("item_key", key);
        if (error) { toast.error("Failed to update"); return; }
        setLocalCompletions((prev) => prev.filter((c) => c.item_key !== key));
        toast.success(lang === "id" ? "Batal ditandai" : "Unchecked");
      });
    } else {
      startTransition(async () => {
        const payload = courseModuleId
          ? { student_id: studentId, course_module_id: courseModuleId, item_key: key, item_type: itemType, confirmed_by: currentUserId }
          : { student_id: studentId, module_id: moduleId, item_key: key, item_type: itemType, confirmed_by: currentUserId };

        const { data, error } = await supabase
          .from("checklist_completions")
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          .insert(payload as any)
          .select()
          .single();
        if (error) { toast.error("Failed to update"); return; }
        setLocalCompletions((prev) => [...prev, data]);
        toast.success(lang === "id" ? "Selesai ✓" : "Done ✓");
      });
    }
  }

  const canCheckStudent = currentUserRole === "student" || currentUserRole === "tutor";
  const canCheckTeacher = currentUserRole === "tutor";

  const studentItems = items.filter((i) => i.item_type === "student");
  const teacherItems = items.filter((i) => i.item_type === "teacher");
  const studentDone = studentItems.filter((i) => isChecked(i.item_key)).length;
  const teacherDone = teacherItems.filter((i) => isChecked(i.item_key)).length;

  // Rich clip card: title + video + practice task + "watched" checkbox.
  const renderClip = (item: ChecklistItem, index: number, canCheck: boolean) => {
    const checked = isChecked(item.item_key);
    const title = clipTitle(lang === "id" && item.label_id ? item.label_id : item.label);
    const practice = lang === "id" && item.practice_task_id ? item.practice_task_id : item.practice_task;
    const videoUrl = lang === "id" && item.video_url_id ? item.video_url_id : item.video_url;
    const disabled = isPending || readonly || !canCheck;

    return (
      <div key={item.id} className={`card space-y-3 ${checked ? "border-green-200 bg-green-50/40" : ""}`}>
        <div className="flex items-start gap-3">
          <span className="shrink-0 mt-0.5 flex h-6 w-6 items-center justify-center rounded-full bg-blue-100 text-blue-700 text-xs font-bold">
            {index + 1}
          </span>
          <h4 className="flex-1 font-semibold text-slate-800 text-sm leading-snug">{title}</h4>
          {checked && <span className="shrink-0 text-green-500 text-sm">✓</span>}
        </div>

        {/* Video (Bahasa Indonesia version when available and viewing in ID) */}
        {videoUrl ? (
          <div className="relative w-full" style={{ paddingBottom: "56.25%" }}>
            <iframe
              src={toEmbedUrl(videoUrl)}
              title={title}
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
              allowFullScreen
              className="absolute inset-0 w-full h-full rounded-xl border border-slate-100"
            />
          </div>
        ) : (
          <div className="flex items-center justify-center rounded-xl w-full h-24 bg-slate-50 border border-dashed border-slate-200 text-slate-400 text-xs gap-2">
            <span className="text-lg">🎬</span>
            {lang === "id" ? "Video segera hadir" : "Video coming soon"}
          </div>
        )}

        {/* Practice task */}
        {practice && (
          <div className="rounded-xl bg-amber-50 border border-amber-100 p-3">
            <p className="text-xs font-semibold text-amber-700 mb-1 flex items-center gap-1">
              🎯 {lang === "id" ? "Sekarang coba di Excel" : "Now try this in Excel"}
            </p>
            <p className="text-sm text-slate-700 leading-snug">{practice}</p>
          </div>
        )}

        {/* Completion toggle */}
        <label className={`flex items-center gap-2 pt-1 ${canCheck && !readonly ? "cursor-pointer" : "cursor-default"}`}>
          <input
            type="checkbox"
            checked={checked}
            onChange={() => canCheck && !readonly && toggleItem(item.item_key, item.item_type)}
            disabled={disabled}
            className="h-4 w-4 rounded border-slate-300 text-blue-600 focus:ring-blue-500"
          />
          <span className={`text-sm font-medium ${checked ? "text-green-600" : "text-slate-600"}`}>
            {checked
              ? (lang === "id" ? "Sudah ditonton & dipraktikkan" : "Watched & practiced")
              : (lang === "id" ? "Tandai sudah ditonton & dipraktikkan" : "Mark as watched & practiced")}
          </span>
        </label>
      </div>
    );
  };

  // Simple row (teacher checklist).
  const renderRow = (item: ChecklistItem, canCheck: boolean) => {
    const checked = isChecked(item.item_key);
    const label = lang === "id" && item.label_id ? item.label_id : item.label;
    return (
      <li key={item.id}>
        <label className={`flex items-start gap-3 ${canCheck && !readonly ? "cursor-pointer" : "cursor-default"}`}>
          <input
            type="checkbox"
            checked={checked}
            onChange={() => canCheck && !readonly && toggleItem(item.item_key, item.item_type)}
            disabled={isPending || readonly || !canCheck}
            className="mt-0.5 h-4 w-4 rounded border-slate-300 text-blue-600 focus:ring-blue-500 shrink-0"
          />
          <span className={`text-sm ${checked ? "line-through text-slate-400" : "text-slate-700"}`}>
            {label}
          </span>
          {checked && <span className="ml-auto text-green-500 text-xs shrink-0">✓</span>}
        </label>
      </li>
    );
  };

  return (
    <div className="space-y-5">
      {/* Student clips */}
      <div>
        <div className="flex items-center justify-between mb-3">
          <h3 className="font-semibold text-slate-700 flex items-center gap-2">
            🎬 {lang === "id" ? "Klip Pelajaran" : "Lesson Clips"}
          </h3>
          <span className="badge-green">{studentDone}/{studentItems.length}</span>
        </div>
        {studentItems.length === 0 ? (
          <p className="text-sm text-slate-400 italic">
            {lang === "id" ? "Belum ada klip." : "No clips yet."}
          </p>
        ) : (
          <div className="space-y-4">
            {studentItems.map((item, i) => renderClip(item, i, canCheckStudent))}
          </div>
        )}
      </div>

      {/* Teacher checklist */}
      <div className="card">
        <div className="flex items-center justify-between mb-3">
          <h3 className="font-semibold text-slate-700 flex items-center gap-2">
            👩‍🏫 {lang === "id" ? "Daftar Periksa Guru" : "Teacher Checklist"}
          </h3>
          <span className="badge-blue">{teacherDone}/{teacherItems.length}</span>
        </div>
        <ul className="space-y-2">
          {teacherItems.length === 0
            ? <li className="text-sm text-slate-400 italic">{lang === "id" ? "Belum ada item guru." : "No teacher items yet."}</li>
            : teacherItems.map((item) => renderRow(item, canCheckTeacher))
          }
        </ul>
        {currentUserRole !== "tutor" && !readonly && (
          <p className="text-xs text-slate-400 mt-3 italic">
            {lang === "id" ? "Hanya guru yang dapat menandai item guru." : "Only the tutor can check teacher items."}
          </p>
        )}
      </div>
    </div>
  );
}
