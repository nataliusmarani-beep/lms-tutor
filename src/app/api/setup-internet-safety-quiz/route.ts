import { NextResponse } from "next/server";
import { createClient as createSupabaseClient } from "@supabase/supabase-js";
import { createClient } from "@/lib/supabase/server";

/**
 * POST /api/setup-internet-safety-quiz
 *
 * One-time setup (tutor only):
 *  1. Adds bilingual columns to quiz_questions & quiz_options (if missing)
 *  2. Creates the "Internet Safety, Email & Security Awareness" module (if missing)
 *  3. Seeds the 10-question bilingual Yes/No quiz into that module
 */
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

  // ── 1. Add bilingual columns if they don't exist ──────────────────────────
  //   Supabase JS can't run DDL directly, so we use a workaround:
  //   try inserting a dummy row with the column; if it errors with PGRST204 the
  //   column is missing and we surface a clear message for the user.
  const ddlCheck = await admin.from("quiz_questions").select("question_text_id").limit(0);
  const needsDDL = ddlCheck.error?.message?.includes("question_text_id");

  if (needsDDL) {
    // The migration supabase/migrate-quiz-bilingual-columns.sql must be run first.
    // Return instructions so the user knows what to do.
    return NextResponse.json({
      error: "migration_required",
      message: "Please run supabase/migrate-quiz-bilingual-columns.sql in the Supabase SQL editor first, then call this endpoint again.",
      sql: [
        "ALTER TABLE quiz_questions ADD COLUMN IF NOT EXISTS question_text_id TEXT;",
        "ALTER TABLE quiz_options    ADD COLUMN IF NOT EXISTS option_text_id   TEXT;",
      ],
    }, { status: 400 });
  }

  // ── 2. Find or create the Internet Safety module ──────────────────────────
  const COURSE_ID = "231c62c3-a478-4d5e-8c1d-768160b933a8";

  let moduleId: string;
  const { data: existingMod } = await admin
    .from("course_modules")
    .select("id")
    .ilike("title", "%Internet Safety%")
    .eq("course_id", COURSE_ID)
    .limit(1)
    .single();

  if (existingMod) {
    moduleId = existingMod.id;
  } else {
    const { data: newMod, error: modErr } = await admin
      .from("course_modules")
      .insert({
        course_id:   COURSE_ID,
        title:       "Internet Safety, Email & Security Awareness",
        title_id:    "Keamanan Internet, Email & Kesadaran Keamanan",
        focus:       "Password hygiene, phishing identification, safe browsing, email etiquette",
        focus_id:    "Kebersihan kata sandi, identifikasi phishing, browsing aman, etiket email",
        icon:        "🔐",
        week_number:  2,
        sort_order:   9,
      })
      .select()
      .single();
    if (modErr || !newMod) return NextResponse.json({ error: modErr?.message }, { status: 500 });
    moduleId = newMod.id;
  }

  // ── 3. Check quiz doesn't already exist ───────────────────────────────────
  const { data: existingQuiz } = await admin
    .from("module_quizzes")
    .select("id")
    .eq("course_module_id", moduleId)
    .ilike("title", "%Safe or Not Safe%")
    .limit(1)
    .single();

  if (existingQuiz) {
    return NextResponse.json({ message: "Quiz already exists", quizId: existingQuiz.id });
  }

  // ── 4. Get next sort_order ────────────────────────────────────────────────
  const { data: latestQuiz } = await admin
    .from("module_quizzes")
    .select("sort_order")
    .eq("course_module_id", moduleId)
    .order("sort_order", { ascending: false })
    .limit(1);
  const quizOrder = (latestQuiz?.[0]?.sort_order ?? -1) + 1;

  // ── 5. Create the quiz ────────────────────────────────────────────────────
  const { data: quiz, error: quizErr } = await admin
    .from("module_quizzes")
    .insert({
      course_module_id: moduleId,
      title:       "Safe or Not Safe? – Internet Safety Quiz",
      description: "For each situation, decide: Yes (do it) or No (avoid it)? | Untuk setiap situasi: Ya (lakukan) atau Tidak (hindari)?",
      sort_order:  quizOrder,
    })
    .select()
    .single();

  if (quizErr || !quiz) return NextResponse.json({ error: quizErr?.message }, { status: 500 });

  // ── 6. Seed 10 bilingual Yes/No questions ─────────────────────────────────
  type Correct = "Yes" | "No";
  const questions: [string, string, Correct][] = [
    [
      "You receive an email from your bank asking you to click a link and enter your password. Should you click the link?",
      "Kamu menerima email dari bank yang memintamu mengklik tautan dan memasukkan kata sandi. Apakah kamu harus mengklik tautan tersebut?",
      "No",
    ],
    [
      "Should you use the same password for your email, social media, and banking accounts?",
      "Apakah boleh menggunakan kata sandi yang sama untuk email, media sosial, dan akun perbankan?",
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
      "Apakah aman menggunakan Wi-Fi publik untuk masuk ke akun perbankan online?",
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

  let seeded = 0;
  for (let i = 0; i < questions.length; i++) {
    const [text, textId, correct] = questions[i];
    const { data: q, error: qErr } = await admin
      .from("quiz_questions")
      .insert({
        quiz_id:          quiz.id,
        question_type:    "yes_no",
        question_text:    text,
        question_text_id: textId,
        sort_order:       i,
      })
      .select()
      .single();

    if (qErr || !q) continue;

    await admin.from("quiz_options").insert([
      { question_id: q.id, option_text: "Yes", option_text_id: "Ya",    is_correct: correct === "Yes", sort_order: 0 },
      { question_id: q.id, option_text: "No",  option_text_id: "Tidak", is_correct: correct === "No",  sort_order: 1 },
    ]);
    seeded++;
  }

  return NextResponse.json({
    ok:         true,
    moduleId,
    quizId:     quiz.id,
    questions:  seeded,
  });
}
