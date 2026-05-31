import { NextResponse } from "next/server";
import { createClient as createSupabaseClient } from "@supabase/supabase-js";
import { createClient } from "@/lib/supabase/server";

/**
 * POST /api/setup-word-checklist-quiz
 *
 * Tutor-only: seeds a 13-question bilingual Yes/No knowledge-check quiz
 * for the Microsoft Word module, based on the student checklist items.
 */
export async function POST() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { data: profile } = await supabase
    .from("profiles").select("role").eq("id", user.id).single();
  if (profile?.role !== "tutor")
    return NextResponse.json({ error: "Forbidden" }, { status: 403 });

  const admin = createSupabaseClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!
  );

  // ── 1. Find the Microsoft Word module ─────────────────────────────────────
  const { data: modules } = await admin
    .from("course_modules")
    .select("id, title")
    .or(
      "title.ilike.%Microsoft Word%," +
      "title.ilike.%Word for Beginner%," +
      "title.ilike.%MS Word%"
    )
    .limit(5);

  if (!modules?.length)
    return NextResponse.json({ error: "Microsoft Word module not found. Check title spelling." }, { status: 404 });

  const moduleId = modules[0].id;

  // ── 2. Guard: quiz already exists? ────────────────────────────────────────
  const { data: existing } = await admin
    .from("module_quizzes")
    .select("id")
    .eq("course_module_id", moduleId)
    .ilike("title", "%Checklist Knowledge Check%")
    .limit(1)
    .single();

  if (existing)
    return NextResponse.json({ message: "Quiz already exists", quizId: existing.id });

  // ── 3. Next sort_order ────────────────────────────────────────────────────
  const { data: latestQuiz } = await admin
    .from("module_quizzes")
    .select("sort_order")
    .eq("course_module_id", moduleId)
    .order("sort_order", { ascending: false })
    .limit(1);
  const quizOrder = (latestQuiz?.[0]?.sort_order ?? -1) + 1;

  // ── 4. Create the quiz ────────────────────────────────────────────────────
  const { data: quiz, error: quizErr } = await admin
    .from("module_quizzes")
    .insert({
      course_module_id: moduleId,
      title:       "Checklist Knowledge Check – Microsoft Word",
      description: "Test your understanding of the skills covered in this module. Answer Yes or No! | Uji pemahamanmu tentang keterampilan dalam modul ini. Jawab Ya atau Tidak!",
      sort_order:  quizOrder,
    })
    .select()
    .single();

  if (quizErr || !quiz)
    return NextResponse.json({ error: quizErr?.message }, { status: 500 });

  // ── 5. 13 bilingual Yes/No questions ─────────────────────────────────────
  type Correct = "Yes" | "No";
  const questions: [string, string, Correct][] = [
    [
      "Good typing skills include both speed and accuracy when using a keyboard.",
      "Keterampilan mengetik yang baik mencakup kecepatan dan ketepatan saat menggunakan keyboard.",
      "Yes",
    ],
    [
      "In Microsoft Word, you cannot change the document margin or paper size.",
      "Di Microsoft Word, kamu tidak bisa mengubah margin dokumen atau ukuran kertas.",
      "No",
    ],
    [
      "Landscape and Portrait are two document orientation options available in Microsoft Word.",
      "Landscape dan Portrait adalah dua pilihan orientasi dokumen yang tersedia di Microsoft Word.",
      "Yes",
    ],
    [
      "Microsoft Word templates can only be used to create blank, empty documents.",
      "Template Microsoft Word hanya bisa digunakan untuk membuat dokumen kosong tanpa format.",
      "No",
    ],
    [
      "Heading 1 and Heading 2 styles help organise the structure of a document in Microsoft Word.",
      "Gaya Heading 1 dan Heading 2 membantu mengorganisir struktur dokumen di Microsoft Word.",
      "Yes",
    ],
    [
      "You can insert pictures, shapes, and WordArt into a Microsoft Word document.",
      "Kamu bisa menyisipkan gambar, bentuk, dan WordArt ke dalam dokumen Microsoft Word.",
      "Yes",
    ],
    [
      "The keyboard shortcut Ctrl+H opens the Find and Replace dialog in Microsoft Word.",
      "Pintasan keyboard Ctrl+H membuka dialog Temukan dan Ganti di Microsoft Word.",
      "Yes",
    ],
    [
      "Microsoft Word 365 online does not allow multiple users to edit the same document at the same time.",
      "Microsoft Word 365 online tidak mengizinkan beberapa pengguna mengedit dokumen yang sama secara bersamaan.",
      "No",
    ],
    [
      "You can add comments to specific paragraphs in a shared Microsoft Word document.",
      "Kamu bisa menambahkan komentar pada paragraf tertentu dalam dokumen Microsoft Word yang dibagikan.",
      "Yes",
    ],
    [
      "Microsoft Word's spell checker can only check English — it cannot check Bahasa Indonesia.",
      "Pemeriksa ejaan Microsoft Word hanya bisa memeriksa Bahasa Inggris — tidak bisa memeriksa Bahasa Indonesia.",
      "No",
    ],
    [
      "In Microsoft Word, you can adjust line spacing and add bullet points to a paragraph.",
      "Di Microsoft Word, kamu bisa mengatur spasi baris dan menambahkan poin-poin bullet pada paragraf.",
      "Yes",
    ],
    [
      "Microsoft Word allows you to export and save a document directly as a PDF file.",
      "Microsoft Word memungkinkan kamu mengekspor dan menyimpan dokumen langsung sebagai file PDF.",
      "Yes",
    ],
    [
      "Track Changes in Microsoft Word automatically accepts all revisions without letting you review them.",
      "Lacak Perubahan di Microsoft Word secara otomatis menerima semua revisi tanpa membiarkanmu meninjaunya.",
      "No",
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
    ok:        true,
    module:    modules[0].title,
    moduleId,
    quizId:    quiz.id,
    questions: seeded,
  });
}
