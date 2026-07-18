-- ============================================================
-- fill-remaining-lesson-clips.sql
-- Fills EVERY still-empty Lesson Clip (checklist item with no video) in the
-- Word (Module 3) and Excel (Module 4) modules of the Digital Skills course
-- — including custom clips added in the app whose item_keys aren't in the
-- repo. Each empty item is matched by its LABEL to the first (most specific)
-- topic and gets that topic's EN + ID video and practice task. Only fills
-- items where video_url IS NULL. All videos oEmbed-verified. Idempotent.
-- Run in the Supabase SQL Editor.
-- ============================================================

ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS video_url        TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS video_url_id     TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS practice_task    TEXT;
ALTER TABLE module_checklist_items ADD COLUMN IF NOT EXISTS practice_task_id TEXT;

DO $$
DECLARE v_mod UUID;
BEGIN
  SELECT m.id INTO v_mod FROM course_modules m JOIN courses c ON c.id=m.course_id
   WHERE c.title='Microsoft Digital Skills for University Prep' AND m.title LIKE 'Microsoft Word%' LIMIT 1;
  IF v_mod IS NULL THEN RAISE EXCEPTION 'Word module not found'; END IF;
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=45s9VKQ6wEI', video_url_id='https://www.youtube.com/watch?v=Uv66MmSWNmY', practice_task='Using your Heading styles, insert an automatic table of contents.', practice_task_id='Dengan gaya Heading-mu, sisipkan daftar isi otomatis.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%table of content%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=45s9VKQ6wEI', video_url_id='https://www.youtube.com/watch?v=Uv66MmSWNmY', practice_task='Using your Heading styles, insert an automatic table of contents.', practice_task_id='Dengan gaya Heading-mu, sisipkan daftar isi otomatis.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%daftar isi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=DGfbbCsZi6Q', video_url_id='https://www.youtube.com/watch?v=k4HWSS8CZBo', practice_task='Add a footnote to one sentence explaining a term.', practice_task_id='Tambahkan catatan kaki pada satu kalimat untuk menjelaskan sebuah istilah.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%footnote%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=DGfbbCsZi6Q', video_url_id='https://www.youtube.com/watch?v=k4HWSS8CZBo', practice_task='Add a footnote to one sentence explaining a term.', practice_task_id='Tambahkan catatan kaki pada satu kalimat untuk menjelaskan sebuah istilah.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%endnote%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=DGfbbCsZi6Q', video_url_id='https://www.youtube.com/watch?v=k4HWSS8CZBo', practice_task='Add a footnote to one sentence explaining a term.', practice_task_id='Tambahkan catatan kaki pada satu kalimat untuk menjelaskan sebuah istilah.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%catatan kaki%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=r4srwwHGWzg', video_url_id='https://www.youtube.com/watch?v=xypzKvsK-1I', practice_task='Add one source, insert a citation, then generate a bibliography.', practice_task_id='Tambahkan satu sumber, sisipkan sitasi, lalu buat daftar pustaka.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%citation%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=r4srwwHGWzg', video_url_id='https://www.youtube.com/watch?v=xypzKvsK-1I', practice_task='Add one source, insert a citation, then generate a bibliography.', practice_task_id='Tambahkan satu sumber, sisipkan sitasi, lalu buat daftar pustaka.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%bibliograph%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=r4srwwHGWzg', video_url_id='https://www.youtube.com/watch?v=xypzKvsK-1I', practice_task='Add one source, insert a citation, then generate a bibliography.', practice_task_id='Tambahkan satu sumber, sisipkan sitasi, lalu buat daftar pustaka.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%daftar pustaka%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=r4srwwHGWzg', video_url_id='https://www.youtube.com/watch?v=xypzKvsK-1I', practice_task='Add one source, insert a citation, then generate a bibliography.', practice_task_id='Tambahkan satu sumber, sisipkan sitasi, lalu buat daftar pustaka.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%sitasi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=mFqCvTOpOL0', video_url_id='https://www.youtube.com/watch?v=0tkDYDBC5nw', practice_task='Use Mail Merge with a short list to make personalised letters.', practice_task_id='Pakai Mail Merge dengan daftar singkat untuk membuat surat yang dipersonalisasi.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%mail merge%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=4QQnh9pkvv0', video_url_id='https://www.youtube.com/watch?v=58_8ySNJ2cA', practice_task='Turn on Track Changes, edit a sentence, add a comment, then accept the change.', practice_task_id='Aktifkan Track Changes, edit satu kalimat, tambahkan komentar, lalu terima perubahannya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%track change%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=4QQnh9pkvv0', video_url_id='https://www.youtube.com/watch?v=58_8ySNJ2cA', practice_task='Turn on Track Changes, edit a sentence, add a comment, then accept the change.', practice_task_id='Aktifkan Track Changes, edit satu kalimat, tambahkan komentar, lalu terima perubahannya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%revision%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=pf8xv4PqnRs', video_url_id='https://www.youtube.com/watch?v=1ENNOeCYUAA', practice_task='Run Spelling & Grammar check and fix the flagged mistakes.', practice_task_id='Jalankan pemeriksaan Ejaan & Tata Bahasa dan perbaiki kesalahan yang ditandai.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%spell%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=pf8xv4PqnRs', video_url_id='https://www.youtube.com/watch?v=1ENNOeCYUAA', practice_task='Run Spelling & Grammar check and fix the flagged mistakes.', practice_task_id='Jalankan pemeriksaan Ejaan & Tata Bahasa dan perbaiki kesalahan yang ditandai.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%grammar%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=pf8xv4PqnRs', video_url_id='https://www.youtube.com/watch?v=1ENNOeCYUAA', practice_task='Run Spelling & Grammar check and fix the flagged mistakes.', practice_task_id='Jalankan pemeriksaan Ejaan & Tata Bahasa dan perbaiki kesalahan yang ditandai.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%proofread%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=pf8xv4PqnRs', video_url_id='https://www.youtube.com/watch?v=1ENNOeCYUAA', practice_task='Run Spelling & Grammar check and fix the flagged mistakes.', practice_task_id='Jalankan pemeriksaan Ejaan & Tata Bahasa dan perbaiki kesalahan yang ditandai.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%ejaan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=pf8xv4PqnRs', video_url_id='https://www.youtube.com/watch?v=1ENNOeCYUAA', practice_task='Run Spelling & Grammar check and fix the flagged mistakes.', practice_task_id='Jalankan pemeriksaan Ejaan & Tata Bahasa dan perbaiki kesalahan yang ditandai.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%tata bahasa%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=wmA90kaP1ks', video_url_id='https://www.youtube.com/watch?v=te1SRPxuFQk', practice_task='Add a "DRAFT" watermark to the document.', practice_task_id='Tambahkan watermark "DRAFT" ke dokumen.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%watermark%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=5r0c7Lx2CaQ', video_url_id='https://www.youtube.com/watch?v=IPQ0G0wi5cc', practice_task='Add automatic page numbers at the bottom of every page.', practice_task_id='Tambahkan nomor halaman otomatis di bagian bawah setiap halaman.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%page number%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=5r0c7Lx2CaQ', video_url_id='https://www.youtube.com/watch?v=IPQ0G0wi5cc', practice_task='Add automatic page numbers at the bottom of every page.', practice_task_id='Tambahkan nomor halaman otomatis di bagian bawah setiap halaman.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%nomor halaman%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=rYuibkDyNYs', video_url_id='https://www.youtube.com/watch?v=5ONFj9cTIwk', practice_task='Add a header with the document title and a footer with your name.', practice_task_id='Tambahkan header berisi judul dokumen dan footer berisi namamu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%header%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=rYuibkDyNYs', video_url_id='https://www.youtube.com/watch?v=5ONFj9cTIwk', practice_task='Add a header with the document title and a footer with your name.', practice_task_id='Tambahkan header berisi judul dokumen dan footer berisi namamu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%footer%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=_KSDGDRNHpY', video_url_id='https://www.youtube.com/watch?v=1gGSs-2IT6g', practice_task='Insert a page break to start a new page, then a section break.', practice_task_id='Sisipkan page break untuk memulai halaman baru, lalu section break.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%section break%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=_KSDGDRNHpY', video_url_id='https://www.youtube.com/watch?v=1gGSs-2IT6g', practice_task='Insert a page break to start a new page, then a section break.', practice_task_id='Sisipkan page break untuk memulai halaman baru, lalu section break.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%page break%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=-lnDFyptQV4', video_url_id='https://www.youtube.com/watch?v=lPmVvJ7574Q', practice_task='Split a block of text into two newspaper-style columns.', practice_task_id='Bagi satu blok teks menjadi dua kolom bergaya koran.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%column%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=-lnDFyptQV4', video_url_id='https://www.youtube.com/watch?v=lPmVvJ7574Q', practice_task='Split a block of text into two newspaper-style columns.', practice_task_id='Bagi satu blok teks menjadi dua kolom bergaya koran.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%kolom%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=-lnDFyptQV4', video_url_id='https://www.youtube.com/watch?v=lPmVvJ7574Q', practice_task='Split a block of text into two newspaper-style columns.', practice_task_id='Bagi satu blok teks menjadi dua kolom bergaya koran.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%koran%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Z_8k1sS9USE', video_url_id='https://www.youtube.com/watch?v=xAd50aXlUfU', practice_task='Change the margins to Narrow and switch the page to Landscape, then back.', practice_task_id='Ubah margin menjadi Narrow dan ubah halaman ke Landscape, lalu kembalikan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%orientation%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Z_8k1sS9USE', video_url_id='https://www.youtube.com/watch?v=xAd50aXlUfU', practice_task='Change the margins to Narrow and switch the page to Landscape, then back.', practice_task_id='Ubah margin menjadi Narrow dan ubah halaman ke Landscape, lalu kembalikan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%orientasi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Z_8k1sS9USE', video_url_id='https://www.youtube.com/watch?v=xAd50aXlUfU', practice_task='Change the margins to Narrow and switch the page to Landscape, then back.', practice_task_id='Ubah margin menjadi Narrow dan ubah halaman ke Landscape, lalu kembalikan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%landscape%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Z_8k1sS9USE', video_url_id='https://www.youtube.com/watch?v=xAd50aXlUfU', practice_task='Change the margins to Narrow and switch the page to Landscape, then back.', practice_task_id='Ubah margin menjadi Narrow dan ubah halaman ke Landscape, lalu kembalikan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%margin%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Z_8k1sS9USE', video_url_id='https://www.youtube.com/watch?v=xAd50aXlUfU', practice_task='Change the margins to Narrow and switch the page to Landscape, then back.', practice_task_id='Ubah margin menjadi Narrow dan ubah halaman ke Landscape, lalu kembalikan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%paper size%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Z_8k1sS9USE', video_url_id='https://www.youtube.com/watch?v=xAd50aXlUfU', practice_task='Change the margins to Narrow and switch the page to Landscape, then back.', practice_task_id='Ubah margin menjadi Narrow dan ubah halaman ke Landscape, lalu kembalikan.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%kertas%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=tKbXkiKSD6o', video_url_id='https://www.youtube.com/watch?v=Nz0Gh57rd4A', practice_task='Apply Heading 1 to your title and Heading 2 to two subtitles.', practice_task_id='Terapkan Heading 1 pada judul dan Heading 2 pada dua subjudul.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%heading%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=tKbXkiKSD6o', video_url_id='https://www.youtube.com/watch?v=Nz0Gh57rd4A', practice_task='Apply Heading 1 to your title and Heading 2 to two subtitles.', practice_task_id='Terapkan Heading 1 pada judul dan Heading 2 pada dua subjudul.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%style%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=tKbXkiKSD6o', video_url_id='https://www.youtube.com/watch?v=Nz0Gh57rd4A', practice_task='Apply Heading 1 to your title and Heading 2 to two subtitles.', practice_task_id='Terapkan Heading 1 pada judul dan Heading 2 pada dua subjudul.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%gaya judul%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=2cyVMBv-rwA', video_url_id='https://www.youtube.com/watch?v=StN_tJpA2gA', practice_task='Put a border around one paragraph and add light shading behind it.', practice_task_id='Beri bingkai di sekitar satu paragraf dan tambahkan arsiran tipis di belakangnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%border%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=2cyVMBv-rwA', video_url_id='https://www.youtube.com/watch?v=StN_tJpA2gA', practice_task='Put a border around one paragraph and add light shading behind it.', practice_task_id='Beri bingkai di sekitar satu paragraf dan tambahkan arsiran tipis di belakangnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%shading%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=2cyVMBv-rwA', video_url_id='https://www.youtube.com/watch?v=StN_tJpA2gA', practice_task='Put a border around one paragraph and add light shading behind it.', practice_task_id='Beri bingkai di sekitar satu paragraf dan tambahkan arsiran tipis di belakangnya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%bingkai%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=_iFZZp29qaY', video_url_id='https://www.youtube.com/watch?v=UzdFQeIkmsU', practice_task='Add a first-line indent to a paragraph and set a tab stop using the ruler.', practice_task_id='Tambahkan indentasi baris pertama pada paragraf dan atur tab lewat penggaris.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%indent%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=_iFZZp29qaY', video_url_id='https://www.youtube.com/watch?v=UzdFQeIkmsU', practice_task='Add a first-line indent to a paragraph and set a tab stop using the ruler.', practice_task_id='Tambahkan indentasi baris pertama pada paragraf dan atur tab lewat penggaris.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%tab stop%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=_w_IeEempwQ', video_url_id='https://www.youtube.com/watch?v=CHLP1cEUf6w', practice_task='Turn five lines into a bulleted list, then change it to a numbered list.', practice_task_id='Ubah lima baris menjadi daftar berpoin, lalu ubah menjadi daftar bernomor.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%bullet%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=_w_IeEempwQ', video_url_id='https://www.youtube.com/watch?v=CHLP1cEUf6w', practice_task='Turn five lines into a bulleted list, then change it to a numbered list.', practice_task_id='Ubah lima baris menjadi daftar berpoin, lalu ubah menjadi daftar bernomor.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%numbered%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=_w_IeEempwQ', video_url_id='https://www.youtube.com/watch?v=CHLP1cEUf6w', practice_task='Turn five lines into a bulleted list, then change it to a numbered list.', practice_task_id='Ubah lima baris menjadi daftar berpoin, lalu ubah menjadi daftar bernomor.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%number list%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=_w_IeEempwQ', video_url_id='https://www.youtube.com/watch?v=CHLP1cEUf6w', practice_task='Turn five lines into a bulleted list, then change it to a numbered list.', practice_task_id='Ubah lima baris menjadi daftar berpoin, lalu ubah menjadi daftar bernomor.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%bernomor%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=mXWvKHWe2Co', video_url_id='https://www.youtube.com/watch?v=jg8rElCGl-E', practice_task='Centre a title, justify a paragraph, and set line spacing to 1.5.', practice_task_id='Ratakan tengah judul, ratakan penuh satu paragraf, dan atur spasi baris 1,5.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%spacing%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=mXWvKHWe2Co', video_url_id='https://www.youtube.com/watch?v=jg8rElCGl-E', practice_task='Centre a title, justify a paragraph, and set line spacing to 1.5.', practice_task_id='Ratakan tengah judul, ratakan penuh satu paragraf, dan atur spasi baris 1,5.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%alignment%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=mXWvKHWe2Co', video_url_id='https://www.youtube.com/watch?v=jg8rElCGl-E', practice_task='Centre a title, justify a paragraph, and set line spacing to 1.5.', practice_task_id='Ratakan tengah judul, ratakan penuh satu paragraf, dan atur spasi baris 1,5.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%align%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=mXWvKHWe2Co', video_url_id='https://www.youtube.com/watch?v=jg8rElCGl-E', practice_task='Centre a title, justify a paragraph, and set line spacing to 1.5.', practice_task_id='Ratakan tengah judul, ratakan penuh satu paragraf, dan atur spasi baris 1,5.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%paragraph%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=mXWvKHWe2Co', video_url_id='https://www.youtube.com/watch?v=jg8rElCGl-E', practice_task='Centre a title, justify a paragraph, and set line spacing to 1.5.', practice_task_id='Ratakan tengah judul, ratakan penuh satu paragraf, dan atur spasi baris 1,5.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%perataan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=mXWvKHWe2Co', video_url_id='https://www.youtube.com/watch?v=jg8rElCGl-E', practice_task='Centre a title, justify a paragraph, and set line spacing to 1.5.', practice_task_id='Ratakan tengah judul, ratakan penuh satu paragraf, dan atur spasi baris 1,5.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%spasi%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=rRqWw9_IYwk', video_url_id='https://www.youtube.com/watch?v=AZJXKHD2FoM', practice_task='Make a heading bold size 16 in blue, and one word italic.', practice_task_id='Buat judul tebal ukuran 16 warna biru, dan satu kata miring.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%bold%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=rRqWw9_IYwk', video_url_id='https://www.youtube.com/watch?v=AZJXKHD2FoM', practice_task='Make a heading bold size 16 in blue, and one word italic.', practice_task_id='Buat judul tebal ukuran 16 warna biru, dan satu kata miring.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%italic%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=rRqWw9_IYwk', video_url_id='https://www.youtube.com/watch?v=AZJXKHD2FoM', practice_task='Make a heading bold size 16 in blue, and one word italic.', practice_task_id='Buat judul tebal ukuran 16 warna biru, dan satu kata miring.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%font%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=rRqWw9_IYwk', video_url_id='https://www.youtube.com/watch?v=AZJXKHD2FoM', practice_task='Make a heading bold size 16 in blue, and one word italic.', practice_task_id='Buat judul tebal ukuran 16 warna biru, dan satu kata miring.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%huruf%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Hna1uJN1-qY', video_url_id='https://www.youtube.com/watch?v=fKZYOHCqFGQ', practice_task='Create a SmartArt list or org chart with three items.', practice_task_id='Buat SmartArt daftar atau bagan organisasi dengan tiga item.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%smartart%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Gu_ElhTtPpc', video_url_id='https://www.youtube.com/watch?v=vd41eaTw2JE', practice_task='Add a text box and turn a title into WordArt.', practice_task_id='Tambahkan kotak teks dan ubah sebuah judul menjadi WordArt.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%text box%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Gu_ElhTtPpc', video_url_id='https://www.youtube.com/watch?v=vd41eaTw2JE', practice_task='Add a text box and turn a title into WordArt.', practice_task_id='Tambahkan kotak teks dan ubah sebuah judul menjadi WordArt.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%wordart%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Gu_ElhTtPpc', video_url_id='https://www.youtube.com/watch?v=vd41eaTw2JE', practice_task='Add a text box and turn a title into WordArt.', practice_task_id='Tambahkan kotak teks dan ubah sebuah judul menjadi WordArt.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%kotak teks%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=RMlYOi_iqyw', video_url_id='https://www.youtube.com/watch?v=EE5OB0ptxZA', practice_task='Insert a rectangle and an icon, then move and resize them.', practice_task_id='Sisipkan persegi panjang dan sebuah ikon, lalu pindahkan dan ubah ukurannya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%shape%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=RMlYOi_iqyw', video_url_id='https://www.youtube.com/watch?v=EE5OB0ptxZA', practice_task='Insert a rectangle and an icon, then move and resize them.', practice_task_id='Sisipkan persegi panjang dan sebuah ikon, lalu pindahkan dan ubah ukurannya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%icon%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=RMlYOi_iqyw', video_url_id='https://www.youtube.com/watch?v=EE5OB0ptxZA', practice_task='Insert a rectangle and an icon, then move and resize them.', practice_task_id='Sisipkan persegi panjang dan sebuah ikon, lalu pindahkan dan ubah ukurannya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%bentuk%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=CZx8RA0x3Js', video_url_id='https://www.youtube.com/watch?v=uMAfeWxvhJ0', practice_task='Insert a 3x4 table, type headings in the first row, and apply a table style.', practice_task_id='Sisipkan tabel 3x4, ketik judul di baris pertama, dan terapkan table style.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%table%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=CZx8RA0x3Js', video_url_id='https://www.youtube.com/watch?v=uMAfeWxvhJ0', practice_task='Insert a 3x4 table, type headings in the first row, and apply a table style.', practice_task_id='Sisipkan tabel 3x4, ketik judul di baris pertama, dan terapkan table style.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%tabel%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=3G_dixHPaMQ', video_url_id='https://www.youtube.com/watch?v=1M4Sq7nuGZM', practice_task='Insert a column chart and edit its data to show three values.', practice_task_id='Sisipkan grafik kolom dan ubah datanya untuk menampilkan tiga nilai.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%chart%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=3G_dixHPaMQ', video_url_id='https://www.youtube.com/watch?v=1M4Sq7nuGZM', practice_task='Insert a column chart and edit its data to show three values.', practice_task_id='Sisipkan grafik kolom dan ubah datanya untuk menampilkan tiga nilai.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%grafik%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=3G_dixHPaMQ', video_url_id='https://www.youtube.com/watch?v=1M4Sq7nuGZM', practice_task='Insert a column chart and edit its data to show three values.', practice_task_id='Sisipkan grafik kolom dan ubah datanya untuk menampilkan tiga nilai.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%graph%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=jh9IQuu8J_s', video_url_id='https://www.youtube.com/watch?v=fvLIifWWbdU', practice_task='Insert a picture and set text wrapping to Square so text flows around it.', practice_task_id='Sisipkan gambar dan atur wrap text ke Square agar teks mengalir mengelilinginya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%picture%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=jh9IQuu8J_s', video_url_id='https://www.youtube.com/watch?v=fvLIifWWbdU', practice_task='Insert a picture and set text wrapping to Square so text flows around it.', practice_task_id='Sisipkan gambar dan atur wrap text ke Square agar teks mengalir mengelilinginya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%image%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=jh9IQuu8J_s', video_url_id='https://www.youtube.com/watch?v=fvLIifWWbdU', practice_task='Insert a picture and set text wrapping to Square so text flows around it.', practice_task_id='Sisipkan gambar dan atur wrap text ke Square agar teks mengalir mengelilinginya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%wrap%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=jh9IQuu8J_s', video_url_id='https://www.youtube.com/watch?v=fvLIifWWbdU', practice_task='Insert a picture and set text wrapping to Square so text flows around it.', practice_task_id='Sisipkan gambar dan atur wrap text ke Square agar teks mengalir mengelilinginya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%gambar%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=8ZSlu4DWJ5k', video_url_id='https://www.youtube.com/watch?v=ucxPbWlx04Y', practice_task='Use Find & Replace to change every occurrence of a word in your document.', practice_task_id='Pakai Cari & Ganti untuk mengubah semua kemunculan sebuah kata di dokumenmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%find%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=8ZSlu4DWJ5k', video_url_id='https://www.youtube.com/watch?v=ucxPbWlx04Y', practice_task='Use Find & Replace to change every occurrence of a word in your document.', practice_task_id='Pakai Cari & Ganti untuk mengubah semua kemunculan sebuah kata di dokumenmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%replace%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=8ZSlu4DWJ5k', video_url_id='https://www.youtube.com/watch?v=ucxPbWlx04Y', practice_task='Use Find & Replace to change every occurrence of a word in your document.', practice_task_id='Pakai Cari & Ganti untuk mengubah semua kemunculan sebuah kata di dokumenmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%cari%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=8ZSlu4DWJ5k', video_url_id='https://www.youtube.com/watch?v=ucxPbWlx04Y', practice_task='Use Find & Replace to change every occurrence of a word in your document.', practice_task_id='Pakai Cari & Ganti untuk mengubah semua kemunculan sebuah kata di dokumenmu.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%ganti%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=_gklpjgaVSo', video_url_id='https://www.youtube.com/watch?v=Exywv-qetZ0', practice_task='Create a new document from a Word template.', practice_task_id='Buat dokumen baru dari sebuah template Word.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%template%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=P9uWUz-e1V0', video_url_id='https://www.youtube.com/watch?v=5R35dR22Hgc', practice_task='Export your document as a PDF and open it to check.', practice_task_id='Ekspor dokumenmu sebagai PDF dan buka untuk memeriksanya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%pdf%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=19rgCLqJxrk', video_url_id='https://www.youtube.com/watch?v=upiyL1WL4WI', practice_task='Type a few lines, undo three actions with Ctrl+Z, then redo them with Ctrl+Y.', practice_task_id='Ketik beberapa baris, batalkan tiga tindakan dengan Ctrl+Z, lalu ulangi dengan Ctrl+Y.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%undo%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=19rgCLqJxrk', video_url_id='https://www.youtube.com/watch?v=upiyL1WL4WI', practice_task='Type a few lines, undo three actions with Ctrl+Z, then redo them with Ctrl+Y.', practice_task_id='Ketik beberapa baris, batalkan tiga tindakan dengan Ctrl+Z, lalu ulangi dengan Ctrl+Y.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%redo%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=19rgCLqJxrk', video_url_id='https://www.youtube.com/watch?v=upiyL1WL4WI', practice_task='Type a few lines, undo three actions with Ctrl+Z, then redo them with Ctrl+Y.', practice_task_id='Ketik beberapa baris, batalkan tiga tindakan dengan Ctrl+Z, lalu ulangi dengan Ctrl+Y.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%autocorrect%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=5_HdVz_lWjI', video_url_id='https://www.youtube.com/watch?v=xWnDr5gF240', practice_task='Select a word by double-click, a sentence, then the whole document with Ctrl+A, and retype one word.', practice_task_id='Pilih satu kata dengan klik ganda, satu kalimat, lalu seluruh dokumen dengan Ctrl+A, dan ketik ulang satu kata.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%typ%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=5_HdVz_lWjI', video_url_id='https://www.youtube.com/watch?v=xWnDr5gF240', practice_task='Select a word by double-click, a sentence, then the whole document with Ctrl+A, and retype one word.', practice_task_id='Pilih satu kata dengan klik ganda, satu kalimat, lalu seluruh dokumen dengan Ctrl+A, dan ketik ulang satu kata.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%select%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=5_HdVz_lWjI', video_url_id='https://www.youtube.com/watch?v=xWnDr5gF240', practice_task='Select a word by double-click, a sentence, then the whole document with Ctrl+A, and retype one word.', practice_task_id='Pilih satu kata dengan klik ganda, satu kalimat, lalu seluruh dokumen dengan Ctrl+A, dan ketik ulang satu kata.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%edit%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=5_HdVz_lWjI', video_url_id='https://www.youtube.com/watch?v=xWnDr5gF240', practice_task='Select a word by double-click, a sentence, then the whole document with Ctrl+A, and retype one word.', practice_task_id='Pilih satu kata dengan klik ganda, satu kalimat, lalu seluruh dokumen dengan Ctrl+A, dan ketik ulang satu kata.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%mengetik%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=5_HdVz_lWjI', video_url_id='https://www.youtube.com/watch?v=xWnDr5gF240', practice_task='Select a word by double-click, a sentence, then the whole document with Ctrl+A, and retype one word.', practice_task_id='Pilih satu kata dengan klik ganda, satu kalimat, lalu seluruh dokumen dengan Ctrl+A, dan ketik ulang satu kata.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%memilih%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=5_HdVz_lWjI', video_url_id='https://www.youtube.com/watch?v=xWnDr5gF240', practice_task='Select a word by double-click, a sentence, then the whole document with Ctrl+A, and retype one word.', practice_task_id='Pilih satu kata dengan klik ganda, satu kalimat, lalu seluruh dokumen dengan Ctrl+A, dan ketik ulang satu kata.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%teks%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Y4hN2khT-Tc', video_url_id='https://www.youtube.com/watch?v=CgI0uMJwwrg', practice_task='Open a blank document and point out the ribbon tabs, the ruler, and the status bar.', practice_task_id='Buka dokumen kosong dan tunjukkan tab ribbon, penggaris, dan status bar.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%interface%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Y4hN2khT-Tc', video_url_id='https://www.youtube.com/watch?v=CgI0uMJwwrg', practice_task='Open a blank document and point out the ribbon tabs, the ruler, and the status bar.', practice_task_id='Buka dokumen kosong dan tunjukkan tab ribbon, penggaris, dan status bar.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%ribbon%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Y4hN2khT-Tc', video_url_id='https://www.youtube.com/watch?v=CgI0uMJwwrg', practice_task='Open a blank document and point out the ribbon tabs, the ruler, and the status bar.', practice_task_id='Buka dokumen kosong dan tunjukkan tab ribbon, penggaris, dan status bar.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%antarmuka%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Y4hN2khT-Tc', video_url_id='https://www.youtube.com/watch?v=CgI0uMJwwrg', practice_task='Open a blank document and point out the ribbon tabs, the ruler, and the status bar.', practice_task_id='Buka dokumen kosong dan tunjukkan tab ribbon, penggaris, dan status bar.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%mengenal%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=Y4hN2khT-Tc', video_url_id='https://www.youtube.com/watch?v=CgI0uMJwwrg', practice_task='Open a blank document and point out the ribbon tabs, the ruler, and the status bar.', practice_task_id='Buka dokumen kosong dan tunjukkan tab ribbon, penggaris, dan status bar.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%pengenalan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=PafCMUVH_OA', video_url_id='https://www.youtube.com/watch?v=Z6UQpCzhcoU', practice_task='Type a sentence, save the file as .docx, then save a copy as PDF.', practice_task_id='Ketik satu kalimat, simpan file sebagai .docx, lalu simpan salinan sebagai PDF.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%save%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=PafCMUVH_OA', video_url_id='https://www.youtube.com/watch?v=Z6UQpCzhcoU', practice_task='Type a sentence, save the file as .docx, then save a copy as PDF.', practice_task_id='Ketik satu kalimat, simpan file sebagai .docx, lalu simpan salinan sebagai PDF.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%open%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=PafCMUVH_OA', video_url_id='https://www.youtube.com/watch?v=Z6UQpCzhcoU', practice_task='Type a sentence, save the file as .docx, then save a copy as PDF.', practice_task_id='Ketik satu kalimat, simpan file sebagai .docx, lalu simpan salinan sebagai PDF.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%document%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=PafCMUVH_OA', video_url_id='https://www.youtube.com/watch?v=Z6UQpCzhcoU', practice_task='Type a sentence, save the file as .docx, then save a copy as PDF.', practice_task_id='Ketik satu kalimat, simpan file sebagai .docx, lalu simpan salinan sebagai PDF.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%simpan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=PafCMUVH_OA', video_url_id='https://www.youtube.com/watch?v=Z6UQpCzhcoU', practice_task='Type a sentence, save the file as .docx, then save a copy as PDF.', practice_task_id='Ketik satu kalimat, simpan file sebagai .docx, lalu simpan salinan sebagai PDF.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%dokumen%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=PafCMUVH_OA', video_url_id='https://www.youtube.com/watch?v=Z6UQpCzhcoU', practice_task='Type a sentence, save the file as .docx, then save a copy as PDF.', practice_task_id='Ketik satu kalimat, simpan file sebagai .docx, lalu simpan salinan sebagai PDF.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%buka%';

  SELECT m.id INTO v_mod FROM course_modules m JOIN courses c ON c.id=m.course_id
   WHERE c.title='Microsoft Digital Skills for University Prep' AND m.title LIKE 'Microsoft Excel%' LIMIT 1;
  IF v_mod IS NULL THEN RAISE EXCEPTION 'Excel module not found'; END IF;
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=dvbLrwD2SpA', video_url_id='https://www.youtube.com/watch?v=OoN5KjqzD2I', practice_task='Create a PivotTable that sums quantity by category.', practice_task_id='Buat PivotTable yang menjumlahkan kuantitas berdasarkan kategori.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%pivot%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=DXbUjlR9URA', video_url_id='https://www.youtube.com/watch?v=1E9DORLGizA', practice_task='Add a Highlight Cells rule so any stock value below 10 turns red.', practice_task_id='Tambahkan aturan Highlight Cells agar nilai stok di bawah 10 berubah menjadi merah.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%conditional%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=DXbUjlR9URA', video_url_id='https://www.youtube.com/watch?v=1E9DORLGizA', practice_task='Add a Highlight Cells rule so any stock value below 10 turns red.', practice_task_id='Tambahkan aturan Highlight Cells agar nilai stok di bawah 10 berubah menjadi merah.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%bersyarat%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=wjGzYpdIcxY', video_url_id='https://www.youtube.com/watch?v=Q45aYUCjLP8', practice_task='Add a header row, then use View -> Freeze Panes -> Freeze Top Row and scroll to test it.', practice_task_id='Tambahkan baris judul, lalu pakai View -> Freeze Panes -> Freeze Top Row dan gulir untuk mengujinya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%freeze%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=wjGzYpdIcxY', video_url_id='https://www.youtube.com/watch?v=Q45aYUCjLP8', practice_task='Add a header row, then use View -> Freeze Panes -> Freeze Top Row and scroll to test it.', practice_task_id='Tambahkan baris judul, lalu pakai View -> Freeze Panes -> Freeze Top Row dan gulir untuk mengujinya.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%mengunci%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=xIynD1gFOLo', video_url_id='https://www.youtube.com/watch?v=7JXWn9c68PM', practice_task='Build a small price list and use VLOOKUP to pull a price by item code.', practice_task_id='Buat daftar harga kecil dan pakai VLOOKUP untuk mengambil harga berdasarkan kode barang.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%vlookup%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=xIynD1gFOLo', video_url_id='https://www.youtube.com/watch?v=7JXWn9c68PM', practice_task='Build a small price list and use VLOOKUP to pull a price by item code.', practice_task_id='Buat daftar harga kecil dan pakai VLOOKUP untuk mengambil harga berdasarkan kode barang.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%lookup%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=jIYD7wiWDU4', video_url_id='https://www.youtube.com/watch?v=xd7KLdprOI8', practice_task='Write =IF(A2>=60,"Pass","Fail") for a list of scores.', practice_task_id='Tulis =IF(A2>=60;"Lulus";"Gagal") untuk daftar nilai.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%if formula%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=jIYD7wiWDU4', video_url_id='https://www.youtube.com/watch?v=xd7KLdprOI8', practice_task='Write =IF(A2>=60,"Pass","Fail") for a list of scores.', practice_task_id='Tulis =IF(A2>=60;"Lulus";"Gagal") untuk daftar nilai.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%if function%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=jIYD7wiWDU4', video_url_id='https://www.youtube.com/watch?v=xd7KLdprOI8', practice_task='Write =IF(A2>=60,"Pass","Fail") for a list of scores.', practice_task_id='Tulis =IF(A2>=60;"Lulus";"Gagal") untuk daftar nilai.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%logika%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=jIYD7wiWDU4', video_url_id='https://www.youtube.com/watch?v=xd7KLdprOI8', practice_task='Write =IF(A2>=60,"Pass","Fail") for a list of scores.', practice_task_id='Tulis =IF(A2>=60;"Lulus";"Gagal") untuk daftar nilai.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%rumus if%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=oSa7pP5um_s', video_url_id='https://www.youtube.com/watch?v=v8w5vWheSoM', practice_task='Use =SUM() to total a column of quantities, then do it again with the AutoSum button.', practice_task_id='Pakai =SUM() untuk menjumlahkan kolom kuantitas, lalu ulangi dengan tombol AutoSum.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%autosum%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=oSa7pP5um_s', video_url_id='https://www.youtube.com/watch?v=v8w5vWheSoM', practice_task='Use =SUM() to total a column of quantities, then do it again with the AutoSum button.', practice_task_id='Pakai =SUM() untuk menjumlahkan kolom kuantitas, lalu ulangi dengan tombol AutoSum.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%sum%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=k3MHxObhD_0', video_url_id='https://www.youtube.com/watch?v=FDmXCngGTOY', practice_task='Add AVERAGE, MIN, and MAX below a column of prices.', practice_task_id='Tambahkan AVERAGE, MIN, dan MAX di bawah kolom harga.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%average%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=k3MHxObhD_0', video_url_id='https://www.youtube.com/watch?v=FDmXCngGTOY', practice_task='Add AVERAGE, MIN, and MAX below a column of prices.', practice_task_id='Tambahkan AVERAGE, MIN, dan MAX di bawah kolom harga.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%count%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=k3MHxObhD_0', video_url_id='https://www.youtube.com/watch?v=FDmXCngGTOY', practice_task='Add AVERAGE, MIN, and MAX below a column of prices.', practice_task_id='Tambahkan AVERAGE, MIN, dan MAX di bawah kolom harga.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%rata%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=oSa7pP5um_s', video_url_id='https://www.youtube.com/watch?v=v8w5vWheSoM', practice_task='Use =SUM() to total a column of quantities, then do it again with the AutoSum button.', practice_task_id='Pakai =SUM() untuk menjumlahkan kolom kuantitas, lalu ulangi dengan tombol AutoSum.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%formula%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=oSa7pP5um_s', video_url_id='https://www.youtube.com/watch?v=v8w5vWheSoM', practice_task='Use =SUM() to total a column of quantities, then do it again with the AutoSum button.', practice_task_id='Pakai =SUM() untuk menjumlahkan kolom kuantitas, lalu ulangi dengan tombol AutoSum.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%rumus%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=YkaYOSduu40', video_url_id='https://www.youtube.com/watch?v=PSHpJRewxPY', practice_task='Sort your table by category, then add a second level to also sort by quantity.', practice_task_id='Urutkan tabelmu berdasarkan kategori, lalu tambah level kedua agar juga terurut berdasarkan kuantitas.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%sort%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=YkaYOSduu40', video_url_id='https://www.youtube.com/watch?v=PSHpJRewxPY', practice_task='Sort your table by category, then add a second level to also sort by quantity.', practice_task_id='Urutkan tabelmu berdasarkan kategori, lalu tambah level kedua agar juga terurut berdasarkan kuantitas.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%urut%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=4i1DH6EwIIE', video_url_id='https://www.youtube.com/watch?v=1xmb4t-3o54', practice_task='Turn on Filter and show only the items in one category.', practice_task_id='Aktifkan Filter dan tampilkan hanya barang dalam satu kategori.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%filter%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=4i1DH6EwIIE', video_url_id='https://www.youtube.com/watch?v=1xmb4t-3o54', practice_task='Turn on Filter and show only the items in one category.', practice_task_id='Aktifkan Filter dan tampilkan hanya barang dalam satu kategori.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%saring%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=64DSXejsYbo', video_url_id='https://www.youtube.com/watch?v=FdzvFJ6Dc0U', practice_task='Select a small table and insert a column chart.', practice_task_id='Pilih tabel kecil dan sisipkan grafik kolom.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%chart%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=64DSXejsYbo', video_url_id='https://www.youtube.com/watch?v=FdzvFJ6Dc0U', practice_task='Select a small table and insert a column chart.', practice_task_id='Pilih tabel kecil dan sisipkan grafik kolom.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%grafik%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=64DSXejsYbo', video_url_id='https://www.youtube.com/watch?v=FdzvFJ6Dc0U', practice_task='Select a small table and insert a column chart.', practice_task_id='Pilih tabel kecil dan sisipkan grafik kolom.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%graph%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=sKv2DOwk6-A', video_url_id='https://www.youtube.com/watch?v=06sRaogKIPU', practice_task='Format one column as Currency (Rp), one as Percentage, and one as Date.', practice_task_id='Format satu kolom sebagai Mata Uang (Rp), satu sebagai Persentase, dan satu sebagai Tanggal.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%number format%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=sKv2DOwk6-A', video_url_id='https://www.youtube.com/watch?v=06sRaogKIPU', practice_task='Format one column as Currency (Rp), one as Percentage, and one as Date.', practice_task_id='Format satu kolom sebagai Mata Uang (Rp), satu sebagai Persentase, dan satu sebagai Tanggal.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%currency%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=sKv2DOwk6-A', video_url_id='https://www.youtube.com/watch?v=06sRaogKIPU', practice_task='Format one column as Currency (Rp), one as Percentage, and one as Date.', practice_task_id='Format satu kolom sebagai Mata Uang (Rp), satu sebagai Persentase, dan satu sebagai Tanggal.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%percentage%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=sKv2DOwk6-A', video_url_id='https://www.youtube.com/watch?v=06sRaogKIPU', practice_task='Format one column as Currency (Rp), one as Percentage, and one as Date.', practice_task_id='Format satu kolom sebagai Mata Uang (Rp), satu sebagai Persentase, dan satu sebagai Tanggal.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%mata uang%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=sKv2DOwk6-A', video_url_id='https://www.youtube.com/watch?v=06sRaogKIPU', practice_task='Format one column as Currency (Rp), one as Percentage, and one as Date.', practice_task_id='Format satu kolom sebagai Mata Uang (Rp), satu sebagai Persentase, dan satu sebagai Tanggal.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%rupiah%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=ryrz6UVvOwM', video_url_id='https://www.youtube.com/watch?v=yF_tnM7BJTg', practice_task='Make the header row bold, add borders around A1:C5, and turn on Wrap Text.', practice_task_id='Buat baris judul menjadi tebal, tambahkan garis tepi di A1:C5, dan aktifkan Wrap Text.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%border%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=ryrz6UVvOwM', video_url_id='https://www.youtube.com/watch?v=yF_tnM7BJTg', practice_task='Make the header row bold, add borders around A1:C5, and turn on Wrap Text.', practice_task_id='Buat baris judul menjadi tebal, tambahkan garis tepi di A1:C5, dan aktifkan Wrap Text.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%colour%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=ryrz6UVvOwM', video_url_id='https://www.youtube.com/watch?v=yF_tnM7BJTg', practice_task='Make the header row bold, add borders around A1:C5, and turn on Wrap Text.', practice_task_id='Buat baris judul menjadi tebal, tambahkan garis tepi di A1:C5, dan aktifkan Wrap Text.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%color%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=ryrz6UVvOwM', video_url_id='https://www.youtube.com/watch?v=yF_tnM7BJTg', practice_task='Make the header row bold, add borders around A1:C5, and turn on Wrap Text.', practice_task_id='Buat baris judul menjadi tebal, tambahkan garis tepi di A1:C5, dan aktifkan Wrap Text.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%format cell%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=ryrz6UVvOwM', video_url_id='https://www.youtube.com/watch?v=yF_tnM7BJTg', practice_task='Make the header row bold, add borders around A1:C5, and turn on Wrap Text.', practice_task_id='Buat baris judul menjadi tebal, tambahkan garis tepi di A1:C5, dan aktifkan Wrap Text.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%format sel%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=ryrz6UVvOwM', video_url_id='https://www.youtube.com/watch?v=yF_tnM7BJTg', practice_task='Make the header row bold, add borders around A1:C5, and turn on Wrap Text.', practice_task_id='Buat baris judul menjadi tebal, tambahkan garis tepi di A1:C5, dan aktifkan Wrap Text.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%shading%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=iuoQyIZW0tA', video_url_id='https://www.youtube.com/watch?v=Ms4lTSlNzhQ', practice_task='Save or export your finished workbook as a PDF.', practice_task_id='Simpan atau ekspor workbook selesaimu sebagai PDF.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%print%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=iuoQyIZW0tA', video_url_id='https://www.youtube.com/watch?v=Ms4lTSlNzhQ', practice_task='Save or export your finished workbook as a PDF.', practice_task_id='Simpan atau ekspor workbook selesaimu sebagai PDF.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%pdf%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=iuoQyIZW0tA', video_url_id='https://www.youtube.com/watch?v=Ms4lTSlNzhQ', practice_task='Save or export your finished workbook as a PDF.', practice_task_id='Simpan atau ekspor workbook selesaimu sebagai PDF.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%export%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=iuoQyIZW0tA', video_url_id='https://www.youtube.com/watch?v=Ms4lTSlNzhQ', practice_task='Save or export your finished workbook as a PDF.', practice_task_id='Simpan atau ekspor workbook selesaimu sebagai PDF.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%cetak%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MFSvwFUirEM', video_url_id='https://www.youtube.com/watch?v=ctMaR7yG-Rs', practice_task='Type 5 item names down column A using Enter and Tab, then edit one cell with F2.', practice_task_id='Ketik 5 nama barang ke bawah di kolom A memakai Enter dan Tab, lalu edit satu sel dengan F2.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%enter%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MFSvwFUirEM', video_url_id='https://www.youtube.com/watch?v=ctMaR7yG-Rs', practice_task='Type 5 item names down column A using Enter and Tab, then edit one cell with F2.', practice_task_id='Ketik 5 nama barang ke bawah di kolom A memakai Enter dan Tab, lalu edit satu sel dengan F2.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%edit data%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MFSvwFUirEM', video_url_id='https://www.youtube.com/watch?v=ctMaR7yG-Rs', practice_task='Type 5 item names down column A using Enter and Tab, then edit one cell with F2.', practice_task_id='Ketik 5 nama barang ke bawah di kolom A memakai Enter dan Tab, lalu edit satu sel dengan F2.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%typ%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MFSvwFUirEM', video_url_id='https://www.youtube.com/watch?v=ctMaR7yG-Rs', practice_task='Type 5 item names down column A using Enter and Tab, then edit one cell with F2.', practice_task_id='Ketik 5 nama barang ke bawah di kolom A memakai Enter dan Tab, lalu edit satu sel dengan F2.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%input%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MFSvwFUirEM', video_url_id='https://www.youtube.com/watch?v=ctMaR7yG-Rs', practice_task='Type 5 item names down column A using Enter and Tab, then edit one cell with F2.', practice_task_id='Ketik 5 nama barang ke bawah di kolom A memakai Enter dan Tab, lalu edit satu sel dengan F2.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%memasukkan%';
  UPDATE module_checklist_items SET
    video_url='https://www.youtube.com/watch?v=MFSvwFUirEM', video_url_id='https://www.youtube.com/watch?v=ctMaR7yG-Rs', practice_task='Type 5 item names down column A using Enter and Tab, then edit one cell with F2.', practice_task_id='Ketik 5 nama barang ke bawah di kolom A memakai Enter dan Tab, lalu edit satu sel dengan F2.'
  WHERE course_module_id=v_mod AND video_url IS NULL AND label ILIKE '%data%';

  RAISE NOTICE 'Filled remaining Word and Excel lesson clips by label match.';
END $$;

SELECT m.title AS module, i.item_key, i.label
  FROM module_checklist_items i JOIN course_modules m ON m.id=i.course_module_id
 WHERE m.course_id=(SELECT id FROM courses WHERE title='Microsoft Digital Skills for University Prep')
   AND i.item_type='student' AND i.video_url IS NULL
 ORDER BY m.title, i.sort_order;
