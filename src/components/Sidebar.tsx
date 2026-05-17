"use client";
import { useState, useEffect } from "react";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

interface SidebarProps {
  name: string;
  role: "tutor" | "student" | "parent";
  avatarUrl?: string | null;
}

type NavItem = { href: string; icon: string; labelEn: string; labelId: string; exact?: boolean };

const navByRole: Record<string, NavItem[]> = {
  tutor: [
    { href: "/tutor",               icon: "🏠", labelEn: "Dashboard",   labelId: "Beranda",    exact: true },
    { href: "/tutor/courses",        icon: "📚", labelEn: "Courses",     labelId: "Kursus"      },
    { href: "/tutor/sessions/new",   icon: "⏱️", labelEn: "Log Session", labelId: "Catat Sesi"  },
    { href: "/tutor/accounts",       icon: "⚙️", labelEn: "Accounts",    labelId: "Akun"        },
  ],
  student: [
    { href: "/student", icon: "🏠", labelEn: "Dashboard", labelId: "Beranda", exact: true },
  ],
  parent: [
    { href: "/parent", icon: "🏠", labelEn: "Dashboard", labelId: "Beranda", exact: true },
  ],
};

const roleLabel: Record<string, Record<string, string>> = {
  en: { tutor: "Tutor", student: "Student", parent: "Parent" },
  id: { tutor: "Tutor", student: "Siswa",   parent: "Orang Tua" },
};

function getCookieLang(): "en" | "id" {
  if (typeof document === "undefined") return "en";
  const m = document.cookie.match(/(?:^|;\s*)lang=([^;]*)/);
  return m?.[1] === "id" ? "id" : "en";
}

export default function Sidebar({ name, role, avatarUrl }: SidebarProps) {
  const router   = useRouter();
  const pathname = usePathname();
  const [lang, setLang]       = useState<"en" | "id">("en");
  const [open, setOpen]       = useState(false);

  useEffect(() => { setLang(getCookieLang()); }, []);

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

  function isActive(item: NavItem) {
    return item.exact ? pathname === item.href : pathname.startsWith(item.href);
  }

  const initials = name ? name.split(" ").map((n) => n[0]).join("").slice(0, 2).toUpperCase() : "?";
  const items    = navByRole[role] ?? [];

  const SidebarContent = () => (
    <div className="flex flex-col h-full" style={{ backgroundColor: "#0f1f3d" }}>

      {/* Logo */}
      <div className="px-5 py-5 border-b border-white/10 shrink-0">
        <div className="flex items-center gap-2.5">
          <span className="text-2xl">💻</span>
          <div className="leading-tight">
            <div className="text-white font-bold text-sm">Learning with</div>
            <div className="text-teal-400 font-bold text-sm">Mr. Teis</div>
          </div>
        </div>
      </div>

      {/* Nav links */}
      <nav className="flex-1 px-3 py-4 space-y-1 overflow-y-auto">
        {items.map((item) => (
          <Link
            key={item.href}
            href={item.href}
            onClick={() => setOpen(false)}
            className={`flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-all ${
              isActive(item)
                ? "bg-teal-500 text-white shadow-sm"
                : "text-white/60 hover:text-white hover:bg-white/10"
            }`}
          >
            <span className="text-base">{item.icon}</span>
            <span>{lang === "id" ? item.labelId : item.labelEn}</span>
          </Link>
        ))}
      </nav>

      {/* Bottom section */}
      <div className="px-3 pb-5 pt-3 border-t border-white/10 space-y-3 shrink-0">

        {/* Language toggle */}
        <div className="flex items-center bg-white/10 rounded-full p-0.5 gap-0.5 self-start w-fit">
          {(["en", "id"] as const).map((l) => (
            <button
              key={l}
              onClick={() => { if (lang !== l) toggleLang(); }}
              className={`flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-semibold transition-all ${
                lang === l ? "bg-white shadow text-slate-800" : "text-white/60 hover:text-white"
              }`}
            >
              <span>{l === "en" ? "🇬🇧" : "🇮🇩"}</span>
              <span>{l.toUpperCase()}</span>
            </button>
          ))}
        </div>

        {/* User row */}
        <div className="flex items-center gap-3 px-1">
          <div className="w-9 h-9 rounded-full overflow-hidden bg-teal-500 flex items-center justify-center shrink-0">
            {avatarUrl ? (
              <img src={avatarUrl} alt={name} className="w-full h-full object-cover" />
            ) : (
              <span className="text-sm font-bold text-white">{initials}</span>
            )}
          </div>
          <div className="flex-1 min-w-0">
            <div className="text-white text-xs font-semibold truncate">{name}</div>
            <div className="text-white/40 text-xs">{roleLabel[lang][role]}</div>
          </div>
          <button
            onClick={handleLogout}
            title={lang === "en" ? "Sign out" : "Keluar"}
            className="text-white/40 hover:text-red-400 transition-colors shrink-0"
          >
            <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a2 2 0 01-2 2H5a2 2 0 01-2-2V7a2 2 0 012-2h6a2 2 0 012 2v1" />
            </svg>
          </button>
        </div>

      </div>
    </div>
  );

  return (
    <>
      {/* Desktop sidebar */}
      <aside className="hidden md:flex flex-col w-60 shrink-0 sticky top-0 h-screen">
        <SidebarContent />
      </aside>

      {/* Mobile: hamburger button */}
      <button
        onClick={() => setOpen(true)}
        className="md:hidden fixed top-3 left-3 z-40 w-10 h-10 rounded-xl flex items-center justify-center shadow-lg text-white"
        style={{ backgroundColor: "#0f1f3d" }}
      >
        <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
          <path strokeLinecap="round" strokeLinejoin="round" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>

      {/* Mobile: overlay + slide-in drawer */}
      {open && (
        <div className="md:hidden fixed inset-0 z-50 flex">
          <div className="w-60 h-full flex flex-col">
            <SidebarContent />
          </div>
          <div className="flex-1 bg-black/50" onClick={() => setOpen(false)} />
        </div>
      )}
    </>
  );
}
