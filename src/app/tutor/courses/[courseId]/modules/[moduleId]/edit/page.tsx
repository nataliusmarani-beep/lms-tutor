"use client";
import { useState, useEffect } from "react";
import { useRouter, useParams } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";
import ResourcePanel from "@/components/ResourcePanel";
import QuizBuilder from "@/components/QuizBuilder";
import TranslateQuizButton from "@/components/TranslateQuizButton";
import { t } from "@/lib/i18n";
import type { Lang } from "@/lib/i18n";

import {
  DndContext,
  closestCenter,
  PointerSensor,
  useSensor,
  useSensors,
  DragEndEvent,
} from "@dnd-kit/core";
import {
  SortableContext,
  verticalListSortingStrategy,
  useSortable,
  arrayMove,
} from "@dnd-kit/sortable";
import { CSS } from "@dnd-kit/utilities";

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

// ─── Drag handle icon ────────────────────────────────────────────────────────
function GripIcon() {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="14"
      height="14"
      viewBox="0 0 24 24"
      fill="currentColor"
      className="text-slate-300 group-hover:text-slate-400 transition-colors"
    >
      <circle cx="9"  cy="5"  r="1.5" />
      <circle cx="15" cy="5"  r="1.5" />
      <circle cx="9"  cy="12" r="1.5" />
      <circle cx="15" cy="12" r="1.5" />
      <circle cx="9"  cy="19" r="1.5" />
      <circle cx="15" cy="19" r="1.5" />
    </svg>
  );
}

// ─── Single sortable checklist row ───────────────────────────────────────────
function SortableChecklistItem({
  item,
  editingId,
  editingLabel,
  onStartEdit,
  onEditChange,
  onSaveEdit,
  onCancelEdit,
  onDelete,
  lang,
}: {
  item: ChecklistItem;
  editingId: string | null;
  editingLabel: string;
  onStartEdit: (id: string, label: string) => void;
  onEditChange: (val: string) => void;
  onSaveEdit: (id: string) => void;
  onCancelEdit: () => void;
  onDelete: (id: string) => void;
  lang: Lang;
}) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging,
  } = useSortable({ id: item.id });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    opacity: isDragging ? 0.5 : 1,
    zIndex: isDragging ? 999 : undefined,
  };

  const isEditing = editingId === item.id;

  return (
    <li
      ref={setNodeRef}
      style={style}
      className="group flex items-center gap-2 bg-slate-50 rounded-lg px-3 py-2 border border-transparent hover:border-slate-200 transition-colors"
    >
      {/* Drag handle — only shown when not editing */}
      {!isEditing && (
        <button
          {...attributes}
          {...listeners}
          className="cursor-grab active:cursor-grabbing shrink-0 p-0.5 rounded hover:bg-slate-200 transition-colors touch-none"
          title="Drag to reorder"
          tabIndex={-1}
        >
          <GripIcon />
        </button>
      )}

      {isEditing ? (
        <div className="flex items-center gap-2 flex-1">
          <input
            className="input flex-1 py-1 text-sm"
            value={editingLabel}
            onChange={(e) => onEditChange(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") { e.preventDefault(); onSaveEdit(item.id); }
              if (e.key === "Escape") onCancelEdit();
            }}
            autoFocus
          />
          <button
            onClick={() => onSaveEdit(item.id)}
            className="btn-primary text-xs py-1 px-2"
          >
            {lang === "id" ? "Simpan" : "Save"}
          </button>
          <button
            onClick={onCancelEdit}
            className="text-slate-400 hover:text-slate-600 text-xs"
          >
            {t(lang, "cancel")}
          </button>
        </div>
      ) : (
        <>
          <span className="text-sm text-slate-700 flex-1">{item.label}</span>
          <div className="flex items-center gap-2 shrink-0">
            <button
              onClick={() => onStartEdit(item.id, item.label)}
              className="text-blue-400 hover:text-blue-600 text-xs"
            >
              {t(lang, "edit")}
            </button>
            <button
              onClick={() => onDelete(item.id)}
              className="text-red-400 hover:text-red-600 text-xs"
            >
              {t(lang, "remove")}
            </button>
          </div>
        </>
      )}
    </li>
  );
}

