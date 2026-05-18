"use client";
import { useState } from "react";
import toast from "react-hot-toast";

export default function TranslateQuizButton({ moduleId }: { moduleId: string }) {
  const [loading, setLoading] = useState(false);

  async function handleTranslate() {
    setLoading(true);
    try {
      const res = await fetch("/api/translate-quiz", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ moduleId }),
      });
      const data = await res.json();
      if (data.ok) {
        if (data.translated === 0) {
          toast.success("All quiz content already translated.");
        } else {
          toast.success(`Translated ${data.translated} items to Indonesian.`);
        }
      } else {
        toast.error("Translation failed: " + data.error);
      }
    } catch {
      toast.error("Translation request failed.");
    }
    setLoading(false);
  }

  return (
    <button
      type="button"
      onClick={handleTranslate}
      disabled={loading}
      className="btn-secondary text-sm py-1.5 flex items-center gap-2 disabled:opacity-50"
    >
      <span>{loading ? "⏳" : "🌐"}</span>
      {loading ? "Translating…" : "Auto-translate Quiz to ID"}
    </button>
  );
}
