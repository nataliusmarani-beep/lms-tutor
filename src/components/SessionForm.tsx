"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

interface Props {
  studentId: string;
  preselectedCourseModuleId?: string;
  modules: {
    id: string;
    title: string;
    icon: string;
    week_number: number | null;
    legacy_module_id: number | null;
  }[];
}

export default function SessionForm({ studentId, preselectedCourseModuleId, modules }: Props) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState({
    course_module_id: preselectedCourseModuleId ?? modules[0]?.id ?? "",
    date: new Date().toISOString().split("T")[0],
    duration_minutes: "75",
    tutor_notes: "",
    student_notes: "",
  });

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    const supabase = createClient();

    const selectedModule = modules.find((m) => m.id === form.course_module_id);
    const { error } = await supabase.from("learning_sessions").insert({
      student_id: studentId,
      course_module_id: form.course_module_id || null,
      module_id: selectedModule?.legacy_module_id ?? null,
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
          <label className="label">Duration (minutes)</label>
          <input
            type="number" className="input" min="10" max="180" required
            value={form.duration_minutes}
            onChange={(e) => setForm({ ...form, duration_minutes: e.target.value })}
            placeholder="60–90 minutes"
          />
        </div>
      </div>

      <div>
        <label className="label">Tutor Notes (optional)</label>
        <textarea
          className="input resize-none" rows={2}
          value={form.tutor_notes}
          onChange={(e) => setForm({ ...form, tutor_notes: e.target.value })}
          placeholder="What was covered, how the student performed..."
        />
      </div>

      <div>
        <label className="label">Student Notes (optional)</label>
        <textarea
          className="input resize-none" rows={2}
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
