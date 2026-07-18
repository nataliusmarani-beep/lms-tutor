-- ============================================================
-- fill-remaining-lesson-clips-ppt-onedrive.sql
-- Same label-match fill as fill-remaining-lesson-clips.sql, for the
-- PowerPoint (Module 5) and OneDrive (Module 6) modules. Fills every
-- still-empty lesson clip (video_url IS NULL) by matching its label to the
-- best topic and setting that topic's EN + ID video + practice task.
-- All videos oEmbed-verified. Idempotent. Run in the Supabase SQL Editor.
-- ============================================================

ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS video_url        TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS video_url_id     TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS practice_task    TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS practice_task_id TEXT;

DO $$
DECLARE v_mod UUID;
BEGIN
  -- Module 5 · PowerPoint
  SELECT m.id INTO v_mod FROM course_modules m JOIN courses c ON c.id=m.course_id
   WHERE c.title='Microsoft Digital Skills for University Prep' AND m.title LIKE 'Microsoft PowerPoint%' LIMIT 1;
  IF v_mod IS NULL THEN RAISE NOTICE 'PowerPoint module not found'; ELSE
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=QiVSIvB1xis', video_url_id='https://www.youtube.com/watch?v=HB-xyEgYyoA', practice_task='Open Slide Master and change the title font once — check that every slide updates.', practice_task_id='Buka Slide Master dan ubah font judul sekali — periksa semua slide ikut berubah.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%slide master%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=QiVSIvB1xis', video_url_id='https://www.youtube.com/watch?v=HB-xyEgYyoA', practice_task='Open Slide Master and change the title font once — check that every slide updates.', practice_task_id='Buka Slide Master dan ubah font judul sekali — periksa semua slide ikut berubah.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%master slide%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7Z1xdPb3-qw', video_url_id='https://www.youtube.com/watch?v=4L7gV0nQEpQ', practice_task='Change the theme''s font and colour set, and see how the whole deck follows.', practice_task_id='Ubah set font dan warna tema, lalu lihat bagaimana seluruh presentasi mengikuti.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%theme color%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7Z1xdPb3-qw', video_url_id='https://www.youtube.com/watch?v=4L7gV0nQEpQ', practice_task='Change the theme''s font and colour set, and see how the whole deck follows.', practice_task_id='Ubah set font dan warna tema, lalu lihat bagaimana seluruh presentasi mengikuti.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%theme font%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7Z1xdPb3-qw', video_url_id='https://www.youtube.com/watch?v=4L7gV0nQEpQ', practice_task='Change the theme''s font and colour set, and see how the whole deck follows.', practice_task_id='Ubah set font dan warna tema, lalu lihat bagaimana seluruh presentasi mengikuti.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%warna tema%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7Z1xdPb3-qw', video_url_id='https://www.youtube.com/watch?v=4L7gV0nQEpQ', practice_task='Change the theme''s font and colour set, and see how the whole deck follows.', practice_task_id='Ubah set font dan warna tema, lalu lihat bagaimana seluruh presentasi mengikuti.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%font tema%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=UH7Gzjd3rGA', video_url_id='https://www.youtube.com/watch?v=rMAFRobkb_U', practice_task='Apply a theme to your deck, then try a different colour variant of it.', practice_task_id='Terapkan sebuah tema ke presentasimu, lalu coba varian warna yang berbeda.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%theme%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=UH7Gzjd3rGA', video_url_id='https://www.youtube.com/watch?v=rMAFRobkb_U', practice_task='Apply a theme to your deck, then try a different colour variant of it.', practice_task_id='Terapkan sebuah tema ke presentasimu, lalu coba varian warna yang berbeda.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%variant%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=UH7Gzjd3rGA', video_url_id='https://www.youtube.com/watch?v=rMAFRobkb_U', practice_task='Apply a theme to your deck, then try a different colour variant of it.', practice_task_id='Terapkan sebuah tema ke presentasimu, lalu coba varian warna yang berbeda.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%tema%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=f2mtp3SEWEg', video_url_id='https://www.youtube.com/watch?v=pLuhy0shbeA', practice_task='Insert a photo of a person or object and remove its background.', practice_task_id='Sisipkan foto orang atau benda lalu hapus latar belakangnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%remove background%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=f2mtp3SEWEg', video_url_id='https://www.youtube.com/watch?v=pLuhy0shbeA', practice_task='Insert a photo of a person or object and remove its background.', practice_task_id='Sisipkan foto orang atau benda lalu hapus latar belakangnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%hapus background%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=f2mtp3SEWEg', video_url_id='https://www.youtube.com/watch?v=pLuhy0shbeA', practice_task='Insert a photo of a person or object and remove its background.', practice_task_id='Sisipkan foto orang atau benda lalu hapus latar belakangnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%hapus latar%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=1-GbcMG6uh4', video_url_id='https://www.youtube.com/watch?v=zEq_j5LO_nI', practice_task='Give one slide a solid colour background and another a picture background.', practice_task_id='Beri satu slide latar warna solid dan slide lain latar berupa gambar.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%background%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=1-GbcMG6uh4', video_url_id='https://www.youtube.com/watch?v=zEq_j5LO_nI', practice_task='Give one slide a solid colour background and another a picture background.', practice_task_id='Beri satu slide latar warna solid dan slide lain latar berupa gambar.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%latar%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=724rFztvZsY', video_url_id='https://www.youtube.com/watch?v=4uMQm9gHkb8', practice_task='Make a shape travel across the slide using a motion path animation.', practice_task_id='Buat sebuah bentuk bergerak melintasi slide memakai animasi motion path.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%motion path%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=724rFztvZsY', video_url_id='https://www.youtube.com/watch?v=4uMQm9gHkb8', practice_task='Make a shape travel across the slide using a motion path animation.', practice_task_id='Buat sebuah bentuk bergerak melintasi slide memakai animasi motion path.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%jalur gerak%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7u5mQ6rfows', video_url_id='https://www.youtube.com/watch?v=Q_NNjGWCbRI', practice_task='Duplicate a slide, move and resize one shape, then apply Morph between them.', practice_task_id='Gandakan slide, pindahkan dan ubah ukuran satu bentuk, lalu terapkan Morph di antaranya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%morph%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=DAiE41g5DWs', video_url_id='https://www.youtube.com/watch?v=yHNE7IDamDk', practice_task='Open the Animation Pane, reorder two animations, then set one to start After Previous.', practice_task_id='Buka Animation Pane, ubah urutan dua animasi, lalu atur satu menjadi After Previous.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%animation pane%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=DAiE41g5DWs', video_url_id='https://www.youtube.com/watch?v=yHNE7IDamDk', practice_task='Open the Animation Pane, reorder two animations, then set one to start After Previous.', practice_task_id='Buka Animation Pane, ubah urutan dua animasi, lalu atur satu menjadi After Previous.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%timing%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=DAiE41g5DWs', video_url_id='https://www.youtube.com/watch?v=yHNE7IDamDk', practice_task='Open the Animation Pane, reorder two animations, then set one to start After Previous.', practice_task_id='Buka Animation Pane, ubah urutan dua animasi, lalu atur satu menjadi After Previous.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%animation order%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=fd-0_MbUsjg', video_url_id='https://www.youtube.com/watch?v=lcwNFeafSp4', practice_task='Give a title an entrance animation and an image an exit animation.', practice_task_id='Beri judul animasi masuk dan beri gambar animasi keluar.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%entrance%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=fd-0_MbUsjg', video_url_id='https://www.youtube.com/watch?v=lcwNFeafSp4', practice_task='Give a title an entrance animation and an image an exit animation.', practice_task_id='Beri judul animasi masuk dan beri gambar animasi keluar.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%exit%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=fd-0_MbUsjg', video_url_id='https://www.youtube.com/watch?v=lcwNFeafSp4', practice_task='Give a title an entrance animation and an image an exit animation.', practice_task_id='Beri judul animasi masuk dan beri gambar animasi keluar.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%emphasis%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=fd-0_MbUsjg', video_url_id='https://www.youtube.com/watch?v=lcwNFeafSp4', practice_task='Give a title an entrance animation and an image an exit animation.', practice_task_id='Beri judul animasi masuk dan beri gambar animasi keluar.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%animation%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=fd-0_MbUsjg', video_url_id='https://www.youtube.com/watch?v=lcwNFeafSp4', practice_task='Give a title an entrance animation and an image an exit animation.', practice_task_id='Beri judul animasi masuk dan beri gambar animasi keluar.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%animasi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=jNxxU0tpHlQ', video_url_id='https://www.youtube.com/watch?v=kMCFzUVYAqM', practice_task='Apply a transition to one slide, then apply it to all slides.', practice_task_id='Terapkan transisi pada satu slide, lalu terapkan ke semua slide.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%transition%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=jNxxU0tpHlQ', video_url_id='https://www.youtube.com/watch?v=kMCFzUVYAqM', practice_task='Apply a transition to one slide, then apply it to all slides.', practice_task_id='Terapkan transisi pada satu slide, lalu terapkan ke semua slide.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%transisi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=zw_9m2Mqckw', video_url_id='https://www.youtube.com/watch?v=biucj-O2dY0', practice_task='Turn on slide numbers and add a footer with your name to every slide.', practice_task_id='Aktifkan nomor slide dan tambahkan footer berisi namamu di semua slide.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%slide number%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=zw_9m2Mqckw', video_url_id='https://www.youtube.com/watch?v=biucj-O2dY0', practice_task='Turn on slide numbers and add a footer with your name to every slide.', practice_task_id='Aktifkan nomor slide dan tambahkan footer berisi namamu di semua slide.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%header%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=zw_9m2Mqckw', video_url_id='https://www.youtube.com/watch?v=biucj-O2dY0', practice_task='Turn on slide numbers and add a footer with your name to every slide.', practice_task_id='Aktifkan nomor slide dan tambahkan footer berisi namamu di semua slide.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%footer%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=zw_9m2Mqckw', video_url_id='https://www.youtube.com/watch?v=biucj-O2dY0', practice_task='Turn on slide numbers and add a footer with your name to every slide.', practice_task_id='Aktifkan nomor slide dan tambahkan footer berisi namamu di semua slide.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%nomor slide%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=6F6qR5hyI6E', video_url_id='https://www.youtube.com/watch?v=KRxHPwz0WbE', practice_task='Place three shapes, then align them to the top and distribute them evenly.', practice_task_id='Letakkan tiga bentuk, lalu ratakan ke atas dan distribusikan jaraknya merata.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%align%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=6F6qR5hyI6E', video_url_id='https://www.youtube.com/watch?v=KRxHPwz0WbE', practice_task='Place three shapes, then align them to the top and distribute them evenly.', practice_task_id='Letakkan tiga bentuk, lalu ratakan ke atas dan distribusikan jaraknya merata.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%distribute%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=ZQK5O_Xe1kY', video_url_id='https://www.youtube.com/watch?v=WCbxVXlIijE', practice_task='Turn a 3-point bullet list into a SmartArt graphic, then add an icon.', practice_task_id='Ubah daftar 3 poin menjadi grafik SmartArt, lalu tambahkan sebuah ikon.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%smartart%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=ZQK5O_Xe1kY', video_url_id='https://www.youtube.com/watch?v=WCbxVXlIijE', practice_task='Turn a 3-point bullet list into a SmartArt graphic, then add an icon.', practice_task_id='Ubah daftar 3 poin menjadi grafik SmartArt, lalu tambahkan sebuah ikon.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%icon%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=ZQK5O_Xe1kY', video_url_id='https://www.youtube.com/watch?v=WCbxVXlIijE', practice_task='Turn a 3-point bullet list into a SmartArt graphic, then add an icon.', practice_task_id='Ubah daftar 3 poin menjadi grafik SmartArt, lalu tambahkan sebuah ikon.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%ikon%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=yKhF5vhcksk', video_url_id='https://www.youtube.com/watch?v=Hyjw8dNazLM', practice_task='Overlap two shapes and try Union, Subtract, and Intersect on them.', practice_task_id='Tumpuk dua bentuk lalu coba Union, Subtract, dan Intersect.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%merge shape%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=yKhF5vhcksk', video_url_id='https://www.youtube.com/watch?v=Hyjw8dNazLM', practice_task='Overlap two shapes and try Union, Subtract, and Intersect on them.', practice_task_id='Tumpuk dua bentuk lalu coba Union, Subtract, dan Intersect.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%shape%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=yKhF5vhcksk', video_url_id='https://www.youtube.com/watch?v=Hyjw8dNazLM', practice_task='Overlap two shapes and try Union, Subtract, and Intersect on them.', practice_task_id='Tumpuk dua bentuk lalu coba Union, Subtract, dan Intersect.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%bentuk%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=DMBjDPrcWF0', video_url_id='https://www.youtube.com/watch?v=26JqD-uDluU', practice_task='Insert a column chart and edit its data to show three months of sales.', practice_task_id='Sisipkan grafik kolom dan ubah datanya untuk menampilkan penjualan tiga bulan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%chart%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=DMBjDPrcWF0', video_url_id='https://www.youtube.com/watch?v=26JqD-uDluU', practice_task='Insert a column chart and edit its data to show three months of sales.', practice_task_id='Sisipkan grafik kolom dan ubah datanya untuk menampilkan penjualan tiga bulan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%grafik%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=DMBjDPrcWF0', video_url_id='https://www.youtube.com/watch?v=26JqD-uDluU', practice_task='Insert a column chart and edit its data to show three months of sales.', practice_task_id='Sisipkan grafik kolom dan ubah datanya untuk menampilkan penjualan tiga bulan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%graph%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=PnlpjsEMikM', video_url_id='https://www.youtube.com/watch?v=XJ3bQrhGtD0', practice_task='Insert a 3x4 table and apply a table style to it.', practice_task_id='Sisipkan tabel 3x4 dan terapkan satu table style padanya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%table%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=PnlpjsEMikM', video_url_id='https://www.youtube.com/watch?v=XJ3bQrhGtD0', practice_task='Insert a 3x4 table and apply a table style to it.', practice_task_id='Sisipkan tabel 3x4 dan terapkan satu table style padanya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%tabel%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=8GQCQiPlfJ0', video_url_id='https://www.youtube.com/watch?v=susNjwgC9kI', practice_task='Insert a photo, crop it to a square, then crop it to a shape.', practice_task_id='Sisipkan foto, potong menjadi persegi, lalu potong mengikuti sebuah bentuk.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%crop%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=8GQCQiPlfJ0', video_url_id='https://www.youtube.com/watch?v=susNjwgC9kI', practice_task='Insert a photo, crop it to a square, then crop it to a shape.', practice_task_id='Sisipkan foto, potong menjadi persegi, lalu potong mengikuti sebuah bentuk.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%picture%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=8GQCQiPlfJ0', video_url_id='https://www.youtube.com/watch?v=susNjwgC9kI', practice_task='Insert a photo, crop it to a square, then crop it to a shape.', practice_task_id='Sisipkan foto, potong menjadi persegi, lalu potong mengikuti sebuah bentuk.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%image%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=8GQCQiPlfJ0', video_url_id='https://www.youtube.com/watch?v=susNjwgC9kI', practice_task='Insert a photo, crop it to a square, then crop it to a shape.', practice_task_id='Sisipkan foto, potong menjadi persegi, lalu potong mengikuti sebuah bentuk.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%gambar%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=X0gH_N2X8cQ', video_url_id='https://www.youtube.com/watch?v=084fXezLy2Y', practice_task='Start a slide show in Presenter View and find the timer and next-slide preview.', practice_task_id='Jalankan slide show dengan Presenter View dan temukan timer serta pratinjau slide berikutnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%presenter%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=X0gH_N2X8cQ', video_url_id='https://www.youtube.com/watch?v=084fXezLy2Y', practice_task='Start a slide show in Presenter View and find the timer and next-slide preview.', practice_task_id='Jalankan slide show dengan Presenter View dan temukan timer serta pratinjau slide berikutnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%slide show%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=X0gH_N2X8cQ', video_url_id='https://www.youtube.com/watch?v=084fXezLy2Y', practice_task='Start a slide show in Presenter View and find the timer and next-slide preview.', practice_task_id='Jalankan slide show dengan Presenter View dan temukan timer serta pratinjau slide berikutnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%presenting%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MIcWwXuIwuU', video_url_id='https://www.youtube.com/watch?v=qfdSM-Cev90', practice_task='Write speaker notes on three slides and read them in Presenter View.', practice_task_id='Tulis catatan pembicara di tiga slide dan baca lewat Presenter View.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%speaker note%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MIcWwXuIwuU', video_url_id='https://www.youtube.com/watch?v=qfdSM-Cev90', practice_task='Write speaker notes on three slides and read them in Presenter View.', practice_task_id='Tulis catatan pembicara di tiga slide dan baca lewat Presenter View.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%notes%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MIcWwXuIwuU', video_url_id='https://www.youtube.com/watch?v=qfdSM-Cev90', practice_task='Write speaker notes on three slides and read them in Presenter View.', practice_task_id='Tulis catatan pembicara di tiga slide dan baca lewat Presenter View.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%catatan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=wjrgHhqO44U', video_url_id='https://www.youtube.com/watch?v=v6XaaXr4qaY', practice_task='Use Rehearse Timings to practise your deck and record how long each slide takes.', practice_task_id='Pakai Rehearse Timings untuk berlatih dan merekam durasi tiap slide.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%rehearse%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=wjrgHhqO44U', video_url_id='https://www.youtube.com/watch?v=v6XaaXr4qaY', practice_task='Use Rehearse Timings to practise your deck and record how long each slide takes.', practice_task_id='Pakai Rehearse Timings untuk berlatih dan merekam durasi tiap slide.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%durasi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=86MZnQYzPYA', video_url_id='https://www.youtube.com/watch?v=JH8rL5RAF6k', practice_task='Export your presentation as an MP4 video and play it back.', practice_task_id='Ekspor presentasimu menjadi video MP4 lalu putar hasilnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%export as video%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=86MZnQYzPYA', video_url_id='https://www.youtube.com/watch?v=JH8rL5RAF6k', practice_task='Export your presentation as an MP4 video and play it back.', practice_task_id='Ekspor presentasimu menjadi video MP4 lalu putar hasilnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%mp4%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=86MZnQYzPYA', video_url_id='https://www.youtube.com/watch?v=JH8rL5RAF6k', practice_task='Export your presentation as an MP4 video and play it back.', practice_task_id='Ekspor presentasimu menjadi video MP4 lalu putar hasilnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%menjadi video%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=86MZnQYzPYA', video_url_id='https://www.youtube.com/watch?v=JH8rL5RAF6k', practice_task='Export your presentation as an MP4 video and play it back.', practice_task_id='Ekspor presentasimu menjadi video MP4 lalu putar hasilnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%jadi video%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=UJBCanWJD0k', video_url_id='https://www.youtube.com/watch?v=lM-oIBjIqo4', practice_task='Insert a short video and set it to start automatically.', practice_task_id='Sisipkan video pendek dan atur agar mulai otomatis.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%video%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=UJBCanWJD0k', video_url_id='https://www.youtube.com/watch?v=lM-oIBjIqo4', practice_task='Insert a short video and set it to start automatically.', practice_task_id='Sisipkan video pendek dan atur agar mulai otomatis.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%audio%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=UJBCanWJD0k', video_url_id='https://www.youtube.com/watch?v=lM-oIBjIqo4', practice_task='Insert a short video and set it to start automatically.', practice_task_id='Sisipkan video pendek dan atur agar mulai otomatis.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%music%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=UJBCanWJD0k', video_url_id='https://www.youtube.com/watch?v=lM-oIBjIqo4', practice_task='Insert a short video and set it to start automatically.', practice_task_id='Sisipkan video pendek dan atur agar mulai otomatis.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%suara%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Itj0ZM93f14', video_url_id='https://www.youtube.com/watch?v=k0IqM7cYud0', practice_task='Use Print to make a handout with 4 slides per page (printing to PDF is fine).', practice_task_id='Pakai Print untuk membuat handout 4 slide per halaman (cetak ke PDF juga boleh).'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%handout%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Itj0ZM93f14', video_url_id='https://www.youtube.com/watch?v=k0IqM7cYud0', practice_task='Use Print to make a handout with 4 slides per page (printing to PDF is fine).', practice_task_id='Pakai Print untuk membuat handout 4 slide per halaman (cetak ke PDF juga boleh).'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%print%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Itj0ZM93f14', video_url_id='https://www.youtube.com/watch?v=k0IqM7cYud0', practice_task='Use Print to make a handout with 4 slides per page (printing to PDF is fine).', practice_task_id='Pakai Print untuk membuat handout 4 slide per halaman (cetak ke PDF juga boleh).'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%cetak%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=fg2JvYheg74', video_url_id='https://www.youtube.com/watch?v=Igrt_tmJubA', practice_task='Export your deck as a PDF and open it to check the slides look right.', practice_task_id='Ekspor presentasimu jadi PDF dan buka untuk memastikan slide tampil benar.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%pdf%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=fg2JvYheg74', video_url_id='https://www.youtube.com/watch?v=Igrt_tmJubA', practice_task='Export your deck as a PDF and open it to check the slides look right.', practice_task_id='Ekspor presentasimu jadi PDF dan buka untuk memastikan slide tampil benar.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%export%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7o9gigXvIlo', video_url_id='https://www.youtube.com/watch?v=FPCtDAtaJXE', practice_task='Split your slides into two sections and give each section a name.', practice_task_id='Bagi slide-mu menjadi dua section dan beri nama masing-masing section.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%section%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Kf-9mWnOx6Y', video_url_id='https://www.youtube.com/watch?v=zrB5Ij6I-Hg', practice_task='Duplicate a slide, drag it to the end, then delete one you do not need.', practice_task_id='Gandakan sebuah slide, seret ke posisi terakhir, lalu hapus slide yang tidak diperlukan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%reorder%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Kf-9mWnOx6Y', video_url_id='https://www.youtube.com/watch?v=zrB5Ij6I-Hg', practice_task='Duplicate a slide, drag it to the end, then delete one you do not need.', practice_task_id='Gandakan sebuah slide, seret ke posisi terakhir, lalu hapus slide yang tidak diperlukan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%duplicate%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Kf-9mWnOx6Y', video_url_id='https://www.youtube.com/watch?v=zrB5Ij6I-Hg', practice_task='Duplicate a slide, drag it to the end, then delete one you do not need.', practice_task_id='Gandakan sebuah slide, seret ke posisi terakhir, lalu hapus slide yang tidak diperlukan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%delete slide%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Kf-9mWnOx6Y', video_url_id='https://www.youtube.com/watch?v=zrB5Ij6I-Hg', practice_task='Duplicate a slide, drag it to the end, then delete one you do not need.', practice_task_id='Gandakan sebuah slide, seret ke posisi terakhir, lalu hapus slide yang tidak diperlukan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%hapus slide%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Kf-9mWnOx6Y', video_url_id='https://www.youtube.com/watch?v=zrB5Ij6I-Hg', practice_task='Duplicate a slide, drag it to the end, then delete one you do not need.', practice_task_id='Gandakan sebuah slide, seret ke posisi terakhir, lalu hapus slide yang tidak diperlukan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%menggandakan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=fhLlISfmGqA', video_url_id='https://www.youtube.com/watch?v=tMeE-GDrFNE', practice_task='Write a 4-point list, then use Tab to demote two of them to a second level.', practice_task_id='Tulis daftar 4 poin, lalu pakai Tab untuk menurunkan dua di antaranya ke level kedua.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%bullet%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=fhLlISfmGqA', video_url_id='https://www.youtube.com/watch?v=tMeE-GDrFNE', practice_task='Write a 4-point list, then use Tab to demote two of them to a second level.', practice_task_id='Tulis daftar 4 poin, lalu pakai Tab untuk menurunkan dua di antaranya ke level kedua.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%poin%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=oKgXeNbKyF4', video_url_id='https://www.youtube.com/watch?v=vzom_kNG3To', practice_task='Add three new slides and give each one a different layout (Title, Title & Content, Blank).', practice_task_id='Tambahkan tiga slide baru dan beri masing-masing layout berbeda (Title, Title & Content, Blank).'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%layout%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=oKgXeNbKyF4', video_url_id='https://www.youtube.com/watch?v=vzom_kNG3To', practice_task='Add three new slides and give each one a different layout (Title, Title & Content, Blank).', practice_task_id='Tambahkan tiga slide baru dan beri masing-masing layout berbeda (Title, Title & Content, Blank).'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%new slide%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=oKgXeNbKyF4', video_url_id='https://www.youtube.com/watch?v=vzom_kNG3To', practice_task='Add three new slides and give each one a different layout (Title, Title & Content, Blank).', practice_task_id='Tambahkan tiga slide baru dan beri masing-masing layout berbeda (Title, Title & Content, Blank).'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%tata letak%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=oKgXeNbKyF4', video_url_id='https://www.youtube.com/watch?v=vzom_kNG3To', practice_task='Add three new slides and give each one a different layout (Title, Title & Content, Blank).', practice_task_id='Tambahkan tiga slide baru dan beri masing-masing layout berbeda (Title, Title & Content, Blank).'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%membuat slide%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=lzJrj8XRqNM', video_url_id='https://www.youtube.com/watch?v=u4ku-XCR9ec', practice_task='Add a text box, type a heading, then change its font, size, and colour.', practice_task_id='Tambahkan kotak teks, ketik sebuah judul, lalu ubah font, ukuran, dan warnanya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%text%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=lzJrj8XRqNM', video_url_id='https://www.youtube.com/watch?v=u4ku-XCR9ec', practice_task='Add a text box, type a heading, then change its font, size, and colour.', practice_task_id='Tambahkan kotak teks, ketik sebuah judul, lalu ubah font, ukuran, dan warnanya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%teks%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=PdUG2o7ocgk', video_url_id='https://www.youtube.com/watch?v=jgG4oQCdl2w', practice_task='Open a blank presentation and point out the ribbon, the slide pane, and the notes pane.', practice_task_id='Buka presentasi kosong dan tunjukkan ribbon, panel slide, dan panel catatan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%interface%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=PdUG2o7ocgk', video_url_id='https://www.youtube.com/watch?v=jgG4oQCdl2w', practice_task='Open a blank presentation and point out the ribbon, the slide pane, and the notes pane.', practice_task_id='Buka presentasi kosong dan tunjukkan ribbon, panel slide, dan panel catatan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%ribbon%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=PdUG2o7ocgk', video_url_id='https://www.youtube.com/watch?v=jgG4oQCdl2w', practice_task='Open a blank presentation and point out the ribbon, the slide pane, and the notes pane.', practice_task_id='Buka presentasi kosong dan tunjukkan ribbon, panel slide, dan panel catatan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%antarmuka%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=PdUG2o7ocgk', video_url_id='https://www.youtube.com/watch?v=jgG4oQCdl2w', practice_task='Open a blank presentation and point out the ribbon, the slide pane, and the notes pane.', practice_task_id='Buka presentasi kosong dan tunjukkan ribbon, panel slide, dan panel catatan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%mengenal%';
  END IF;

  -- Module 6 · OneDrive
  SELECT m.id INTO v_mod FROM course_modules m JOIN courses c ON c.id=m.course_id
   WHERE c.title='Microsoft Digital Skills for University Prep' AND m.title LIKE 'OneDrive%' LIMIT 1;
  IF v_mod IS NULL THEN RAISE NOTICE 'OneDrive module not found'; ELSE
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=kc4JvqGEM-M', video_url_id='https://www.youtube.com/watch?v=O7jeP76ESj8', practice_task='In your own words, explain what OneDrive is and one benefit of keeping files in the cloud.', practice_task_id='Dengan kata-katamu sendiri, jelaskan apa itu OneDrive dan satu manfaat menyimpan file di cloud.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%what is onedrive%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=kc4JvqGEM-M', video_url_id='https://www.youtube.com/watch?v=O7jeP76ESj8', practice_task='In your own words, explain what OneDrive is and one benefit of keeping files in the cloud.', practice_task_id='Dengan kata-katamu sendiri, jelaskan apa itu OneDrive dan satu manfaat menyimpan file di cloud.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%cloud storage%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=kc4JvqGEM-M', video_url_id='https://www.youtube.com/watch?v=O7jeP76ESj8', practice_task='In your own words, explain what OneDrive is and one benefit of keeping files in the cloud.', practice_task_id='Dengan kata-katamu sendiri, jelaskan apa itu OneDrive dan satu manfaat menyimpan file di cloud.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%apa itu%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=YQRTZku2glc', video_url_id='https://www.youtube.com/watch?v=QKTzPGR4htw', practice_task='Sign in to OneDrive with your Microsoft account on onedrive.com.', practice_task_id='Masuk ke OneDrive dengan akun Microsoft-mu di onedrive.com.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%sign in%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=YQRTZku2glc', video_url_id='https://www.youtube.com/watch?v=QKTzPGR4htw', practice_task='Sign in to OneDrive with your Microsoft account on onedrive.com.', practice_task_id='Masuk ke OneDrive dengan akun Microsoft-mu di onedrive.com.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%log in%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=YQRTZku2glc', video_url_id='https://www.youtube.com/watch?v=QKTzPGR4htw', practice_task='Sign in to OneDrive with your Microsoft account on onedrive.com.', practice_task_id='Masuk ke OneDrive dengan akun Microsoft-mu di onedrive.com.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%login%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=YQRTZku2glc', video_url_id='https://www.youtube.com/watch?v=QKTzPGR4htw', practice_task='Sign in to OneDrive with your Microsoft account on onedrive.com.', practice_task_id='Masuk ke OneDrive dengan akun Microsoft-mu di onedrive.com.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%account%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=YQRTZku2glc', video_url_id='https://www.youtube.com/watch?v=QKTzPGR4htw', practice_task='Sign in to OneDrive with your Microsoft account on onedrive.com.', practice_task_id='Masuk ke OneDrive dengan akun Microsoft-mu di onedrive.com.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%akun%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=YQRTZku2glc', video_url_id='https://www.youtube.com/watch?v=QKTzPGR4htw', practice_task='Sign in to OneDrive with your Microsoft account on onedrive.com.', practice_task_id='Masuk ke OneDrive dengan akun Microsoft-mu di onedrive.com.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%masuk%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7goYd-B1_sM', video_url_id='https://www.youtube.com/watch?v=TYbAPEk496g', practice_task='Open a shared document and edit it at the same time as a classmate.', practice_task_id='Buka dokumen bersama dan sunting bersamaan dengan temanmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%co-author%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7goYd-B1_sM', video_url_id='https://www.youtube.com/watch?v=TYbAPEk496g', practice_task='Open a shared document and edit it at the same time as a classmate.', practice_task_id='Buka dokumen bersama dan sunting bersamaan dengan temanmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%collaborat%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7goYd-B1_sM', video_url_id='https://www.youtube.com/watch?v=TYbAPEk496g', practice_task='Open a shared document and edit it at the same time as a classmate.', practice_task_id='Buka dokumen bersama dan sunting bersamaan dengan temanmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%real-time%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7goYd-B1_sM', video_url_id='https://www.youtube.com/watch?v=TYbAPEk496g', practice_task='Open a shared document and edit it at the same time as a classmate.', practice_task_id='Buka dokumen bersama dan sunting bersamaan dengan temanmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%real time%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7goYd-B1_sM', video_url_id='https://www.youtube.com/watch?v=TYbAPEk496g', practice_task='Open a shared document and edit it at the same time as a classmate.', practice_task_id='Buka dokumen bersama dan sunting bersamaan dengan temanmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%kolaborasi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7goYd-B1_sM', video_url_id='https://www.youtube.com/watch?v=TYbAPEk496g', practice_task='Open a shared document and edit it at the same time as a classmate.', practice_task_id='Buka dokumen bersama dan sunting bersamaan dengan temanmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%menyunting%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=7goYd-B1_sM', video_url_id='https://www.youtube.com/watch?v=TYbAPEk496g', practice_task='Open a shared document and edit it at the same time as a classmate.', practice_task_id='Buka dokumen bersama dan sunting bersamaan dengan temanmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%bersama%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=fEm6PNT1opA', video_url_id='https://www.youtube.com/watch?v=P3elP0wHPyU', practice_task='Open a file''s Version History and restore an earlier version.', practice_task_id='Buka Riwayat Versi sebuah file dan pulihkan versi sebelumnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%version history%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=fEm6PNT1opA', video_url_id='https://www.youtube.com/watch?v=P3elP0wHPyU', practice_task='Open a file''s Version History and restore an earlier version.', practice_task_id='Buka Riwayat Versi sebuah file dan pulihkan versi sebelumnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%previous version%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=fEm6PNT1opA', video_url_id='https://www.youtube.com/watch?v=P3elP0wHPyU', practice_task='Open a file''s Version History and restore an earlier version.', practice_task_id='Buka Riwayat Versi sebuah file dan pulihkan versi sebelumnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%riwayat versi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=fEm6PNT1opA', video_url_id='https://www.youtube.com/watch?v=P3elP0wHPyU', practice_task='Open a file''s Version History and restore an earlier version.', practice_task_id='Buka Riwayat Versi sebuah file dan pulihkan versi sebelumnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%restore version%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=fEm6PNT1opA', video_url_id='https://www.youtube.com/watch?v=P3elP0wHPyU', practice_task='Open a file''s Version History and restore an earlier version.', practice_task_id='Buka Riwayat Versi sebuah file dan pulihkan versi sebelumnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%versi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=vlYCp02txK4', video_url_id='https://www.youtube.com/watch?v=mh_iMcl_bdg', practice_task='Delete a file, then recover it from the OneDrive Recycle Bin.', practice_task_id='Hapus sebuah file, lalu pulihkan dari Recycle Bin OneDrive.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%recycle%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=vlYCp02txK4', video_url_id='https://www.youtube.com/watch?v=mh_iMcl_bdg', practice_task='Delete a file, then recover it from the OneDrive Recycle Bin.', practice_task_id='Hapus sebuah file, lalu pulihkan dari Recycle Bin OneDrive.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%deleted%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=vlYCp02txK4', video_url_id='https://www.youtube.com/watch?v=mh_iMcl_bdg', practice_task='Delete a file, then recover it from the OneDrive Recycle Bin.', practice_task_id='Hapus sebuah file, lalu pulihkan dari Recycle Bin OneDrive.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%recover%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=vlYCp02txK4', video_url_id='https://www.youtube.com/watch?v=mh_iMcl_bdg', practice_task='Delete a file, then recover it from the OneDrive Recycle Bin.', practice_task_id='Hapus sebuah file, lalu pulihkan dari Recycle Bin OneDrive.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%terhapus%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=vlYCp02txK4', video_url_id='https://www.youtube.com/watch?v=mh_iMcl_bdg', practice_task='Delete a file, then recover it from the OneDrive Recycle Bin.', practice_task_id='Hapus sebuah file, lalu pulihkan dari Recycle Bin OneDrive.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%keranjang sampah%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=vlYCp02txK4', video_url_id='https://www.youtube.com/watch?v=mh_iMcl_bdg', practice_task='Delete a file, then recover it from the OneDrive Recycle Bin.', practice_task_id='Hapus sebuah file, lalu pulihkan dari Recycle Bin OneDrive.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%memulihkan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=RErtkfQ8Zpg', video_url_id='https://www.youtube.com/watch?v=7baEBWcnwJk', practice_task='Change a shared link to view-only, then to edit.', practice_task_id='Ubah tautan berbagi menjadi hanya-lihat, lalu menjadi bisa-edit.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%permission%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=RErtkfQ8Zpg', video_url_id='https://www.youtube.com/watch?v=7baEBWcnwJk', practice_task='Change a shared link to view-only, then to edit.', practice_task_id='Ubah tautan berbagi menjadi hanya-lihat, lalu menjadi bisa-edit.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%izin%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=RErtkfQ8Zpg', video_url_id='https://www.youtube.com/watch?v=7baEBWcnwJk', practice_task='Change a shared link to view-only, then to edit.', practice_task_id='Ubah tautan berbagi menjadi hanya-lihat, lalu menjadi bisa-edit.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%expir%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=RErtkfQ8Zpg', video_url_id='https://www.youtube.com/watch?v=7baEBWcnwJk', practice_task='Change a shared link to view-only, then to edit.', practice_task_id='Ubah tautan berbagi menjadi hanya-lihat, lalu menjadi bisa-edit.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%read only%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=RErtkfQ8Zpg', video_url_id='https://www.youtube.com/watch?v=7baEBWcnwJk', practice_task='Change a shared link to view-only, then to edit.', practice_task_id='Ubah tautan berbagi menjadi hanya-lihat, lalu menjadi bisa-edit.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%link%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=RErtkfQ8Zpg', video_url_id='https://www.youtube.com/watch?v=7baEBWcnwJk', practice_task='Change a shared link to view-only, then to edit.', practice_task_id='Ubah tautan berbagi menjadi hanya-lihat, lalu menjadi bisa-edit.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%tautan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=KmzWo8n0oec', video_url_id='https://www.youtube.com/watch?v=z-b4FS7Vl08', practice_task='Share one file or folder with a classmate.', practice_task_id='Bagikan satu file atau folder ke temanmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%share%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=KmzWo8n0oec', video_url_id='https://www.youtube.com/watch?v=z-b4FS7Vl08', practice_task='Share one file or folder with a classmate.', practice_task_id='Bagikan satu file atau folder ke temanmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%berbagi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=KmzWo8n0oec', video_url_id='https://www.youtube.com/watch?v=z-b4FS7Vl08', practice_task='Share one file or folder with a classmate.', practice_task_id='Bagikan satu file atau folder ke temanmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%membagikan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=DtduNsOXVlw', video_url_id='https://www.youtube.com/watch?v=XYyVGpRsmYo', practice_task='Turn on backup so your Desktop, Documents and Photos save to OneDrive.', practice_task_id='Aktifkan backup agar Desktop, Dokumen, dan Foto tersimpan ke OneDrive.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%backup%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=DtduNsOXVlw', video_url_id='https://www.youtube.com/watch?v=XYyVGpRsmYo', practice_task='Turn on backup so your Desktop, Documents and Photos save to OneDrive.', practice_task_id='Aktifkan backup agar Desktop, Dokumen, dan Foto tersimpan ke OneDrive.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%back up%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=DtduNsOXVlw', video_url_id='https://www.youtube.com/watch?v=XYyVGpRsmYo', practice_task='Turn on backup so your Desktop, Documents and Photos save to OneDrive.', practice_task_id='Aktifkan backup agar Desktop, Dokumen, dan Foto tersimpan ke OneDrive.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%cadangan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=wZlGiqYmrkI', video_url_id='https://www.youtube.com/watch?v=ebl1tQYO3U8', practice_task='Install or turn on OneDrive on a PC and let one folder sync.', practice_task_id='Pasang atau aktifkan OneDrive di PC dan biarkan satu folder tersinkron.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%sync%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=wZlGiqYmrkI', video_url_id='https://www.youtube.com/watch?v=ebl1tQYO3U8', practice_task='Install or turn on OneDrive on a PC and let one folder sync.', practice_task_id='Pasang atau aktifkan OneDrive di PC dan biarkan satu folder tersinkron.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%sinkron%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=wZlGiqYmrkI', video_url_id='https://www.youtube.com/watch?v=ebl1tQYO3U8', practice_task='Install or turn on OneDrive on a PC and let one folder sync.', practice_task_id='Pasang atau aktifkan OneDrive di PC dan biarkan satu folder tersinkron.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%setup%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=wZlGiqYmrkI', video_url_id='https://www.youtube.com/watch?v=ebl1tQYO3U8', practice_task='Install or turn on OneDrive on a PC and let one folder sync.', practice_task_id='Pasang atau aktifkan OneDrive di PC dan biarkan satu folder tersinkron.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%install%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=wZlGiqYmrkI', video_url_id='https://www.youtube.com/watch?v=ebl1tQYO3U8', practice_task='Install or turn on OneDrive on a PC and let one folder sync.', practice_task_id='Pasang atau aktifkan OneDrive di PC dan biarkan satu folder tersinkron.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%pasang%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MkJPG-1QrmE', video_url_id='https://www.youtube.com/watch?v=gO9CIipcQFk', practice_task='Open onedrive.com in a browser and find a file you uploaded earlier.', practice_task_id='Buka onedrive.com di browser dan temukan file yang tadi kamu unggah.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%browser%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MkJPG-1QrmE', video_url_id='https://www.youtube.com/watch?v=gO9CIipcQFk', practice_task='Open onedrive.com in a browser and find a file you uploaded earlier.', practice_task_id='Buka onedrive.com di browser dan temukan file yang tadi kamu unggah.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%web%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MkJPG-1QrmE', video_url_id='https://www.youtube.com/watch?v=gO9CIipcQFk', practice_task='Open onedrive.com in a browser and find a file you uploaded earlier.', practice_task_id='Buka onedrive.com di browser dan temukan file yang tadi kamu unggah.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%online%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=vfzAFQ54DIU', video_url_id='https://www.youtube.com/watch?v=q1owHjNHFO8', practice_task='Open the OneDrive app on a phone and view your files.', practice_task_id='Buka aplikasi OneDrive di HP dan lihat file-mu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%mobile%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=vfzAFQ54DIU', video_url_id='https://www.youtube.com/watch?v=q1owHjNHFO8', practice_task='Open the OneDrive app on a phone and view your files.', practice_task_id='Buka aplikasi OneDrive di HP dan lihat file-mu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%phone%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=vfzAFQ54DIU', video_url_id='https://www.youtube.com/watch?v=q1owHjNHFO8', practice_task='Open the OneDrive app on a phone and view your files.', practice_task_id='Buka aplikasi OneDrive di HP dan lihat file-mu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%android%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=vfzAFQ54DIU', video_url_id='https://www.youtube.com/watch?v=q1owHjNHFO8', practice_task='Open the OneDrive app on a phone and view your files.', practice_task_id='Buka aplikasi OneDrive di HP dan lihat file-mu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%aplikasi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=vfzAFQ54DIU', video_url_id='https://www.youtube.com/watch?v=q1owHjNHFO8', practice_task='Open the OneDrive app on a phone and view your files.', practice_task_id='Buka aplikasi OneDrive di HP dan lihat file-mu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '% app%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=XzHozNuYnkA', video_url_id='https://www.youtube.com/watch?v=kPkuVNQSGek', practice_task='Check how much OneDrive storage you have used and free up some space.', practice_task_id='Periksa berapa banyak penyimpanan OneDrive yang terpakai dan kosongkan sebagian.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%storage%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=XzHozNuYnkA', video_url_id='https://www.youtube.com/watch?v=kPkuVNQSGek', practice_task='Check how much OneDrive storage you have used and free up some space.', practice_task_id='Periksa berapa banyak penyimpanan OneDrive yang terpakai dan kosongkan sebagian.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%space%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=XzHozNuYnkA', video_url_id='https://www.youtube.com/watch?v=kPkuVNQSGek', practice_task='Check how much OneDrive storage you have used and free up some space.', practice_task_id='Periksa berapa banyak penyimpanan OneDrive yang terpakai dan kosongkan sebagian.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%quota%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=XzHozNuYnkA', video_url_id='https://www.youtube.com/watch?v=kPkuVNQSGek', practice_task='Check how much OneDrive storage you have used and free up some space.', practice_task_id='Periksa berapa banyak penyimpanan OneDrive yang terpakai dan kosongkan sebagian.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%penyimpanan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=XzHozNuYnkA', video_url_id='https://www.youtube.com/watch?v=kPkuVNQSGek', practice_task='Check how much OneDrive storage you have used and free up some space.', practice_task_id='Periksa berapa banyak penyimpanan OneDrive yang terpakai dan kosongkan sebagian.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%kuota%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=XzHozNuYnkA', video_url_id='https://www.youtube.com/watch?v=kPkuVNQSGek', practice_task='Check how much OneDrive storage you have used and free up some space.', practice_task_id='Periksa berapa banyak penyimpanan OneDrive yang terpakai dan kosongkan sebagian.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%ruang%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=grXApvc8isU', video_url_id='https://www.youtube.com/watch?v=GfKU5mYD4bQ', practice_task='Upload one file and one whole folder to OneDrive.', practice_task_id='Unggah satu file dan satu folder utuh ke OneDrive.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%upload%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=grXApvc8isU', video_url_id='https://www.youtube.com/watch?v=GfKU5mYD4bQ', practice_task='Upload one file and one whole folder to OneDrive.', practice_task_id='Unggah satu file dan satu folder utuh ke OneDrive.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%unggah%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=BpkcId4Umhg', video_url_id='https://www.youtube.com/watch?v=udNyUfDq1nk', practice_task='Download a file from OneDrive back to your computer.', practice_task_id='Unduh sebuah file dari OneDrive kembali ke komputermu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%download%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=BpkcId4Umhg', video_url_id='https://www.youtube.com/watch?v=udNyUfDq1nk', practice_task='Download a file from OneDrive back to your computer.', practice_task_id='Unduh sebuah file dari OneDrive kembali ke komputermu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%unduh%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Olu7hk_AWV8', video_url_id='https://www.youtube.com/watch?v=03VztnMG0wg', practice_task='Create two folders and move three files into them to stay organised.', practice_task_id='Buat dua folder dan pindahkan tiga file ke dalamnya agar rapi.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%organi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Olu7hk_AWV8', video_url_id='https://www.youtube.com/watch?v=03VztnMG0wg', practice_task='Create two folders and move three files into them to stay organised.', practice_task_id='Buat dua folder dan pindahkan tiga file ke dalamnya agar rapi.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%folder%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Olu7hk_AWV8', video_url_id='https://www.youtube.com/watch?v=03VztnMG0wg', practice_task='Create two folders and move three files into them to stay organised.', practice_task_id='Buat dua folder dan pindahkan tiga file ke dalamnya agar rapi.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%merapikan%';
  END IF;

  RAISE NOTICE 'Filled PowerPoint and OneDrive lesson clips by label match.';
END $$;

SELECT m.title AS module, i.item_key, i.label
  FROM module_checklist_items i JOIN course_modules m ON m.id=i.course_module_id
 WHERE m.course_id=(SELECT id FROM courses WHERE title='Microsoft Digital Skills for University Prep')
   AND i.item_type='student' AND i.video_url IS NULL
 ORDER BY m.title, i.sort_order;
