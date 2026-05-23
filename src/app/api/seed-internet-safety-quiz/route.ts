import { NextResponse } from "next/server";
import { createClient as createSupabaseClient } from "@supabase/supabase-js";
import { createClient } from "@/lib/supabase/server";

// POST /api/seed-internet-safety-quiz
// One-time seed: creates the Yes/No Internet Safety quiz in the matching module.
// Only tutors can call this.
export async function POST() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { data: profile } = await supabase.from("profiles").select("role").eq("id", user.id).single();
  if (profile?.role !== "tutor") return NextResponse.json({ error: "Forbidden" }, { status: 403 });

  const admin = createSupabaseClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!
  );

  // Find the Internet Safety module (match both EN and ID title variants)
  const { data: modules } = await admin
    .from("course_modules")
    .select("id, title")
    .or("title.ilike.%Internet Safety%,title.ilike.%Keamanan Internet%,title.ilike.%Internet%Security%");

  if (!modules?.length) {
    return NextResponse.json({ error: "Internet Safety module not found" }, { status: 404 });
  }

  const moduleId = modules[0].id;

  // Check quiz doesn't already exist
  const { data: existing } = await admin
    .from("module_quizzes")
    .select("id")
    .eq("course_module_id", moduleId)
    .ilike("title", "%Safe or Not%");

  if (existing?.length) {
    return NextResponse.json({ message: "Quiz already exists", quizId: existing[0].id });
  }

  // Get next sort_order
  const { data: existingQuizzes } = await admin
    .from("module_quizzes")
    .select("sort_order")
    .eq("course_module_id", moduleId)
    .order("sort_order", { ascending: false })
    .limit(1);
  const nextOrder = (existingQuizzes?.[0]?.sort_order ?? 0) + 1;

  // Create quiz
  const { data: quiz, error: quizErr } = await admin
    .from("module_quizzes")
    .insert({
      course_module_id: moduleId,
      title: "Safe or Not Safe? – Internet Safety Quiz",
      description: "For each situation, decide: should you do it (Yes) or avoid it (No)?",
      sort_order: nextOrder,
    })
    .select()
    .single();

  if (quizErr || !quiz) {
    return NextResponse.json({ error: quizErr?.message ?? "Failed to create quiz" }, { status: 500 });
  }

  // Questions: [text, text_id, correct = "Yes" | "No"]
  const questions: [string, string, "Yes" | "No"][] = [
    [
      "You receive an email from your bank asking you to click a link and enter your password. Should you click the link?",
      "Kamu menerima email dari bank yang memintamu mengklik tautan dan memasukkan kata sandi. Apakah kamu harus mengklik tautan tersebut?",
      "No",
    ],
    [
      "Should you use the same password for your email, social media, and banking accounts?",
      "Apakah kamu boleh menggunakan kata sandi yang sama untuk email, media sosial, dan akun perbankan?",
      "No",
    ],
    [
      "Should you enable two-factor authentication (2FA) on your important accounts?",
      "Apakah kamu perlu mengaktifkan autentikasi dua faktor (2FA) pada akun-akun penting?",
      "Yes",
    ],
    [
      "A pop-up says your computer has a virus and asks you to call a phone number immediately. Should you call the number?",
      "Sebuah pop-up menyatakan komputermu terkena virus dan memintamu menghubungi nomor telepon segera. Apakah kamu harus menelepon nomor tersebut?",
      "No",
    ],
    [
      "Should you update your software and operating system regularly when updates are available?",
      "Apakah kamu perlu memperbarui perangkat lunak dan sistem operasi secara rutin ketika pembaruan tersedia?",
      "Yes",
    ],
    [
      "Is it safe to use public Wi-Fi to log in to your online banking?",
      "Apakah aman menggunakan Wi-Fi publik untuk masuk ke perbankan online?",
      "No",
    ],
    [
      "A friend sends you a link saying 'You won a prize! Click here.' Should you click the link without checking first?",
      "Temanmu mengirim tautan bertuliskan 'Kamu menang hadiah! Klik di sini.' Apakah kamu harus mengklik tautan tersebut tanpa memeriksa terlebih dahulu?",
      "No",
    ],
    [
      "Should you lock your computer screen when you step away from it in a public place?",
      "Apakah kamu perlu mengunci layar komputer saat meninggalkannya di tempat umum?",
      "Yes",
    ],
    [
      "Is it okay to share your password with a close friend so they can help you with something?",
      "Apakah boleh berbagi kata sandi dengan teman dekat agar mereka bisa membantumu?",
      "No",
    ],
    [
      "Should you check the sender's email address carefully before opening attachments in an email?",
      "Apakah kamu perlu memeriksa alamat email pengirim dengan teliti sebelum membuka lampiran email?",
      "Yes",
    ],
  ];

  let sortOrder = 0;
  for (const [text, textId, correct] of questions) {
    const { data: q, error: qErr } = await admin
      .from("quiz_questions")
      .insert({
        quiz_id: quiz.id,
        question_type: "yes_no",
        question_text: text,
        question_text_id: textId,
        attachment_url: null,
        attachment_type: null,
        sort_order: sortOrder++,
      })
      .select()
      .single();

    if (qErr || !q) continue;

    await admin.from("quiz_options").insert([
      { question_id: q.id, option_text: "Yes", option_text_id: "Ya",  is_correct: correct === "Yes", sort_order: 0 },
      { question_id: q.id, option_text: "No",  option_text_id: "Tidak", is_correct: correct === "No",  sort_order: 1 },
    ]);
  }

  return NextResponse.json({ ok: true, quizId: quiz.id, module: modules[0].title, questions: questions.length });
}
