"use client";
import { useState, useEffect } from "react";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

interface Resource {
  id: string;
  course_module_id: string;
  resource_type: "video" | "pdf" | "doc" | "image" | "link";
  title: string;
  url: string;
  description: string | null;
  sort_order: number;
  created_at: string;
}

interface ResourcePanelProps {
  courseModuleId: string;
  currentUserRole: "tutor" | "student" | "parent" | "guardian";
}

const typeIcon: Record<string, string> = {
  video: "🎬",
  pdf: "📄",
  doc: "📝",
  image: "🖼️",
  link: "🔗",
};

const typeBadgeClass: Record<string, string> = {
  video: "badge-red",
  pdf: "badge-blue",
  doc: "badge-blue",
  image: "badge-green",
  link: "badge-gray",
};

const typeLabel: Record<string, string> = {
  video: "Video",
  pdf: "PDF",
  doc: "Document",
  image: "Image",
  link: "Link",
};

const urlPlaceholder: Record<string, string> = {
  video: "https://www.youtube.com/watch?v=... or embed URL",
  pdf: "https://example.com/file.pdf",
  doc: "https://example.com/document.docx",
  image: "https://example.com/image.png",
  link: "https://example.com",
};

function toEmbedUrl(url: string): string {
  // Convert YouTube watch URL to embed URL
  const watchMatch = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})/);
  if (watchMatch) {
    return `https://www.youtube.com/embed/${watchMatch[1]}`;
  }
  return url;
}