// ─── Main page ────────────────────────────────────────────────────────────────
export default function EditCourseModulePage() {
  const params = useParams();
  const router = useRouter();
  const courseId = params.courseId as string;
  const moduleId = params.moduleId as string;
  const supabase = createClient();

  const [loading, setLoading]       = useState(true);
  const [saving, setSaving]         = useState(false);
  const [course, setCourse]         = useState<CourseInfo | null>(null);
  const [lang, setLang]             = useState<Lang>("en");
  const [title, setTitle]           = useState("");
  const [focus, setFocus]           = useState("");
  const [icon, setIcon]             = useState("📚");
  const [weekNumber, setWeekNumber] = useState<number | "">("");
  const [items, setItems]           = useState<ChecklistItem[]>([]);
  const [newLabel, setNewLabel]     = useState("");
  const [newType, setNewType]       = useState<"student" | "teacher">("student");
  const [editingId, setEditingId]   = useState<string | null>(null);
  const [editingLabel, setEditingLabel] = useState("");

  // dnd-kit sensors (supports both mouse and touch)
  const sensors = useSensors(
    useSensor(PointerSensor, { activationConstraint: { distance: 5 } })
  );

  useEffect(() => {
    const m = document.cookie.match(/(?:^|;\s*)lang=([^;]*)/);
    setLang(m?.[1] === "id" ? "id" : "en");
  }, []);

  useEffect(() => { loadData(); }, [moduleId, courseId]);

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
    const typeItems = items.filter((i) => i.item_type === newType);
    const maxOrder  = typeItems.reduce((m, i) => Math.max(m, i.sort_order), -1);
    const { data, error } = await supabase
      .from("module_checklist_items")
      .insert({
        course_module_id: moduleId,
        item_type:  newType,
        item_key:   `custom_${Date.now()}`,
        label:      newLabel.trim(),
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

  // ── Drag end handler ────────────────────────────────────────────────────────
  async function handleDragEnd(event: DragEndEvent, itemType: "student" | "teacher") {
    const { active, over } = event;
    if (!over || active.id === over.id) return;

    setItems((prev) => {
      // Separate the two lists; only reorder within the same type
      const others = prev.filter((i) => i.item_type !== itemType);
      const typed  = prev.filter((i) => i.item_type === itemType);

      const oldIndex = typed.findIndex((i) => i.id === active.id);
      const newIndex = typed.findIndex((i) => i.id === over.id);
      if (oldIndex === -1 || newIndex === -1) return prev;

      const reordered = arrayMove(typed, oldIndex, newIndex).map((item, idx) => ({
        ...item,
        sort_order: idx,
      }));

      // Persist to DB (fire-and-forget with toast on error)
      Promise.all(
        reordered.map((item) =>
          supabase
            .from("module_checklist_items")
            .update({ sort_order: item.sort_order })
            .eq("id", item.id)
        )
      ).then((results) => {
        const failed = results.find((r) => r.error);
        if (failed?.error) toast.error("Failed to save order");
      });

      return [...others, ...reordered];
    });
  }

  const studentItems = items.filter((i) => i.item_type === "student");
  const teacherItems = items.filter((i) => i.item_type === "teacher");

  const renderChecklist = (
    listItems: ChecklistItem[],
    itemType: "student" | "teacher"
  ) => (
    <DndContext
      sensors={sensors}
      collisionDetection={closestCenter}
      onDragEnd={(e) => handleDragEnd(e, itemType)}
    >
      <SortableContext
        items={listItems.map((i) => i.id)}
        strategy={verticalListSortingStrategy}
      >
        <ul className="space-y-2">
          {listItems.map((item) => (
            <SortableChecklistItem
              key={item.id}
              item={item}
              editingId={editingId}
              editingLabel={editingLabel}
              onStartEdit={(id, label) => { setEditingId(id); setEditingLabel(label); }}
              onEditChange={setEditingLabel}
              onSaveEdit={handleUpdateItem}
              onCancelEdit={() => setEditingId(null)}
              onDelete={handleDeleteItem}
              lang={lang}
            />
          ))}
        </ul>
      </SortableContext>
    </DndContext>
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
        {/* Breadcrumb */}
        <div className="flex items-center gap-2 text-sm text-slate-400 flex-wrap">
          <Link href="/tutor" className="hover:text-slate-600">{t(lang, "dashboard").replace("← ", "")}</Link>
          <span>›</span>
          <Link href="/tutor/courses" className="hover:text-slate-600">{t(lang, "courses")}</Link>
          <span>›</span>
          <Link href={`/tutor/courses/${courseId}`} className="hover:text-slate-600">
            {course?.title ?? t(lang, "courses")}
          </Link>
          <span>›</span>
          <span className="text-slate-600">{t(lang, "editModule")}</span>
        </div>

        {/* Page title */}
        <div className="flex items-center gap-3">
          <span className="text-3xl">{icon}</span>
          <div>
            {weekNumber !== "" && (
              <span className="badge-blue text-xs">{t(lang, "week")} {weekNumber}</span>
            )}
            <h1 className="text-xl font-bold text-slate-800 mt-1">{t(lang, "editModule")}</h1>
          </div>
        </div>

        {/* Module Info Form */}
        <form onSubmit={handleSave} className="card space-y-4">
          <h2 className="font-semibold text-slate-700">{t(lang, "moduleInformation")}</h2>
          <div className="flex gap-3">
            <div className="w-24">
              <label className="label">{lang === "id" ? "Ikon" : "Icon"}</label>
              <input
                className="input text-2xl text-center"
                value={icon}
                onChange={(e) => setIcon(e.target.value)}
                maxLength={8}
              />
            </div>
            <div className="w-24">
              <label className="label">{t(lang, "week")}</label>
              <input
                className="input"
                type="number"
                min={1}
                value={weekNumber}
                onChange={(e) =>
                  setWeekNumber(e.target.value === "" ? "" : parseInt(e.target.value))
                }
                placeholder="1"
              />
            </div>
          </div>
          <div>
            <label className="label">{lang === "id" ? "Judul" : "Title"}</label>
            <input
              className="input"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder={lang === "id" ? "Judul modul" : "Module title"}
              required
            />
          </div>
          <div>
            <label className="label">{t(lang, "focusDescription")}</label>
            <textarea
              className="input resize-none"
              rows={3}
              value={focus}
              onChange={(e) => setFocus(e.target.value)}
              placeholder={
                lang === "id" ? "Apa yang dicakup modul ini..." : "What this module covers..."
              }
            />
          </div>
          <div className="flex gap-3">
            <button type="submit" className="btn-primary" disabled={saving}>
              {saving ? t(lang, "saving") : t(lang, "saveChanges")}
            </button>
            <Link href={`/tutor/courses/${courseId}`} className="btn-secondary">
              {t(lang, "cancel")}
            </Link>
          </div>
        </form>

        {/* Student Checklist */}
        <div className="card space-y-3">
          <div className="flex items-center justify-between">
            <h2 className="font-semibold text-slate-700">👤 {t(lang, "studentChecklist")}</h2>
            <div className="flex items-center gap-2">
              <span className="text-xs text-slate-400 italic">
                {lang === "id" ? "Seret untuk urutkan ulang" : "Drag to reorder"}
              </span>
              <span className="badge-green text-xs">{studentItems.length} {t(lang, "items")}</span>
            </div>
          </div>

          {studentItems.length > 0
            ? renderChecklist(studentItems, "student")
            : <p className="text-sm text-slate-400 italic">{t(lang, "noStudentItemsYet")}</p>
          }

          {/* Add student item */}
          <div className="flex gap-2 pt-1 border-t border-slate-100">
            <input
              className="input flex-1"
              value={newType === "student" ? newLabel : ""}
              onChange={(e) => { setNewType("student"); setNewLabel(e.target.value); }}
              onFocus={() => setNewType("student")}
              placeholder={t(lang, "addStudentItem")}
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
              {t(lang, "add")}
            </button>
          </div>
        </div>

        {/* Teacher Checklist */}
        <div className="card space-y-3">
          <div className="flex items-center justify-between">
            <h2 className="font-semibold text-slate-700">👩‍🏫 {t(lang, "teacherChecklistLabel")}</h2>
            <div className="flex items-center gap-2">
              <span className="text-xs text-slate-400 italic">
                {lang === "id" ? "Seret untuk urutkan ulang" : "Drag to reorder"}
              </span>
              <span className="badge-blue text-xs">{teacherItems.length} {t(lang, "items")}</span>
            </div>
          </div>

          {teacherItems.length > 0
            ? renderChecklist(teacherItems, "teacher")
            : <p className="text-sm text-slate-400 italic">{t(lang, "noTeacherItemsYet")}</p>
          }

          {/* Add teacher item */}
          <div className="flex gap-2 pt-1 border-t border-slate-100">
            <input
              className="input flex-1"
              value={newType === "teacher" ? newLabel : ""}
              onChange={(e) => { setNewType("teacher"); setNewLabel(e.target.value); }}
              onFocus={() => setNewType("teacher")}
              placeholder={t(lang, "addTeacherItem")}
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
              {t(lang, "add")}
            </button>
          </div>
        </div>

        {/* Lesson Resources */}
        <ResourcePanel courseModuleId={moduleId} currentUserRole="tutor" />

        {/* Quiz Builder */}
        <div className="space-y-3">
          <QuizBuilder courseModuleId={moduleId} />
          <div className="flex justify-end">
            <TranslateQuizButton moduleId={moduleId} />
          </div>
        </div>
      </div>
    </div>
  );
}
