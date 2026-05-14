"use client";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

interface NavbarProps {
  name: string;
  role: string;
}

const roleLabel: Record<string, string> = {
  tutor: "Tutor",
  student: "Student",
  parent: "Parent",
};

const roleBadgeClass: Record<string, string> = {
  tutor: "badge-blue",
  student: "badge-green",
  parent: "badge-yellow",
};

export default function Navbar({ name, role }: NavbarProps) {
  const router = useRouter();

  async function handleLogout() {
    const supabase = createClient();
    await supabase.auth.signOut();
    toast.success("Logged out");
    router.push("/login");
    router.refresh();
  }

  const initials = name
    ? name
        .split(" ")
        .map((n) => n[0])
        .join("")
        .slice(0, 2)
        .toUpperCase()
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
          {/* Role badge — hidden on very small screens */}
          <span className={`hidden sm:inline-flex ${roleBadgeClass[role] ?? "badge-gray"}`}>
            {roleLabel[role] ?? role}
          </span>

          {/* Name — hidden on very small screens */}
          <span className="hidden sm:block text-sm font-medium text-slate-700 truncate max-w-[120px]">
            {name}
          </span>

          {/* Avatar circle */}
          <div className="w-8 h-8 rounded-full bg-indigo-100 text-indigo-700 flex items-center justify-center text-xs font-bold shrink-0">
            {initials}
          </div>

          {/* Sign out */}
          <button
            onClick={handleLogout}
            className="text-sm text-slate-400 hover:text-red-500 transition-colors"
          >
            Sign out
          </button>
        </div>
      </div>
    </nav>
  );
}