export default function ResourcePanel({ courseModuleId, currentUserRole }: ResourcePanelProps) {
  const supabase = createClient();
  const [resources, setResources] = useState<Resource[]>([]);
  const [loading, setLoading] = useState(true);

  // Add form state
  const [showAddForm, setShowAddForm] = useState(false);
  const [addType, setAddType] = useState<Resource["resource_type"]>("link");
  const [addTitle, setAddTitle] = useState("");
  const [addUrl, setAddUrl] = useState("");
  const [addDesc, setAddDesc] = useState("");
  const [adding, setAdding] = useState(false);

  // Image upload state
  const [imageFile, setImageFile] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);

  useEffect(() => {
    loadResources();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [courseModuleId]);

  async function loadResources() {
    setLoading(true);
    const { data, error } = await supabase
      .from("module_resources")
      .select("*")
      .eq("course_module_id", courseModuleId)
      .order("sort_order")
      .order("created_at");
    if (error) {
      toast.error("Failed to load resources");
    } else {
      setResources((data ?? []) as Resource[]);
    }
    setLoading(false);
  }

  async function handleAdd() {
    if (!addTitle.trim()) { toast.error("Title is required"); return; }

    let finalUrl = addUrl.trim();

    // ── Image: upload file to Supabase storage ───────────────────────────────
    if (addType === "image") {
      if (!imageFile && !finalUrl) { toast.error("Please upload an image or paste a URL"); return; }
      if (imageFile) {
        setAdding(true);
        const ext  = imageFile.name.split(".").pop() ?? "jpg";
        const path = `module-resources/${courseModuleId}/${Date.now()}.${ext}`;
        const { error: upErr } = await supabase.storage
          .from("module-resources")
          .upload(path, imageFile, { upsert: true });
        if (upErr) { toast.error("Image upload failed: " + upErr.message); setAdding(false); return; }
        const { data: urlData } = supabase.storage.from("module-resources").getPublicUrl(path);
        finalUrl = urlData.publicUrl;
      }
    } else {
      if (!finalUrl) { toast.error("URL is required"); return; }
    }

    setAdding(true);
    const maxOrder = resources.reduce((m, r) => Math.max(m, r.sort_order), 0);
    const { data, error } = await supabase
      .from("module_resources")
      .insert({
        course_module_id: courseModuleId,
        resource_type: addType,
        title: addTitle.trim(),
        url: finalUrl,
        description: addDesc.trim() || null,
        sort_order: maxOrder + 1,
      })
      .select()
      .single();
    setAdding(false);
    if (error) { toast.error(error.message); return; }
    setResources((prev) => [...prev, data as Resource]);
    setAddTitle(""); setAddUrl(""); setAddDesc("");
    setImageFile(null); setImagePreview(null);
    setShowAddForm(false);
    toast.success("Resource added!");
  }

  async function handleRemove(id: string) {
    const { error } = await supabase.from("module_resources").delete().eq("id", id);
    if (error) {
      toast.error(error.message);
      return;
    }
    setResources((prev) => prev.filter((r) => r.id !== id));
    toast.success("Resource removed");
  }

  function renderResource(resource: Resource) {
    const isTutor = currentUserRole === "tutor";

    if (resource.resource_type === "video") {
      const embedUrl = toEmbedUrl(resource.url);
      return (
        <div key={resource.id} className="card space-y-2">
          <div className="flex items-center justify-between gap-2">
            <div className="flex items-center gap-2 flex-wrap">
              <span className={typeBadgeClass[resource.resource_type]}>{typeIcon[resource.resource_type]} {typeLabel[resource.resource_type]}</span>
              <span className="font-medium text-slate-800 text-sm">{resource.title}</span>
            </div>
            {isTutor && (
              <button
                onClick={() => handleRemove(resource.id)}
                className="text-xs text-red-400 hover:text-red-600 transition-colors shrink-0"
              >
                Remove
              </button>
            )}
          </div>
          {resource.description && (
            <p className="text-xs text-slate-500">{resource.description}</p>
          )}
          <div className="relative w-full" style={{ paddingBottom: "56.25%" }}>
            <iframe
              src={embedUrl}
              title={resource.title}
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
              allowFullScreen
              className="absolute inset-0 w-full h-full rounded-xl border border-slate-100"
            />
          </div>
        </div>
      );
    }

    if (resource.resource_type === "image") {
      return (
        <div key={resource.id} className="card space-y-2">
          <div className="flex items-center justify-between gap-2">
            <div className="flex items-center gap-2 flex-wrap">
              <span className={typeBadgeClass[resource.resource_type]}>{typeIcon[resource.resource_type]} {typeLabel[resource.resource_type]}</span>
              <span className="font-medium text-slate-800 text-sm">{resource.title}</span>
            </div>
            {isTutor && (
              <div className="flex items-center gap-3">
                {/* Replace image button */}
                <label className="text-xs text-blue-400 hover:text-blue-600 cursor-pointer transition-colors">
                  Replace image
                  <input
                    type="file"
                    accept="image/*"
                    className="sr-only"
                    onChange={async (e) => {
                      const file = e.target.files?.[0];
                      if (!file) return;
                      const ext  = file.name.split(".").pop() ?? "jpg";
                      const path = `module-resources/${courseModuleId}/${Date.now()}.${ext}`;
                      const { error: upErr } = await supabase.storage
                        .from("module-resources")
                        .upload(path, file, { upsert: true });
                      if (upErr) { toast.error("Upload failed: " + upErr.message); return; }
                      const { data: urlData } = supabase.storage.from("module-resources").getPublicUrl(path);
                      const newUrl = urlData.publicUrl;
                      const { error } = await supabase
                        .from("module_resources")
                        .update({ url: newUrl })
                        .eq("id", resource.id);
                      if (error) { toast.error(error.message); return; }
                      setResources((prev) => prev.map((r) => r.id === resource.id ? { ...r, url: newUrl } : r));
                      toast.success("Image updated!");
                    }}
                  />
                </label>
                <button
                  onClick={() => handleRemove(resource.id)}
                  className="text-xs text-red-400 hover:text-red-600 transition-colors"
                >
                  Remove
                </button>
              </div>
            )}
          </div>
          {resource.description && (
            <p className="text-xs text-slate-500">{resource.description}</p>
          )}
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src={resource.url}
            alt={resource.title}
            className="rounded-xl w-full object-cover max-h-80 border border-slate-100"
            onError={(e) => {
              const el = e.currentTarget;
              el.style.display = "none";
              const placeholder = el.nextElementSibling as HTMLElement | null;
              if (placeholder) placeholder.style.removeProperty("display");
            }}
          />
          {/* placeholder — use inline style so JS can un-hide it (Tailwind hidden uses !important) */}
          <div
            style={{ display: "none" }}
            className="items-center justify-center rounded-xl w-full h-40 bg-slate-100 border border-slate-200 text-slate-400 text-sm gap-2 flex-col"
          >
            <span className="text-3xl">🖼️</span>
            <span>Image could not be loaded</span>
            {isTutor && <span className="text-xs">Use "Replace image" above to upload a new one</span>}
          </div>
        </div>
      );
    }

    // pdf, doc, link
    const thumbColors: Record<string, { bg: string; text: string; fold: string }> = {
      pdf:  { bg: "#3b9faa", text: "#ffffff", fold: "#2c7a84" },
      doc:  { bg: "#5b7fe8", text: "#ffffff", fold: "#3d5ec4" },
      link: { bg: "#64748b", text: "#ffffff", fold: "#475569" },
    };
    const thumb = thumbColors[resource.resource_type] ?? thumbColors.link;
    const label = typeLabel[resource.resource_type];

    return (
      <div key={resource.id} className="card flex items-center gap-4">
        {/* Document thumbnail */}
        <a href={resource.url} target="_blank" rel="noopener noreferrer" className="shrink-0">
          <svg width="52" height="64" viewBox="0 0 52 64" fill="none" xmlns="http://www.w3.org/2000/svg">
            {/* Page body */}
            <rect x="0" y="0" width="52" height="64" rx="5" fill={thumb.bg} />
            {/* Folded corner */}
            <path d="M36 0 L52 16 L36 16 Z" fill={thumb.fold} />
            <path d="M36 0 L52 16 L36 16 Z" fill="rgba(0,0,0,0.15)" />
            {/* Label text */}
            <text
              x="26" y="46"
              textAnchor="middle"
              fill={thumb.text}
              fontSize="13"
              fontWeight="700"
              fontFamily="system-ui, sans-serif"
              letterSpacing="1"
            >
              {label}
            </text>
          </svg>
        </a>

        <div className="flex-1 min-w-0">
          <p className="font-semibold text-slate-800 text-sm leading-tight">{resource.title}</p>
          {resource.description && (
            <p className="text-xs text-slate-500 mt-0.5">{resource.description}</p>
          )}
          <a
            href={resource.url}
            target="_blank"
            rel="noopener noreferrer"
            className="mt-1.5 inline-flex items-center gap-1 text-xs font-semibold text-teal-600 hover:text-teal-700 transition-colors"
          >
            Open ↗
          </a>
        </div>

        {isTutor && (
          <button
            onClick={() => handleRemove(resource.id)}
            className="text-xs text-red-400 hover:text-red-600 transition-colors shrink-0"
          >
            Remove
          </button>
        )}
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h2 className="font-semibold text-slate-700 flex items-center gap-2">
          <span>📎</span> Lesson Resources
        </h2>
        {currentUserRole === "tutor" && !showAddForm && (
          <button
            onClick={() => setShowAddForm(true)}
            className="btn-primary text-xs py-1.5 px-3"
          >
            + Add Resource
          </button>
        )}
      </div>

      {loading ? (
        <p className="text-sm text-slate-400">Loading resources…</p>
      ) : resources.length === 0 && !showAddForm ? (
        <div className="card text-center py-8">
          <p className="text-slate-400 text-sm">No resources yet.</p>
          {currentUserRole === "tutor" && (
            <button
              onClick={() => setShowAddForm(true)}
              className="mt-3 btn-primary text-xs py-1.5 px-3"
            >
              + Add First Resource
            </button>
          )}
        </div>
      ) : (
        <div className="space-y-3">
          {resources.map((r) => renderResource(r))}
        </div>
      )}

      {/* Add resource form (tutor only) */}
      {currentUserRole === "tutor" && showAddForm && (
        <div className="card space-y-3 border-indigo-100">
          <h3 className="font-semibold text-slate-700 text-sm">New Resource</h3>

          <div>
            <label className="label">Type</label>
            <select
              className="input"
              value={addType}
              onChange={(e) => setAddType(e.target.value as Resource["resource_type"])}
            >
              <option value="video">🎬 Video</option>
              <option value="pdf">📄 PDF</option>
              <option value="doc">📝 Document</option>
              <option value="image">🖼️ Image</option>
              <option value="link">🔗 Link</option>
            </select>
          </div>

          <div>
            <label className="label">Title</label>
            <input
              className="input"
              value={addTitle}
              onChange={(e) => setAddTitle(e.target.value)}
              placeholder="Resource title"
            />
          </div>

          {addType === "image" ? (
            <div className="space-y-2">
              <label className="label">Image</label>
              {/* File upload */}
              <label className="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed border-slate-200 rounded-xl cursor-pointer hover:border-teal-400 hover:bg-teal-50 transition-colors relative overflow-hidden">
                {imagePreview ? (
                  // eslint-disable-next-line @next/next/no-img-element
                  <img src={imagePreview} alt="preview" className="absolute inset-0 w-full h-full object-cover rounded-xl" />
                ) : (
                  <div className="flex flex-col items-center gap-1 text-slate-400">
                    <span className="text-2xl">🖼️</span>
                    <span className="text-xs">Click to upload image</span>
                    <span className="text-xs text-slate-300">JPG, PNG, GIF, WebP</span>
                  </div>
                )}
                <input
                  type="file"
                  accept="image/*"
                  className="sr-only"
                  onChange={(e) => {
                    const f = e.target.files?.[0];
                    if (!f) return;
                    setImageFile(f);
                    setImagePreview(URL.createObjectURL(f));
                    setAddUrl(""); // clear URL if file chosen
                  }}
                />
              </label>
              {imageFile && (
                <button
                  type="button"
                  onClick={() => { setImageFile(null); setImagePreview(null); }}
                  className="text-xs text-red-400 hover:text-red-600"
                >
                  ✕ Remove image
                </button>
              )}
              <p className="text-xs text-slate-400">— or paste a URL instead —</p>
              <input
                className="input"
                value={addUrl}
                onChange={(e) => { setAddUrl(e.target.value); if (e.target.value) { setImageFile(null); setImagePreview(null); } }}
                placeholder="https://example.com/image.jpg"
              />
            </div>
          ) : (
            <div>
              <label className="label">URL</label>
              <input
                className="input"
                value={addUrl}
                onChange={(e) => setAddUrl(e.target.value)}
                placeholder={urlPlaceholder[addType]}
              />
            </div>
          )}

          <div>
            <label className="label">Description (optional)</label>
            <textarea
              className="input resize-none"
              rows={2}
              value={addDesc}
              onChange={(e) => setAddDesc(e.target.value)}
              placeholder="Brief description…"
            />
          </div>

          <div className="flex gap-2 pt-1">
            <button
              type="button"
              onClick={handleAdd}
              disabled={adding}
              className="btn-primary text-sm"
            >
              {adding ? "Adding…" : "Add Resource"}
            </button>
            <button
              type="button"
              onClick={() => {
                setShowAddForm(false);
                setAddTitle(""); setAddUrl(""); setAddDesc("");
                setImageFile(null); setImagePreview(null);
              }}
              className="btn-secondary text-sm"
            >
              Cancel
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
