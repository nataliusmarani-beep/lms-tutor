import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import Navbar from "@/components/Navbar";
import ProgressRing from "@/components/ProgressRing";
import type { Profile } from "@/types";

interface CourseRow {
  id: string;
  title: string;
  description: string | null;
  icon: string;
}

async function getStudentProgress(
  supabase: ReturnType<typeof createClient>,
  studentId: string
) {
  const [{ data: sessions }, { data: checks }] = await Promise.all([
    supabase
      .from("learning_sessions")
      .select("course_module_id, module_id, duration_minutes")
      .eq("student_id", studentId),
    supabase
      .from("checklist_completions")
      .select("item_key, course_module_id, module_id")
      .eq("student_id", studentId),
  ]);

  const completedChecks = checks?.length ?? 0;
  const totalMinutes =
    sessions?.reduce(
      (a: number, s: { duration_minutes: number }) => a + s.duration_minutes,
      0
    ) ?? 0;

  // Count unique modules started (by course_module_id or module_id)
  const modulesStarted = new Set([
    ...(sessions
      ?.filter((s: { course_module_id: string | null }) => s.course_module_id)
      .map((s: { course_module_id: string | null }) => `cm:${s.course_module_id}`) ?? []),
    ...(sessions
      ?.filter((s: { module_id: number | null }) => s.module_id)
      .map((s: { module_id: number | null }) => `m:${s.module_id}`) ?? []),
  ]).size;

  return {
    totalChecks: completedChecks,
    totalMinutes,
    totalHours: Math.round((totalMinutes / 60) * 10) / 10,
    modulesStarted,
    sessionsCount: sessions?.length ?? 0,
  };
}

