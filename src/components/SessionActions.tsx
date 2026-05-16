"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

interface Props {
  sessionId: string;
}

export default function SessionActions({ sessionId }: Props) {
  const router = useRouter();
  const [deleting, setDeleting] = useState(false);

  async function handleDelete() {
    if (!confirm("Delete this session? This cannot be undone.")) return;
    setDeleting(true);
    const supabase = createClient();
    const { error } = await supabase.from("learning_sessions").delete().eq("id", sessionId);
    if (error) {
      toast.error(error.message);
      setDeleting(false);
      return;
    }
    toast.success("Session deleted");
    router.refresh();
  }

  return (
    <div className="flex items-center gap-3 shrink-0">
      <Link
        href={`/tutor/sessions/${sessionId}/edit`}
        className="text-sm text-blue-500 hover:text-blue-700 font-medium"
      >
        Edit
      </Link>
      <button
        onClick={handleDelete}
        disabled={deleting}
        className="text-sm text-red-400 hover:text-red-600 font-medium disabled:opacity-50"
      >
        {deleting ? "..." : "Delete"}
      </button>
    </div>
  );
}
