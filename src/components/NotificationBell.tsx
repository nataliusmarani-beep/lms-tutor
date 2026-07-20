"use client";
import { useState, useEffect, useCallback, useRef } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";

interface Notification {
  id: string;
  type: string;
  title: string;
  title_id: string | null;
  body: string | null;
  body_id: string | null;
  link: string | null;
  read: boolean;
  created_at: string;
}

interface Props {
  role: "student" | "parent" | "guardian";
  lang: "en" | "id";
}

function timeAgo(iso: string, lang: "en" | "id"): string {
  const s = Math.floor((Date.now() - new Date(iso).getTime()) / 1000);
  const en = lang === "en";
  if (s < 60) return en ? "just now" : "baru saja";
  const m = Math.floor(s / 60);
  if (m < 60) return en ? `${m}m ago` : `${m} mnt lalu`;
  const h = Math.floor(m / 60);
  if (h < 24) return en ? `${h}h ago` : `${h} jam lalu`;
  const d = Math.floor(h / 24);
  return en ? `${d}d ago` : `${d} hr lalu`;
}

export default function NotificationBell({ role, lang }: Props) {
  const supabase = createClient();
  const router = useRouter();
  const [items, setItems] = useState<Notification[]>([]);
  const [open, setOpen] = useState(false);
  const panelRef = useRef<HTMLDivElement>(null);
  const base = role === "student" ? "/student" : "/parent";
  const unread = items.filter((n) => !n.read).length;

  const load = useCallback(async () => {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) return;
    const { data } = await supabase
      .from("notifications")
      .select("*")
      .eq("recipient_id", user.id)
      .order("created_at", { ascending: false })
      .limit(20);
    if (data) setItems(data as Notification[]);
  }, [supabase]);

  // Initial load + poll every 45s
  useEffect(() => {
    load();
    const t = setInterval(load, 45000);
    return () => clearInterval(t);
  }, [load]);

  // Close on outside click
  useEffect(() => {
    if (!open) return;
    function onClick(e: MouseEvent) {
      if (panelRef.current && !panelRef.current.contains(e.target as Node)) setOpen(false);
    }
    document.addEventListener("mousedown", onClick);
    return () => document.removeEventListener("mousedown", onClick);
  }, [open]);

  async function markAllRead() {
    const ids = items.filter((n) => !n.read).map((n) => n.id);
    if (ids.length === 0) return;
    setItems((prev) => prev.map((n) => ({ ...n, read: true })));
    await supabase.from("notifications").update({ read: true }).in("id", ids);
  }

  async function openPanel() {
    const next = !open;
    setOpen(next);
    if (next && unread > 0) markAllRead();
  }

  function go(n: Notification) {
    setOpen(false);
    if (n.link) router.push(base + n.link);
  }

  const t = (en: string, id: string) => (lang === "id" ? id : en);

  return (
    <div className="relative" ref={panelRef}>
      <button
        onClick={openPanel}
        aria-label={t("Notifications", "Notifikasi")}
        className="relative w-9 h-9 rounded-xl flex items-center justify-center text-white/70 hover:text-white hover:bg-white/10 transition-colors"
      >
        <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.8}>
          <path strokeLinecap="round" strokeLinejoin="round" d="M15 17h5l-1.4-1.4A2 2 0 0118 14.2V11a6 6 0 10-12 0v3.2a2 2 0 01-.6 1.4L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
        </svg>
        {unread > 0 && (
          <span className="absolute -top-0.5 -right-0.5 min-w-[18px] h-[18px] px-1 rounded-full bg-red-500 text-white text-[10px] font-bold flex items-center justify-center ring-2 ring-[#0f1f3d]">
            {unread > 9 ? "9+" : unread}
          </span>
        )}
      </button>

      {open && (
        <div className="absolute left-0 top-11 z-50 w-72 max-w-[85vw] rounded-2xl bg-white shadow-xl border border-slate-100 overflow-hidden">
          <div className="flex items-center justify-between px-4 py-2.5 border-b border-slate-100">
            <span className="text-sm font-semibold text-slate-700">{t("Notifications", "Notifikasi")}</span>
            {unread > 0 && (
              <button onClick={markAllRead} className="text-xs font-medium text-teal-600 hover:text-teal-700">
                {t("Mark all read", "Tandai dibaca")}
              </button>
            )}
          </div>

          <div className="max-h-80 overflow-y-auto divide-y divide-slate-50">
            {items.length === 0 ? (
              <p className="px-4 py-8 text-center text-sm text-slate-400">
                {t("No notifications yet", "Belum ada notifikasi")}
              </p>
            ) : (
              items.map((n) => (
                <button
                  key={n.id}
                  onClick={() => go(n)}
                  className={`w-full text-left px-4 py-3 hover:bg-slate-50 transition-colors flex gap-3 ${n.read ? "" : "bg-teal-50/50"}`}
                >
                  <span className="text-base leading-none mt-0.5">{n.type === "session" ? "📋" : "✅"}</span>
                  <span className="flex-1 min-w-0">
                    <span className="block text-sm font-semibold text-slate-800 leading-snug">
                      {lang === "id" && n.title_id ? n.title_id : n.title}
                    </span>
                    {(n.body || n.body_id) && (
                      <span className="block text-xs text-slate-500 mt-0.5 line-clamp-2">
                        {lang === "id" && n.body_id ? n.body_id : n.body}
                      </span>
                    )}
                    <span className="block text-[11px] text-slate-400 mt-1">{timeAgo(n.created_at, lang)}</span>
                  </span>
                  {!n.read && <span className="w-2 h-2 rounded-full bg-teal-500 shrink-0 mt-1.5" />}
                </button>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}
