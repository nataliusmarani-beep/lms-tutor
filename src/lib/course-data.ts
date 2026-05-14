import type { CourseModule } from "@/types";

export const COURSE_MODULES: CourseModule[] = [
  {
    id: 1, week: 1, month: 1,
    icon: "💻",
    title: "Digital Basics, Security, Printer & OneNote",
    titleId: "Dasar Digital, Keamanan, Printer & OneNote",
    focus: "Computer literacy, file management, cyber safety, printer use, OneNote notebooks.",
    focusId: "Literasi komputer, manajemen file, keamanan siber, penggunaan printer, buku catatan OneNote.",
    studentChecklist: [
      { key: "m1s1", label: "Created a strong, unique password and locked the screen", labelId: "Membuat kata sandi kuat & unik dan mengunci layar" },
      { key: "m1s2", label: "Identified a phishing email", labelId: "Mengidentifikasi email phishing" },
      { key: "m1s3", label: "Successfully printed a document (or used Print to PDF)", labelId: "Berhasil mencetak dokumen (atau Print to PDF)" },
      { key: "m1s4", label: "Set up semester folder structure in OneDrive", labelId: "Membuat struktur folder semester di OneDrive" },
      { key: "m1s5", label: "Built Biology 101 notebook with all sections", labelId: "Membangun buku catatan Biologi 101 dengan semua bagian" },
      { key: "m1s6", label: "Added a lecture page with summary, clipping, and to-do tags", labelId: "Menambahkan halaman kuliah dengan ringkasan, kliping, dan tag" },
      { key: "m1s7", label: "Wrote a professional email with PDF attachment", labelId: "Menulis email profesional dengan lampiran PDF" },
      { key: "m1s8", label: "Can search and instantly find a specific note", labelId: "Dapat mencari dan langsung menemukan catatan tertentu" },
    ],
    teacherChecklist: [
      { key: "m1t1", label: "Student demonstrates basic security awareness (password, lock, phishing)", labelId: "Siswa menunjukkan kesadaran keamanan dasar" },
      { key: "m1t2", label: "Printer setup / print-to-PDF works correctly", labelId: "Pengaturan printer / print-to-PDF berfungsi" },
      { key: "m1t3", label: "Folder structure is logical and shared correctly", labelId: "Struktur folder logis dan dibagikan dengan benar" },
      { key: "m1t4", label: "OneNote notebook is well-organized with required elements", labelId: "OneNote terorganisir baik dengan elemen yang diminta" },
      { key: "m1t5", label: "Email demonstrates proper format and attachment", labelId: "Email menunjukkan format dan lampiran yang tepat" },
    ],
  },
  {
    id: 2, week: 2, month: 1,
    icon: "📄",
    title: "Word Foundations – Academic Papers & Formatting",
    titleId: "Dasar Word – Makalah Akademik & Pemformatan",
    focus: "Document creation, formatting, referencing, review.",
    focusId: "Pembuatan dokumen, pemformatan, referensi, peninjauan.",
    studentChecklist: [
      { key: "m2s1", label: "Typed a 300-word essay with exact formatting specifications", labelId: "Mengetik esai 300 kata dengan spesifikasi format yang tepat" },
      { key: "m2s2", label: "Created a college paper with running head and page number starting on page 2", labelId: "Membuat makalah kuliah dengan running head dan nomor halaman mulai halaman 2" },
      { key: "m2s3", label: "Inserted APA 7th citations and generated bibliography & TOC", labelId: "Menyisipkan sitasi APA 7th dan menghasilkan daftar pustaka & daftar isi" },
      { key: "m2s4", label: "Used Track Changes and comments to review a peer's paper", labelId: "Menggunakan Lacak Perubahan dan komentar untuk meninjau makalah rekan" },
      { key: "m2s5", label: "Can format an unformatted text into a college template in under 20 min", labelId: "Dapat memformat teks mentah menjadi templat kuliah dalam 20 menit" },
    ],
    teacherChecklist: [
      { key: "m2t1", label: "Essay formatting meets academic guidelines", labelId: "Pemformatan esai memenuhi pedoman akademik" },
      { key: "m2t2", label: "Running head and page numbering are correct", labelId: "Running head dan penomoran halaman benar" },
      { key: "m2t3", label: "Citations are properly formatted; TOC updates correctly", labelId: "Sitasi diformat dengan benar; daftar isi diperbarui otomatis" },
      { key: "m2t4", label: "Student effectively uses review features (Track Changes, comments)", labelId: "Siswa efektif menggunakan fitur peninjauan" },
      { key: "m2t5", label: "Time and accuracy on formatting drill", labelId: "Waktu dan akurasi pada latihan pemformatan" },
    ],
  },
  {
    id: 3, week: 3, month: 1,
    icon: "📊",
    title: "Excel Foundations – Data, Formulas & Charts",
    titleId: "Dasar Excel – Data, Rumus & Grafik",
    focus: "Spreadsheet literacy, basic analysis, visualization.",
    focusId: "Literasi lembar kerja, analisis dasar, visualisasi.",
    studentChecklist: [
      { key: "m3s1", label: "Built a monthly budget with SUM and formatting", labelId: "Membangun anggaran bulanan dengan SUM dan pemformatan" },
      { key: "m3s2", label: "Created a grade calculator that drops the lowest score", labelId: "Membuat kalkulator nilai yang membuang nilai terendah" },
      { key: "m3s3", label: "Designed a sales dashboard with summary table and two charts", labelId: "Merancang dasbor penjualan dengan tabel ringkasan dan dua grafik" },
      { key: "m3s4", label: "Merged data using XLOOKUP", labelId: "Menggabungkan data menggunakan XLOOKUP" },
      { key: "m3s5", label: "Applied drop-down and conditional formatting in grade calculator", labelId: "Menerapkan dropdown dan pemformatan bersyarat pada kalkulator nilai" },
    ],
    teacherChecklist: [
      { key: "m3t1", label: "Budget sheet has correct totals and is well-formatted", labelId: "Lembar anggaran memiliki total yang benar dan diformat dengan baik" },
      { key: "m3t2", label: "Grade calculator works with any set of scores", labelId: "Kalkulator nilai berfungsi dengan kumpulan nilai apa pun" },
      { key: "m3t3", label: "Dashboard charts are labeled and professional", labelId: "Grafik dasbor berlabel dan profesional" },
      { key: "m3t4", label: "XLOOKUP formula is correct", labelId: "Rumus XLOOKUP benar" },
      { key: "m3t5", label: "Advanced conditional formatting functions as intended", labelId: "Pemformatan bersyarat tingkat lanjut berfungsi sesuai harapan" },
    ],
  },
  {
    id: 4, week: 4, month: 1,
    icon: "🎨",
    title: "PowerPoint Essentials & Presentation Design",
    titleId: "Dasar PowerPoint & Desain Presentasi",
    focus: "Slide creation, design principles, delivery tools.",
    focusId: "Pembuatan slide, prinsip desain, alat penyampaian.",
    studentChecklist: [
      { key: "m4s1", label: "Built a 5-slide 'About Me' with consistent design and SmartArt", labelId: "Membangun presentasi 5 slide 'Tentang Saya' dengan desain konsisten" },
      { key: "m4s2", label: "Created 'Water Cycle' presentation with linked Excel chart and morph", labelId: "Membuat presentasi 'Siklus Air' dengan grafik Excel tertaut dan morph" },
      { key: "m4s3", label: "Recorded a 3-min presentation and self-critiqued", labelId: "Merekam presentasi 3 menit dan mengevaluasi diri" },
      { key: "m4s4", label: "Redesigned a bullet-point slide into a visual layout", labelId: "Mendesain ulang slide bullet point menjadi tata letak visual" },
      { key: "m4s5", label: "Can deliver a presentation confidently with Presenter View", labelId: "Dapat menyampaikan presentasi dengan Tampilan Penyaji" },
    ],
    teacherChecklist: [
      { key: "m4t1", label: "Slide Master is used; design is consistent", labelId: "Master Slide digunakan; desain konsisten" },
      { key: "m4t2", label: "Morph transitions and animations work smoothly", labelId: "Transisi morph dan animasi berfungsi mulus" },
      { key: "m4t3", label: "Linked Excel chart updates correctly", labelId: "Grafik Excel tertaut diperbarui dengan benar" },
      { key: "m4t4", label: "Recording is clear; speaker notes are used", labelId: "Rekaman jelas; catatan pembicara digunakan" },
      { key: "m4t5", label: "Visual redesign demonstrates understanding of design principles", labelId: "Desain ulang visual menunjukkan pemahaman prinsip desain" },
    ],
  },
  {
    id: 5, week: 5, month: 2,
    icon: "📑",
    title: "Advanced Word – Long Documents & Automation",
    titleId: "Word Mahir – Dokumen Panjang & Otomatisasi",
    focus: "Complex academic writing, templates.",
    focusId: "Penulisan akademik kompleks, templat.",
    studentChecklist: [
      { key: "m5s1", label: "Created a multi-level list linked to heading styles", labelId: "Membuat daftar bertingkat yang terhubung ke gaya heading" },
      { key: "m5s2", label: "Generated automatic TOC, table of figures, and cross-references", labelId: "Menghasilkan daftar isi, daftar gambar, dan referensi silang otomatis" },
      { key: "m5s3", label: "Built a .dotx template for a research paper", labelId: "Membangun templat .dotx untuk makalah riset" },
      { key: "m5s4", label: "Performed mail merge for labels/certificates", labelId: "Melakukan mail merge untuk label/sertifikat" },
      { key: "m5s5", label: "Created a form with content controls and protection", labelId: "Membuat formulir dengan kontrol konten dan proteksi" },
    ],
    teacherChecklist: [
      { key: "m5t1", label: "Document structure uses heading styles correctly", labelId: "Struktur dokumen menggunakan gaya heading dengan benar" },
      { key: "m5t2", label: "TOC and cross-references update properly", labelId: "Daftar isi dan referensi silang diperbarui dengan baik" },
      { key: "m5t3", label: "Template is reusable and professional", labelId: "Templat dapat digunakan kembali dan profesional" },
      { key: "m5t4", label: "Mail merge functions as expected", labelId: "Mail merge berfungsi sesuai harapan" },
      { key: "m5t5", label: "Form controls are properly set and protected", labelId: "Kontrol formulir diatur dengan benar dan terlindungi" },
    ],
  },
  {
    id: 6, week: 6, month: 2,
    icon: "📈",
    title: "Advanced Excel – Analysis & Modeling",
    titleId: "Excel Mahir – Analisis & Pemodelan",
    focus: "PivotTables, what-if tools, dashboard.",
    focusId: "PivotTable, alat what-if, dasbor.",
    studentChecklist: [
      { key: "m6s1", label: "Created PivotTable with slicers and calculated fields", labelId: "Membuat PivotTable dengan pemotong dan bidang terhitung" },
      { key: "m6s2", label: "Used SUMIFS, COUNTIFS, XLOOKUP, INDEX-MATCH", labelId: "Menggunakan SUMIFS, COUNTIFS, XLOOKUP, INDEX-MATCH" },
      { key: "m6s3", label: "Applied data validation and conditional formatting", labelId: "Menerapkan validasi data dan pemformatan bersyarat" },
      { key: "m6s4", label: "Performed Goal Seek and Scenario Manager", labelId: "Melakukan Goal Seek dan Scenario Manager" },
      { key: "m6s5", label: "Recorded a simple macro", labelId: "Merekam makro sederhana" },
      { key: "m6s6", label: "Built an interactive student grades dashboard", labelId: "Membangun dasbor interaktif nilai mahasiswa" },
    ],
    teacherChecklist: [
      { key: "m6t1", label: "PivotTable groups and filters data correctly", labelId: "PivotTable mengelompokkan dan menyaring data dengan benar" },
      { key: "m6t2", label: "Formulas are accurate and efficient", labelId: "Rumus akurat dan efisien" },
      { key: "m6t3", label: "Goal Seek produces correct required score", labelId: "Goal Seek menghasilkan skor yang diperlukan dengan tepat" },
      { key: "m6t4", label: "Macro runs without errors", labelId: "Makro berjalan tanpa kesalahan" },
      { key: "m6t5", label: "Dashboard is user-friendly and visually clear", labelId: "Dasbor ramah pengguna dan jelas secara visual" },
    ],
  },
  {
    id: 7, week: 7, month: 2,
    icon: "🧑‍🤝‍🧑",
    title: "Teams & OneNote – Collaboration for Group Projects",
    titleId: "Teams & OneNote – Kolaborasi Proyek Kelompok",
    focus: "Seamless teamwork, meetings, shared notes.",
    focusId: "Kerja tim, rapat, catatan bersama.",
    studentChecklist: [
      { key: "m7s1", label: "Created a Team with channels for a study group", labelId: "Membuat Tim dengan saluran untuk kelompok belajar" },
      { key: "m7s2", label: "Scheduled and hosted a Teams meeting with recording", labelId: "Menjadwalkan dan mengadakan rapat Teams dengan rekaman" },
      { key: "m7s3", label: "Shared files and co-authored in real time", labelId: "Berbagi file dan menulis bersama secara real time" },
      { key: "m7s4", label: "Used OneNote Class Notebook for collaboration", labelId: "Menggunakan OneNote Class Notebook untuk kolaborasi" },
      { key: "m7s5", label: "Completed a full group project workflow simulation", labelId: "Menyelesaikan simulasi alur kerja proyek kelompok penuh" },
    ],
    teacherChecklist: [
      { key: "m7t1", label: "Team and channels are set up correctly", labelId: "Tim dan saluran diatur dengan benar" },
      { key: "m7t2", label: "Meeting recording and file sharing work", labelId: "Rekaman rapat dan berbagi file berfungsi" },
      { key: "m7t3", label: "Co-authoring shows simultaneous edits", labelId: "Penulisan bersama menunjukkan pengeditan simultan" },
      { key: "m7t4", label: "OneNote collaboration space is used appropriately", labelId: "Ruang kolaborasi OneNote digunakan dengan tepat" },
      { key: "m7t5", label: "Student demonstrates version history and conflict resolution", labelId: "Siswa menunjukkan riwayat versi dan resolusi konflik" },
    ],
  },
  {
    id: 8, week: 8, month: 2,
    icon: "⚙️",
    title: "Integration, Automation & Final Portfolio",
    titleId: "Integrasi, Otomatisasi & Portofolio Akhir",
    focus: "Cross-app efficiency, Power Automate, portfolio.",
    focusId: "Efisiensi lintas aplikasi, Power Automate, portofolio.",
    studentChecklist: [
      { key: "m8s1", label: "Linked Excel objects in Word and PowerPoint that update", labelId: "Menautkan objek Excel di Word dan PowerPoint yang dapat diperbarui" },
      { key: "m8s2", label: "Shared OneDrive file with expiration and password", labelId: "Membagikan file OneDrive dengan kedaluwarsa dan kata sandi" },
      { key: "m8s3", label: "Built a Power Automate flow for file notification", labelId: "Membangun alur Power Automate untuk notifikasi file baru" },
      { key: "m8s4", label: "Completed a 'College Day' simulation", labelId: "Menyelesaikan simulasi 'Hari Kuliah'" },
      { key: "m8s5", label: "Assembled final portfolio with all components", labelId: "Menyusun portofolio akhir dengan semua komponen" },
    ],
    teacherChecklist: [
      { key: "m8t1", label: "Linked objects update correctly across apps", labelId: "Objek tertaut diperbarui dengan benar di seluruh aplikasi" },
      { key: "m8t2", label: "Sharing settings are appropriate and secure", labelId: "Pengaturan berbagi sesuai dan aman" },
      { key: "m8t3", label: "Power Automate flow triggers as designed", labelId: "Alur Power Automate berjalan sesuai desain" },
      { key: "m8t4", label: "Simulation demonstrates integrated workflow", labelId: "Simulasi menunjukkan alur kerja terintegrasi" },
      { key: "m8t5", label: "Portfolio is complete and reflection shows growth", labelId: "Portofolio lengkap dan refleksi menunjukkan perkembangan" },
    ],
  },
];

export function getModule(id: number) {
  return COURSE_MODULES.find((m) => m.id === id);
}

export function getTotalChecks(moduleId: number, type: "student" | "teacher") {
  const mod = getModule(moduleId);
  if (!mod) return 0;
  return type === "student" ? mod.studentChecklist.length : mod.teacherChecklist.length;
}
