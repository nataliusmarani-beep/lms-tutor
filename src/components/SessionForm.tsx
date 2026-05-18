"use client";
import { useRef, useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

interface Props {
  studentId: string;
  preselectedCourseModuleId?: string;
  courses: { id: string; title: string; icon: string }[];
  modules: {
    id: string;
    title: string;
    icon: string;
    week_number: number | null;
    course_id: string;
    legacy_module_id: number | null;
  }[];
}

async function compressToThumbnail(file: File): Promise<Blob> {
  return new Promise((resolve, reject) => {
    const img = new Image();
    const objectUrl = URL.createObjectURL(file);

    img.onload = () => {
      const MAX = 480;
      let w = img.width;
      let h = img.height;
      if (w > MAX || h > MAX) {
        if (w >= h) { h = Math.round((h * MAX) / w); w = MAX; }
        else         { w = Math.round((w * MAX) / h); h = MAX; }
      }

      const canvas = document.createElement("canvas");
      canvas.width  = w;
      canvas.height = h;
      canvas.getContext("2d")!.drawImage(img, 0, 0, w, h);
      URL.revokeObjectURL(objectUrl);

      // Reduce JPEG quality until blob ≤ 100 KB
      let quality = 0.85;
      function attempt() {
        canvas.toBlob((blob) => {
          if (!blob) { reject(new Error("Compression failed")); return; }
          if (blob.size <= 100 * 1024 || quality <= 0.05) {
            resolve(blob);
          } else {
            quality = Math.max(0.05, quality - 0.1);
            attempt();
          }
        }, "image/jpeg", quality);
      }
      attempt();
    };

    img.onerror = () => { URL.revokeObjectURL(objectUrl); reject(new Error("Image load failed")); };
    img.src = objectUrl;
  });
}

export default function SessionForm({ studentId, preselectedCourseModuleId, courses, modules }: Props) {
  const router   = useRouter();
  const fileRef  = useRef<HTMLInputElement>(null);
  const [loading,      setLoading]      = useState(false);
  const [photoFile,    setPhotoFile]    = useState<File | null>(null);
  const [photoPreview, setPhotoPreview] = useState<string | null>(null);
  const [compressing,  setCompressing]  = useState(false);
  const [form, setForm] = useState({
    course_module_id: preselectedCourseModuleId ?? modules[0]?.id ?? "",
    date:             new Date().toISOString().split("T")[0],
    duration_minutes: "90",
    tutor_notes:      "",
    student_notes:    "",
  });

  async function handlePhotoChange(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    setCompressing(true);
    try {
      const blob = await compressToThumbnail(file);
      const compressed = new File([blob], "photo.jpg", { type: "image/jpeg" });
      setPhotoFile(compressed);
      setPhotoPreview(URL.createObjectURL(blob));
      toast.success(`Photo ready — ${Math.round(blob.size / 1024)} KB`);
    } catch {
      toast.error("Could not process image");
    }
    setCompressing(false);
  }

  function removePhoto() {
    setPhotoFile(null);
    if (photoPreview) URL.revokeObjectURL(photoPreview);
    setPhotoPreview(null);
    if (fileRef.current) fileRef.current.value = "";
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    const supabase = createClient();

    let photo_url: string | null = null;

    if (photoFile) {
      const path = `${studentId}/${Date.now()}.jpg`;
      const { error: upErr } = await supabase.storage
        .from("session-photos")
        .upload(path, photoFile, { upsert: false });
      if (upErr) {
        toast.error("Photo upload failed: " + upErr.message);
        setLoading(false);
        return;
      }
      const { data } = supabase.storage.from("session-photos").getPublicUrl(path);
      photo_url = data.publicUrl;
    }

    const selectedModule = modules.find((m) => m.id === form.course_module_id);
    const { error } = await supabase.from("learning_sessions").insert({
      student_id:        studentId,
      course_module_id:  form.course_module_id || null,
      module_id:         selectedModule?.legacy_module_id ?? null,
      date:              form.date,
      duration_minutes:  parseInt(form.duration_minutes),
      tutor_notes:       form.tutor_notes  || null,
      student_notes:     form.student_notes || null,
      photo_url,
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
        <label className="label">Course &amp; Module</label>
        <select
          className="input"
          value={form.course_module_id}
          onChange={(e) => setForm({ ...form, course_module_id: e.target.value })}
        >
          <option value="">— No module —</option>
          {courses.map((course) => {
            const courseModules = modules.filter((m) => m.course_id === course.id);
            if (courseModules.length === 0) return null;
            return (
              <optgroup key={course.id} label={`${course.icon} ${course.title}`}>
                {courseModules.map((m) => (
                  <option key={m.id} value={m.id}>
                    {m.icon} {m.week_number ? `Week ${m.week_number} – ` : ""}{m.title}
                  </option>
                ))}
              </optgroup>
            );
          })}
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

      {/* Photo documentation */}
      <div>
        <label className="label">Photo Documentation (optional)</label>
        {photoPreview ? (
          <div className="relative inline-block">
            <img
              src={photoPreview}
              alt="Session photo"
              className="w-full max-w-xs rounded-xl border border-slate-200 object-cover"
            />
            <button
              type="button"
              onClick={removePhoto}
              className="absolute top-2 right-2 w-7 h-7 bg-red-500 text-white rounded-full flex items-center justify-center text-sm hover:bg-red-600 transition-colors"
            >
              ✕
            </button>
            <div className="mt-1 text-xs text-slate-400 text-center">
              {photoFile && `${Math.round(photoFile.size / 1024)} KB`}
            </div>
          </div>
        ) : (
          <button
            type="button"
            onClick={() => fileRef.current?.click()}
            disabled={compressing}
            className="w-full border-2 border-dashed border-slate-200 rounded-xl p-6 flex flex-col items-center gap-2 text-slate-400 hover:border-teal-400 hover:text-teal-500 transition-colors disabled:opacity-50"
          >
            <span className="text-3xl">📷</span>
            <span className="text-sm font-medium">
              {compressing ? "Compressing…" : "Click to add photo"}
            </span>
            <span className="text-xs">Auto-compressed to ≤ 100 KB</span>
          </button>
        )}
        <input
          ref={fileRef}
          type="file"
          accept="image/*"
          capture="environment"
          className="hidden"
          onChange={handlePhotoChange}
        />
      </div>

      <button type="submit" className="btn-primary w-full" disabled={loading || compressing}>
        {loading ? "Saving…" : "Save Session Record"}
      </button>
    </form>
  );
}
