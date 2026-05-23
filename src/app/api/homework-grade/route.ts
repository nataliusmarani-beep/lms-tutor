import { NextRequest, NextResponse } from "next/server";
import { createClient as createSupabaseClient } from "@supabase/supabase-js";
import { createClient } from "@/lib/supabase/server";

// PATCH /api/homework-grade
// Body: { questionId, studentId, quizId, grade, feedback? }
// Only tutors can call this endpoint
export async function PATCH(req: NextRequest) {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { data: profile } = await supabase.from("profiles").select("role").eq("id", user.id).single();
  if (profile?.role !== "tutor") {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  }

  const body = await req.json();
  const { questionId, studentId, quizId, grade, feedback } = body;

  if (!questionId || !studentId || !quizId || grade === undefined) {
    return NextResponse.json({ error: "Missing required fields" }, { status: 400 });
  }

  if (typeof grade !== "number" || grade < 0) {
    return NextResponse.json({ error: "Grade must be a non-negative number" }, { status: 400 });
  }

  const admin = createSupabaseClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!
  );

  const { error } = await admin
    .from("homework_submissions")
    .update({
      tutor_grade: grade,
      tutor_feedback: feedback ?? null,
    })
    .eq("question_id", questionId)
    .eq("student_id", studentId)
    .eq("quiz_id", quizId);

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ ok: true });
}
