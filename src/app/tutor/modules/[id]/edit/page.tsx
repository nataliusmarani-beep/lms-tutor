"use client";
import { useState, useEffect } from "react";
import { useRouter, useParams } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import { getModule } from "@/lib/course-data";
import toast from "react-hot-toast";

interface ChecklistItem {
  id: string;
  item_key: string;
  item_type: "student" | "teacher";
  label: string;
  sort_order: number;
}

export default function EditModulePage() {
  const params = useParams();
  const router = useRouter();
  const moduleId = parseInt(params.id as string);
  const mod = getModule(moduleId);

  const [loading, setLoading] = useState(false);
  const [title, setTitle] = useState("");
  const [focus, setFocus] = useState("");
  const [items, setItems] = useState<ChecklistItem[]>([]);
  const [newLabel, setNewLabel] = useState("");
  const [newType, setNewType] = useState<"student" | "teacher">("student");
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editingLabel, setEditingLabel] = useState("");

  const supabase = createClient();

  useEffect(() => {
    if (!mod) return;
    setTitle(mod.title);
    setFocus(mod.focus);
    loadData();
  }, [moduleId]);

  async function loadData() {
    const [{ data: custom }, { data: dbItems }] = await Promise.all([
      supabase.from("module_customizations").select("*").eq("module_id", moduleId).maybeSingle(),
      supabase.from("module_checklist_items").select("*").eq("module_id", moduleId).order("item_type").order("sort_order"),
    ]);
    if (custom) {
      if (custom.custom_title) setTitle(custom.custom_title);
      if (custom.custom_focus) setFocus(custom.custom_focus);
    }
    if (dbItems) setItems(dbItems);
  }

  async function handleSave(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    const { error } = await supabase.from("module_customizations").upsert({
      module_id: moduleId,
      custom_title: title,
      custom_focus: focus,
      updated_at: new Date().toISOString(),
    });
    setLoading(false);
    if (error) { toast.error(error.message); return; }
    toast.success("Module updated!");
    router.back();
  }

  async function handleAddItem() {
    if (!newLabel.trim()) return;
    const maxOrder = items.filter((i) => i.item_type === newType).reduce((m, i) => Math.max(m, i.sort_order), 0);
    const { data, error } = await supabase.from("module_checklist_items").insert({
      module_id: moduleId,
      item_type: newType,
      item_key: `custom_${Date.now()}`,
      label: newLabel.trim(),
      sort_order: maxOrder + 1,
    }).select().single();
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
    setItems((prev) => prev.map((i) => i.id === id ? { ...i, label: editingLabel.trim() } : i));
    setEditingId(null);
    toast.success("Item updated!");
  }

  async function handleDeleteItem(id: string) {
    const { error } = await supabase.from("module_checklist_items").delete().eq("id", id);
    if (error) { toast.error(error.message); return; }
    setItems((prev) => prev.filter((i) => i.id !== id));
    toast.success("Item removed");
  }

  if (!mod) return <div className="p-8 text-slate-500">Module not found.</div>;

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

  return (
    <div className="min-h-screen bg-slate-50">
      <nav className="bg-white border-b border-slate-100 sticky top-0 z-10">
        <div className="max-w-5xl mx-auto px-4 py-3 flex items-center justify-between">
          <span className="text-xl font-bold text-blue-600">📘 LMS Tutor</span>
        </div>
      </nav>

      <div className="max-w-5xl mx-auto px-4 py-8 space-y-8">
        <div className="flex items-center gap-2 text-sm text-slate-400">
          <Link href="/tutor" className="hover:text-slate-600">Dashboard</Link>
          <span>›</span>
          <span className="text-slate-600">Edit Module {moduleId}</span>
        </div>

        <div className="flex items-center gap-3">
          <span className="text-3xl">{mod.icon}</span>
          <div>
            <span className="badge-blue text-xs">Week {mod.week}</span>
            <h1 className="text-xl font-bold text-slate-800 mt-1">Edit Module {moduleId}</h1>
          </div>
        </div>

        {/* Module info */}
        <form onSubmit={handleSave} className="card space-y-4">
          <h2 className="font-semibold text-slate-700">Module Information</h2>
          <div>
            <label className="label">Title</label>
            <input
              className="input" value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="Module title"
            />
          </div>
          <div>
            <label className="label">Focus / Description</label>
            <textarea
              className="input resize-none" rows={3}
              value={focus}
              onChange={(e) => setFocus(e.target.value)}
              placeholder="What this module covers..."
            />
          </div>
          <div className="flex gap-3">
            <button type="submit" className="btn-primary" disabled={loading}>
              {loading ? "Saving..." : "Save Changes"}
            </button>
            <Link href="/tutor" className="btn-secondary">Cancel</Link>
          </div>
        </form>

        {/* Student checklist items */}
        <div className="card space-y-3">
          <div className="flex items-center justify-between">
            <h2 className="font-semibold text-slate-700">👤 Student Checklist</h2>
            <span className="badge-green text-xs">{studentItems.length} items</span>
          </div>
          {studentItems.length > 0 ? (
            <ul className="space-y-2">{studentItems.map(renderItem)}</ul>
          ) : (
            <p className="text-sm text-slate-400 italic">No items yet.</p>
          )}
          <div className="flex gap-2 pt-1 border-t border-slate-100">
            <input
              className="input flex-1"
              value={newType === "student" ? newLabel : ""}
              onChange={(e) => { setNewType("student"); setNewLabel(e.target.value); }}
              onFocus={() => setNewType("student")}
              placeholder="Add student checklist item..."
              onKeyDown={(e) => e.key === "Enter" && newType === "student" && (e.preventDefault(), handleAddItem())}
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

        {/* Teacher checklist items */}
        <div className="card space-y-3">
          <div className="flex items-center justify-between">
            <h2 className="font-semibold text-slate-700">👩‍🏫 Teacher Checklist</h2>
            <span className="badge-blue text-xs">{teacherItems.length} items</span>
          </div>
          {teacherItems.length > 0 ? (
            <ul className="space-y-2">{teacherItems.map(renderItem)}</ul>
          ) : (
            <p className="text-sm text-slate-400 italic">No items yet.</p>
          )}
          <div className="flex gap-2 pt-1 border-t border-slate-100">
            <input
              className="input flex-1"
              value={newType === "teacher" ? newLabel : ""}
              onChange={(e) => { setNewType("teacher"); setNewLabel(e.target.value); }}
              onFocus={() => setNewType("teacher")}
              placeholder="Add teacher checklist item..."
              onKeyDown={(e) => e.key === "Enter" && newType === "teacher" && (e.preventDefault(), handleAddItem())}
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
      </div>
    </div>
  );
}
