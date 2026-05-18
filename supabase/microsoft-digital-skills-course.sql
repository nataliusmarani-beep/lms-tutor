
DO $$
DECLARE
  v_course_id UUID;

  v_mod1_id UUID;
  v_mod2_id UUID;
  v_mod3_id UUID;
  v_mod4_id UUID;
  v_mod5_id UUID;
  v_mod6_id UUID;
  v_mod7_id UUID;
  v_mod8_id UUID;

  v_quiz1_id UUID;
  v_quiz2_id UUID;
  v_quiz3_id UUID;
  v_quiz4_id UUID;
  v_quiz5_id UUID;
  v_quiz6_id UUID;
  v_quiz7_id UUID;
  v_quiz8_id UUID;

  v_q_id UUID;

BEGIN

  -- Guard: skip if course already exists
  IF EXISTS (SELECT 1 FROM courses WHERE title = 'Microsoft Digital Skills for University Prep') THEN
    RETURN;
  END IF;

  -- ============================================================
  -- COURSE
  -- ============================================================
  v_course_id := gen_random_uuid();
  INSERT INTO courses (id, title, description, icon, created_at)
  VALUES (
    v_course_id,
    'Microsoft Digital Skills for University Prep',
    'An 8-week program equipping university-bound students with essential Microsoft digital skills — from file management and cybersecurity through Word, Excel, PowerPoint, OneDrive, Forms, and Teams — building the productivity foundation needed for academic success.',
    '💻',
    NOW()
  );

  -- ============================================================
  -- MODULE 1 — Week 1: Computer Survival Skills & File Management
  -- ============================================================
  v_mod1_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, focus, icon, week_number, sort_order)
  VALUES (
    v_mod1_id, v_course_id,
    'Computer Survival Skills & File Management',
    'Keyboard shortcuts, file/folder organisation, print & PDF, screen lock',
    '🗂️', 1, 1
  );

  -- Student checklist items – Module 1
  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod1_id, 'student', 'ms_1_s_1', 'Organised files into a semester folder structure', 1),
    (gen_random_uuid(), v_mod1_id, 'student', 'ms_1_s_2', 'Used keyboard shortcuts (Ctrl+C, Ctrl+V, Ctrl+Z, Alt+Tab)', 2),
    (gen_random_uuid(), v_mod1_id, 'student', 'ms_1_s_3', 'Printed a document and saved as PDF', 3),
    (gen_random_uuid(), v_mod1_id, 'student', 'ms_1_s_4', 'Locked the computer screen when leaving desk', 4),
    (gen_random_uuid(), v_mod1_id, 'student', 'ms_1_s_5', 'Created a new folder and renamed files correctly', 5);

  -- Teacher checklist items – Module 1
  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod1_id, 'teacher', 'ms_1_t_1', 'Delivered keyboard shortcuts demo slide', 1),
    (gen_random_uuid(), v_mod1_id, 'teacher', 'ms_1_t_2', 'Showed file/folder organisation on screen', 2),
    (gen_random_uuid(), v_mod1_id, 'teacher', 'ms_1_t_3', 'Demonstrated Print and Print to PDF', 3),
    (gen_random_uuid(), v_mod1_id, 'teacher', 'ms_1_t_4', 'Explained screen lock and device security basics', 4),
    (gen_random_uuid(), v_mod1_id, 'teacher', 'ms_1_t_5', 'Checked student folder structures', 5);

  -- Quiz – Module 1
  v_quiz1_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, description, sort_order)
  VALUES (v_quiz1_id, v_mod1_id, 'File Management & Shortcuts Quiz', 'Test your knowledge of keyboard shortcuts and file organisation.', 1);

  -- Q1
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz1_id, 'single_choice', 'Which keyboard shortcut is used to copy selected text or files?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Ctrl+V', false, 1),
    (gen_random_uuid(), v_q_id, 'Ctrl+C', true,  2),
    (gen_random_uuid(), v_q_id, 'Ctrl+X', false, 3),
    (gen_random_uuid(), v_q_id, 'Ctrl+Z', false, 4);

  -- Q2
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz1_id, 'single_choice', 'What does Ctrl+Z do in most Windows applications?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Redo the last action', false, 1),
    (gen_random_uuid(), v_q_id, 'Save the file',        false, 2),
    (gen_random_uuid(), v_q_id, 'Undo the last action', true,  3),
    (gen_random_uuid(), v_q_id, 'Close the window',     false, 4);

  -- Q3
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz1_id, 'single_choice', 'Which keyboard shortcut lets you switch between open windows on Windows?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Ctrl+Tab',  false, 1),
    (gen_random_uuid(), v_q_id, 'Alt+Tab',   true,  2),
    (gen_random_uuid(), v_q_id, 'Win+Tab',   false, 3),
    (gen_random_uuid(), v_q_id, 'Shift+Tab', false, 4);

  -- Q4
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz1_id, 'single_choice', 'When you "Save as PDF" from Microsoft Word, what benefit does this provide?', 4);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'The file can be easily edited by anyone',                      false, 1),
    (gen_random_uuid(), v_q_id, 'The formatting is preserved and the file is universally readable', true, 2),
    (gen_random_uuid(), v_q_id, 'The file size becomes larger',                                  false, 3),
    (gen_random_uuid(), v_q_id, 'The document is automatically emailed',                         false, 4);

  -- Q5
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz1_id, 'single_choice', 'Why is it important to lock your computer screen when leaving your desk?', 5);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'It saves battery power only',                                 false, 1),
    (gen_random_uuid(), v_q_id, 'It prevents others from accessing your files and accounts',   true,  2),
    (gen_random_uuid(), v_q_id, 'It speeds up the computer',                                   false, 3),
    (gen_random_uuid(), v_q_id, 'It automatically backs up your files',                        false, 4);

  -- Resources – Module 1
  INSERT INTO module_resources (id, course_module_id, resource_type, title, url, description, sort_order) VALUES
    (gen_random_uuid(), v_mod1_id, 'video', 'Windows 10/11 Keyboard Shortcuts Tutorial',
     'https://www.youtube.com/results?search_query=windows+keyboard+shortcuts+tutorial+beginners',
     'A beginner-friendly YouTube tutorial covering essential Windows keyboard shortcuts.', 1),
    (gen_random_uuid(), v_mod1_id, 'link',  'Organise Files in Windows – Microsoft Support',
     'https://learn.microsoft.com/en-us/windows/client-management/manage-windows-10-file-system',
     'Official Microsoft documentation on managing files and folders in Windows.', 2);

  -- ============================================================
  -- MODULE 2 — Week 2: Internet Safety, Email & Security Awareness
  -- ============================================================
  v_mod2_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, focus, icon, week_number, sort_order)
  VALUES (
    v_mod2_id, v_course_id,
    'Internet Safety, Email & Security Awareness',
    'Password hygiene, phishing identification, safe browsing, email etiquette',
    '🔒', 2, 2
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod2_id, 'student', 'ms_2_s_1', 'Created a strong password using a passphrase', 1),
    (gen_random_uuid(), v_mod2_id, 'student', 'ms_2_s_2', 'Identified 3 red flags in a phishing email example', 2),
    (gen_random_uuid(), v_mod2_id, 'student', 'ms_2_s_3', 'Enabled two-factor authentication on one account', 3),
    (gen_random_uuid(), v_mod2_id, 'student', 'ms_2_s_4', 'Practised writing a professional email', 4),
    (gen_random_uuid(), v_mod2_id, 'student', 'ms_2_s_5', 'Learned how to report spam/phishing email', 5);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod2_id, 'teacher', 'ms_2_t_1', 'Presented phishing email case studies', 1),
    (gen_random_uuid(), v_mod2_id, 'teacher', 'ms_2_t_2', 'Demonstrated strong vs weak passwords', 2),
    (gen_random_uuid(), v_mod2_id, 'teacher', 'ms_2_t_3', 'Walked through 2FA setup steps', 3),
    (gen_random_uuid(), v_mod2_id, 'teacher', 'ms_2_t_4', 'Showed email etiquette dos and don''ts', 4),
    (gen_random_uuid(), v_mod2_id, 'teacher', 'ms_2_t_5', 'Reviewed student phishing identification exercise', 5);

  v_quiz2_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, description, sort_order)
  VALUES (v_quiz2_id, v_mod2_id, 'Internet Safety & Email Security Quiz', 'Test your understanding of online security and email etiquette.', 1);

  -- Q1
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz2_id, 'single_choice', 'Which of the following is a red flag that an email may be a phishing attempt?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'The email comes from your university address',          false, 1),
    (gen_random_uuid(), v_q_id, 'The email contains a link you did not expect and asks for your password urgently', true, 2),
    (gen_random_uuid(), v_q_id, 'The email has a professional greeting',                 false, 3),
    (gen_random_uuid(), v_q_id, 'The email includes your correct full name',             false, 4);

  -- Q2
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz2_id, 'single_choice', 'Which of the following is the strongest password?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'password123',            false, 1),
    (gen_random_uuid(), v_q_id, 'John1990',               false, 2),
    (gen_random_uuid(), v_q_id, 'PurpleTiger$Runs@Night7', true, 3),
    (gen_random_uuid(), v_q_id, 'qwerty',                 false, 4);

  -- Q3
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz2_id, 'single_choice', 'What does two-factor authentication (2FA) do?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'It lets you log in twice faster',                                 false, 1),
    (gen_random_uuid(), v_q_id, 'It requires two forms of verification, adding an extra security layer', true, 2),
    (gen_random_uuid(), v_q_id, 'It blocks all emails from unknown senders',                       false, 3),
    (gen_random_uuid(), v_q_id, 'It automatically changes your password every two weeks',           false, 4);

  -- Q4
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz2_id, 'single_choice', 'When writing a professional email, which practice is most appropriate?', 4);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Use emojis throughout to appear friendly',                         false, 1),
    (gen_random_uuid(), v_q_id, 'Write in all capitals to emphasise your points',                   false, 2),
    (gen_random_uuid(), v_q_id, 'Use a clear subject line, formal greeting, and polite sign-off',   true,  3),
    (gen_random_uuid(), v_q_id, 'Skip the greeting and go straight to your request',                false, 4);

  -- Q5
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz2_id, 'single_choice', 'If you receive a suspicious phishing email, what should you do?', 5);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Reply asking if it is legitimate',                         false, 1),
    (gen_random_uuid(), v_q_id, 'Click the link to investigate further',                    false, 2),
    (gen_random_uuid(), v_q_id, 'Report it as phishing/spam and do not click any links',    true,  3),
    (gen_random_uuid(), v_q_id, 'Forward it to friends as a warning',                       false, 4);

  INSERT INTO module_resources (id, course_module_id, resource_type, title, url, description, sort_order) VALUES
    (gen_random_uuid(), v_mod2_id, 'video', 'How to Spot a Phishing Email – YouTube',
     'https://www.youtube.com/results?search_query=how+to+spot+phishing+email+tutorial',
     'Video guide showing real phishing email examples and warning signs.', 1),
    (gen_random_uuid(), v_mod2_id, 'link',  'Microsoft Security – Stay Safe Online',
     'https://learn.microsoft.com/en-us/microsoft-365/security/defender/microsoft-365-security-center-mdo',
     'Microsoft documentation on email security and protecting your accounts.', 2);

  -- ============================================================
  -- MODULE 3 — Week 3: Microsoft Word – Professional Documents
  -- ============================================================
  v_mod3_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, focus, icon, week_number, sort_order)
  VALUES (
    v_mod3_id, v_course_id,
    'Microsoft Word – Professional Documents',
    'Formatting, styles, templates, spell check, track changes, export to PDF',
    '📝', 3, 3
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod3_id, 'student', 'ms_3_s_1', 'Applied Heading styles (Heading 1, Heading 2) to a document', 1),
    (gen_random_uuid(), v_mod3_id, 'student', 'ms_3_s_2', 'Used spell check and grammar check to proofread a document', 2),
    (gen_random_uuid(), v_mod3_id, 'student', 'ms_3_s_3', 'Enabled Track Changes and accepted/rejected a revision', 3),
    (gen_random_uuid(), v_mod3_id, 'student', 'ms_3_s_4', 'Created a document from a Microsoft Word template', 4),
    (gen_random_uuid(), v_mod3_id, 'student', 'ms_3_s_5', 'Exported a Word document as a PDF file', 5);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod3_id, 'teacher', 'ms_3_t_1', 'Demonstrated applying Styles and Themes in Word', 1),
    (gen_random_uuid(), v_mod3_id, 'teacher', 'ms_3_t_2', 'Showed how to run Spelling & Grammar check', 2),
    (gen_random_uuid(), v_mod3_id, 'teacher', 'ms_3_t_3', 'Walked through Track Changes and Comments workflow', 3),
    (gen_random_uuid(), v_mod3_id, 'teacher', 'ms_3_t_4', 'Guided students through selecting and filling a template', 4),
    (gen_random_uuid(), v_mod3_id, 'teacher', 'ms_3_t_5', 'Reviewed exported PDFs for formatting consistency', 5);

  v_quiz3_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, description, sort_order)
  VALUES (v_quiz3_id, v_mod3_id, 'Microsoft Word Features Quiz', 'Test your knowledge of Word formatting and document management.', 1);

  -- Q1
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz3_id, 'single_choice', 'What is the main benefit of using Heading Styles in Microsoft Word?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'They make the text bold only',                                        false, 1),
    (gen_random_uuid(), v_q_id, 'They create a consistent structure and enable an automatic Table of Contents', true, 2),
    (gen_random_uuid(), v_q_id, 'They automatically spell-check your document',                        false, 3),
    (gen_random_uuid(), v_q_id, 'They change the page orientation',                                    false, 4);

  -- Q2
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz3_id, 'single_choice', 'Where can you find the Spelling & Grammar check in Microsoft Word?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Home tab → Font group',   false, 1),
    (gen_random_uuid(), v_q_id, 'Insert tab → Text group', false, 2),
    (gen_random_uuid(), v_q_id, 'Review tab → Proofing group', true, 3),
    (gen_random_uuid(), v_q_id, 'View tab → Show group',   false, 4);

  -- Q3
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz3_id, 'single_choice', 'What does "Track Changes" allow you to do in Microsoft Word?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Automatically save the document every 5 minutes',                        false, 1),
    (gen_random_uuid(), v_q_id, 'Record all edits so reviewers can see, accept, or reject each change',   true,  2),
    (gen_random_uuid(), v_q_id, 'Lock the document so no one can edit it',                                false, 3),
    (gen_random_uuid(), v_q_id, 'Convert the document into a PDF',                                        false, 4);

  -- Q4
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz3_id, 'single_choice', 'How do you export a Word document as a PDF?', 4);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Home → Save',                                                  false, 1),
    (gen_random_uuid(), v_q_id, 'File → Save As → choose PDF format',                           true,  2),
    (gen_random_uuid(), v_q_id, 'Insert → PDF',                                                  false, 3),
    (gen_random_uuid(), v_q_id, 'Review → Export',                                               false, 4);

  -- Q5
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz3_id, 'single_choice', 'Which feature helps you start a professional-looking document quickly without formatting from scratch?', 5);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Macros',      false, 1),
    (gen_random_uuid(), v_q_id, 'Templates',   true,  2),
    (gen_random_uuid(), v_q_id, 'Bookmarks',   false, 3),
    (gen_random_uuid(), v_q_id, 'Mail Merge',  false, 4);

  INSERT INTO module_resources (id, course_module_id, resource_type, title, url, description, sort_order) VALUES
    (gen_random_uuid(), v_mod3_id, 'video', 'Microsoft Word Tutorial for Beginners – YouTube',
     'https://www.youtube.com/results?search_query=microsoft+word+tutorial+beginners+formatting+styles',
     'Step-by-step video covering Word formatting, styles, and document export.', 1),
    (gen_random_uuid(), v_mod3_id, 'link',  'Get started with Word – Microsoft Learn',
     'https://learn.microsoft.com/en-us/office/client-developer/word/word-home',
     'Official Microsoft Learn documentation for Microsoft Word features and tips.', 2);

  -- ============================================================
  -- MODULE 4 — Week 4: Microsoft Excel – Data & Spreadsheets
  -- ============================================================
  v_mod4_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, focus, icon, week_number, sort_order)
  VALUES (
    v_mod4_id, v_course_id,
    'Microsoft Excel – Data & Spreadsheets',
    'Data entry, SUM/AVERAGE/COUNT formulas, charts, cell formatting, basic sorting/filtering',
    '📊', 4, 4
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod4_id, 'student', 'ms_4_s_1', 'Entered and formatted data in an Excel spreadsheet', 1),
    (gen_random_uuid(), v_mod4_id, 'student', 'ms_4_s_2', 'Used SUM, AVERAGE, and COUNT formulas correctly', 2),
    (gen_random_uuid(), v_mod4_id, 'student', 'ms_4_s_3', 'Created a chart from a data range', 3),
    (gen_random_uuid(), v_mod4_id, 'student', 'ms_4_s_4', 'Applied sorting and filtering to a dataset', 4),
    (gen_random_uuid(), v_mod4_id, 'student', 'ms_4_s_5', 'Formatted cells with borders, colours, and number formats', 5);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod4_id, 'teacher', 'ms_4_t_1', 'Demonstrated basic data entry and cell referencing', 1),
    (gen_random_uuid(), v_mod4_id, 'teacher', 'ms_4_t_2', 'Walked through SUM, AVERAGE, and COUNT formula syntax', 2),
    (gen_random_uuid(), v_mod4_id, 'teacher', 'ms_4_t_3', 'Showed how to create and customise a chart', 3),
    (gen_random_uuid(), v_mod4_id, 'teacher', 'ms_4_t_4', 'Explained sorting and filtering a dataset', 4),
    (gen_random_uuid(), v_mod4_id, 'teacher', 'ms_4_t_5', 'Reviewed student spreadsheets for formula accuracy', 5);

  v_quiz4_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, description, sort_order)
  VALUES (v_quiz4_id, v_mod4_id, 'Microsoft Excel Quiz', 'Test your knowledge of Excel formulas, charts, and data management.', 1);

  -- Q1
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz4_id, 'single_choice', 'Which formula would you use to add up all values in cells A1 through A10?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, '=TOTAL(A1:A10)',   false, 1),
    (gen_random_uuid(), v_q_id, '=ADD(A1,A10)',     false, 2),
    (gen_random_uuid(), v_q_id, '=SUM(A1:A10)',     true,  3),
    (gen_random_uuid(), v_q_id, '=COUNT(A1:A10)',   false, 4);

  -- Q2
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz4_id, 'single_choice', 'What does the AVERAGE function do in Excel?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Returns the largest value in a range',             false, 1),
    (gen_random_uuid(), v_q_id, 'Counts how many cells contain numbers',             false, 2),
    (gen_random_uuid(), v_q_id, 'Calculates the arithmetic mean of a range of cells', true, 3),
    (gen_random_uuid(), v_q_id, 'Adds only the first and last cell values',          false, 4);

  -- Q3
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz4_id, 'single_choice', 'To create a chart in Excel from selected data, which tab do you use?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Home',     false, 1),
    (gen_random_uuid(), v_q_id, 'Formulas', false, 2),
    (gen_random_uuid(), v_q_id, 'Insert',   true,  3),
    (gen_random_uuid(), v_q_id, 'Data',     false, 4);

  -- Q4
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz4_id, 'single_choice', 'What does the Filter feature in Excel allow you to do?', 4);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Delete rows that do not match your criteria',                           false, 1),
    (gen_random_uuid(), v_q_id, 'Display only the rows that meet specified criteria, hiding the rest',   true,  2),
    (gen_random_uuid(), v_q_id, 'Sort data alphabetically only',                                         false, 3),
    (gen_random_uuid(), v_q_id, 'Copy data to a new worksheet automatically',                            false, 4);

  -- Q5
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz4_id, 'single_choice', 'Which number format would you apply to a cell to display a value as currency (e.g. $1,250.00)?', 5);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'General',    false, 1),
    (gen_random_uuid(), v_q_id, 'Text',       false, 2),
    (gen_random_uuid(), v_q_id, 'Currency',   true,  3),
    (gen_random_uuid(), v_q_id, 'Percentage', false, 4);

  INSERT INTO module_resources (id, course_module_id, resource_type, title, url, description, sort_order) VALUES
    (gen_random_uuid(), v_mod4_id, 'video', 'Microsoft Excel for Beginners – YouTube',
     'https://www.youtube.com/results?search_query=microsoft+excel+beginners+tutorial+formulas+charts',
     'Beginner Excel tutorial covering data entry, formulas, and creating charts.', 1),
    (gen_random_uuid(), v_mod4_id, 'link',  'Excel training – Microsoft Learn',
     'https://learn.microsoft.com/en-us/office/client-developer/excel/excel-home',
     'Official Microsoft Learn resource for Excel formulas, functions, and data tools.', 2);

  -- ============================================================
  -- MODULE 5 — Week 5: Microsoft PowerPoint – Dynamic Presentations
  -- ============================================================
  v_mod5_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, focus, icon, week_number, sort_order)
  VALUES (
    v_mod5_id, v_course_id,
    'Microsoft PowerPoint – Dynamic Presentations',
    'Slide layouts, themes, transitions, inserting images/charts, presenting tips, export',
    '🎨', 5, 5
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod5_id, 'student', 'ms_5_s_1', 'Applied a consistent theme and layout to a presentation', 1),
    (gen_random_uuid(), v_mod5_id, 'student', 'ms_5_s_2', 'Added slide transitions and animations appropriately', 2),
    (gen_random_uuid(), v_mod5_id, 'student', 'ms_5_s_3', 'Inserted an image and a chart into a slide', 3),
    (gen_random_uuid(), v_mod5_id, 'student', 'ms_5_s_4', 'Practised presenting using Slide Show view', 4),
    (gen_random_uuid(), v_mod5_id, 'student', 'ms_5_s_5', 'Exported the presentation as a PDF', 5);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod5_id, 'teacher', 'ms_5_t_1', 'Demonstrated slide layouts and Design themes', 1),
    (gen_random_uuid(), v_mod5_id, 'teacher', 'ms_5_t_2', 'Showed how to add and customise transitions', 2),
    (gen_random_uuid(), v_mod5_id, 'teacher', 'ms_5_t_3', 'Guided students through inserting images and charts', 3),
    (gen_random_uuid(), v_mod5_id, 'teacher', 'ms_5_t_4', 'Coached presentation delivery and use of Presenter View', 4),
    (gen_random_uuid(), v_mod5_id, 'teacher', 'ms_5_t_5', 'Reviewed student presentations for clarity and design', 5);

  v_quiz5_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, description, sort_order)
  VALUES (v_quiz5_id, v_mod5_id, 'Microsoft PowerPoint Quiz', 'Test your knowledge of PowerPoint design and presentation skills.', 1);

  -- Q1
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz5_id, 'single_choice', 'What is the purpose of applying a Theme in PowerPoint?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'To add animations to every slide automatically',                           false, 1),
    (gen_random_uuid(), v_q_id, 'To apply a consistent set of colours, fonts, and effects across all slides', true, 2),
    (gen_random_uuid(), v_q_id, 'To convert slides into a PDF',                                             false, 3),
    (gen_random_uuid(), v_q_id, 'To lock slide content from editing',                                       false, 4);

  -- Q2
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz5_id, 'single_choice', 'Where do you add slide transitions in PowerPoint?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Home tab',        false, 1),
    (gen_random_uuid(), v_q_id, 'Insert tab',      false, 2),
    (gen_random_uuid(), v_q_id, 'Transitions tab', true,  3),
    (gen_random_uuid(), v_q_id, 'Review tab',      false, 4);

  -- Q3
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz5_id, 'single_choice', 'What is Presenter View in PowerPoint used for?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Printing slides with speaker notes',                                       false, 1),
    (gen_random_uuid(), v_q_id, 'Showing slides on the audience screen while the presenter sees notes and upcoming slides on their own screen', true, 2),
    (gen_random_uuid(), v_q_id, 'Recording a video of the presentation',                                   false, 3),
    (gen_random_uuid(), v_q_id, 'Checking spelling on all slides at once',                                  false, 4);

  -- Q4
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz5_id, 'single_choice', 'Which is a best practice for slide design in a professional presentation?', 4);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Use as many different fonts as possible to keep slides interesting',     false, 1),
    (gen_random_uuid(), v_q_id, 'Fill each slide with as much text as possible',                          false, 2),
    (gen_random_uuid(), v_q_id, 'Use minimal text, clear headings, and relevant visuals',                 true,  3),
    (gen_random_uuid(), v_q_id, 'Apply a different theme to each slide',                                  false, 4);

  -- Q5
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz5_id, 'single_choice', 'How do you insert a chart from Excel data into a PowerPoint slide?', 5);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Home tab → Paste Special',                                              false, 1),
    (gen_random_uuid(), v_q_id, 'Insert tab → Chart, or copy from Excel and Paste Special as a linked object', true, 2),
    (gen_random_uuid(), v_q_id, 'File tab → Import',                                                     false, 3),
    (gen_random_uuid(), v_q_id, 'Design tab → Add Data',                                                  false, 4);

  INSERT INTO module_resources (id, course_module_id, resource_type, title, url, description, sort_order) VALUES
    (gen_random_uuid(), v_mod5_id, 'video', 'PowerPoint Tutorial for Beginners – YouTube',
     'https://www.youtube.com/results?search_query=microsoft+powerpoint+tutorial+beginners+presentation+tips',
     'Comprehensive beginner tutorial covering slides, themes, transitions, and presenting.', 1),
    (gen_random_uuid(), v_mod5_id, 'link',  'PowerPoint for Microsoft 365 help – Microsoft Learn',
     'https://learn.microsoft.com/en-us/office/client-developer/powerpoint/powerpoint-home',
     'Official Microsoft Learn resource with PowerPoint guides and how-tos.', 2);

  -- ============================================================
  -- MODULE 6 — Week 6: OneDrive & Cloud Storage
  -- ============================================================
  v_mod6_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, focus, icon, week_number, sort_order)
  VALUES (
    v_mod6_id, v_course_id,
    'OneDrive & Cloud Storage',
    'Upload/download, folder sharing, co-authoring, version history, sync to desktop',
    '☁️', 6, 6
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod6_id, 'student', 'ms_6_s_1', 'Uploaded a file to OneDrive and downloaded it on another device', 1),
    (gen_random_uuid(), v_mod6_id, 'student', 'ms_6_s_2', 'Shared a OneDrive folder with a classmate with view-only permissions', 2),
    (gen_random_uuid(), v_mod6_id, 'student', 'ms_6_s_3', 'Co-authored a Word document simultaneously with another user', 3),
    (gen_random_uuid(), v_mod6_id, 'student', 'ms_6_s_4', 'Restored a previous version of a file using Version History', 4),
    (gen_random_uuid(), v_mod6_id, 'student', 'ms_6_s_5', 'Set up OneDrive sync on a desktop/laptop', 5);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod6_id, 'teacher', 'ms_6_t_1', 'Demonstrated uploading and downloading files in OneDrive', 1),
    (gen_random_uuid(), v_mod6_id, 'teacher', 'ms_6_t_2', 'Showed how to share folders with different permission levels', 2),
    (gen_random_uuid(), v_mod6_id, 'teacher', 'ms_6_t_3', 'Demonstrated real-time co-authoring in a shared document', 3),
    (gen_random_uuid(), v_mod6_id, 'teacher', 'ms_6_t_4', 'Walked through accessing and restoring Version History', 4),
    (gen_random_uuid(), v_mod6_id, 'teacher', 'ms_6_t_5', 'Guided students through OneDrive desktop sync setup', 5);

  v_quiz6_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, description, sort_order)
  VALUES (v_quiz6_id, v_mod6_id, 'OneDrive & Cloud Storage Quiz', 'Test your understanding of OneDrive and cloud collaboration features.', 1);

  -- Q1
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz6_id, 'single_choice', 'What is the main advantage of storing files on OneDrive instead of only on your local hard drive?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Files on OneDrive open faster on your computer',                               false, 1),
    (gen_random_uuid(), v_q_id, 'Files are accessible from any device with internet access and are backed up',  true,  2),
    (gen_random_uuid(), v_q_id, 'OneDrive automatically edits your documents for you',                          false, 3),
    (gen_random_uuid(), v_q_id, 'Files stored on OneDrive cannot be deleted',                                   false, 4);

  -- Q2
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz6_id, 'single_choice', 'When sharing a OneDrive file, which permission level allows someone to view but NOT edit the file?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Can edit',          false, 1),
    (gen_random_uuid(), v_q_id, 'Owner',             false, 2),
    (gen_random_uuid(), v_q_id, 'Can view',          true,  3),
    (gen_random_uuid(), v_q_id, 'Full access',       false, 4);

  -- Q3
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz6_id, 'single_choice', 'What does "co-authoring" mean in OneDrive and Office 365?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Two people write separate documents and merge them later',              false, 1),
    (gen_random_uuid(), v_q_id, 'Multiple users can edit the same document at the same time',           true,  2),
    (gen_random_uuid(), v_q_id, 'One person writes and another person approves changes',                false, 3),
    (gen_random_uuid(), v_q_id, 'A document is copied to multiple folders automatically',               false, 4);

  -- Q4
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz6_id, 'single_choice', 'What does Version History in OneDrive allow you to do?', 4);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'See who has viewed a file',                                            false, 1),
    (gen_random_uuid(), v_q_id, 'Restore a file to an earlier saved state if changes were made in error', true, 2),
    (gen_random_uuid(), v_q_id, 'Duplicate the current version of a file',                              false, 3),
    (gen_random_uuid(), v_q_id, 'Lock a file so no further changes can be made',                        false, 4);

  -- Q5
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz6_id, 'single_choice', 'When OneDrive is synced to your desktop, what happens when you save a file to the OneDrive folder?', 5);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'The file is saved only on your computer until you manually upload it', false, 1),
    (gen_random_uuid(), v_q_id, 'The file is automatically synced to the cloud and accessible on other devices', true, 2),
    (gen_random_uuid(), v_q_id, 'The file is shared with all your contacts automatically',               false, 3),
    (gen_random_uuid(), v_q_id, 'The file is converted to a PDF before uploading',                      false, 4);

  INSERT INTO module_resources (id, course_module_id, resource_type, title, url, description, sort_order) VALUES
    (gen_random_uuid(), v_mod6_id, 'video', 'OneDrive Tutorial for Beginners – YouTube',
     'https://www.youtube.com/results?search_query=microsoft+onedrive+tutorial+beginners+cloud+storage',
     'A beginner-friendly guide to uploading, sharing, and syncing files with OneDrive.', 1),
    (gen_random_uuid(), v_mod6_id, 'link',  'OneDrive help & learning – Microsoft Learn',
     'https://learn.microsoft.com/en-us/onedrive/onedrive',
     'Official Microsoft documentation covering all OneDrive features and storage management.', 2);

  -- ============================================================
  -- MODULE 7 — Week 7: Microsoft Forms & Digital Assessment
  -- ============================================================
  v_mod7_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, focus, icon, week_number, sort_order)
  VALUES (
    v_mod7_id, v_course_id,
    'Microsoft Forms & Digital Assessment',
    'Creating a form/quiz, adding question types, sharing, viewing responses, branching',
    '📋', 7, 7
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod7_id, 'student', 'ms_7_s_1', 'Created a Microsoft Form with at least 4 different question types', 1),
    (gen_random_uuid(), v_mod7_id, 'student', 'ms_7_s_2', 'Added branching logic to a form question', 2),
    (gen_random_uuid(), v_mod7_id, 'student', 'ms_7_s_3', 'Shared the form via a link and collected responses', 3),
    (gen_random_uuid(), v_mod7_id, 'student', 'ms_7_s_4', 'Viewed and analysed the Responses summary tab', 4),
    (gen_random_uuid(), v_mod7_id, 'student', 'ms_7_s_5', 'Exported form responses to Excel for further analysis', 5);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod7_id, 'teacher', 'ms_7_t_1', 'Demonstrated creating a new form from scratch', 1),
    (gen_random_uuid(), v_mod7_id, 'teacher', 'ms_7_t_2', 'Showed how to add multiple question types including rating and Likert', 2),
    (gen_random_uuid(), v_mod7_id, 'teacher', 'ms_7_t_3', 'Explained branching/conditional logic in forms', 3),
    (gen_random_uuid(), v_mod7_id, 'teacher', 'ms_7_t_4', 'Walked through sharing options (link, QR code, embed)', 4),
    (gen_random_uuid(), v_mod7_id, 'teacher', 'ms_7_t_5', 'Demonstrated the Responses dashboard and Excel export', 5);

  v_quiz7_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, description, sort_order)
  VALUES (v_quiz7_id, v_mod7_id, 'Microsoft Forms & Digital Assessment Quiz', 'Test your knowledge of Microsoft Forms features and digital assessment tools.', 1);

  -- Q1
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz7_id, 'single_choice', 'Which of the following is NOT a question type available in Microsoft Forms?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Multiple choice',     false, 1),
    (gen_random_uuid(), v_q_id, 'Rating',              false, 2),
    (gen_random_uuid(), v_q_id, 'Pivot table',         true,  3),
    (gen_random_uuid(), v_q_id, 'Text (open-ended)',   false, 4);

  -- Q2
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz7_id, 'single_choice', 'What does "branching" in Microsoft Forms allow you to do?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Copy the form to another account',                                       false, 1),
    (gen_random_uuid(), v_q_id, 'Direct respondents to different questions based on their previous answers', true, 2),
    (gen_random_uuid(), v_q_id, 'Automatically grade all responses',                                      false, 3),
    (gen_random_uuid(), v_q_id, 'Split the form into multiple pages',                                     false, 4);

  -- Q3
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz7_id, 'single_choice', 'Where can you view a summary of all responses collected in Microsoft Forms?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Settings tab',    false, 1),
    (gen_random_uuid(), v_q_id, 'Design tab',      false, 2),
    (gen_random_uuid(), v_q_id, 'Responses tab',   true,  3),
    (gen_random_uuid(), v_q_id, 'Share tab',       false, 4);

  -- Q4
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz7_id, 'single_choice', 'How can you share a Microsoft Form with people outside your organisation?', 4);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Export it as a Word document',                                         false, 1),
    (gen_random_uuid(), v_q_id, 'Send the form link set to "Anyone with the link can respond"',         true,  2),
    (gen_random_uuid(), v_q_id, 'Upload it to OneDrive as a PDF',                                       false, 3),
    (gen_random_uuid(), v_q_id, 'Forms cannot be shared outside your organisation',                     false, 4);

  -- Q5
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz7_id, 'single_choice', 'After collecting responses in Microsoft Forms, what is a useful way to analyse the data further?', 5);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Print the form and count responses manually',                           false, 1),
    (gen_random_uuid(), v_q_id, 'Export the responses to Microsoft Excel for sorting and charting',      true,  2),
    (gen_random_uuid(), v_q_id, 'Delete responses and re-create the form',                               false, 3),
    (gen_random_uuid(), v_q_id, 'Copy responses into a PowerPoint slide',                                false, 4);

  INSERT INTO module_resources (id, course_module_id, resource_type, title, url, description, sort_order) VALUES
    (gen_random_uuid(), v_mod7_id, 'video', 'Microsoft Forms Tutorial – YouTube',
     'https://www.youtube.com/results?search_query=microsoft+forms+tutorial+create+quiz+branching',
     'Step-by-step tutorial on creating forms, quizzes, and using branching logic in Microsoft Forms.', 1),
    (gen_random_uuid(), v_mod7_id, 'link',  'Introduction to Microsoft Forms – Microsoft Learn',
     'https://learn.microsoft.com/en-us/office365/servicedescriptions/microsoft-forms-service-description',
     'Official Microsoft documentation covering Microsoft Forms features, sharing, and response analysis.', 2);

  -- ============================================================
  -- MODULE 8 — Week 8: Digital Workflow & Microsoft Teams
  -- ============================================================
  v_mod8_id := gen_random_uuid();
  INSERT INTO course_modules (id, course_id, title, focus, icon, week_number, sort_order)
  VALUES (
    v_mod8_id, v_course_id,
    'Digital Workflow & Microsoft Teams',
    'Teams channels/chat, file sharing in Teams, scheduling meetings, assignments, productivity tips',
    '🤝', 8, 8
  );

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod8_id, 'student', 'ms_8_s_1', 'Navigated Teams channels and posted a message in the correct channel', 1),
    (gen_random_uuid(), v_mod8_id, 'student', 'ms_8_s_2', 'Shared a file directly in a Teams channel conversation', 2),
    (gen_random_uuid(), v_mod8_id, 'student', 'ms_8_s_3', 'Scheduled a Teams meeting and added a classmate as a guest', 3),
    (gen_random_uuid(), v_mod8_id, 'student', 'ms_8_s_4', 'Submitted an assignment through the Teams Assignments tab', 4),
    (gen_random_uuid(), v_mod8_id, 'student', 'ms_8_s_5', 'Applied a personal productivity tip (e.g. Do Not Disturb, pinned chats, keyboard shortcuts)', 5);

  INSERT INTO module_checklist_items (id, course_module_id, item_type, item_key, label, sort_order) VALUES
    (gen_random_uuid(), v_mod8_id, 'teacher', 'ms_8_t_1', 'Demonstrated Teams interface: Teams, Channels, Chat, Activity feed', 1),
    (gen_random_uuid(), v_mod8_id, 'teacher', 'ms_8_t_2', 'Showed file sharing and co-editing within a Teams channel', 2),
    (gen_random_uuid(), v_mod8_id, 'teacher', 'ms_8_t_3', 'Walked through scheduling and joining a Teams meeting', 3),
    (gen_random_uuid(), v_mod8_id, 'teacher', 'ms_8_t_4', 'Demonstrated creating and managing Assignments in Teams', 4),
    (gen_random_uuid(), v_mod8_id, 'teacher', 'ms_8_t_5', 'Shared productivity tips: notifications, status, keyboard shortcuts', 5);

  v_quiz8_id := gen_random_uuid();
  INSERT INTO module_quizzes (id, course_module_id, title, description, sort_order)
  VALUES (v_quiz8_id, v_mod8_id, 'Microsoft Teams & Digital Workflow Quiz', 'Test your knowledge of Teams features and digital productivity.', 1);

  -- Q1
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz8_id, 'single_choice', 'In Microsoft Teams, what is a "Channel" used for?', 1);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'A private one-on-one chat with a single person',                               false, 1),
    (gen_random_uuid(), v_q_id, 'An organised space within a Team for focused topic discussions and file sharing', true, 2),
    (gen_random_uuid(), v_q_id, 'A video call between two people',                                               false, 3),
    (gen_random_uuid(), v_q_id, 'A folder for storing personal files',                                           false, 4);

  -- Q2
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz8_id, 'single_choice', 'When you share a file in a Teams channel, where is it actually stored?', 2);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'On your local hard drive only',                                                 false, 1),
    (gen_random_uuid(), v_q_id, 'In the team''s SharePoint document library (accessible via OneDrive/SharePoint)', true, 2),
    (gen_random_uuid(), v_q_id, 'In your personal email inbox',                                                   false, 3),
    (gen_random_uuid(), v_q_id, 'On Microsoft Forms',                                                             false, 4);

  -- Q3
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz8_id, 'single_choice', 'How do you schedule a Teams meeting directly from Microsoft Teams?', 3);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Click "New Chat" and type the meeting details',                                 false, 1),
    (gen_random_uuid(), v_q_id, 'Go to the Calendar tab and click "New Meeting" to set date, time, and attendees', true, 2),
    (gen_random_uuid(), v_q_id, 'Use the Files tab to create a meeting invitation document',                     false, 3),
    (gen_random_uuid(), v_q_id, 'Meetings can only be scheduled from Outlook, not from Teams',                   false, 4);

  -- Q4
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz8_id, 'single_choice', 'What does setting your Teams status to "Do Not Disturb" do?', 4);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Logs you out of Teams automatically',                                          false, 1),
    (gen_random_uuid(), v_q_id, 'Blocks all notifications so you can focus without interruptions',              true,  2),
    (gen_random_uuid(), v_q_id, 'Deletes all pending messages',                                                  false, 3),
    (gen_random_uuid(), v_q_id, 'Prevents anyone from adding you to new teams',                                  false, 4);

  -- Q5
  v_q_id := gen_random_uuid();
  INSERT INTO quiz_questions (id, quiz_id, question_type, question_text, sort_order)
  VALUES (v_q_id, v_quiz8_id, 'single_choice', 'Which Teams feature is used by educators to distribute, collect, and grade student work?', 5);
  INSERT INTO quiz_options (id, question_id, option_text, is_correct, sort_order) VALUES
    (gen_random_uuid(), v_q_id, 'Teams Wiki',        false, 1),
    (gen_random_uuid(), v_q_id, 'Teams Assignments', true,  2),
    (gen_random_uuid(), v_q_id, 'Teams Analytics',   false, 3),
    (gen_random_uuid(), v_q_id, 'Teams Planner',     false, 4);

  INSERT INTO module_resources (id, course_module_id, resource_type, title, url, description, sort_order) VALUES
    (gen_random_uuid(), v_mod8_id, 'video', 'Microsoft Teams Tutorial for Beginners – YouTube',
     'https://www.youtube.com/results?search_query=microsoft+teams+tutorial+beginners+channels+meetings',
     'Complete beginner guide to Microsoft Teams including channels, meetings, and file sharing.', 1),
    (gen_random_uuid(), v_mod8_id, 'link',  'Microsoft Teams help & learning – Microsoft Learn',
     'https://learn.microsoft.com/en-us/microsoftteams/microsoft-teams',
     'Official Microsoft documentation for all Teams features including chat, meetings, and assignments.', 2);

END $$;

