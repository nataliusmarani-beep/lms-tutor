export type Role = "tutor" | "student" | "parent" | "guardian";

export interface Profile {
  id: string;
  name: string;
  role: Role;
  avatar_url?: string | null;
  created_at: string;
}

export interface ParentStudent {
  parent_id: string;
  student_id: string;
}

export interface LearningSession {
  id: string;
  student_id: string;
  module_id: number;
  date: string;
  duration_minutes: number;
  tutor_notes: string | null;
  student_notes: string | null;
  created_at: string;
  profiles?: Profile;
}

export interface ChecklistCompletion {
  id: string;
  student_id: string;
  module_id: number;
  item_key: string;
  item_type: "student" | "teacher";
  confirmed_at: string;
  confirmed_by: string;
}

export interface Assignment {
  id: string;
  module_id: number;
  title: string;
  description: string | null;
  due_date: string | null;
  created_by: string;
  created_at: string;
}

export interface Submission {
  id: string;
  assignment_id: string;
  student_id: string;
  file_link: string | null;
  notes: string | null;
  submitted_at: string;
  grade: string | null;
  feedback: string | null;
  graded_at: string | null;
  assignments?: Assignment;
  profiles?: Profile;
}

export interface ModuleProgress {
  moduleId: number;
  sessionsCount: number;
  totalMinutes: number;
  studentChecksCompleted: number;
  studentChecksTotal: number;
  teacherChecksCompleted: number;
  teacherChecksTotal: number;
  percentComplete: number;
}

export interface CourseModule {
  id: number;
  week: number;
  month: number;
  title: string;
  titleId: string;
  icon: string;
  focus: string;
  focusId: string;
  studentChecklist: ChecklistItem[];
  teacherChecklist: ChecklistItem[];
}

export interface ChecklistItem {
  key: string;
  label: string;
  labelId: string;
}
