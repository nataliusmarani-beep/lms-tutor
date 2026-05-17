"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

interface Props {
  sessionId: string;
  studentId: string;
  initialData: {
    course_module_id: string;
    module_id: number;
    date: string;
    duration_minutes: number;
    tutor_notes: string;
    tutor_notes_id: string;
    student_notes: string;
  };
  modules: {
    id: string;
    title: string;
    icon: string;
    week_number: number | null;
    legacy_module_id: number | null;
  }[];
}

export default function SessionEditForm({ sessionId, studentId, initialData, modules }: Props) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState({
    course_module_id: initialData.course_module_id,
    date: initialData.date,
    duration_minutes: initialData.duration_minutes.toString(),
    tutor_notes: initialData.tutor_notes,
    tutor_notes_id: initialData.tutor_notes_id,
    student_notes: initialData.student_notes,
  });

  async function handleSave(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    const supabase = createClient();

    const selectedModule = modules.find((m) => m.id === form.course_module_id);
    const { error } = await supabase
      .from("learning_sessions")
      .update({
        course_module_id: form.course_module_id || null,
        module_id: selectedModule?.legacy_module_id ?? null,
        date: form.date,
        duration_minutes: parseInt(form.duration_minutes),
        tutor_notes: form.tutor_notes || null,
        tutor_notes_id: form.tutor_notes_id || null,
        student_notes: form.student_notes || null,
      })
      .eq("id", sessionId);

    setLoading(false);
    if (error) { toast.error(error.message); return; }
    toast.success("Session updated!");
    router.push(`/tutor/students/${studentId}`);
    router.refresh();
  }

  return (
    <form onSubmit={handleSave} className="space-y-4">
      <div>
        <label className="label">Module</label>
        <select
          className="input"
          value={form.course_module_id}
          onChange={(e) => setForm({ ...form, course_module_id: e.target.value })}
        >
          <option value="">— No module —</option>
          {modules.map((m) => (
            <option key={m.id} value={m.id}>
              {m.icon} {m.week_number ? `Week ${m.week_number} – ` : ""}{m.title}
            </option>
          ))}
        </select>
      </div>

      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="label">Date</label>
          <input
            type="date" className="input" required
            value={form.date}
            onChange={(e) => setForm({ ...form, date: e.target.value })}
          />
        </div>
        <div>
          <label className="label">Duration (min)</label>
          <input
            type="number" className="input" min="10" max="180" required
            value={form.duration_minutes}
            onChange={(e) => setForm({ ...form, duration_minutes: e.target.value })}
          />
        </div>
      </div>

      <div>
        <label className="label">Tutor Notes (EN)</label>
        <textarea
          className="input resize-none" rows={3}
          value={form.tutor_notes}
          onChange={(e) => setForm({ ...form, tutor_notes: e.target.value })}
          placeholder="What was covered, how the student performed..."
        />
      </div>

      <div>
        <label className="label">Catatan Tutor (ID)</label>
        <textarea
          className="input resize-none" rows={3}
          value={form.tutor_notes_id}
          onChange={(e) => setForm({ ...form, tutor_notes_id: e.target.value })}
          placeholder="Apa yang dipelajari, bagaimana performa siswa..."
        />
      </div>

      <div>
        <label className="label">Student Notes</label>
        <textarea
          className="input resize-none" rows={2}
          value={form.student_notes}
          onChange={(e) => setForm({ ...form, student_notes: e.target.value })}
          placeholder="What I learned today..."
        />
      </div>

      <div className="flex gap-3">
        <button type="submit" className="btn-primary flex-1" disabled={loading}>
          {loading ? "Saving..." : "Save Changes"}
        </button>
        <button
          type="button"
          onClick={() => router.back()}
          className="btn-secondary flex-1"
        >
          Cancel
        </button>
      </div>
    </form>
  );
}
