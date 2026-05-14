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
        toast.success("Unchecked");
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
        toast.success("Checked ✓");
      });
    }
  }

  const canCheckStudent = currentUserRole === "student" || currentUserRole === "tutor";
  const canCheckTeacher = currentUserRole === "tutor";

  const studentItems = items.filter((i) => i.item_type === "student");
  const teacherItems = items.filter((i) => i.item_type === "teacher");
  const studentDone = studentItems.filter((i) => isChecked(i.item_key)).length;
  const teacherDone = teacherItems.filter((i) => isChecked(i.item_key)).length;

  const renderItem = (item: ChecklistItem, canCheck: boolean) => {
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
      <div className="card">
        <div className="flex items-center justify-between mb-3">
          <h3 className="font-semibold text-slate-700 flex items-center gap-2">
            👤 {lang === "id" ? "Daftar Periksa Siswa" : "Student Checklist"}
          </h3>
          <span className="badge-green">{studentDone}/{studentItems.length}</span>
        </div>
        <ul className="space-y-2">
          {studentItems.length === 0
            ? <li className="text-sm text-slate-400 italic">No student items yet.</li>
            : studentItems.map((item) => renderItem(item, canCheckStudent))
          }
        </ul>
      </div>

      <div className="card">
        <div className="flex items-center justify-between mb-3">
          <h3 className="font-semibold text-slate-700 flex items-center gap-2">
            👩‍🏫 {lang === "id" ? "Daftar Periksa Guru" : "Teacher Checklist"}
          </h3>
          <span className="badge-blue">{teacherDone}/{teacherItems.length}</span>
        </div>
        <ul className="space-y-2">
          {teacherItems.length === 0
            ? <li className="text-sm text-slate-400 italic">No teacher items yet.</li>
            : teacherItems.map((item) => renderItem(item, canCheckTeacher))
          }
        </ul>
        {currentUserRole !== "tutor" && !readonly && (
          <p className="text-xs text-slate-400 mt-3 italic">Only the tutor can check teacher items.</p>
        )}
      </div>
    </div>
  );
}
