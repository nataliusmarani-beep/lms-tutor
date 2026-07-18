-- ============================================================
-- fill-lesson-clips-module-7-8.sql
-- Fills every still-empty lesson clip (video_url IS NULL) in Module 7
-- (Microsoft Forms) and Module 8 (Microsoft Teams) by matching each clip's
-- label to the best topic, setting its EN video (and ID video where one
-- exists; otherwise ChecklistSection falls back to the English video for
-- Indonesian viewers) plus a bilingual practice task. Idempotent.
-- Run in the Supabase SQL Editor.
-- ============================================================
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS video_url        TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS video_url_id     TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS practice_task    TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS practice_task_id TEXT;
DO $$
DECLARE v_mod UUID;
BEGIN
  -- Module 7 · Microsoft Forms & Digital Assessment
  SELECT m.id INTO v_mod FROM course_modules m JOIN courses c ON c.id=m.course_id
   WHERE c.title='Microsoft Digital Skills for University Prep' AND m.title LIKE 'Microsoft Forms%' LIMIT 1;
  IF v_mod IS NULL THEN RAISE EXCEPTION 'module not found'; END IF;
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=tlo4QUAhzgU', practice_task='Add branching so one answer skips to a later question.', practice_task_id='Tambahkan percabangan agar satu jawaban melompat ke pertanyaan berikutnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%branching%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=tlo4QUAhzgU', practice_task='Add branching so one answer skips to a later question.', practice_task_id='Tambahkan percabangan agar satu jawaban melompat ke pertanyaan berikutnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%logic%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=tlo4QUAhzgU', practice_task='Add branching so one answer skips to a later question.', practice_task_id='Tambahkan percabangan agar satu jawaban melompat ke pertanyaan berikutnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%percabangan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=vyEYe0_6o6Y', practice_task='Open the responses in Excel for further analysis.', practice_task_id='Buka respons di Excel untuk dianalisis lebih lanjut.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%export%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=vyEYe0_6o6Y', practice_task='Open the responses in Excel for further analysis.', practice_task_id='Buka respons di Excel untuk dianalisis lebih lanjut.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%excel%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=vyEYe0_6o6Y', practice_task='Open the responses in Excel for further analysis.', practice_task_id='Buka respons di Excel untuk dianalisis lebih lanjut.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%ekspor%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MT9BuOI7ook', video_url_id='https://www.youtube.com/watch?v=vaaXcc1tCOo', practice_task='Turn your form into a quiz with correct answers and points.', practice_task_id='Ubah formulirmu menjadi kuis dengan jawaban benar dan poin.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%quiz%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MT9BuOI7ook', video_url_id='https://www.youtube.com/watch?v=vaaXcc1tCOo', practice_task='Turn your form into a quiz with correct answers and points.', practice_task_id='Ubah formulirmu menjadi kuis dengan jawaban benar dan poin.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%kuis%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MT9BuOI7ook', video_url_id='https://www.youtube.com/watch?v=vaaXcc1tCOo', practice_task='Turn your form into a quiz with correct answers and points.', practice_task_id='Ubah formulirmu menjadi kuis dengan jawaban benar dan poin.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%points%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MT9BuOI7ook', video_url_id='https://www.youtube.com/watch?v=vaaXcc1tCOo', practice_task='Turn your form into a quiz with correct answers and points.', practice_task_id='Ubah formulirmu menjadi kuis dengan jawaban benar dan poin.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%correct answer%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MT9BuOI7ook', video_url_id='https://www.youtube.com/watch?v=vaaXcc1tCOo', practice_task='Turn your form into a quiz with correct answers and points.', practice_task_id='Ubah formulirmu menjadi kuis dengan jawaban benar dan poin.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%soal%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=IFzBv6mN6ts', practice_task='Add a choice question, a text question, and a rating question.', practice_task_id='Tambahkan pertanyaan pilihan, teks, dan rating.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%question type%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=IFzBv6mN6ts', practice_task='Add a choice question, a text question, and a rating question.', practice_task_id='Tambahkan pertanyaan pilihan, teks, dan rating.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%different question%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=IFzBv6mN6ts', practice_task='Add a choice question, a text question, and a rating question.', practice_task_id='Tambahkan pertanyaan pilihan, teks, dan rating.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%jenis pertanyaan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=cbmADc6X9GE', practice_task='Change the form''s theme or background.', practice_task_id='Ubah tema atau latar formulirmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%theme%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=cbmADc6X9GE', practice_task='Change the form''s theme or background.', practice_task_id='Ubah tema atau latar formulirmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%design%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=cbmADc6X9GE', practice_task='Change the form''s theme or background.', practice_task_id='Ubah tema atau latar formulirmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%tema%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=p3s826treHg', video_url_id='https://www.youtube.com/watch?v=EDJDcKlCUVo', practice_task='Share the form via a link and open the Responses tab.', practice_task_id='Bagikan formulir lewat tautan dan buka tab Responses.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%summary%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=p3s826treHg', video_url_id='https://www.youtube.com/watch?v=EDJDcKlCUVo', practice_task='Share the form via a link and open the Responses tab.', practice_task_id='Bagikan formulir lewat tautan dan buka tab Responses.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%responses%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=p3s826treHg', video_url_id='https://www.youtube.com/watch?v=EDJDcKlCUVo', practice_task='Share the form via a link and open the Responses tab.', practice_task_id='Bagikan formulir lewat tautan dan buka tab Responses.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%response%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=p3s826treHg', video_url_id='https://www.youtube.com/watch?v=EDJDcKlCUVo', practice_task='Share the form via a link and open the Responses tab.', practice_task_id='Bagikan formulir lewat tautan dan buka tab Responses.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%collected%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=p3s826treHg', video_url_id='https://www.youtube.com/watch?v=EDJDcKlCUVo', practice_task='Share the form via a link and open the Responses tab.', practice_task_id='Bagikan formulir lewat tautan dan buka tab Responses.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%share%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=p3s826treHg', video_url_id='https://www.youtube.com/watch?v=EDJDcKlCUVo', practice_task='Share the form via a link and open the Responses tab.', practice_task_id='Bagikan formulir lewat tautan dan buka tab Responses.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%link%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=p3s826treHg', video_url_id='https://www.youtube.com/watch?v=EDJDcKlCUVo', practice_task='Share the form via a link and open the Responses tab.', practice_task_id='Bagikan formulir lewat tautan dan buka tab Responses.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%respons%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=p3s826treHg', video_url_id='https://www.youtube.com/watch?v=EDJDcKlCUVo', practice_task='Share the form via a link and open the Responses tab.', practice_task_id='Bagikan formulir lewat tautan dan buka tab Responses.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%bagikan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=V--z5Nx_sZo', video_url_id='https://www.youtube.com/watch?v=sdO9rCtWEeE', practice_task='Create a form and add three questions.', practice_task_id='Buat sebuah formulir dan tambahkan tiga pertanyaan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%create%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=V--z5Nx_sZo', video_url_id='https://www.youtube.com/watch?v=sdO9rCtWEeE', practice_task='Create a form and add three questions.', practice_task_id='Buat sebuah formulir dan tambahkan tiga pertanyaan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%form%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=V--z5Nx_sZo', video_url_id='https://www.youtube.com/watch?v=sdO9rCtWEeE', practice_task='Create a form and add three questions.', practice_task_id='Buat sebuah formulir dan tambahkan tiga pertanyaan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%formulir%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=V--z5Nx_sZo', video_url_id='https://www.youtube.com/watch?v=sdO9rCtWEeE', practice_task='Create a form and add three questions.', practice_task_id='Buat sebuah formulir dan tambahkan tiga pertanyaan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%membuat%';

  -- Module 8 · Digital Workflow & Microsoft Teams
  SELECT m.id INTO v_mod FROM course_modules m JOIN courses c ON c.id=m.course_id
   WHERE c.title='Microsoft Digital Skills for University Prep' AND m.title LIKE '%Microsoft Teams%' LIMIT 1;
  IF v_mod IS NULL THEN RAISE EXCEPTION 'module not found'; END IF;
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=hhhQEJF9xOo', practice_task='Open the Assignments tab and turn in an assignment.', practice_task_id='Buka tab Assignments dan kumpulkan sebuah tugas.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%assignment%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=hhhQEJF9xOo', practice_task='Open the Assignments tab and turn in an assignment.', practice_task_id='Buka tab Assignments dan kumpulkan sebuah tugas.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%submit%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=hhhQEJF9xOo', practice_task='Open the Assignments tab and turn in an assignment.', practice_task_id='Buka tab Assignments dan kumpulkan sebuah tugas.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%turn in%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=hhhQEJF9xOo', practice_task='Open the Assignments tab and turn in an assignment.', practice_task_id='Buka tab Assignments dan kumpulkan sebuah tugas.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%tugas%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=eNBYv0-GnqM', video_url_id='https://www.youtube.com/watch?v=EXWkJlJQNvM', practice_task='Schedule a Teams meeting and invite a classmate.', practice_task_id='Jadwalkan rapat Teams dan undang seorang teman.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%schedule%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=eNBYv0-GnqM', video_url_id='https://www.youtube.com/watch?v=EXWkJlJQNvM', practice_task='Schedule a Teams meeting and invite a classmate.', practice_task_id='Jadwalkan rapat Teams dan undang seorang teman.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%meeting%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=eNBYv0-GnqM', video_url_id='https://www.youtube.com/watch?v=EXWkJlJQNvM', practice_task='Schedule a Teams meeting and invite a classmate.', practice_task_id='Jadwalkan rapat Teams dan undang seorang teman.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%rapat%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=eNBYv0-GnqM', video_url_id='https://www.youtube.com/watch?v=EXWkJlJQNvM', practice_task='Schedule a Teams meeting and invite a classmate.', practice_task_id='Jadwalkan rapat Teams dan undang seorang teman.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%jadwal%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=3xqEuSQBBxo', video_url_id='https://www.youtube.com/watch?v=YKysrDTkJYQ', practice_task='Share a file in a channel conversation.', practice_task_id='Bagikan sebuah file di percakapan channel.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%share a file%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=3xqEuSQBBxo', video_url_id='https://www.youtube.com/watch?v=YKysrDTkJYQ', practice_task='Share a file in a channel conversation.', practice_task_id='Bagikan sebuah file di percakapan channel.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%shared a file%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=3xqEuSQBBxo', video_url_id='https://www.youtube.com/watch?v=YKysrDTkJYQ', practice_task='Share a file in a channel conversation.', practice_task_id='Bagikan sebuah file di percakapan channel.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%share file%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=3xqEuSQBBxo', video_url_id='https://www.youtube.com/watch?v=YKysrDTkJYQ', practice_task='Share a file in a channel conversation.', practice_task_id='Bagikan sebuah file di percakapan channel.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%berbagi file%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=3xqEuSQBBxo', video_url_id='https://www.youtube.com/watch?v=YKysrDTkJYQ', practice_task='Share a file in a channel conversation.', practice_task_id='Bagikan sebuah file di percakapan channel.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%file%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=bLI8IMxXY2I', practice_task='Set Do Not Disturb and pin an important chat.', practice_task_id='Atur Do Not Disturb dan sematkan chat penting.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%do not disturb%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=bLI8IMxXY2I', practice_task='Set Do Not Disturb and pin an important chat.', practice_task_id='Atur Do Not Disturb dan sematkan chat penting.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%productivity%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=bLI8IMxXY2I', practice_task='Set Do Not Disturb and pin an important chat.', practice_task_id='Atur Do Not Disturb dan sematkan chat penting.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%pinned%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=bLI8IMxXY2I', practice_task='Set Do Not Disturb and pin an important chat.', practice_task_id='Atur Do Not Disturb dan sematkan chat penting.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%notification%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=bLI8IMxXY2I', practice_task='Set Do Not Disturb and pin an important chat.', practice_task_id='Atur Do Not Disturb dan sematkan chat penting.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%shortcut%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=bLI8IMxXY2I', practice_task='Set Do Not Disturb and pin an important chat.', practice_task_id='Atur Do Not Disturb dan sematkan chat penting.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%produktivitas%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=QhjXzpiUKxc', practice_task='Join a meeting and share your screen.', practice_task_id='Bergabung ke rapat dan bagikan layarmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%share screen%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=QhjXzpiUKxc', practice_task='Join a meeting and share your screen.', practice_task_id='Bergabung ke rapat dan bagikan layarmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%share your screen%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=QhjXzpiUKxc', practice_task='Join a meeting and share your screen.', practice_task_id='Bergabung ke rapat dan bagikan layarmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%join%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=QhjXzpiUKxc', practice_task='Join a meeting and share your screen.', practice_task_id='Bergabung ke rapat dan bagikan layarmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%screen%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=QhjXzpiUKxc', practice_task='Join a meeting and share your screen.', practice_task_id='Bergabung ke rapat dan bagikan layarmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%layar%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=BLsgK_MyIOw', practice_task='Use @mention and add a reaction to a message.', practice_task_id='Gunakan @mention dan beri reaksi pada sebuah pesan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%mention%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=BLsgK_MyIOw', practice_task='Use @mention and add a reaction to a message.', practice_task_id='Gunakan @mention dan beri reaksi pada sebuah pesan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%reaction%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=BLsgK_MyIOw', practice_task='Use @mention and add a reaction to a message.', practice_task_id='Gunakan @mention dan beri reaksi pada sebuah pesan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%react%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=BLsgK_MyIOw', practice_task='Use @mention and add a reaction to a message.', practice_task_id='Gunakan @mention dan beri reaksi pada sebuah pesan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%reaksi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=CNAF3NBvtPM', practice_task='Post a message in a channel and reply to one.', practice_task_id='Kirim pesan di channel dan balas satu pesan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%post%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=CNAF3NBvtPM', practice_task='Post a message in a channel and reply to one.', practice_task_id='Kirim pesan di channel dan balas satu pesan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%message%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=CNAF3NBvtPM', practice_task='Post a message in a channel and reply to one.', practice_task_id='Kirim pesan di channel dan balas satu pesan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%reply%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=CNAF3NBvtPM', practice_task='Post a message in a channel and reply to one.', practice_task_id='Kirim pesan di channel dan balas satu pesan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%pesan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=CNAF3NBvtPM', practice_task='Post a message in a channel and reply to one.', practice_task_id='Kirim pesan di channel dan balas satu pesan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%balas%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=hceM4FnYv7Y', video_url_id='https://www.youtube.com/watch?v=3x_tCX_TNHw', practice_task='Find a team and open its channels.', practice_task_id='Temukan sebuah tim dan buka channel-nya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%channel%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=hceM4FnYv7Y', video_url_id='https://www.youtube.com/watch?v=3x_tCX_TNHw', practice_task='Find a team and open its channels.', practice_task_id='Temukan sebuah tim dan buka channel-nya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%team%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=hceM4FnYv7Y', video_url_id='https://www.youtube.com/watch?v=3x_tCX_TNHw', practice_task='Find a team and open its channels.', practice_task_id='Temukan sebuah tim dan buka channel-nya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%navigat%';
  RAISE NOTICE 'Filled Module 7 & 8 lesson clips by label match.';
END $$;

SELECT m.title AS module, i.item_key, i.label
  FROM module_checklist_items i JOIN course_modules m ON m.id=i.course_module_id
 WHERE m.course_id=(SELECT id FROM courses WHERE title='Microsoft Digital Skills for University Prep')
   AND i.item_type='student' AND i.video_url IS NULL
   AND (m.title LIKE 'Microsoft Forms%' OR m.title LIKE '%Microsoft Teams%')
 ORDER BY m.title, i.sort_order;
