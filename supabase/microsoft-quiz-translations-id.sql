DO $$
BEGIN

  -- ============================================================
  -- MODULE 1 — File Management & Shortcuts Quiz
  -- ============================================================

  -- Q1
  UPDATE quiz_questions
  SET question_text_id = 'Pintasan keyboard mana yang digunakan untuk menyalin teks atau file yang dipilih?'
  WHERE question_text = 'Which keyboard shortcut is used to copy selected text or files?';

  UPDATE quiz_options
  SET option_text_id = 'Ctrl+V'
  WHERE option_text = 'Ctrl+V'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which keyboard shortcut is used to copy selected text or files?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Ctrl+C'
  WHERE option_text = 'Ctrl+C'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which keyboard shortcut is used to copy selected text or files?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Ctrl+X'
  WHERE option_text = 'Ctrl+X'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which keyboard shortcut is used to copy selected text or files?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Ctrl+Z'
  WHERE option_text = 'Ctrl+Z'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which keyboard shortcut is used to copy selected text or files?' LIMIT 1);

  -- Q2
  UPDATE quiz_questions
  SET question_text_id = 'Apa fungsi Ctrl+Z di sebagian besar aplikasi Windows?'
  WHERE question_text = 'What does Ctrl+Z do in most Windows applications?';

  UPDATE quiz_options
  SET option_text_id = 'Ulangi tindakan terakhir'
  WHERE option_text = 'Redo the last action'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does Ctrl+Z do in most Windows applications?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Simpan file'
  WHERE option_text = 'Save the file'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does Ctrl+Z do in most Windows applications?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Batalkan tindakan terakhir'
  WHERE option_text = 'Undo the last action'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does Ctrl+Z do in most Windows applications?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tutup jendela'
  WHERE option_text = 'Close the window'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does Ctrl+Z do in most Windows applications?' LIMIT 1);

  -- Q3
  UPDATE quiz_questions
  SET question_text_id = 'Pintasan keyboard mana yang memungkinkan Anda berpindah antar jendela yang terbuka di Windows?'
  WHERE question_text = 'Which keyboard shortcut lets you switch between open windows on Windows?';

  UPDATE quiz_options
  SET option_text_id = 'Ctrl+Tab'
  WHERE option_text = 'Ctrl+Tab'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which keyboard shortcut lets you switch between open windows on Windows?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Alt+Tab'
  WHERE option_text = 'Alt+Tab'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which keyboard shortcut lets you switch between open windows on Windows?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Win+Tab'
  WHERE option_text = 'Win+Tab'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which keyboard shortcut lets you switch between open windows on Windows?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Shift+Tab'
  WHERE option_text = 'Shift+Tab'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which keyboard shortcut lets you switch between open windows on Windows?' LIMIT 1);

  -- Q4
  UPDATE quiz_questions
  SET question_text_id = 'Saat Anda "Simpan sebagai PDF" dari Microsoft Word, apa manfaat yang diberikan?'
  WHERE question_text = 'When you "Save as PDF" from Microsoft Word, what benefit does this provide?';

  UPDATE quiz_options
  SET option_text_id = 'File dapat dengan mudah diedit oleh siapa saja'
  WHERE option_text = 'The file can be easily edited by anyone'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When you "Save as PDF" from Microsoft Word, what benefit does this provide?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Pemformatan terjaga dan file dapat dibaca secara universal'
  WHERE option_text = 'The formatting is preserved and the file is universally readable'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When you "Save as PDF" from Microsoft Word, what benefit does this provide?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Ukuran file menjadi lebih besar'
  WHERE option_text = 'The file size becomes larger'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When you "Save as PDF" from Microsoft Word, what benefit does this provide?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Dokumen secara otomatis dikirim melalui email'
  WHERE option_text = 'The document is automatically emailed'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When you "Save as PDF" from Microsoft Word, what benefit does this provide?' LIMIT 1);

  -- Q5
  UPDATE quiz_questions
  SET question_text_id = 'Mengapa penting mengunci layar komputer saat meninggalkan meja?'
  WHERE question_text = 'Why is it important to lock your computer screen when leaving your desk?';

  UPDATE quiz_options
  SET option_text_id = 'Hanya menghemat daya baterai'
  WHERE option_text = 'It saves battery power only'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Why is it important to lock your computer screen when leaving your desk?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Mencegah orang lain mengakses file dan akun Anda'
  WHERE option_text = 'It prevents others from accessing your files and accounts'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Why is it important to lock your computer screen when leaving your desk?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Mempercepat komputer'
  WHERE option_text = 'It speeds up the computer'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Why is it important to lock your computer screen when leaving your desk?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Secara otomatis mencadangkan file Anda'
  WHERE option_text = 'It automatically backs up your files'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Why is it important to lock your computer screen when leaving your desk?' LIMIT 1);

  -- ============================================================
  -- MODULE 2 — Internet Safety & Email Security Quiz
  -- ============================================================

  -- Q1
  UPDATE quiz_questions
  SET question_text_id = 'Manakah dari berikut ini yang merupakan tanda bahaya bahwa email mungkin merupakan upaya phishing?'
  WHERE question_text = 'Which of the following is a red flag that an email may be a phishing attempt?';

  UPDATE quiz_options
  SET option_text_id = 'Email berasal dari alamat universitas Anda'
  WHERE option_text = 'The email comes from your university address'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which of the following is a red flag that an email may be a phishing attempt?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Email berisi tautan yang tidak Anda harapkan dan meminta kata sandi Anda secara mendesak'
  WHERE option_text = 'The email contains a link you did not expect and asks for your password urgently'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which of the following is a red flag that an email may be a phishing attempt?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Email memiliki salam yang profesional'
  WHERE option_text = 'The email has a professional greeting'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which of the following is a red flag that an email may be a phishing attempt?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Email mencantumkan nama lengkap Anda yang benar'
  WHERE option_text = 'The email includes your correct full name'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which of the following is a red flag that an email may be a phishing attempt?' LIMIT 1);

  -- Q2
  UPDATE quiz_questions
  SET question_text_id = 'Manakah dari berikut ini yang merupakan kata sandi terkuat?'
  WHERE question_text = 'Which of the following is the strongest password?';

  UPDATE quiz_options
  SET option_text_id = 'password123'
  WHERE option_text = 'password123'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which of the following is the strongest password?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'John1990'
  WHERE option_text = 'John1990'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which of the following is the strongest password?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'PurpleTiger$Runs@Night7'
  WHERE option_text = 'PurpleTiger$Runs@Night7'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which of the following is the strongest password?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'qwerty'
  WHERE option_text = 'qwerty'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which of the following is the strongest password?' LIMIT 1);

  -- Q3
  UPDATE quiz_questions
  SET question_text_id = 'Apa yang dilakukan autentikasi dua faktor (2FA)?'
  WHERE question_text = 'What does two-factor authentication (2FA) do?';

  UPDATE quiz_options
  SET option_text_id = 'Memungkinkan Anda masuk dua kali lebih cepat'
  WHERE option_text = 'It lets you log in twice faster'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does two-factor authentication (2FA) do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Memerlukan dua bentuk verifikasi, menambahkan lapisan keamanan ekstra'
  WHERE option_text = 'It requires two forms of verification, adding an extra security layer'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does two-factor authentication (2FA) do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Memblokir semua email dari pengirim yang tidak dikenal'
  WHERE option_text = 'It blocks all emails from unknown senders'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does two-factor authentication (2FA) do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Secara otomatis mengubah kata sandi Anda setiap dua minggu'
  WHERE option_text = 'It automatically changes your password every two weeks'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does two-factor authentication (2FA) do?' LIMIT 1);

  -- Q4
  UPDATE quiz_questions
  SET question_text_id = 'Saat menulis email profesional, praktik mana yang paling tepat?'
  WHERE question_text = 'When writing a professional email, which practice is most appropriate?';

  UPDATE quiz_options
  SET option_text_id = 'Gunakan emoji di seluruh email agar tampak ramah'
  WHERE option_text = 'Use emojis throughout to appear friendly'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When writing a professional email, which practice is most appropriate?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tulis dengan huruf kapital semua untuk menekankan poin Anda'
  WHERE option_text = 'Write in all capitals to emphasise your points'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When writing a professional email, which practice is most appropriate?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Gunakan baris subjek yang jelas, salam formal, dan penutup yang sopan'
  WHERE option_text = 'Use a clear subject line, formal greeting, and polite sign-off'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When writing a professional email, which practice is most appropriate?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Lewati salam dan langsung ke permintaan Anda'
  WHERE option_text = 'Skip the greeting and go straight to your request'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When writing a professional email, which practice is most appropriate?' LIMIT 1);

  -- Q5
  UPDATE quiz_questions
  SET question_text_id = 'Jika Anda menerima email phishing yang mencurigakan, apa yang harus Anda lakukan?'
  WHERE question_text = 'If you receive a suspicious phishing email, what should you do?';

  UPDATE quiz_options
  SET option_text_id = 'Balas dengan menanyakan apakah email itu sah'
  WHERE option_text = 'Reply asking if it is legitimate'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'If you receive a suspicious phishing email, what should you do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Klik tautan untuk menyelidiki lebih lanjut'
  WHERE option_text = 'Click the link to investigate further'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'If you receive a suspicious phishing email, what should you do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Laporkan sebagai phishing/spam dan jangan klik tautan apapun'
  WHERE option_text = 'Report it as phishing/spam and do not click any links'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'If you receive a suspicious phishing email, what should you do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Teruskan ke teman sebagai peringatan'
  WHERE option_text = 'Forward it to friends as a warning'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'If you receive a suspicious phishing email, what should you do?' LIMIT 1);

  -- ============================================================
  -- MODULE 3 — Microsoft Word Features Quiz
  -- ============================================================

  -- Q1
  UPDATE quiz_questions
  SET question_text_id = 'Apa manfaat utama menggunakan Gaya Judul di Microsoft Word?'
  WHERE question_text = 'What is the main benefit of using Heading Styles in Microsoft Word?';

  UPDATE quiz_options
  SET option_text_id = 'Hanya membuat teks menjadi tebal'
  WHERE option_text = 'They make the text bold only'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is the main benefit of using Heading Styles in Microsoft Word?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Membuat struktur yang konsisten dan memungkinkan Daftar Isi otomatis'
  WHERE option_text = 'They create a consistent structure and enable an automatic Table of Contents'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is the main benefit of using Heading Styles in Microsoft Word?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Secara otomatis memeriksa ejaan dokumen Anda'
  WHERE option_text = 'They automatically spell-check your document'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is the main benefit of using Heading Styles in Microsoft Word?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Mengubah orientasi halaman'
  WHERE option_text = 'They change the page orientation'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is the main benefit of using Heading Styles in Microsoft Word?' LIMIT 1);

  -- Q2
  UPDATE quiz_questions
  SET question_text_id = 'Di mana Anda dapat menemukan pemeriksaan Ejaan & Tata Bahasa di Microsoft Word?'
  WHERE question_text = 'Where can you find the Spelling & Grammar check in Microsoft Word?';

  UPDATE quiz_options
  SET option_text_id = 'Tab Beranda → Grup Font'
  WHERE option_text = 'Home tab → Font group'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Where can you find the Spelling & Grammar check in Microsoft Word?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tab Sisipkan → Grup Teks'
  WHERE option_text = 'Insert tab → Text group'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Where can you find the Spelling & Grammar check in Microsoft Word?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tab Tinjau → Grup Pemeriksaan'
  WHERE option_text = 'Review tab → Proofing group'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Where can you find the Spelling & Grammar check in Microsoft Word?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tab Tampilan → Grup Tampilkan'
  WHERE option_text = 'View tab → Show group'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Where can you find the Spelling & Grammar check in Microsoft Word?' LIMIT 1);

  -- Q3
  UPDATE quiz_questions
  SET question_text_id = 'Apa yang "Lacak Perubahan" memungkinkan Anda lakukan di Microsoft Word?'
  WHERE question_text = 'What does "Track Changes" allow you to do in Microsoft Word?';

  UPDATE quiz_options
  SET option_text_id = 'Menyimpan dokumen secara otomatis setiap 5 menit'
  WHERE option_text = 'Automatically save the document every 5 minutes'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does "Track Changes" allow you to do in Microsoft Word?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Merekam semua pengeditan sehingga peninjau dapat melihat, menerima, atau menolak setiap perubahan'
  WHERE option_text = 'Record all edits so reviewers can see, accept, or reject each change'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does "Track Changes" allow you to do in Microsoft Word?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Mengunci dokumen agar tidak ada yang bisa mengeditnya'
  WHERE option_text = 'Lock the document so no one can edit it'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does "Track Changes" allow you to do in Microsoft Word?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Mengonversi dokumen menjadi PDF'
  WHERE option_text = 'Convert the document into a PDF'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does "Track Changes" allow you to do in Microsoft Word?' LIMIT 1);

  -- Q4
  UPDATE quiz_questions
  SET question_text_id = 'Bagaimana cara mengekspor dokumen Word sebagai PDF?'
  WHERE question_text = 'How do you export a Word document as a PDF?';

  UPDATE quiz_options
  SET option_text_id = 'Beranda → Simpan'
  WHERE option_text = 'Home → Save'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How do you export a Word document as a PDF?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'File → Simpan Sebagai → pilih format PDF'
  WHERE option_text = 'File → Save As → choose PDF format'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How do you export a Word document as a PDF?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Sisipkan → PDF'
  WHERE option_text = 'Insert → PDF'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How do you export a Word document as a PDF?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tinjau → Ekspor'
  WHERE option_text = 'Review → Export'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How do you export a Word document as a PDF?' LIMIT 1);

  -- Q5
  UPDATE quiz_questions
  SET question_text_id = 'Fitur mana yang membantu Anda memulai dokumen yang tampak profesional dengan cepat tanpa memformat dari awal?'
  WHERE question_text = 'Which feature helps you start a professional-looking document quickly without formatting from scratch?';

  UPDATE quiz_options
  SET option_text_id = 'Makro'
  WHERE option_text = 'Macros'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which feature helps you start a professional-looking document quickly without formatting from scratch?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Templat'
  WHERE option_text = 'Templates'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which feature helps you start a professional-looking document quickly without formatting from scratch?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Penanda'
  WHERE option_text = 'Bookmarks'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which feature helps you start a professional-looking document quickly without formatting from scratch?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Gabung Surat'
  WHERE option_text = 'Mail Merge'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which feature helps you start a professional-looking document quickly without formatting from scratch?' LIMIT 1);

  -- ============================================================
  -- MODULE 4 — Microsoft Excel Quiz
  -- ============================================================

  -- Q1
  UPDATE quiz_questions
  SET question_text_id = 'Rumus mana yang akan Anda gunakan untuk menjumlahkan semua nilai di sel A1 hingga A10?'
  WHERE question_text = 'Which formula would you use to add up all values in cells A1 through A10?';

  UPDATE quiz_options
  SET option_text_id = '=TOTAL(A1:A10)'
  WHERE option_text = '=TOTAL(A1:A10)'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which formula would you use to add up all values in cells A1 through A10?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = '=ADD(A1,A10)'
  WHERE option_text = '=ADD(A1,A10)'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which formula would you use to add up all values in cells A1 through A10?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = '=SUM(A1:A10)'
  WHERE option_text = '=SUM(A1:A10)'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which formula would you use to add up all values in cells A1 through A10?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = '=COUNT(A1:A10)'
  WHERE option_text = '=COUNT(A1:A10)'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which formula would you use to add up all values in cells A1 through A10?' LIMIT 1);

  -- Q2
  UPDATE quiz_questions
  SET question_text_id = 'Apa fungsi AVERAGE di Excel?'
  WHERE question_text = 'What does the AVERAGE function do in Excel?';

  UPDATE quiz_options
  SET option_text_id = 'Mengembalikan nilai terbesar dalam rentang'
  WHERE option_text = 'Returns the largest value in a range'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does the AVERAGE function do in Excel?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Menghitung berapa banyak sel yang berisi angka'
  WHERE option_text = 'Counts how many cells contain numbers'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does the AVERAGE function do in Excel?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Menghitung rata-rata aritmatika dari rentang sel'
  WHERE option_text = 'Calculates the arithmetic mean of a range of cells'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does the AVERAGE function do in Excel?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Hanya menjumlahkan nilai sel pertama dan terakhir'
  WHERE option_text = 'Adds only the first and last cell values'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does the AVERAGE function do in Excel?' LIMIT 1);

  -- Q3
  UPDATE quiz_questions
  SET question_text_id = 'Untuk membuat grafik di Excel dari data yang dipilih, tab mana yang Anda gunakan?'
  WHERE question_text = 'To create a chart in Excel from selected data, which tab do you use?';

  UPDATE quiz_options
  SET option_text_id = 'Beranda'
  WHERE option_text = 'Home'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'To create a chart in Excel from selected data, which tab do you use?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Rumus'
  WHERE option_text = 'Formulas'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'To create a chart in Excel from selected data, which tab do you use?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Sisipkan'
  WHERE option_text = 'Insert'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'To create a chart in Excel from selected data, which tab do you use?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Data'
  WHERE option_text = 'Data'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'To create a chart in Excel from selected data, which tab do you use?' LIMIT 1);

  -- Q4
  UPDATE quiz_questions
  SET question_text_id = 'Apa yang fitur Filter di Excel memungkinkan Anda lakukan?'
  WHERE question_text = 'What does the Filter feature in Excel allow you to do?';

  UPDATE quiz_options
  SET option_text_id = 'Menghapus baris yang tidak sesuai dengan kriteria Anda'
  WHERE option_text = 'Delete rows that do not match your criteria'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does the Filter feature in Excel allow you to do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Menampilkan hanya baris yang memenuhi kriteria yang ditentukan, menyembunyikan yang lain'
  WHERE option_text = 'Display only the rows that meet specified criteria, hiding the rest'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does the Filter feature in Excel allow you to do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Hanya mengurutkan data secara alfabetis'
  WHERE option_text = 'Sort data alphabetically only'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does the Filter feature in Excel allow you to do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Menyalin data ke lembar kerja baru secara otomatis'
  WHERE option_text = 'Copy data to a new worksheet automatically'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does the Filter feature in Excel allow you to do?' LIMIT 1);

  -- Q5
  UPDATE quiz_questions
  SET question_text_id = 'Format angka mana yang akan Anda terapkan pada sel untuk menampilkan nilai sebagai mata uang (mis. $1.250,00)?'
  WHERE question_text = 'Which number format would you apply to a cell to display a value as currency (e.g. $1,250.00)?';

  UPDATE quiz_options
  SET option_text_id = 'Umum'
  WHERE option_text = 'General'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which number format would you apply to a cell to display a value as currency (e.g. $1,250.00)?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Teks'
  WHERE option_text = 'Text'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which number format would you apply to a cell to display a value as currency (e.g. $1,250.00)?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Mata Uang'
  WHERE option_text = 'Currency'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which number format would you apply to a cell to display a value as currency (e.g. $1,250.00)?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Persentase'
  WHERE option_text = 'Percentage'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which number format would you apply to a cell to display a value as currency (e.g. $1,250.00)?' LIMIT 1);

  -- ============================================================
  -- MODULE 5 — Microsoft PowerPoint Quiz
  -- ============================================================

  -- Q1
  UPDATE quiz_questions
  SET question_text_id = 'Apa tujuan menerapkan Tema di PowerPoint?'
  WHERE question_text = 'What is the purpose of applying a Theme in PowerPoint?';

  UPDATE quiz_options
  SET option_text_id = 'Menambahkan animasi ke setiap slide secara otomatis'
  WHERE option_text = 'To add animations to every slide automatically'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is the purpose of applying a Theme in PowerPoint?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Menerapkan sekumpulan warna, font, dan efek yang konsisten di semua slide'
  WHERE option_text = 'To apply a consistent set of colours, fonts, and effects across all slides'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is the purpose of applying a Theme in PowerPoint?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Mengonversi slide menjadi PDF'
  WHERE option_text = 'To convert slides into a PDF'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is the purpose of applying a Theme in PowerPoint?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Mengunci konten slide dari pengeditan'
  WHERE option_text = 'To lock slide content from editing'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is the purpose of applying a Theme in PowerPoint?' LIMIT 1);

  -- Q2
  UPDATE quiz_questions
  SET question_text_id = 'Di mana Anda menambahkan transisi slide di PowerPoint?'
  WHERE question_text = 'Where do you add slide transitions in PowerPoint?';

  UPDATE quiz_options
  SET option_text_id = 'Tab Beranda'
  WHERE option_text = 'Home tab'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Where do you add slide transitions in PowerPoint?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tab Sisipkan'
  WHERE option_text = 'Insert tab'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Where do you add slide transitions in PowerPoint?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tab Transisi'
  WHERE option_text = 'Transitions tab'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Where do you add slide transitions in PowerPoint?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tab Tinjau'
  WHERE option_text = 'Review tab'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Where do you add slide transitions in PowerPoint?' LIMIT 1);

  -- Q3
  UPDATE quiz_questions
  SET question_text_id = 'Untuk apa Tampilan Presenter di PowerPoint digunakan?'
  WHERE question_text = 'What is Presenter View in PowerPoint used for?';

  UPDATE quiz_options
  SET option_text_id = 'Mencetak slide dengan catatan pembicara'
  WHERE option_text = 'Printing slides with speaker notes'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is Presenter View in PowerPoint used for?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Menampilkan slide di layar audiens sementara presenter melihat catatan dan slide berikutnya di layarnya sendiri'
  WHERE option_text = 'Showing slides on the audience screen while the presenter sees notes and upcoming slides on their own screen'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is Presenter View in PowerPoint used for?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Merekam video presentasi'
  WHERE option_text = 'Recording a video of the presentation'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is Presenter View in PowerPoint used for?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Memeriksa ejaan di semua slide sekaligus'
  WHERE option_text = 'Checking spelling on all slides at once'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is Presenter View in PowerPoint used for?' LIMIT 1);

  -- Q4
  UPDATE quiz_questions
  SET question_text_id = 'Manakah praktik terbaik untuk desain slide dalam presentasi profesional?'
  WHERE question_text = 'Which is a best practice for slide design in a professional presentation?';

  UPDATE quiz_options
  SET option_text_id = 'Gunakan sebanyak mungkin font berbeda agar slide menarik'
  WHERE option_text = 'Use as many different fonts as possible to keep slides interesting'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which is a best practice for slide design in a professional presentation?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Isi setiap slide dengan teks sebanyak mungkin'
  WHERE option_text = 'Fill each slide with as much text as possible'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which is a best practice for slide design in a professional presentation?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Gunakan teks minimal, judul yang jelas, dan visual yang relevan'
  WHERE option_text = 'Use minimal text, clear headings, and relevant visuals'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which is a best practice for slide design in a professional presentation?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Terapkan tema yang berbeda pada setiap slide'
  WHERE option_text = 'Apply a different theme to each slide'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which is a best practice for slide design in a professional presentation?' LIMIT 1);

  -- Q5
  UPDATE quiz_questions
  SET question_text_id = 'Bagaimana cara menyisipkan grafik dari data Excel ke dalam slide PowerPoint?'
  WHERE question_text = 'How do you insert a chart from Excel data into a PowerPoint slide?';

  UPDATE quiz_options
  SET option_text_id = 'Tab Beranda → Tempel Spesial'
  WHERE option_text = 'Home tab → Paste Special'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How do you insert a chart from Excel data into a PowerPoint slide?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tab Sisipkan → Grafik, atau salin dari Excel dan Tempel Spesial sebagai objek tertaut'
  WHERE option_text = 'Insert tab → Chart, or copy from Excel and Paste Special as a linked object'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How do you insert a chart from Excel data into a PowerPoint slide?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tab File → Impor'
  WHERE option_text = 'File tab → Import'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How do you insert a chart from Excel data into a PowerPoint slide?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tab Desain → Tambah Data'
  WHERE option_text = 'Design tab → Add Data'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How do you insert a chart from Excel data into a PowerPoint slide?' LIMIT 1);

  -- ============================================================
  -- MODULE 6 — OneDrive & Cloud Storage Quiz
  -- ============================================================

  -- Q1
  UPDATE quiz_questions
  SET question_text_id = 'Apa keuntungan utama menyimpan file di OneDrive daripada hanya di hard drive lokal Anda?'
  WHERE question_text = 'What is the main advantage of storing files on OneDrive instead of only on your local hard drive?';

  UPDATE quiz_options
  SET option_text_id = 'File di OneDrive terbuka lebih cepat di komputer Anda'
  WHERE option_text = 'Files on OneDrive open faster on your computer'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is the main advantage of storing files on OneDrive instead of only on your local hard drive?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'File dapat diakses dari perangkat mana pun dengan akses internet dan dicadangkan'
  WHERE option_text = 'Files are accessible from any device with internet access and are backed up'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is the main advantage of storing files on OneDrive instead of only on your local hard drive?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'OneDrive secara otomatis mengedit dokumen Anda'
  WHERE option_text = 'OneDrive automatically edits your documents for you'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is the main advantage of storing files on OneDrive instead of only on your local hard drive?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'File yang disimpan di OneDrive tidak dapat dihapus'
  WHERE option_text = 'Files stored on OneDrive cannot be deleted'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What is the main advantage of storing files on OneDrive instead of only on your local hard drive?' LIMIT 1);

  -- Q2
  UPDATE quiz_questions
  SET question_text_id = 'Saat berbagi file OneDrive, tingkat izin mana yang memungkinkan seseorang melihat tetapi TIDAK mengedit file?'
  WHERE question_text = 'When sharing a OneDrive file, which permission level allows someone to view but NOT edit the file?';

  UPDATE quiz_options
  SET option_text_id = 'Dapat mengedit'
  WHERE option_text = 'Can edit'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When sharing a OneDrive file, which permission level allows someone to view but NOT edit the file?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Pemilik'
  WHERE option_text = 'Owner'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When sharing a OneDrive file, which permission level allows someone to view but NOT edit the file?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Dapat melihat'
  WHERE option_text = 'Can view'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When sharing a OneDrive file, which permission level allows someone to view but NOT edit the file?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Akses penuh'
  WHERE option_text = 'Full access'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When sharing a OneDrive file, which permission level allows someone to view but NOT edit the file?' LIMIT 1);

  -- Q3
  UPDATE quiz_questions
  SET question_text_id = 'Apa arti "penulisan bersama" di OneDrive dan Office 365?'
  WHERE question_text = 'What does "co-authoring" mean in OneDrive and Office 365?';

  UPDATE quiz_options
  SET option_text_id = 'Dua orang menulis dokumen terpisah dan menggabungkannya nanti'
  WHERE option_text = 'Two people write separate documents and merge them later'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does "co-authoring" mean in OneDrive and Office 365?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Beberapa pengguna dapat mengedit dokumen yang sama secara bersamaan'
  WHERE option_text = 'Multiple users can edit the same document at the same time'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does "co-authoring" mean in OneDrive and Office 365?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Satu orang menulis dan orang lain menyetujui perubahan'
  WHERE option_text = 'One person writes and another person approves changes'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does "co-authoring" mean in OneDrive and Office 365?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Dokumen disalin ke beberapa folder secara otomatis'
  WHERE option_text = 'A document is copied to multiple folders automatically'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does "co-authoring" mean in OneDrive and Office 365?' LIMIT 1);

  -- Q4
  UPDATE quiz_questions
  SET question_text_id = 'Apa yang Riwayat Versi di OneDrive memungkinkan Anda lakukan?'
  WHERE question_text = 'What does Version History in OneDrive allow you to do?';

  UPDATE quiz_options
  SET option_text_id = 'Melihat siapa yang telah melihat file'
  WHERE option_text = 'See who has viewed a file'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does Version History in OneDrive allow you to do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Memulihkan file ke kondisi tersimpan sebelumnya jika perubahan dibuat secara tidak sengaja'
  WHERE option_text = 'Restore a file to an earlier saved state if changes were made in error'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does Version History in OneDrive allow you to do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Menduplikasi versi file saat ini'
  WHERE option_text = 'Duplicate the current version of a file'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does Version History in OneDrive allow you to do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Mengunci file agar tidak ada perubahan lebih lanjut'
  WHERE option_text = 'Lock a file so no further changes can be made'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does Version History in OneDrive allow you to do?' LIMIT 1);

  -- Q5
  UPDATE quiz_questions
  SET question_text_id = 'Ketika OneDrive disinkronkan ke desktop Anda, apa yang terjadi saat Anda menyimpan file ke folder OneDrive?'
  WHERE question_text = 'When OneDrive is synced to your desktop, what happens when you save a file to the OneDrive folder?';

  UPDATE quiz_options
  SET option_text_id = 'File hanya disimpan di komputer Anda sampai Anda mengunggahnya secara manual'
  WHERE option_text = 'The file is saved only on your computer until you manually upload it'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When OneDrive is synced to your desktop, what happens when you save a file to the OneDrive folder?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'File secara otomatis disinkronkan ke cloud dan dapat diakses di perangkat lain'
  WHERE option_text = 'The file is automatically synced to the cloud and accessible on other devices'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When OneDrive is synced to your desktop, what happens when you save a file to the OneDrive folder?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'File dibagikan ke semua kontak Anda secara otomatis'
  WHERE option_text = 'The file is shared with all your contacts automatically'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When OneDrive is synced to your desktop, what happens when you save a file to the OneDrive folder?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'File dikonversi ke PDF sebelum diunggah'
  WHERE option_text = 'The file is converted to a PDF before uploading'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When OneDrive is synced to your desktop, what happens when you save a file to the OneDrive folder?' LIMIT 1);

  -- ============================================================
  -- MODULE 7 — Microsoft Forms & Digital Assessment Quiz
  -- ============================================================

  -- Q1
  UPDATE quiz_questions
  SET question_text_id = 'Manakah dari berikut ini yang BUKAN jenis pertanyaan yang tersedia di Microsoft Forms?'
  WHERE question_text = 'Which of the following is NOT a question type available in Microsoft Forms?';

  UPDATE quiz_options
  SET option_text_id = 'Pilihan ganda'
  WHERE option_text = 'Multiple choice'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which of the following is NOT a question type available in Microsoft Forms?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Penilaian'
  WHERE option_text = 'Rating'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which of the following is NOT a question type available in Microsoft Forms?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tabel pivot'
  WHERE option_text = 'Pivot table'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which of the following is NOT a question type available in Microsoft Forms?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Teks (jawaban terbuka)'
  WHERE option_text = 'Text (open-ended)'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which of the following is NOT a question type available in Microsoft Forms?' LIMIT 1);

  -- Q2
  UPDATE quiz_questions
  SET question_text_id = 'Apa yang "percabangan" di Microsoft Forms memungkinkan Anda lakukan?'
  WHERE question_text = 'What does "branching" in Microsoft Forms allow you to do?';

  UPDATE quiz_options
  SET option_text_id = 'Menyalin formulir ke akun lain'
  WHERE option_text = 'Copy the form to another account'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does "branching" in Microsoft Forms allow you to do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Mengarahkan responden ke pertanyaan berbeda berdasarkan jawaban sebelumnya'
  WHERE option_text = 'Direct respondents to different questions based on their previous answers'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does "branching" in Microsoft Forms allow you to do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Menilai semua respons secara otomatis'
  WHERE option_text = 'Automatically grade all responses'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does "branching" in Microsoft Forms allow you to do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Membagi formulir menjadi beberapa halaman'
  WHERE option_text = 'Split the form into multiple pages'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does "branching" in Microsoft Forms allow you to do?' LIMIT 1);

  -- Q3
  UPDATE quiz_questions
  SET question_text_id = 'Di mana Anda dapat melihat ringkasan semua respons yang dikumpulkan di Microsoft Forms?'
  WHERE question_text = 'Where can you view a summary of all responses collected in Microsoft Forms?';

  UPDATE quiz_options
  SET option_text_id = 'Tab Pengaturan'
  WHERE option_text = 'Settings tab'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Where can you view a summary of all responses collected in Microsoft Forms?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tab Desain'
  WHERE option_text = 'Design tab'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Where can you view a summary of all responses collected in Microsoft Forms?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tab Respons'
  WHERE option_text = 'Responses tab'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Where can you view a summary of all responses collected in Microsoft Forms?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tab Bagikan'
  WHERE option_text = 'Share tab'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Where can you view a summary of all responses collected in Microsoft Forms?' LIMIT 1);

  -- Q4
  UPDATE quiz_questions
  SET question_text_id = 'Bagaimana cara berbagi Microsoft Form dengan orang di luar organisasi Anda?'
  WHERE question_text = 'How can you share a Microsoft Form with people outside your organisation?';

  UPDATE quiz_options
  SET option_text_id = 'Ekspor sebagai dokumen Word'
  WHERE option_text = 'Export it as a Word document'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How can you share a Microsoft Form with people outside your organisation?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Kirim tautan formulir yang diatur ke "Siapa pun dengan tautan dapat merespons"'
  WHERE option_text = 'Send the form link set to "Anyone with the link can respond"'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How can you share a Microsoft Form with people outside your organisation?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Unggah ke OneDrive sebagai PDF'
  WHERE option_text = 'Upload it to OneDrive as a PDF'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How can you share a Microsoft Form with people outside your organisation?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Forms tidak dapat dibagikan di luar organisasi Anda'
  WHERE option_text = 'Forms cannot be shared outside your organisation'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How can you share a Microsoft Form with people outside your organisation?' LIMIT 1);

  -- Q5
  UPDATE quiz_questions
  SET question_text_id = 'Setelah mengumpulkan respons di Microsoft Forms, apa cara yang berguna untuk menganalisis data lebih lanjut?'
  WHERE question_text = 'After collecting responses in Microsoft Forms, what is a useful way to analyse the data further?';

  UPDATE quiz_options
  SET option_text_id = 'Cetak formulir dan hitung respons secara manual'
  WHERE option_text = 'Print the form and count responses manually'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'After collecting responses in Microsoft Forms, what is a useful way to analyse the data further?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Ekspor respons ke Microsoft Excel untuk pengurutan dan pembuatan grafik'
  WHERE option_text = 'Export the responses to Microsoft Excel for sorting and charting'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'After collecting responses in Microsoft Forms, what is a useful way to analyse the data further?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Hapus respons dan buat ulang formulir'
  WHERE option_text = 'Delete responses and re-create the form'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'After collecting responses in Microsoft Forms, what is a useful way to analyse the data further?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Salin respons ke dalam slide PowerPoint'
  WHERE option_text = 'Copy responses into a PowerPoint slide'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'After collecting responses in Microsoft Forms, what is a useful way to analyse the data further?' LIMIT 1);

  -- ============================================================
  -- MODULE 8 — Microsoft Teams & Digital Workflow Quiz
  -- ============================================================

  -- Q1
  UPDATE quiz_questions
  SET question_text_id = 'Di Microsoft Teams, untuk apa "Saluran" digunakan?'
  WHERE question_text = 'In Microsoft Teams, what is a "Channel" used for?';

  UPDATE quiz_options
  SET option_text_id = 'Obrolan pribadi satu-satu dengan satu orang'
  WHERE option_text = 'A private one-on-one chat with a single person'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'In Microsoft Teams, what is a "Channel" used for?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Ruang terorganisir dalam Tim untuk diskusi topik tertentu dan berbagi file'
  WHERE option_text = 'An organised space within a Team for focused topic discussions and file sharing'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'In Microsoft Teams, what is a "Channel" used for?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Panggilan video antara dua orang'
  WHERE option_text = 'A video call between two people'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'In Microsoft Teams, what is a "Channel" used for?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Folder untuk menyimpan file pribadi'
  WHERE option_text = 'A folder for storing personal files'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'In Microsoft Teams, what is a "Channel" used for?' LIMIT 1);

  -- Q2
  UPDATE quiz_questions
  SET question_text_id = 'Saat Anda berbagi file di saluran Teams, di mana sebenarnya file tersebut disimpan?'
  WHERE question_text = 'When you share a file in a Teams channel, where is it actually stored?';

  UPDATE quiz_options
  SET option_text_id = 'Hanya di hard drive lokal Anda'
  WHERE option_text = 'On your local hard drive only'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When you share a file in a Teams channel, where is it actually stored?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Di perpustakaan dokumen SharePoint tim (dapat diakses melalui OneDrive/SharePoint)'
  WHERE option_text = 'In the team''s SharePoint document library (accessible via OneDrive/SharePoint)'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When you share a file in a Teams channel, where is it actually stored?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Di kotak masuk email pribadi Anda'
  WHERE option_text = 'In your personal email inbox'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When you share a file in a Teams channel, where is it actually stored?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Di Microsoft Forms'
  WHERE option_text = 'On Microsoft Forms'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'When you share a file in a Teams channel, where is it actually stored?' LIMIT 1);

  -- Q3
  UPDATE quiz_questions
  SET question_text_id = 'Bagaimana cara menjadwalkan rapat Teams langsung dari Microsoft Teams?'
  WHERE question_text = 'How do you schedule a Teams meeting directly from Microsoft Teams?';

  UPDATE quiz_options
  SET option_text_id = 'Klik "Obrolan Baru" dan ketik detail rapat'
  WHERE option_text = 'Click "New Chat" and type the meeting details'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How do you schedule a Teams meeting directly from Microsoft Teams?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Buka tab Kalender dan klik "Rapat Baru" untuk mengatur tanggal, waktu, dan peserta'
  WHERE option_text = 'Go to the Calendar tab and click "New Meeting" to set date, time, and attendees'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How do you schedule a Teams meeting directly from Microsoft Teams?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Gunakan tab File untuk membuat dokumen undangan rapat'
  WHERE option_text = 'Use the Files tab to create a meeting invitation document'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How do you schedule a Teams meeting directly from Microsoft Teams?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Rapat hanya dapat dijadwalkan dari Outlook, bukan dari Teams'
  WHERE option_text = 'Meetings can only be scheduled from Outlook, not from Teams'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'How do you schedule a Teams meeting directly from Microsoft Teams?' LIMIT 1);

  -- Q4
  UPDATE quiz_questions
  SET question_text_id = 'Apa yang terjadi saat Anda mengatur status Teams ke "Jangan Ganggu"?'
  WHERE question_text = 'What does setting your Teams status to "Do Not Disturb" do?';

  UPDATE quiz_options
  SET option_text_id = 'Keluar dari Teams secara otomatis'
  WHERE option_text = 'Logs you out of Teams automatically'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does setting your Teams status to "Do Not Disturb" do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Memblokir semua notifikasi agar Anda dapat fokus tanpa gangguan'
  WHERE option_text = 'Blocks all notifications so you can focus without interruptions'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does setting your Teams status to "Do Not Disturb" do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Menghapus semua pesan yang tertunda'
  WHERE option_text = 'Deletes all pending messages'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does setting your Teams status to "Do Not Disturb" do?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Mencegah siapa pun menambahkan Anda ke tim baru'
  WHERE option_text = 'Prevents anyone from adding you to new teams'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'What does setting your Teams status to "Do Not Disturb" do?' LIMIT 1);

  -- Q5
  UPDATE quiz_questions
  SET question_text_id = 'Fitur Teams mana yang digunakan oleh pendidik untuk mendistribusikan, mengumpulkan, dan menilai tugas siswa?'
  WHERE question_text = 'Which Teams feature is used by educators to distribute, collect, and grade student work?';

  UPDATE quiz_options
  SET option_text_id = 'Wiki Teams'
  WHERE option_text = 'Teams Wiki'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which Teams feature is used by educators to distribute, collect, and grade student work?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Tugas Teams'
  WHERE option_text = 'Teams Assignments'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which Teams feature is used by educators to distribute, collect, and grade student work?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Analitik Teams'
  WHERE option_text = 'Teams Analytics'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which Teams feature is used by educators to distribute, collect, and grade student work?' LIMIT 1);

  UPDATE quiz_options
  SET option_text_id = 'Perencana Teams'
  WHERE option_text = 'Teams Planner'
    AND question_id = (SELECT id FROM quiz_questions WHERE question_text = 'Which Teams feature is used by educators to distribute, collect, and grade student work?' LIMIT 1);

END $$;