export default async function TutorDashboard() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: profile } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user.id)
    .single();
  if (!profile || profile.role !== "tutor") redirect("/login");

  const [{ data: students }, { data: courses }] = await Promise.all([
    supabase.from("profiles").select("*").eq("role", "student").order("name"),
    supabase.from("courses").select("*").order("created_at"),
  ]);

  const studentList = (students as Profile[]) ?? [];
  const courseList = (courses ?? []) as CourseRow[];

  // Enrich courses with module & student counts
  const enrichedCourses = await Promise.all(
    courseList.map(async (course) => {
      const [{ count: moduleCount }, { count: studentCount }] = await Promise.all([
        supabase
          .from("course_modules")
          .select("id", { count: "exact", head: true })
          .eq("course_id", course.id),
        supabase
          .from("course_enrollments")
          .select("id", { count: "exact", head: true })
          .eq("course_id", course.id),
      ]);
      return { ...course, moduleCount: moduleCount ?? 0, studentCount: studentCount ?? 0 };
    })
  );

  const progressList = await Promise.all(
    studentList.map(async (s) => ({
      id: s.id,
      progress: await getStudentProgress(supabase, s.id),
    }))
  );
  const progressMap = Object.fromEntries(
    progressList.map((p) => [p.id, p.progress])
  );

  const courseAccentColors = [
    "from-indigo-500 to-indigo-600",
    "from-purple-500 to-purple-600",
    "from-emerald-500 to-emerald-600",
    "from-amber-500 to-amber-600",
    "from-rose-500 to-rose-600",
    "from-cyan-500 to-cyan-600",
  ];

  return (
    <div className="min-h-screen">
      <Navbar name={profile.name} role="tutor" />
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-8">

        {/* Welcome banner */}
        <div className="rounded-2xl bg-gradient-to-r from-indigo-600 to-purple-600 p-6 text-white shadow-md">
          <h1 className="text-2xl font-bold">Welcome back, {profile.name.split(" ")[0]}! 👋</h1>
          <p className="mt-1 text-indigo-200 text-sm">
            {courseList.length} course{courseList.length !== 1 ? "s" : ""} · {studentList.length} student{studentList.length !== 1 ? "s" : ""} · Ready to teach?
          </p>
        </div>

        {/* Stat cards */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
          <div className="card text-center">
            <div className="text-3xl mb-1">🎓</div>
            <div className="text-3xl font-bold text-indigo-600">{studentList.length}</div>
            <div className="text-sm text-slate-500 mt-1">Students</div>
          </div>
          <div className="card text-center">
            <div className="text-3xl mb-1">📚</div>
            <div className="text-3xl font-bold text-indigo-600">{courseList.length}</div>
            <div className="text-sm text-slate-500 mt-1">Courses</div>
          </div>
          <div className="card text-center">
            <div className="text-3xl mb-1">🗂️</div>
            <div className="text-3xl font-bold text-indigo-600">
              {enrichedCourses.reduce((a, c) => a + c.moduleCount, 0)}
            </div>
            <div className="text-sm text-slate-500 mt-1">Modules</div>
          </div>
          <div className="card text-center">
            <div className="text-3xl mb-1">⏱️</div>
            <div className="text-3xl font-bold text-indigo-600">60–90</div>
            <div className="text-sm text-slate-500 mt-1">Min/session</div>
          </div>
        </div>

        {/* Courses Section */}
        <div>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-slate-700">Courses</h2>
            <Link href="/tutor/courses" className="btn-secondary text-sm py-1.5">View All</Link>
          </div>
          {enrichedCourses.length === 0 ? (
            <div className="card text-center py-10">
              <div className="text-4xl mb-3">📚</div>
              <p className="text-slate-500 mb-3">No courses yet.</p>
              <Link href="/tutor/courses/new" className="btn-primary inline-block">Create First Course</Link>
            </div>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              {enrichedCourses.map((course, idx) => (
                <Link
                  key={course.id}
                  href={`/tutor/courses/${course.id}`}
                  className="card hover:shadow-md transition-shadow flex items-stretch gap-0 overflow-hidden p-0"
                >
                  {/* Color accent bar */}
                  <div className={`w-1.5 rounded-l-2xl bg-gradient-to-b ${courseAccentColors[idx % courseAccentColors.length]} shrink-0`} />
                  <div className="flex items-center gap-3 p-4 flex-1 min-w-0">
                    <span className="text-3xl shrink-0">{course.icon}</span>
                    <div className="flex-1 min-w-0">
                      <div className="font-semibold text-slate-800 truncate">{course.title}</div>
                      {course.description && (
                        <p className="text-xs text-slate-500 mt-0.5 truncate">{course.description}</p>
                      )}
                      <div className="flex gap-2 mt-1">
                        <span className="badge-blue text-xs">{course.moduleCount} modules</span>
                        <span className="badge-green text-xs">{course.studentCount} students</span>
                      </div>
                    </div>
                    <span className="text-slate-300 shrink-0">›</span>
                  </div>
                </Link>
              ))}
            </div>
          )}
        </div>

        {/* Students Section */}
        <div>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-slate-700">Students</h2>
            <Link href="/tutor/students/new" className="btn-primary text-sm py-1.5">+ Add Student</Link>
          </div>

          {studentList.length === 0 ? (
            <div className="card text-center py-12">
              <div className="text-4xl mb-3">👤</div>
              <p className="text-slate-500">No students yet.</p>
              <Link href="/tutor/students/new" className="btn-primary mt-4 inline-block">
                Add First Student
              </Link>
            </div>
          ) : (
            <div className="space-y-3">
              {studentList.map((student) => {
                const p = progressMap[student.id];
                const maxChecks = 100; // relative — we no longer know total from static data
                const pct = p.totalChecks > 0 ? Math.min(100, Math.round((p.totalChecks / maxChecks) * 100)) : 0;
                return (
                  <Link
                    key={student.id}
                    href={`/tutor/students/${student.id}`}
                    className="card flex items-center gap-4 hover:shadow-md transition-shadow"
                  >
                    <ProgressRing percent={pct} size={60} strokeWidth={6} />
                    <div className="flex-1">
                      <h3 className="font-semibold text-slate-800">{student.name}</h3>
                      <p className="text-sm text-slate-500">
                        {p.sessionsCount} sessions · {p.totalHours}h · {p.modulesStarted} modules started
                      </p>
                    </div>
                    <div className="text-right">
                      <span
                        className={`badge ${
                          p.sessionsCount >= 6
                            ? "badge-green"
                            : p.sessionsCount >= 2
                            ? "badge-blue"
                            : "badge-gray"
                        }`}
                      >
                        {p.sessionsCount >= 6
                          ? "Active"
                          : p.sessionsCount >= 2
                          ? "In Progress"
                          : "Just Started"}
                      </span>
                    </div>
                    <span className="text-slate-300">›</span>
                  </Link>
                );
              })}
            </div>
          )}
        </div>

        {/* Quick Actions */}
        <div>
          <h2 className="text-lg font-semibold text-slate-700 mb-4">Quick Actions</h2>
          <div className="grid grid-cols-1 sm:grid-cols-4 gap-3">
            <Link
              href="/tutor/sessions/new"
              className="card hover:shadow-md transition-shadow flex items-center gap-3"
            >
              <span className="text-2xl">⏱️</span>
              <div>
                <div className="font-medium text-slate-800">Log a Session</div>
                <div className="text-sm text-slate-500">Record a learning session</div>
              </div>
            </Link>
            <Link
              href="/tutor/students/new"
              className="card hover:shadow-md transition-shadow flex items-center gap-3"
            >
              <span className="text-2xl">👤</span>
              <div>
                <div className="font-medium text-slate-800">Add Student</div>
                <div className="text-sm text-slate-500">Create student account</div>
              </div>
            </Link>
            <Link
              href="/tutor/courses"
              className="card hover:shadow-md transition-shadow flex items-center gap-3"
            >
              <span className="text-2xl">📚</span>
              <div>
                <div className="font-medium text-slate-800">Courses</div>
                <div className="text-sm text-slate-500">Manage course catalogue</div>
              </div>
            </Link>
            <Link
              href="/tutor/accounts"
              className="card hover:shadow-md transition-shadow flex items-center gap-3"
            >
              <span className="text-2xl">⚙️</span>
              <div>
                <div className="font-medium text-slate-800">Manage Accounts</div>
                <div className="text-sm text-slate-500">Students &amp; parents</div>
              </div>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
