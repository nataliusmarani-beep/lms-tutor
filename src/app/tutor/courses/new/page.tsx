"use client";
import { useRef, useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";
import { t } from "@/lib/i18n";
import type { Lang } from "@/lib/i18n";

export default function NewCoursePage() {
  const router  = useRouter();
  const fileRef = useRef<HTMLInputElement>(null);

  const [iconFile,    setIconFile]    = useState<File | null>(null);
  const [iconPreview, setIconPreview] = useState<string | null>(null);
  const [title,       setTitle]       = useState("");
  const [description, setDescription] = useState("");
  const [loading,     setLoading]     = useState(false);
  const [lang, setLang] = useState<Lang>("en");
  useEffect(() => {
    const m = document.cookie.match(/(?:^|;\s*)lang=([^;]*)/);
    setLang(m?.[1] === "id" ? "id" : "en");
  }, []);

  function handleIconFile(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    if (file.size > 2 * 1024 * 1024) { toast.error("Image must be under 2 MB"); return; }
    if (iconPreview) URL.revokeObjectURL(iconPreview);
    setIconFile(file);
    setIconPreview(URL.createObjectURL(file));
  }

  function removeIconImage() {
    setIconFile(null);
    if (iconPreview) URL.revokeObjectURL(iconPreview);
    setIconPreview(null);
    if (fileRef.current) fileRef.current.value = "";
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!title.trim()) { toast.error("Title is required"); return; }
    setLoading(true);

    const supabase = createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) { toast.error("Not authenticated"); setLoading(false); return; }

    const { data, error } = await supabase
      .from("courses")
      .insert({
        title: title.trim(),
        description: description.trim() || null,
        icon: "📚",
        created_by: user.id,
      })
      .select()
      .single();

    if (error) { toast.error(error.message); setLoading(false); return; }

    if (iconFile && data) {
      const ext  = iconFile.name.split(".").pop();
      const path = `${data.id}.${ext}`;
      const { error: upErr } = await supabase.storage
        .from("course-icons").upload(path, iconFile, { upsert: true });
      if (!upErr) {
        const { data: urlData } = supabase.storage.from("course-icons").getPublicUrl(path);
        await supabase.from("courses").update({ icon_url: urlData.publicUrl }).eq("id", data.id);
      }
    }

    setLoading(false);
    toast.success("Course created!");
    router.push(`/tutor/courses/${data.id}`);
  }

  return (
    <div className="min-h-screen">
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-6">
        <div className="flex items-center gap-2 text-sm text-slate-400">
          <Link href="/tutor" className="hover:text-slate-600">{t(lang, "dashboard").replace("← ", "")}</Link>
          <span>›</span>
          <Link href="/tutor/courses" className="hover:text-slate-600">{t(lang, "courses")}</Link>
          <span>›</span>
          <span className="text-slate-600">{t(lang, "createNewCourse")}</span>
        </div>

        <h1 className="text-2xl font-bold text-slate-800">{t(lang, "createNewCourse")}</h1>

        <form onSubmit={handleSubmit} className="card space-y-5">

          <div>
            <label className="label">{t(lang, "courseIconImage")}</label>
            <div className="flex items-center gap-4">
              <div
                className="w-16 h-16 rounded-2xl overflow-hidden bg-slate-100 flex items-center justify-center shrink-0 border-2 border-dashed border-slate-300 cursor-pointer hover:border-teal-400 transition-colors"
                onClick={() => fileRef.current?.click()}
              >
                {iconPreview ? (
                  <img src={iconPreview} alt="icon" className="w-full h-full object-cover" />
                ) : (
                  <span className="text-2xl text-slate-400">🖼️</span>
                )}
              </div>
              <div className="space-y-1">
                <div className="flex items-center gap-2">
                  <button type="button" onClick={() => fileRef.current?.click()} className="btn-secondary text-xs py-1.5 px-3">
                    {iconPreview ? (lang === "id" ? "Ganti" : "Replace") : (lang === "id" ? "Upload Gambar" : "Upload Image")}
                  </button>
                  {iconPreview && (
                    <button type="button" onClick={removeIconImage} className="text-xs text-red-500 hover:text-red-700">{t(lang, "remove")}</button>
                  )}
                </div>
                <p className="text-xs text-slate-400">PNG or JPG, max 2 MB</p>
              </div>
            </div>
            <input ref={fileRef} type="file" accept="image/*" className="hidden" onChange={handleIconFile} />
          </div>

          <div>
            <label className="label">{lang === "id" ? "Judul *" : "Title *"}</label>
            <input className="input" value={title} onChange={(e) => setTitle(e.target.value)}
              placeholder="e.g. Microsoft Apps Fundamental to Advance" required />
          </div>

          <div>
            <label className="label">{lang === "id" ? "Deskripsi" : "Description"}</label>
            <textarea className="input resize-none" rows={3} value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder={lang === "id" ? "Apa yang akan dipelajari siswa?" : "What will students learn in this course?"} />
          </div>

          <div className="flex gap-3 pt-2">
            <button type="submit" className="btn-primary" disabled={loading}>
              {loading ? (lang === "id" ? "Membuat…" : "Creating…") : (lang === "id" ? "Buat Kursus" : "Create Course")}
            </button>
            <Link href="/tutor/courses" className="btn-secondary">{t(lang, "cancel")}</Link>
          </div>
        </form>
      </div>
    </div>
  );
}
