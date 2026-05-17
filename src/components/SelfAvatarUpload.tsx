"use client";
import { useRef, useState } from "react";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

interface Props {
  userId: string;
  currentUrl: string | null;
  name: string;
}

export default function SelfAvatarUpload({ userId, currentUrl, name }: Props) {
  const [url, setUrl] = useState<string | null>(currentUrl);
  const [uploading, setUploading] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  async function handleFile(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    if (file.size > 2 * 1024 * 1024) { toast.error("Image must be under 2 MB"); return; }

    setUploading(true);
    const supabase = createClient();
    const ext = file.name.split(".").pop();
    const path = `${userId}.${ext}`;

    const { error: uploadError } = await supabase.storage
      .from("avatars")
      .upload(path, file, { upsert: true });

    if (uploadError) { toast.error(uploadError.message); setUploading(false); return; }

    const { data } = supabase.storage.from("avatars").getPublicUrl(path);
    const publicUrl = `${data.publicUrl}?t=${Date.now()}`;

    const { error: updateError } = await supabase
      .from("profiles")
      .update({ avatar_url: publicUrl })
      .eq("id", userId);

    if (updateError) { toast.error(updateError.message); setUploading(false); return; }

    setUrl(publicUrl);
    setUploading(false);
    toast.success("Photo updated!");
  }

  const initials = name.split(" ").map((n) => n[0]).join("").slice(0, 2).toUpperCase();

  return (
    <div className="flex flex-col items-center gap-3">
      <div
        className="w-24 h-24 rounded-full overflow-hidden bg-teal-500 flex items-center justify-center cursor-pointer ring-4 ring-offset-2 ring-teal-200 hover:ring-teal-400 transition-all"
        onClick={() => inputRef.current?.click()}
        title="Click to update photo"
      >
        {url ? (
          <img src={url} alt={name} className="w-full h-full object-cover" />
        ) : (
          <span className="text-3xl font-bold text-white">{initials}</span>
        )}
      </div>
      <button
        type="button"
        onClick={() => inputRef.current?.click()}
        disabled={uploading}
        className="btn-primary text-sm py-1.5 px-4 disabled:opacity-50"
      >
        {uploading ? "Uploading…" : "Change Photo"}
      </button>
      <input ref={inputRef} type="file" accept="image/*" className="hidden" onChange={handleFile} />
    </div>
  );
}
