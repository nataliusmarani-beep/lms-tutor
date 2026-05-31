-- ============================================================
-- Seed: Checklist Knowledge Check – Microsoft Word
-- 13 bilingual Yes/No questions based on the student checklist
-- Run in Supabase SQL Editor (adjust module_id if needed)
-- ============================================================

DO $$
DECLARE
  v_module_id   UUID;
  v_quiz_id     UUID;
  v_question_id UUID;
  v_sort        INT := 0;
BEGIN

  -- ── Find the Microsoft Word module ──────────────────────────────────────
  SELECT id INTO v_module_id
  FROM course_modules
  WHERE title ILIKE '%Microsoft Word%'
     OR title ILIKE '%Word for Beginner%'
  ORDER BY created_at
  LIMIT 1;

  IF v_module_id IS NULL THEN
    RAISE EXCEPTION 'Microsoft Word module not found';
  END IF;

  -- ── Guard: skip if quiz already exists ──────────────────────────────────
  IF EXISTS (
    SELECT 1 FROM module_quizzes
    WHERE course_module_id = v_module_id
      AND title ILIKE '%Checklist Knowledge Check%'
  ) THEN
    RAISE NOTICE 'Quiz already exists — skipping.';
    RETURN;
  END IF;

  -- ── Create the quiz ─────────────────────────────────────────────────────
  INSERT INTO module_quizzes (course_module_id, title, description, sort_order)
  VALUES (
    v_module_id,
    'Checklist Knowledge Check – Microsoft Word',
    'Test your understanding of the skills covered in this module. Answer Yes or No! | Uji pemahamanmu tentang keterampilan dalam modul ini. Jawab Ya atau Tidak!',
    COALESCE((SELECT MAX(sort_order) FROM module_quizzes WHERE course_module_id = v_module_id), -1) + 1
  )
  RETURNING id INTO v_quiz_id;

  -- ── Helper: insert one yes_no question + options ─────────────────────────
  -- Q1
  INSERT INTO quiz_questions (quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_quiz_id, 'yes_no',
    'Good typing skills include both speed and accuracy when using a keyboard.',
    'Keterampilan mengetik yang baik mencakup kecepatan dan ketepatan saat menggunakan keyboard.',
    v_sort) RETURNING id INTO v_question_id;
  INSERT INTO quiz_options (question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (v_question_id, 'Yes', 'Ya',    TRUE,  0),
    (v_question_id, 'No',  'Tidak', FALSE, 1);
  v_sort := v_sort + 1;

  -- Q2
  INSERT INTO quiz_questions (quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_quiz_id, 'yes_no',
    'In Microsoft Word, you cannot change the document margin or paper size.',
    'Di Microsoft Word, kamu tidak bisa mengubah margin dokumen atau ukuran kertas.',
    v_sort) RETURNING id INTO v_question_id;
  INSERT INTO quiz_options (question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (v_question_id, 'Yes', 'Ya',    FALSE, 0),
    (v_question_id, 'No',  'Tidak', TRUE,  1);
  v_sort := v_sort + 1;

  -- Q3
  INSERT INTO quiz_questions (quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_quiz_id, 'yes_no',
    'Landscape and Portrait are two document orientation options available in Microsoft Word.',
    'Landscape dan Portrait adalah dua pilihan orientasi dokumen yang tersedia di Microsoft Word.',
    v_sort) RETURNING id INTO v_question_id;
  INSERT INTO quiz_options (question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (v_question_id, 'Yes', 'Ya',    TRUE,  0),
    (v_question_id, 'No',  'Tidak', FALSE, 1);
  v_sort := v_sort + 1;

  -- Q4
  INSERT INTO quiz_questions (quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_quiz_id, 'yes_no',
    'Microsoft Word templates can only be used to create blank, empty documents.',
    'Template Microsoft Word hanya bisa digunakan untuk membuat dokumen kosong tanpa format.',
    v_sort) RETURNING id INTO v_question_id;
  INSERT INTO quiz_options (question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (v_question_id, 'Yes', 'Ya',    FALSE, 0),
    (v_question_id, 'No',  'Tidak', TRUE,  1);
  v_sort := v_sort + 1;

  -- Q5
  INSERT INTO quiz_questions (quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_quiz_id, 'yes_no',
    'Heading 1 and Heading 2 styles help organise the structure of a document in Microsoft Word.',
    'Gaya Heading 1 dan Heading 2 membantu mengorganisir struktur dokumen di Microsoft Word.',
    v_sort) RETURNING id INTO v_question_id;
  INSERT INTO quiz_options (question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (v_question_id, 'Yes', 'Ya',    TRUE,  0),
    (v_question_id, 'No',  'Tidak', FALSE, 1);
  v_sort := v_sort + 1;

  -- Q6
  INSERT INTO quiz_questions (quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_quiz_id, 'yes_no',
    'You can insert pictures, shapes, and WordArt into a Microsoft Word document.',
    'Kamu bisa menyisipkan gambar, bentuk, dan WordArt ke dalam dokumen Microsoft Word.',
    v_sort) RETURNING id INTO v_question_id;
  INSERT INTO quiz_options (question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (v_question_id, 'Yes', 'Ya',    TRUE,  0),
    (v_question_id, 'No',  'Tidak', FALSE, 1);
  v_sort := v_sort + 1;

  -- Q7
  INSERT INTO quiz_questions (quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_quiz_id, 'yes_no',
    'The keyboard shortcut Ctrl+H opens the Find and Replace dialog in Microsoft Word.',
    'Pintasan keyboard Ctrl+H membuka dialog Temukan dan Ganti di Microsoft Word.',
    v_sort) RETURNING id INTO v_question_id;
  INSERT INTO quiz_options (question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (v_question_id, 'Yes', 'Ya',    TRUE,  0),
    (v_question_id, 'No',  'Tidak', FALSE, 1);
  v_sort := v_sort + 1;

  -- Q8
  INSERT INTO quiz_questions (quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_quiz_id, 'yes_no',
    'Microsoft Word 365 online does not allow multiple users to edit the same document at the same time.',
    'Microsoft Word 365 online tidak mengizinkan beberapa pengguna mengedit dokumen yang sama secara bersamaan.',
    v_sort) RETURNING id INTO v_question_id;
  INSERT INTO quiz_options (question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (v_question_id, 'Yes', 'Ya',    FALSE, 0),
    (v_question_id, 'No',  'Tidak', TRUE,  1);
  v_sort := v_sort + 1;

  -- Q9
  INSERT INTO quiz_questions (quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_quiz_id, 'yes_no',
    'You can add comments to specific paragraphs in a shared Microsoft Word document.',
    'Kamu bisa menambahkan komentar pada paragraf tertentu dalam dokumen Microsoft Word yang dibagikan.',
    v_sort) RETURNING id INTO v_question_id;
  INSERT INTO quiz_options (question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (v_question_id, 'Yes', 'Ya',    TRUE,  0),
    (v_question_id, 'No',  'Tidak', FALSE, 1);
  v_sort := v_sort + 1;

  -- Q10
  INSERT INTO quiz_questions (quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_quiz_id, 'yes_no',
    'Microsoft Word''s spell checker can only check English — it cannot check Bahasa Indonesia.',
    'Pemeriksa ejaan Microsoft Word hanya bisa memeriksa Bahasa Inggris — tidak bisa memeriksa Bahasa Indonesia.',
    v_sort) RETURNING id INTO v_question_id;
  INSERT INTO quiz_options (question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (v_question_id, 'Yes', 'Ya',    FALSE, 0),
    (v_question_id, 'No',  'Tidak', TRUE,  1);
  v_sort := v_sort + 1;

  -- Q11
  INSERT INTO quiz_questions (quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_quiz_id, 'yes_no',
    'In Microsoft Word, you can adjust line spacing and add bullet points to a paragraph.',
    'Di Microsoft Word, kamu bisa mengatur spasi baris dan menambahkan poin-poin bullet pada paragraf.',
    v_sort) RETURNING id INTO v_question_id;
  INSERT INTO quiz_options (question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (v_question_id, 'Yes', 'Ya',    TRUE,  0),
    (v_question_id, 'No',  'Tidak', FALSE, 1);
  v_sort := v_sort + 1;

  -- Q12
  INSERT INTO quiz_questions (quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_quiz_id, 'yes_no',
    'Microsoft Word allows you to export and save a document directly as a PDF file.',
    'Microsoft Word memungkinkan kamu mengekspor dan menyimpan dokumen langsung sebagai file PDF.',
    v_sort) RETURNING id INTO v_question_id;
  INSERT INTO quiz_options (question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (v_question_id, 'Yes', 'Ya',    TRUE,  0),
    (v_question_id, 'No',  'Tidak', FALSE, 1);
  v_sort := v_sort + 1;

  -- Q13
  INSERT INTO quiz_questions (quiz_id, question_type, question_text, question_text_id, sort_order)
  VALUES (v_quiz_id, 'yes_no',
    'Track Changes in Microsoft Word automatically accepts all revisions without letting you review them.',
    'Lacak Perubahan di Microsoft Word secara otomatis menerima semua revisi tanpa membiarkanmu meninjaunya.',
    v_sort) RETURNING id INTO v_question_id;
  INSERT INTO quiz_options (question_id, option_text, option_text_id, is_correct, sort_order) VALUES
    (v_question_id, 'Yes', 'Ya',    FALSE, 0),
    (v_question_id, 'No',  'Tidak', TRUE,  1);

  RAISE NOTICE 'Quiz seeded: % (module: %)', v_quiz_id, v_module_id;
END $$;
