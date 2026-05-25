const { createClient } = require("@supabase/supabase-js");

const SUPABASE_URL = "https://wkovchswwtdilakszusu.supabase.co";
const SERVICE_KEY  = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Indrb3ZjaHN3d3RkaWxha3N6dXN1Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3ODc1MzMxNiwiZXhwIjoyMDk0MzI5MzE2fQ.iXVCgU44MdvW6y7NhYNTrysCw3nMEIjZMA1ETFHAPsU";

async function main() {
  const admin = createClient(SUPABASE_URL, SERVICE_KEY);

  const { data: modules, error: modErr } = await admin
    .from("course_modules")
    .select("id, title")
    .or("title.ilike.%Internet Safety%,title.ilike.%Keamanan Internet%");

  if (modErr || !modules?.length) {
    console.error("Module not found", modErr);
    process.exit(1);
  }

  const moduleId = modules[0].id;
  console.log("Module:", modules[0].title, "→", moduleId);

  const { data: existing } = await admin
    .from("module_quizzes")
    .select("id, title")
    .eq("course_module_id", moduleId)
    .ilike("title", "%Safe or Not%");

  if (existing?.length) {
    console.log("Quiz already seeded:", existing[0].title);
    process.exit(0);
  }

  const { data: existingQuizzes } = await admin
    .from("module_quizzes")
    .select("sort_order")
    .eq("course_module_id", moduleId)
    .order("sort_order", { ascending: false })
    .limit(1);
  const nextOrder = (existingQuizzes?.[0]?.sort_order ?? 0) + 1;
  console.log("Inserting at sort_order:", nextOrder);

  const { data: quiz, error: quizErr } = await admin
    .from("module_quizzes")
    .insert({
      course_module_id: moduleId,
      title: "Safe or Not Safe? – Internet Safety Quiz",
      title_id: "Aman atau Tidak Aman? – Kuis Keamanan Internet",
      description: "For each situation, decide: should you do it (Yes) or avoid it (No)?",
      description_id: "Untuk setiap situasi, tentukan: haruskah kamu melakukannya (Ya) atau menghindarinya (Tidak)?",
      sort_order: nextOrder,
    })
    .select()
    .single();

  if (quizErr || !quiz) {
    console.error("Failed to create quiz:", quizErr);
    process.exit(1);
  }
  console.log("Quiz created:", quiz.id);

  const questions = [
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

  let sortOrder = 0;
  for (const [text, textId, correct] of questions) {
    const { data: q, error: qErr } = await admin
      .from("quiz_questions")
      .insert({
        quiz_id: quiz.id,
        question_type: "yes_no",
        question_text: text,
        question_text_id: textId,
        sort_order: sortOrder++,
      })
      .select()
      .single();

    if (qErr || !q) { console.error("Question error:", qErr); continue; }

    const { error: optErr } = await admin.from("quiz_options").insert([
      { question_id: q.id, option_text: "Yes", option_text_id: "Ya",    is_correct: correct === "Yes", sort_order: 0 },
      { question_id: q.id, option_text: "No",  option_text_id: "Tidak", is_correct: correct === "No",  sort_order: 1 },
    ]);
    if (optErr) console.error("Option error:", optErr);
    else console.log(`  Q${sortOrder} [${correct}]: ${text.substring(0, 55)}...`);
  }

  console.log("\nDone! 10 Yes/No questions seeded.");
}

main().catch(console.error);
