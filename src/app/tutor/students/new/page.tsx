"use client";
import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";
import { t } from "@/lib/i18n";
import type { Lang } from "@/lib/i18n";

export default function NewStudentPage() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [profile, setProfile] = useState<{ name: string; role: string } | null>(null);
  const [lang, setLang] = useState<Lang>("en");
  useEffect(() => {
    const m = document.cookie.match(/(?:^|;\s*)lang=([^;]*)/);
    setLang(m?.[1] === "id" ? "id" : "en");
  }, []);
  const [form, setForm] = useState({
    name: "", email: "", password: "", role: "student" as "student" | "guardian",
    parentEmail: "",
  });

  async function loadProfile() {
    const supabase = createClient();
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) { router.push("/login"); return; }
    const { data } = await supabase.from("profiles").select("name, role").eq("id", user.id).single();
    setProfile(data);
  }

  useEffect(() => { loadProfile(); }, []);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);

    const res = await fetch("/api/create-user", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(form),
    });

    const json = await res.json();
    setLoading(false);

    if (!res.ok) { toast.error(json.error ?? "Failed"); return; }
    toast.success(`Account created! Invite email sent to ${form.email}`);
    router.push("/tutor");
  }

  return (
    <div className="min-h-screen">
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-6">
        <div className="flex items-center gap-2 text-sm text-slate-400">
          <Link href="/tutor">{t(lang, "dashboard")}</Link>
        </div>

        <h1 className="text-xl font-bold text-slate-800">{t(lang, "createAccount")}</h1>

        <div className="card space-y-4">
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="label">{t(lang, "accountType")}</label>
              <select className="input" value={form.role}
                onChange={(e) => setForm({ ...form, role: e.target.value as "student" | "guardian" })}>
                <option value="student">{t(lang, "rolestudent")}</option>
                <option value="guardian">{t(lang, "roleparent")}</option>
              </select>
            </div>
            <div>
              <label className="label">{t(lang, "fullName")} *</label>
              <input className="input" required value={form.name}
                onChange={(e) => setForm({ ...form, name: e.target.value })}
                placeholder="e.g. Budi Santoso" />
            </div>
            <div>
              <label className="label">Email *</label>
              <input type="email" className="input" required value={form.email}
                onChange={(e) => setForm({ ...form, email: e.target.value })}
                placeholder={form.role === "guardian" ? "guardian@email.com" : "student@email.com"} />
            </div>
            <div>
              <label className="label">Password *</label>
              <input type="password" className="input" required value={form.password}
                onChange={(e) => setForm({ ...form, password: e.target.value })}
                placeholder="Min 6 characters" minLength={6} />
            </div>
            {form.role === "guardian" && (
              <div>
                <label className="label">{t(lang, "studentEmailLink")}</label>
                <input type="email" className="input" value={form.parentEmail}
                  onChange={(e) => setForm({ ...form, parentEmail: e.target.value })}
                  placeholder="student@email.com" />
                <p className="text-xs text-slate-400 mt-1">{lang === "id" ? "Wali dapat melihat progres siswa ini." : "Guardian will be able to see this student's progress."}</p>
              </div>
            )}
            <button className="btn-primary w-full py-2.5" type="submit" disabled={loading}>
              {loading ? t(lang, "creating") : t(lang, "createAccount")}
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
