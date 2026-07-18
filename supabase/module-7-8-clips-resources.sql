-- ============================================================
-- module-7-8-clips-resources.sql
-- EN + ID video resources (Materi) for Module 7 "Microsoft Forms & Digital
-- Assessment" and Module 8 "Digital Workflow & Microsoft Teams" of the
-- Digital Skills course. Microsoft Forms/Teams have thin Indonesian video
-- coverage, so 9 of 15 topics have an English video only (no ID pair);
-- the 6 with a genuine Bahasa Indonesia video get the "ID ·" resource too.
-- All videos oEmbed-verified. Idempotent (delete-by-prefix). Run in SQL Editor.
-- ============================================================
DO $$
DECLARE v_mod UUID;
BEGIN
  -- Module 7
  SELECT m.id INTO v_mod FROM course_modules m JOIN courses c ON c.id=m.course_id
   WHERE c.title='Microsoft Digital Skills for University Prep' AND m.title LIKE 'Microsoft Forms%' LIMIT 1;
  IF v_mod IS NULL THEN RAISE EXCEPTION 'module not found'; END IF;
  DELETE FROM module_resources WHERE course_module_id=v_mod AND (title LIKE 'Building Forms · %' OR title LIKE 'Responses · %' OR title LIKE 'ID · %');
  INSERT INTO module_resources (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod, 'video', 'Building Forms · Create a form and add questions', 'https://www.youtube.com/watch?v=V--z5Nx_sZo', 'Create a form and add three questions.', 1),
    (v_mod, 'video', 'ID · Membuat Formulir · Membuat formulir dan menambah pertanyaan', 'https://www.youtube.com/watch?v=sdO9rCtWEeE', 'Buat sebuah formulir dan tambahkan tiga pertanyaan.', 2),
    (v_mod, 'video', 'Building Forms · Question types (choice, text, rating)', 'https://www.youtube.com/watch?v=IFzBv6mN6ts', 'Add a choice question, a text question, and a rating question.', 3),
    (v_mod, 'video', 'Building Forms · Branching logic', 'https://www.youtube.com/watch?v=tlo4QUAhzgU', 'Add branching so one answer skips to a later question.', 4),
    (v_mod, 'video', 'Building Forms · Make a quiz (answers and points)', 'https://www.youtube.com/watch?v=MT9BuOI7ook', 'Turn your form into a quiz with correct answers and points.', 5),
    (v_mod, 'video', 'ID · Membuat Formulir · Membuat kuis (jawaban dan poin)', 'https://www.youtube.com/watch?v=vaaXcc1tCOo', 'Ubah formulirmu menjadi kuis dengan jawaban benar dan poin.', 6),
    (v_mod, 'video', 'Building Forms · Customise the theme', 'https://www.youtube.com/watch?v=cbmADc6X9GE', 'Change the form''s theme or background.', 7),
    (v_mod, 'video', 'Responses · Share the form and view responses', 'https://www.youtube.com/watch?v=p3s826treHg', 'Share the form via a link and open the Responses tab.', 8),
    (v_mod, 'video', 'ID · Respons · Membagikan formulir dan melihat respons', 'https://www.youtube.com/watch?v=EDJDcKlCUVo', 'Bagikan formulir lewat tautan dan buka tab Responses.', 9),
    (v_mod, 'video', 'Responses · Export responses to Excel', 'https://www.youtube.com/watch?v=vyEYe0_6o6Y', 'Open the responses in Excel for further analysis.', 10);

  -- Module 8
  SELECT m.id INTO v_mod FROM course_modules m JOIN courses c ON c.id=m.course_id
   WHERE c.title='Microsoft Digital Skills for University Prep' AND m.title LIKE '%Microsoft Teams%' LIMIT 1;
  IF v_mod IS NULL THEN RAISE EXCEPTION 'module not found'; END IF;
  DELETE FROM module_resources WHERE course_module_id=v_mod AND (title LIKE 'Teams & Channels · %' OR title LIKE 'Meetings & Work · %' OR title LIKE 'ID · %');
  INSERT INTO module_resources (course_module_id, resource_type, title, url, description, sort_order) VALUES
    (v_mod, 'video', 'Teams & Channels · Teams and channels', 'https://www.youtube.com/watch?v=hceM4FnYv7Y', 'Find a team and open its channels.', 1),
    (v_mod, 'video', 'ID · Tim & Channel · Tim dan channel', 'https://www.youtube.com/watch?v=3x_tCX_TNHw', 'Temukan sebuah tim dan buka channel-nya.', 2),
    (v_mod, 'video', 'Teams & Channels · Post messages and replies', 'https://www.youtube.com/watch?v=CNAF3NBvtPM', 'Post a message in a channel and reply to one.', 3),
    (v_mod, 'video', 'Teams & Channels · Mentions and reactions', 'https://www.youtube.com/watch?v=BLsgK_MyIOw', 'Use @mention and add a reaction to a message.', 4),
    (v_mod, 'video', 'Teams & Channels · Share files in a channel', 'https://www.youtube.com/watch?v=3xqEuSQBBxo', 'Share a file in a channel conversation.', 5),
    (v_mod, 'video', 'ID · Tim & Channel · Berbagi file di channel', 'https://www.youtube.com/watch?v=YKysrDTkJYQ', 'Bagikan sebuah file di percakapan channel.', 6),
    (v_mod, 'video', 'Meetings & Work · Schedule a meeting', 'https://www.youtube.com/watch?v=eNBYv0-GnqM', 'Schedule a Teams meeting and invite a classmate.', 7),
    (v_mod, 'video', 'ID · Rapat & Kerja · Menjadwalkan rapat', 'https://www.youtube.com/watch?v=EXWkJlJQNvM', 'Jadwalkan rapat Teams dan undang seorang teman.', 8),
    (v_mod, 'video', 'Meetings & Work · Join a meeting and share your screen', 'https://www.youtube.com/watch?v=QhjXzpiUKxc', 'Join a meeting and share your screen.', 9),
    (v_mod, 'video', 'Meetings & Work · Assignments (turn in work)', 'https://www.youtube.com/watch?v=hhhQEJF9xOo', 'Open the Assignments tab and turn in an assignment.', 10),
    (v_mod, 'video', 'Meetings & Work · Productivity tips (Do Not Disturb)', 'https://www.youtube.com/watch?v=bLI8IMxXY2I', 'Set Do Not Disturb and pin an important chat.', 11);
  RAISE NOTICE 'Added Module 7 & 8 video resources.';
END $$;
