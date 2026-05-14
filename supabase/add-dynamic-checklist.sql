-- Unified checklist items table (replaces static course-data + custom_checklist_items)
CREATE TABLE IF NOT EXISTS module_checklist_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  module_id SMALLINT NOT NULL CHECK (module_id BETWEEN 1 AND 8),
  item_type TEXT NOT NULL CHECK (item_type IN ('student', 'teacher')),
  item_key TEXT NOT NULL,
  label TEXT NOT NULL,
  label_id TEXT,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(module_id, item_key)
);

ALTER TABLE module_checklist_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can read module_checklist_items" ON module_checklist_items
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Tutors can manage module_checklist_items" ON module_checklist_items
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );

-- Seed all default items (safe to re-run: ON CONFLICT DO NOTHING)
INSERT INTO module_checklist_items (module_id, item_type, item_key, label, label_id, sort_order) VALUES
-- Module 1 Student
(1,'student','m1s1','Created a strong, unique password and locked the screen','Membuat kata sandi kuat & unik dan mengunci layar',1),
(1,'student','m1s2','Identified a phishing email','Mengidentifikasi email phishing',2),
(1,'student','m1s3','Successfully printed a document (or used Print to PDF)','Berhasil mencetak dokumen (atau Print to PDF)',3),
(1,'student','m1s4','Set up semester folder structure in OneDrive','Membuat struktur folder semester di OneDrive',4),
(1,'student','m1s5','Built Biology 101 notebook with all sections','Membangun buku catatan Biologi 101 dengan semua bagian',5),
(1,'student','m1s6','Added a lecture page with summary, clipping, and to-do tags','Menambahkan halaman kuliah dengan ringkasan, kliping, dan tag',6),
(1,'student','m1s7','Wrote a professional email with PDF attachment','Menulis email profesional dengan lampiran PDF',7),
(1,'student','m1s8','Can search and instantly find a specific note','Dapat mencari dan langsung menemukan catatan tertentu',8),
-- Module 1 Teacher
(1,'teacher','m1t1','Student demonstrates basic security awareness (password, lock, phishing)','Siswa menunjukkan kesadaran keamanan dasar',1),
(1,'teacher','m1t2','Printer setup / print-to-PDF works correctly','Pengaturan printer / print-to-PDF berfungsi',2),
(1,'teacher','m1t3','Folder structure is logical and shared correctly','Struktur folder logis dan dibagikan dengan benar',3),
(1,'teacher','m1t4','OneNote notebook is well-organized with required elements','OneNote terorganisir baik dengan elemen yang diminta',4),
(1,'teacher','m1t5','Email demonstrates proper format and attachment','Email menunjukkan format dan lampiran yang tepat',5),
-- Module 2 Student
(2,'student','m2s1','Typed a 300-word essay with exact formatting specifications','Mengetik esai 300 kata dengan spesifikasi format yang tepat',1),
(2,'student','m2s2','Created a college paper with running head and page number starting on page 2','Membuat makalah kuliah dengan running head dan nomor halaman mulai halaman 2',2),
(2,'student','m2s3','Inserted APA 7th citations and generated bibliography & TOC','Menyisipkan sitasi APA 7th dan menghasilkan daftar pustaka & daftar isi',3),
(2,'student','m2s4','Used Track Changes and comments to review a peer''s paper','Menggunakan Lacak Perubahan dan komentar untuk meninjau makalah rekan',4),
(2,'student','m2s5','Can format an unformatted text into a college template in under 20 min','Dapat memformat teks mentah menjadi templat kuliah dalam 20 menit',5),
-- Module 2 Teacher
(2,'teacher','m2t1','Essay formatting meets academic guidelines','Pemformatan esai memenuhi pedoman akademik',1),
(2,'teacher','m2t2','Running head and page numbering are correct','Running head dan penomoran halaman benar',2),
(2,'teacher','m2t3','Citations are properly formatted; TOC updates correctly','Sitasi diformat dengan benar; daftar isi diperbarui otomatis',3),
(2,'teacher','m2t4','Student effectively uses review features (Track Changes, comments)','Siswa efektif menggunakan fitur peninjauan',4),
(2,'teacher','m2t5','Time and accuracy on formatting drill','Waktu dan akurasi pada latihan pemformatan',5),
-- Module 3 Student
(3,'student','m3s1','Built a monthly budget with SUM and formatting','Membangun anggaran bulanan dengan SUM dan pemformatan',1),
(3,'student','m3s2','Created a grade calculator that drops the lowest score','Membuat kalkulator nilai yang membuang nilai terendah',2),
(3,'student','m3s3','Designed a sales dashboard with summary table and two charts','Merancang dasbor penjualan dengan tabel ringkasan dan dua grafik',3),
(3,'student','m3s4','Merged data using XLOOKUP','Menggabungkan data menggunakan XLOOKUP',4),
(3,'student','m3s5','Applied drop-down and conditional formatting in grade calculator','Menerapkan dropdown dan pemformatan bersyarat pada kalkulator nilai',5),
-- Module 3 Teacher
(3,'teacher','m3t1','Budget sheet has correct totals and is well-formatted','Lembar anggaran memiliki total yang benar dan diformat dengan baik',1),
(3,'teacher','m3t2','Grade calculator works with any set of scores','Kalkulator nilai berfungsi dengan kumpulan nilai apa pun',2),
(3,'teacher','m3t3','Dashboard charts are labeled and professional','Grafik dasbor berlabel dan profesional',3),
(3,'teacher','m3t4','XLOOKUP formula is correct','Rumus XLOOKUP benar',4),
(3,'teacher','m3t5','Advanced conditional formatting functions as intended','Pemformatan bersyarat tingkat lanjut berfungsi sesuai harapan',5),
-- Module 4 Student
(4,'student','m4s1','Built a 5-slide ''About Me'' with consistent design and SmartArt','Membangun presentasi 5 slide Tentang Saya dengan desain konsisten',1),
(4,'student','m4s2','Created ''Water Cycle'' presentation with linked Excel chart and morph','Membuat presentasi Siklus Air dengan grafik Excel tertaut dan morph',2),
(4,'student','m4s3','Recorded a 3-min presentation and self-critiqued','Merekam presentasi 3 menit dan mengevaluasi diri',3),
(4,'student','m4s4','Redesigned a bullet-point slide into a visual layout','Mendesain ulang slide bullet point menjadi tata letak visual',4),
(4,'student','m4s5','Can deliver a presentation confidently with Presenter View','Dapat menyampaikan presentasi dengan Tampilan Penyaji',5),
-- Module 4 Teacher
(4,'teacher','m4t1','Slide Master is used; design is consistent','Master Slide digunakan; desain konsisten',1),
(4,'teacher','m4t2','Morph transitions and animations work smoothly','Transisi morph dan animasi berfungsi mulus',2),
(4,'teacher','m4t3','Linked Excel chart updates correctly','Grafik Excel tertaut diperbarui dengan benar',3),
(4,'teacher','m4t4','Recording is clear; speaker notes are used','Rekaman jelas; catatan pembicara digunakan',4),
(4,'teacher','m4t5','Visual redesign demonstrates understanding of design principles','Desain ulang visual menunjukkan pemahaman prinsip desain',5),
-- Module 5 Student
(5,'student','m5s1','Created a multi-level list linked to heading styles','Membuat daftar bertingkat yang terhubung ke gaya heading',1),
(5,'student','m5s2','Generated automatic TOC, table of figures, and cross-references','Menghasilkan daftar isi, daftar gambar, dan referensi silang otomatis',2),
(5,'student','m5s3','Built a .dotx template for a research paper','Membangun templat .dotx untuk makalah riset',3),
(5,'student','m5s4','Performed mail merge for labels/certificates','Melakukan mail merge untuk label/sertifikat',4),
(5,'student','m5s5','Created a form with content controls and protection','Membuat formulir dengan kontrol konten dan proteksi',5),
-- Module 5 Teacher
(5,'teacher','m5t1','Document structure uses heading styles correctly','Struktur dokumen menggunakan gaya heading dengan benar',1),
(5,'teacher','m5t2','TOC and cross-references update properly','Daftar isi dan referensi silang diperbarui dengan baik',2),
(5,'teacher','m5t3','Template is reusable and professional','Templat dapat digunakan kembali dan profesional',3),
(5,'teacher','m5t4','Mail merge functions as expected','Mail merge berfungsi sesuai harapan',4),
(5,'teacher','m5t5','Form controls are properly set and protected','Kontrol formulir diatur dengan benar dan terlindungi',5),
-- Module 6 Student
(6,'student','m6s1','Created PivotTable with slicers and calculated fields','Membuat PivotTable dengan pemotong dan bidang terhitung',1),
(6,'student','m6s2','Used SUMIFS, COUNTIFS, XLOOKUP, INDEX-MATCH','Menggunakan SUMIFS, COUNTIFS, XLOOKUP, INDEX-MATCH',2),
(6,'student','m6s3','Applied data validation and conditional formatting','Menerapkan validasi data dan pemformatan bersyarat',3),
(6,'student','m6s4','Performed Goal Seek and Scenario Manager','Melakukan Goal Seek dan Scenario Manager',4),
(6,'student','m6s5','Recorded a simple macro','Merekam makro sederhana',5),
(6,'student','m6s6','Built an interactive student grades dashboard','Membangun dasbor interaktif nilai mahasiswa',6),
-- Module 6 Teacher
(6,'teacher','m6t1','PivotTable groups and filters data correctly','PivotTable mengelompokkan dan menyaring data dengan benar',1),
(6,'teacher','m6t2','Formulas are accurate and efficient','Rumus akurat dan efisien',2),
(6,'teacher','m6t3','Goal Seek produces correct required score','Goal Seek menghasilkan skor yang diperlukan dengan tepat',3),
(6,'teacher','m6t4','Macro runs without errors','Makro berjalan tanpa kesalahan',4),
(6,'teacher','m6t5','Dashboard is user-friendly and visually clear','Dasbor ramah pengguna dan jelas secara visual',5),
-- Module 7 Student
(7,'student','m7s1','Created a Team with channels for a study group','Membuat Tim dengan saluran untuk kelompok belajar',1),
(7,'student','m7s2','Scheduled and hosted a Teams meeting with recording','Menjadwalkan dan mengadakan rapat Teams dengan rekaman',2),
(7,'student','m7s3','Shared files and co-authored in real time','Berbagi file dan menulis bersama secara real time',3),
(7,'student','m7s4','Used OneNote Class Notebook for collaboration','Menggunakan OneNote Class Notebook untuk kolaborasi',4),
(7,'student','m7s5','Completed a full group project workflow simulation','Menyelesaikan simulasi alur kerja proyek kelompok penuh',5),
-- Module 7 Teacher
(7,'teacher','m7t1','Team and channels are set up correctly','Tim dan saluran diatur dengan benar',1),
(7,'teacher','m7t2','Meeting recording and file sharing work','Rekaman rapat dan berbagi file berfungsi',2),
(7,'teacher','m7t3','Co-authoring shows simultaneous edits','Penulisan bersama menunjukkan pengeditan simultan',3),
(7,'teacher','m7t4','OneNote collaboration space is used appropriately','Ruang kolaborasi OneNote digunakan dengan tepat',4),
(7,'teacher','m7t5','Student demonstrates version history and conflict resolution','Siswa menunjukkan riwayat versi dan resolusi konflik',5),
-- Module 8 Student
(8,'student','m8s1','Linked Excel objects in Word and PowerPoint that update','Menautkan objek Excel di Word dan PowerPoint yang dapat diperbarui',1),
(8,'student','m8s2','Shared OneDrive file with expiration and password','Membagikan file OneDrive dengan kedaluwarsa dan kata sandi',2),
(8,'student','m8s3','Built a Power Automate flow for file notification','Membangun alur Power Automate untuk notifikasi file baru',3),
(8,'student','m8s4','Completed a ''College Day'' simulation','Menyelesaikan simulasi Hari Kuliah',4),
(8,'student','m8s5','Assembled final portfolio with all components','Menyusun portofolio akhir dengan semua komponen',5),
-- Module 8 Teacher
(8,'teacher','m8t1','Linked objects update correctly across apps','Objek tertaut diperbarui dengan benar di seluruh aplikasi',1),
(8,'teacher','m8t2','Sharing settings are appropriate and secure','Pengaturan berbagi sesuai dan aman',2),
(8,'teacher','m8t3','Power Automate flow triggers as designed','Alur Power Automate berjalan sesuai desain',3),
(8,'teacher','m8t4','Simulation demonstrates integrated workflow','Simulasi menunjukkan alur kerja terintegrasi',4),
(8,'teacher','m8t5','Portfolio is complete and reflection shows growth','Portofolio lengkap dan refleksi menunjukkan perkembangan',5)
ON CONFLICT (module_id, item_key) DO NOTHING;

-- Migrate any existing custom_checklist_items into the new table
INSERT INTO module_checklist_items (module_id, item_type, item_key, label, sort_order)
SELECT module_id, item_type, 'custom_' || id::text, label, 1000
FROM custom_checklist_items
ON CONFLICT (module_id, item_key) DO NOTHING;
