import { NextRequest, NextResponse } from "next/server";
import { createClient as createSupabaseClient } from "@supabase/supabase-js";
import { createClient } from "@/lib/supabase/server";

// GET /api/quiz-review?quizId=xxx&studentId=xxx
// Uses service role key to bypass RLS (accessible by tutors, parents, and the student)
export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url);
  const quizId = searchParams.get("quizId");
  const studentId = searchParams.get("studentId");

  if (!quizId || !studentId) {
    return NextResponse.json({ error: "Missing quizId or studentId" }, { status: 400 });
  }

  // Verify caller is authenticated
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  // Verify the caller has permission to view this student's data
  const { data: profile } = await supabase.from("profiles").select("role").eq("id", user.id).single();
  const role = profile?.role;

  if (role === "student" && user.id !== studentId) {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  }

  if (role === "parent") {
    const { data: link } = await supabase
      .from("parent_student")
      .select("student_id")
      .eq("parent_id", user.id)
      .eq("student_id", studentId)
      .maybeSingle();
    if (!link) return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  }

  // Use admin client to bypass RLS
  const admin = createSupabaseClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!
  );

  const [{ data: qs }, { data: att }, { data: hw }] = await Promise.all([
    admin
      .from("quiz_questions")
      .select("id, question_type, question_text, question_text_id, attachment_url, attachment_type, sort_order")
      .eq("quiz_id", quizId)
      .order("sort_order"),
    admin
      .from("quiz_attempts")
      .select("score, max_score, completed_at, answers")
      .eq("quiz_id", quizId)
      .eq("student_id", studentId)
      .order("completed_at", { ascending: false })
      .limit(1)
      .maybeSingle(),
    admin
      .from("homework_submissions")
      .select("question_id, file_url, file_type")
      .eq("quiz_id", quizId)
      .eq("student_id", studentId)
      .order("created_at", { ascending: false }),
  ]);

  const questionList = (qs ?? []) as Array<Record<string, unknown>>;
  let questions: Array<Record<string, unknown>> = questionList;

  if (questionList.length > 0) {
    const { data: opts } = await admin
      .from("quiz_options")
      .select("id, question_id, option_text, option_text_id, is_correct, sort_order")
      .in("question_id", questionList.map((q) => q.id as string))
      .order("sort_order");

    const optsByQ: Record<string, unknown[]> = {};
    for (const o of (opts ?? []) as Array<{ question_id: string }>) {
      if (!optsByQ[o.question_id]) optsByQ[o.question_id] = [];
      optsByQ[o.question_id].push(o);
    }
    questions = questionList.map((q) => ({
      ...q,
      options: optsByQ[q.id as string] ?? [],
    }));
  }

  // Deduplicate homework: keep latest per question
  const hwMap: Record<string, unknown> = {};
  for (const h of (hw ?? []) as Array<{ question_id: string }>) {
    if (!hwMap[h.question_id]) hwMap[h.question_id] = h;
  }

  return NextResponse.json({
    questions,
    attempt: att ?? null,
    homework: Object.values(hwMap),
  });
}
