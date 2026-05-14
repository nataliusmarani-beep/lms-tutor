"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import { COURSE_MODULES } from "@/lib/course-data";
import toast from "react-hot-toast";

interface SessionFormProps {
  studentId: string;
  preselectedModuleId?: number;
}

export default function SessionForm({ studentId, preselectedModuleId }: SessionFormProps) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState({
    module_id: preselectedModuleId?.toString() ?? "1",
    date: new Date().toISOString().split("T")[0],
    duration_minutes: "75",
    tutor_notes: "",
    student_notes: "",
  });

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    const supabase = createClient();

    const { error } = await supabase.from("learning_sessions").insert({
      student_id: studentId,
      module_id: parseInt(form.module_id),
      date: form.date,
      duration_minutes: parseInt(form.duration_minutes),
      tutor_notes: form.tutor_notes || null,
      student_notes: form.student_notes || null,
    });

    setLoading(false);
    if (error) { toast.error(error.message); return; }
    toast.success("Session recorded!");
    router.refresh();
    router.back();
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="grid grid-cols-2 gap-4">
        <div>
          <label className="label">Module</label>
          <select
            className="input"
            value={form.module_id}
            onChange={(e) => setForm({ ...form, module_id: e.target.value })}
            required
          >
            {COURSE_MODULES.map((m) => (
              <option key={m.id} value={m.id}>{m.icon} Module {m.id} – {m.title}</option>
            ))}
          </select>
        </div>
        <div>
          <label className="label">Date</label>
          <input
            type="date" className="input" required
            value={form.date}
            onChange={(e) => setForm({ ...form, date: e.target.value })}
          />
        </div>
      </div>

      <div>
        <label className="label">Duration (minutes)</label>
        <input
          type="number" className="input" min="10" max="180" required
          value={form.duration_minutes}
          onChange={(e) => setForm({ ...form, duration_minutes: e.target.value })}
          placeholder="60–90 minutes"
        />
        <p className="text-xs text-slate-400 mt-1">Standard session: 60–90 minutes</p>
      </div>

      <div>
        <label className="label">Tutor Notes (optional)</label>
        <textarea
          className="input resize-none"
          rows={2}
          value={form.tutor_notes}
          onChange={(e) => setForm({ ...form, tutor_notes: e.target.value })}
          placeholder="What was covered, how the student performed..."
        />
      </div>

      <div>
        <label className="label">Student Notes (optional)</label>
        <textarea
          className="input resize-none"
          rows={2}
          value={form.student_notes}
          onChange={(e) => setForm({ ...form, student_notes: e.target.value })}
          placeholder="What I learned today, questions I have..."
        />
      </div>

      <button type="submit" className="btn-primary w-full" disabled={loading}>
        {loading ? "Saving..." : "Save Session Record"}
      </button>
    </form>
  );
}
