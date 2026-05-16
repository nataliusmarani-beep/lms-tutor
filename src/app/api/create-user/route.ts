import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";
import { createClient as createAdminClient } from "@supabase/supabase-js";

export async function POST(req: Request) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { data: profile } = await supabase.from("profiles").select("role").eq("id", user.id).single();
  if (!profile || profile.role !== "tutor") {
    return NextResponse.json({ error: "Only tutors can create accounts" }, { status: 403 });
  }

  const body = await req.json();
  const { name, email, password, role, parentEmail } = body;

  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!supabaseUrl || !serviceKey) {
    return NextResponse.json(
      { error: `Missing env vars: URL=${!!supabaseUrl}, SERVICE_KEY=${!!serviceKey}` },
      { status: 500 }
    );
  }

  const adminSupabase = createAdminClient(supabaseUrl, serviceKey);

  const { data: newUser, error: createError } = await adminSupabase.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
  });

  if (createError) return NextResponse.json({ error: createError.message }, { status: 400 });

  const { error: profileError } = await adminSupabase.from("profiles").upsert({
    id: newUser.user!.id,
    name,
    role,
  });

  if (profileError) return NextResponse.json({ error: profileError.message }, { status: 400 });

  // Send password reset email so the user can set their own password and is notified of their account
  await adminSupabase.auth.resetPasswordForEmail(email);

  if (role === "parent" && parentEmail) {
    const { data: studentProfile } = await adminSupabase
      .from("profiles")
      .select("id")
      .eq("id", (await adminSupabase.auth.admin.listUsers()).data.users.find(u => u.email === parentEmail)?.id ?? "")
      .single();

    if (studentProfile) {
      await adminSupabase.from("parent_student").insert({
        parent_id: newUser.user!.id,
        student_id: studentProfile.id,
      });
    }
  }

  return NextResponse.json({ success: true });
}
