import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";

export default async function RootPage() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase
    .from("profiles")
    .select("role")
    .eq("id", user.id)
    .single();

  if (!profile) redirect("/login");

  if (profile.role === "tutor") redirect("/tutor");
  if (profile.role === "student") redirect("/student");
  if (profile.role === "parent" || profile.role === "guardian") redirect("/parent");

  redirect("/login");
}
