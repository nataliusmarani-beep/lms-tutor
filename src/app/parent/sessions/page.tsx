import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { format } from "date-fns";
import { t } from "@/lib/i18n";
import { getLang } from "@/lib/getLang";

interface SessionRow {
  id: string;
  date: string;
  duration_minutes: number;
  tutor_notes: string | null;
  course_module_id: string | null;
  module_id: number | null;
}

interface CourseModule {
  id: string;
  title: string;
  title_id?: string | null;
  icon: string;
}

export default async function ParentSessionsPage() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || profile.role !== "parent") redirect("/login");

  const lang = getLang();

  const { data: links } = await supabase.from("parent_student").select("student_id").eq("parent_id", user.id);
  const studentId = links?.[0]?.student_id;
  if (!studentId) redirect("/parent");

  const { data: studentProfile } = await supabase.from("profiles").select("name, avatar_url").eq("id", studentId).single();

  const { data: sessions } = await supabase
    .from("learning_sessions")
    .select("id, date, duration_minutes, tutor_notes, course_module_id, module_id")
    .eq("student_id", studentId)
    .order("date", { ascending: false });

  const sessionList = (sessions ?? []) as SessionRow[];

  const moduleIds = Array.from(new Set(sessionList.map((s) => s.course_module_id).filter((x): x is string => x !== null)));
  const { data: modules } = await supabase
    .from("course_modules").select("id, title, title_id, icon")
    .in("id", moduleIds.length > 0 ? moduleIds : ["__none__"]);
  const moduleMap: Record<string, CourseModule> = {};
  for (const m of (modules ?? []) as CourseModule[]) moduleMap[m.id] = m;

  const totalMinutes = sessionList.reduce((a, s) => a + s.duration_minutes, 0);
  const totalHours = Math.round((totalMinutes / 60) * 10) / 10;

  const grouped: Record<string, SessionRow[]> = {};
  for (const s of sessionList) {
    const key = format(new Date(s.date), "MMMM yyyy");
    if (!grouped[key]) grouped[key] = [];
    grouped[key].push(s);
  }

  return (
    <div className="max-w-4xl mx-auto px-4 py-8 space-y-6">

      <div>
        <h1 className="text-2xl font-bold text-slate-800">{t(lang, "sessions")}</h1>
        <p className="text-slate-500 text-sm mt-1">
          {studentProfile?.name} · {sessionList.length} {t(lang, "sessions").toLowerCase()} · {totalHours}h
        </p>
      </div>

      <div className="grid grid-cols-2 sm:grid-cols-3 gap-4">
        <div className="card text-center">
          <div className="text-2xl mb-1">📅</div>
          <div className="text-2xl font-bold text-teal-600">{sessionList.length}</div>
          <div className="text-sm text-slate-500">{t(lang, "sessions")}</div>
        </div>
        <div className="card text-center">
          <div className="text-2xl mb-1">⏱️</div>
          <div className="text-2xl font-bold text-teal-600">{totalHours}h</div>
          <div className="text-sm text-slate-500">{t(lang, "learningTime")}</div>
        </div>
        <div className="card text-center">
          <div className="text-2xl mb-1">📆</div>
          <div className="text-2xl font-bold text-teal-600">{Object.keys(grouped).length}</div>
          <div className="text-sm text-slate-500">Months</div>
        </div>
      </div>

      {sessionList.length === 0 ? (
        <div className="card text-center py-16">
          <div className="text-5xl mb-4">📋</div>
          <p className="text-slate-500">{t(lang, "noSessionsYet")}</p>
        </div>
      ) : (
        Object.entries(grouped).map(([month, items]) => (
          <div key={month}>
            <h2 className="text-sm font-semibold text-slate-400 uppercase tracking-wide mb-2">{month}</h2>
            <div className="space-y-2">
              {items.map((s) => {
                const mod = s.course_module_id ? moduleMap[s.course_module_id] : null;
                const title = mod
                  ? ((lang === "id" && mod.title_id) ? mod.title_id : mod.title)
                  : s.module_id ? `Module ${s.module_id}` : "Session";
                return (
                  <div key={s.id} className="card flex items-center gap-3 py-3">
                    <div className="w-10 h-10 rounded-xl flex items-center justify-center shrink-0" style={{ backgroundColor: "#0f1f3d" }}>
                      <span className="text-lg">{mod?.icon ?? "📅"}</span>
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="text-sm font-medium text-slate-700">{title}</div>
                      {s.tutor_notes && (
                        <p className="text-xs text-slate-500 mt-0.5 line-clamp-1">{s.tutor_notes}</p>
                      )}
                    </div>
                    <div className="text-right shrink-0">
                      <div className="text-sm font-semibold text-slate-700">{s.duration_minutes} min</div>
                      <div className="text-xs text-slate-400">{format(new Date(s.date), "MMM d, yyyy")}</div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        ))
      )}
    </div>
  );
}
