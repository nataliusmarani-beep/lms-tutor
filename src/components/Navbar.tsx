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
  en: { tutor: "Tutor", student: "Student", parent: "Guardian", guardian: "Guardian" },
  id: { tutor: "Tutor", student: "Siswa", parent: "Wali", guardian: "Wali" },
};

const roleBadgeClass: Record<string, string> = {
  tutor: "badge-blue",
  student: "badge-green",
  parent: "badge-yellow",
  guardian: "badge-yellow",
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
    <nav className="sticky top-0 z-50 border-b border-white/10" style={{ backgroundColor: "#0f1f3d" }}>
      <div className="max-w-5xl mx-auto px-4 py-2.5 flex items-center justify-between gap-2">

        {/* Logo — full text on sm+, icon only on mobile */}
        <div className="flex items-center gap-1.5 shrink-0">
          <span className="text-xl">💻</span>
          <span className="block sm:hidden text-base font-bold text-white leading-tight">
            Imlearning Club
          </span>
          <span className="hidden sm:block text-base font-bold text-white leading-tight">
            Imlearning Club
          </span>
        </div>

        {/* Right side */}
        <div className="flex items-center gap-2">

          {/* Language toggle — flags + labels on sm+, flags only on mobile */}
          <div className="flex items-center bg-white/10 rounded-full p-0.5 gap-0.5">
            <button
              onClick={() => { if (lang !== "en") toggleLang(); }}
              className={`flex items-center gap-1 px-2 py-1 rounded-full text-xs font-semibold transition-all duration-200 ${
                lang === "en" ? "bg-white shadow text-slate-800" : "text-white/60 hover:text-white"
              }`}
            >
              <span>🇬🇧</span>
              <span className="hidden sm:inline">EN</span>
            </button>
            <button
              onClick={() => { if (lang !== "id") toggleLang(); }}
              className={`flex items-center gap-1 px-2 py-1 rounded-full text-xs font-semibold transition-all duration-200 ${
                lang === "id" ? "bg-white shadow text-slate-800" : "text-white/60 hover:text-white"
              }`}
            >
              <span>🇮🇩</span>
              <span className="hidden sm:inline">ID</span>
            </button>
          </div>

          {/* Role badge — hidden on mobile */}
          <span className={`hidden sm:inline-flex ${roleBadgeClass[role] ?? "badge-gray"} text-xs`}>
            {roleLabel[lang][role] ?? role}
          </span>

          {/* Name — hidden on mobile */}
          <span className="hidden md:block text-sm font-medium text-white/80 truncate max-w-[120px]">
            {name}
          </span>

          {/* Avatar — always visible, shows initials */}
          <div className="w-8 h-8 rounded-full bg-white/20 text-white flex items-center justify-center text-xs font-bold shrink-0">
            {initials}
          </div>

          {/* Sign out — icon on mobile, text on sm+ */}
          <button
            onClick={handleLogout}
            title={lang === "en" ? "Sign out" : "Keluar"}
            className="flex items-center gap-1 text-white/50 hover:text-red-400 transition-colors"
          >
            {/* door/exit icon */}
            <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h6a2 2 0 012 2v1" />
            </svg>
            <span className="hidden sm:inline text-sm">{lang === "en" ? "Sign out" : "Keluar"}</span>
          </button>

        </div>
      </div>
    </nav>
  );
}
