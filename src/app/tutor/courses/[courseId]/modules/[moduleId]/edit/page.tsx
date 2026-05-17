"use client";
import { useState, useEffect } from "react";
import { useRouter, useParams } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";
import ResourcePanel from "@/components/ResourcePanel";
import QuizBuilder from "@/components/QuizBuilder";

interface ChecklistItem {
  id: string;
  item_key: string;
  item_type: "student" | "teacher";
  label: string;
  sort_order: number;
}

interface CourseInfo {
  id: string;
  title: string;
}

export default function EditCourseModulePage() {
  const params = useParams();
  const router = useRouter();
  const courseId = params.courseId as string;
  const moduleId = params.moduleId as string;
  const supabase = createClient();

  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [course, setCourse] = useState<CourseInfo | null>(null);
  const [title, setTitle] = useState("");
  const [focus, setFocus] = useState("");
  const [icon, setIcon] = useState("📚");
  const [weekNumber, setWeekNumber] = useState<number | "">("");
  const [items, setItems] = useState<ChecklistItem[]>([]);
  const [newLabel, setNewLabel] = useState("");
  const [newType, setNewType] = useState<"student" | "teacher">("student");
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editingLabel, setEditingLabel] = useState("");

  useEffect(() => {
    loadData();
  }, [moduleId, courseId]);

  async function loadData() {
    const [{ data: courseData }, { data: modData }, { data: itemsData }] = await Promise.all([
      supabase.from("courses").select("id, title").eq("id", courseId).single(),
      supabase.from("course_modules").select("*").eq("id", moduleId).single(),
      supabase
        .from("module_checklist_items")
        .select("*")
        .eq("course_module_id", moduleId)
        .order("item_type")
        .order("sort_order"),
    ]);

    if (courseData) setCourse(courseData);
    if (modData) {
      setTitle(modData.title);
      setFocus(modData.focus ?? "");
      setIcon(modData.icon ?? "📚");
      setWeekNumber(modData.week_number ?? "");
    }
    if (itemsData) setItems(itemsData);
    setLoading(false);
  }

  async function handleSave(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    const { error } = await supabase.from("course_modules").update({
      title: title.trim(),
      focus: focus.trim() || null,
      icon: icon.trim() || "📚",
      week_number: weekNumber !== "" ? weekNumber : null,
    }).eq("id", moduleId);
    setSaving(false);
    if (error) { toast.error(error.message); return; }
    toast.success("Module updated!");
    router.push(`/tutor/courses/${courseId}`);
  }

  async function handleAddItem() {
    if (!newLabel.trim()) return;
    const maxOrder = items
      .filter((i) => i.item_type === newType)
      .reduce((m, i) => Math.max(m, i.sort_order), 0);
    const { data, error } = await supabase
      .from("module_checklist_items")
      .insert({
        course_module_id: moduleId,
        item_type: newType,
        item_key: `custom_${Date.now()}`,
        label: newLabel.trim(),
        sort_order: maxOrder + 1,
      })
      .select()
      .single();
    if (error) { toast.error(error.message); return; }
    setItems((prev) => [...prev, data]);
    setNewLabel("");
    toast.success("Item added!");
  }

  async function handleUpdateItem(id: string) {
    if (!editingLabel.trim()) return;
    const { error } = await supabase
      .from("module_checklist_items")
      .update({ label: editingLabel.trim() })
      .eq("id", id);
    if (error) { toast.error(error.message); return; }
    setItems((prev) => prev.map((i) => (i.id === id ? { ...i, label: editingLabel.trim() } : i)));
    setEditingId(null);
    toast.success("Item updated!");
  }

  async function handleDeleteItem(id: string) {
    const { error } = await supabase.from("module_checklist_items").delete().eq("id", id);
    if (error) { toast.error(error.message); return; }
    setItems((prev) => prev.filter((i) => i.id !== id));
    toast.success("Item removed");
  }

  const studentItems = items.filter((i) => i.item_type === "student");
  const teacherItems = items.filter((i) => i.item_type === "teacher");

  const renderItem = (item: ChecklistItem) => (
    <li key={item.id} className="flex items-center justify-between gap-2 bg-slate-50 rounded-lg px-3 py-2">
      {editingId === item.id ? (
        <div className="flex items-center gap-2 flex-1">
          <input
            className="input flex-1 py-1 text-sm"
            value={editingLabel}
            onChange={(e) => setEditingLabel(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") { e.preventDefault(); handleUpdateItem(item.id); }
              if (e.key === "Escape") setEditingId(null);
            }}
            autoFocus
          />
          <button onClick={() => handleUpdateItem(item.id)} className="btn-primary text-xs py-1 px-2">Save</button>
          <button onClick={() => setEditingId(null)} className="text-slate-400 text-xs">Cancel</button>
        </div>
      ) : (
        <>
          <span className="text-sm text-slate-700 flex-1">{item.label}</span>
          <div className="flex items-center gap-2 shrink-0">
            <button
              onClick={() => { setEditingId(item.id); setEditingLabel(item.label); }}
              className="text-blue-400 hover:text-blue-600 text-xs"
            >
              Edit
            </button>
            <button
              onClick={() => handleDeleteItem(item.id)}
              className="text-red-400 hover:text-red-600 text-xs"
            >
              Remove
            </button>
          </div>
        </>
      )}
    </li>
  );

  if (loading) {
    return (
      <div className="min-h-screen bg-slate-50 flex items-center justify-center">
        <p className="text-slate-400">Loading...</p>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-50">
      <nav className="bg-white border-b border-slate-100 sticky top-0 z-10">
        <div className="max-w-5xl mx-auto px-4 py-3">
          <span className="text-xl font-bold text-blue-600">📘 LMS Tutor</span>
        </div>
      </nav>

      <div className="max-w-5xl mx-auto px-4 py-8 space-y-8">
        <div className="flex items-center gap-2 text-sm text-slate-400 flex-wrap">
          <Link href="/tutor" className="hover:text-slate-600">Dashboard</Link>
          <span>›</span>
          <Link href="/tutor/courses" className="hover:text-slate-600">Courses</Link>
          <span>›</span>
          <Link href={`/tutor/courses/${courseId}`} className="hover:text-slate-600">
            {course?.title ?? "Course"}
          </Link>
          <span>›</span>
          <span className="text-slate-600">Edit Module</span>
        </div>

        <div className="flex items-center gap-3">
          <span className="text-3xl">{icon}</span>
          <div>
            {weekNumber !== "" && <span className="badge-blue text-xs">Week {weekNumber}</span>}
            <h1 className="text-xl font-bold text-slate-800 mt-1">Edit Module</h1>
          </div>
        </div>

        {/* Module Info Form */}
        <form onSubmit={handleSave} className="card space-y-4">
          <h2 className="font-semibold text-slate-700">Module Information</h2>
          <div className="flex gap-3">
            <div className="w-24">
              <label className="label">Icon</label>
              <input
                className="input text-2xl text-center"
                value={icon}
                onChange={(e) => setIcon(e.target.value)}
                maxLength={8}
              />
            </div>
            <div className="w-24">
              <label className="label">Week</label>
              <input
                className="input"
                type="number"
                min={1}
                value={weekNumber}
                onChange={(e) => setWeekNumber(e.target.value === "" ? "" : parseInt(e.target.value))}
                placeholder="1"
              />
            </div>
          </div>
          <div>
            <label className="label">Title</label>
            <input
              className="input"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="Module title"
              required
            />
          </div>
          <div>
            <label className="label">Focus / Description</label>
            <textarea
              className="input resize-none"
              rows={3}
              value={focus}
              onChange={(e) => setFocus(e.target.value)}
              placeholder="What this module covers..."
            />
          </div>
          <div className="flex gap-3">
            <button type="submit" className="btn-primary" disabled={saving}>
              {saving ? "Saving..." : "Save Changes"}
            </button>
            <Link href={`/tutor/courses/${courseId}`} className="btn-secondary">Cancel</Link>
          </div>
        </form>

        {/* Student Checklist Items */}
        <div className="card space-y-3">
          <div className="flex items-center justify-between">
            <h2 className="font-semibold text-slate-700">👤 Student Checklist</h2>
            <span className="badge-green text-xs">{studentItems.length} items</span>
          </div>
          {studentItems.length > 0 ? (
            <ul className="space-y-2">{studentItems.map(renderItem)}</ul>
          ) : (
            <p className="text-sm text-slate-400 italic">No student items yet.</p>
          )}
          <div className="flex gap-2 pt-1 border-t border-slate-100">
            <input
              className="input flex-1"
              value={newType === "student" ? newLabel : ""}
              onChange={(e) => { setNewType("student"); setNewLabel(e.target.value); }}
              onFocus={() => setNewType("student")}
              placeholder="Add student checklist item..."
              onKeyDown={(e) => {
                if (e.key === "Enter" && newType === "student") {
                  e.preventDefault();
                  handleAddItem();
                }
              }}
            />
            <button
              type="button"
              className="btn-primary shrink-0"
              onClick={() => { setNewType("student"); setTimeout(handleAddItem, 0); }}
            >
              Add
            </button>
          </div>
        </div>

        {/* Teacher Checklist Items */}
        <div className="card space-y-3">
          <div className="flex items-center justify-between">
            <h2 className="font-semibold text-slate-700">👩‍🏫 Teacher Checklist</h2>
            <span className="badge-blue text-xs">{teacherItems.length} items</span>
          </div>
          {teacherItems.length > 0 ? (
            <ul className="space-y-2">{teacherItems.map(renderItem)}</ul>
          ) : (
            <p className="text-sm text-slate-400 italic">No teacher items yet.</p>
          )}
          <div className="flex gap-2 pt-1 border-t border-slate-100">
            <input
              className="input flex-1"
              value={newType === "teacher" ? newLabel : ""}
              onChange={(e) => { setNewType("teacher"); setNewLabel(e.target.value); }}
              onFocus={() => setNewType("teacher")}
              placeholder="Add teacher checklist item..."
              onKeyDown={(e) => {
                if (e.key === "Enter" && newType === "teacher") {
                  e.preventDefault();
                  handleAddItem();
                }
              }}
            />
            <button
              type="button"
              className="btn-primary shrink-0"
              onClick={() => { setNewType("teacher"); setTimeout(handleAddItem, 0); }}
            >
              Add
            </button>
          </div>
        </div>

        {/* Lesson Resources */}
        <ResourcePanel courseModuleId={moduleId} currentUserRole="tutor" />

        {/* Quiz Builder */}
        <QuizBuilder courseModuleId={moduleId} />
      </div>
    </div>
  );
}
