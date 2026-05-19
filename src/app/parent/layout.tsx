import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import Sidebar from "@/components/Sidebar";

export default async function ParentLayout({ children }: { children: React.ReactNode }) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!profile || !["parent", "guardian"].includes(profile.role)) redirect("/login");

  return (
    <div className="flex min-h-screen bg-slate-50">
      <Sidebar name={profile.name} role={profile.role as "parent" | "guardian"} avatarUrl={profile.avatar_url ?? null} />
      <main className="flex-1 min-w-0 overflow-x-hidden">
        {children}
      </main>
    </div>
  );
}
