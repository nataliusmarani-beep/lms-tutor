"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

export default function NewCoursePage() {
  const router = useRouter();
  const supabase = createClient();

  const [icon, setIcon] = useState("📚");
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!title.trim()) { toast.error("Title is required"); return; }

    setLoading(true);
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) { toast.error("Not authenticated"); setLoading(false); return; }

    const { data, error } = await supabase
      .from("courses")
      .insert({
        title: title.trim(),
        description: description.trim() || null,
        icon: icon.trim() || "📚",
        created_by: user.id,
      })
      .select()
      .single();

    setLoading(false);

    if (error) {
      toast.error(error.message);
      return;
    }

    toast.success("Course created!");
    router.push(`/tutor/courses/${data.id}`);
  }

  return (
    <div className="min-h-screen bg-slate-50">
      <nav className="bg-white border-b border-slate-100 sticky top-0 z-10">
        <div className="max-w-3xl mx-auto px-4 py-3">
          <span className="text-xl font-bold text-blue-600">📘 LMS Tutor</span>
        </div>
      </nav>

      <div className="max-w-xl mx-auto px-4 py-8 space-y-6">
        <div className="flex items-center gap-2 text-sm text-slate-400">
          <Link href="/tutor" className="hover:text-slate-600">Dashboard</Link>
          <span>›</span>
          <Link href="/tutor/courses" className="hover:text-slate-600">Courses</Link>
          <span>›</span>
          <span className="text-slate-600">New Course</span>
        </div>

        <h1 className="text-2xl font-bold text-slate-800">Create New Course</h1>

        <form onSubmit={handleSubmit} className="card space-y-4">
          <div>
            <label className="label">Icon</label>
            <input
              className="input w-24 text-2xl"
              value={icon}
              onChange={(e) => setIcon(e.target.value)}
              placeholder="📚"
              maxLength={8}
            />
            <p className="text-xs text-slate-400 mt-1">Paste an emoji</p>
          </div>

          <div>
            <label className="label">Title *</label>
            <input
              className="input"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="e.g. Microsoft App Course"
              required
            />
          </div>

          <div>
            <label className="label">Description</label>
            <textarea
              className="input resize-none"
              rows={3}
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="What will students learn in this course?"
            />
          </div>

          <div className="flex gap-3 pt-2">
            <button type="submit" className="btn-primary" disabled={loading}>
              {loading ? "Creating..." : "Create Course"}
            </button>
            <Link href="/tutor/courses" className="btn-secondary">Cancel</Link>
          </div>
        </form>
      </div>
    </div>
  );
}
