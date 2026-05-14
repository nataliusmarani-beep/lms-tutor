-- Module resources (video, pdf, doc, image, link)
CREATE TABLE IF NOT EXISTS module_resources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_module_id UUID NOT NULL REFERENCES course_modules(id) ON DELETE CASCADE,
  resource_type TEXT NOT NULL CHECK (resource_type IN ('video','pdf','doc','image','link')),
  title TEXT NOT NULL,
  url TEXT NOT NULL,
  description TEXT,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Module quizzes
CREATE TABLE IF NOT EXISTS module_quizzes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  course_module_id UUID NOT NULL REFERENCES course_modules(id) ON DELETE CASCADE,
  title TEXT NOT NULL DEFAULT 'Module Quiz',
  description TEXT,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Quiz questions
CREATE TABLE IF NOT EXISTS quiz_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  quiz_id UUID NOT NULL REFERENCES module_quizzes(id) ON DELETE CASCADE,
  question_type TEXT NOT NULL CHECK (question_type IN ('single_choice','multiple_choice','fill_blank')),
  question_text TEXT NOT NULL,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Quiz options (for single/multiple choice)
CREATE TABLE IF NOT EXISTS quiz_options (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID NOT NULL REFERENCES quiz_questions(id) ON DELETE CASCADE,
  option_text TEXT NOT NULL,
  is_correct BOOLEAN DEFAULT FALSE,
  sort_order INT DEFAULT 0
);

-- Quiz attempts by students
CREATE TABLE IF NOT EXISTS quiz_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  quiz_id UUID NOT NULL REFERENCES module_quizzes(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  score INT NOT NULL DEFAULT 0,
  max_score INT NOT NULL DEFAULT 0,
  answers JSONB DEFAULT '{}',
  completed_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- Row Level Security
-- ============================================================

ALTER TABLE module_resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE module_quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_attempts ENABLE ROW LEVEL SECURITY;

-- module_resources: authenticated users can SELECT
CREATE POLICY "module_resources_select" ON module_resources
  FOR SELECT TO authenticated USING (true);

-- module_resources: tutors can do ALL
CREATE POLICY "module_resources_tutor_all" ON module_resources
  FOR ALL TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );

-- module_quizzes: authenticated users can SELECT
CREATE POLICY "module_quizzes_select" ON module_quizzes
  FOR SELECT TO authenticated USING (true);

-- module_quizzes: tutors can do ALL
CREATE POLICY "module_quizzes_tutor_all" ON module_quizzes
  FOR ALL TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );

-- quiz_questions: authenticated users can SELECT
CREATE POLICY "quiz_questions_select" ON quiz_questions
  FOR SELECT TO authenticated USING (true);

-- quiz_questions: tutors can do ALL
CREATE POLICY "quiz_questions_tutor_all" ON quiz_questions
  FOR ALL TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );

-- quiz_options: authenticated users can SELECT
CREATE POLICY "quiz_options_select" ON quiz_options
  FOR SELECT TO authenticated USING (true);

-- quiz_options: tutors can do ALL
CREATE POLICY "quiz_options_tutor_all" ON quiz_options
  FOR ALL TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );

-- quiz_attempts: students can SELECT their own attempts
CREATE POLICY "quiz_attempts_student_select" ON quiz_attempts
  FOR SELECT TO authenticated
  USING (student_id = auth.uid());

-- quiz_attempts: students can INSERT their own attempts
CREATE POLICY "quiz_attempts_student_insert" ON quiz_attempts
  FOR INSERT TO authenticated
  WITH CHECK (student_id = auth.uid());

-- quiz_attempts: tutors can SELECT all attempts (for grading/review)
CREATE POLICY "quiz_attempts_tutor_select" ON quiz_attempts
  FOR SELECT TO authenticated
  USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'tutor')
  );
