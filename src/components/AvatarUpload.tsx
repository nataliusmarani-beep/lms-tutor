"use client";
import { useRef, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

interface Props {
  studentId: string;
  currentUrl: string | null;
  studentName: string;
}

export default function AvatarUpload({ studentId, currentUrl, studentName }: Props) {
  const [url, setUrl] = useState<string | null>(currentUrl);
  const [uploading, setUploading] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  async function handleFile(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    if (file.size > 2 * 1024 * 1024) { toast.error("Image must be under 2MB"); return; }

    setUploading(true);
    const supabase = createClient();
    const ext = file.name.split(".").pop();
    const path = `${studentId}.${ext}`;

    const { error: uploadError } = await supabase.storage
      .from("avatars")
      .upload(path, file, { upsert: true });

    if (uploadError) { toast.error(uploadError.message); setUploading(false); return; }

    const { data } = supabase.storage.from("avatars").getPublicUrl(path);
    const publicUrl = `${data.publicUrl}?t=${Date.now()}`;

    const { error: updateError } = await supabase
      .from("profiles")
      .update({ avatar_url: publicUrl })
      .eq("id", studentId);

    if (updateError) { toast.error(updateError.message); setUploading(false); return; }

    setUrl(publicUrl);
    setUploading(false);
    toast.success("Photo updated!");
  }

  return (
    <div className="flex flex-col items-center gap-2">
      <div
        className="w-20 h-20 rounded-full overflow-hidden bg-blue-100 flex items-center justify-center cursor-pointer ring-2 ring-offset-2 ring-blue-200 hover:ring-blue-400 transition-all"
        onClick={() => inputRef.current?.click()}
        title="Click to update photo"
      >
        {url ? (
          <img src={url} alt={studentName} className="w-full h-full object-cover" />
        ) : (
          <span className="text-3xl font-bold text-blue-700">{studentName[0]?.toUpperCase()}</span>
        )}
      </div>
      <button
        type="button"
        onClick={() => inputRef.current?.click()}
        disabled={uploading}
        className="text-xs text-blue-500 hover:text-blue-700"
      >
        {uploading ? "Uploading..." : "Update photo"}
      </button>
      <input
        ref={inputRef}
        type="file"
        accept="image/*"
        className="hidden"
        onChange={handleFile}
      />
    </div>
  );
}
