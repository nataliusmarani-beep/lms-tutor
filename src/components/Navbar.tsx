"use client";
import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

interface NavbarProps {
  name: string;
  role: string;
}

const roleLabel: Record<string, Record<string, string>> = {
  en: { tutor: "Tutor", student: "Student", parent: "Parent" },
  id: { tutor: "Tutor", student: "Siswa", parent: "Orang Tua" },
};

const roleBadgeClass: Record<string, string> = {
  tutor: "badge-blue",
  student: "badge-green",
  parent: "badge-yellow",
};

function getCookieLang(): "en" | "id" {
  if (typeof document === "undefined") return "en";
  const m = document.cookie.match(/(?:^|;\s*)lang=([^;]*)/);
  return m?.[1] === "id" ? "id" : "en";
}

export default function Navbar({ name, role }: NavbarProps) {
  const router = useRouter();
  const [lang, setLang] = useState<"en" | "id">("en");

  useEffect(() => {
    setLang(getCookieLang());
  }, []);

  async function handleLogout() {
    const supabase = createClient();
    await supabase.auth.signOut();
    toast.success(lang === "id" ? "Berhasil keluar" : "Logged out");
    router.push("/login");
    router.refresh();
  }

  function toggleLang() {
    const next = lang === "en" ? "id" : "en";
    document.cookie = `lang=${next}; path=/; max-age=31536000`;
    setLang(next);
    router.refresh();
  }

  const initials = name
    ? name.split(" ").map((n) => n[0]).join("").slice(0, 2).toUpperCase()
    : "?";

  return (
    <nav className="bg-white border-b border-slate-200 sticky top-0 z-50">
      <div className="max-w-5xl mx-auto px-4 py-3 flex items-center justify-between">
        {/* Logo */}
        <div className="flex items-center gap-3">
          <span className="text-xl font-bold text-indigo-600 flex items-center gap-1.5">
            <span>📘</span>
            <span>LMS Tutor</span>
          </span>
          <span className="hidden sm:block text-slate-300 font-light text-lg">|</span>
          <span className="hidden sm:block text-sm text-slate-400">Learn with Mr. Teis</span>
        </div>

        {/* Right side */}
        <div className="flex items-center gap-3">
          {/* Language toggle — sliding pill */}
          <div className="flex items-center bg-slate-100 rounded-full p-0.5 gap-0.5">
            <button
              onClick={() => { if (lang !== "en") toggleLang(); }}
              className={`flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold transition-all duration-200 ${
                lang === "en"
                  ? "bg-white shadow text-slate-800"
                  : "text-slate-400 hover:text-slate-600"
              }`}
            >
              <span>🇬🇧</span>
              <span>EN</span>
            </button>
            <button
              onClick={() => { if (lang !== "id") toggleLang(); }}
              className={`flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold transition-all duration-200 ${
                lang === "id"
                  ? "bg-white shadow text-slate-800"
                  : "text-slate-400 hover:text-slate-600"
              }`}
            >
              <span>🇮🇩</span>
              <span>ID</span>
            </button>
          </div>

          {/* Role badge */}
          <span className={`hidden sm:inline-flex ${roleBadgeClass[role] ?? "badge-gray"}`}>
            {roleLabel[lang][role] ?? role}
          </span>

          {/* Name */}
          <span className="hidden sm:block text-sm font-medium text-slate-700 truncate max-w-[120px]">
            {name}
          </span>

          {/* Avatar */}
          <div className="w-8 h-8 rounded-full bg-indigo-100 text-indigo-700 flex items-center justify-center text-xs font-bold shrink-0">
            {initials}
          </div>

          {/* Sign out */}
          <button
            onClick={handleLogout}
            className="text-sm text-slate-400 hover:text-red-500 transition-colors"
          >
            {lang === "en" ? "Sign out" : "Keluar"}
          </button>
        </div>
      </div>
    </nav>
  );
}
