import { cookies } from "next/headers";

export type Lang = "en" | "id";

export const translations = {
  en: {
    // Navbar
    signOut: "Sign out",
    langToggle: "ID",
    // Roles
    roletutor: "Tutor",
    rolestudent: "Student",
    roleparent: "Parent",
    // Common stats
    sessions: "Sessions",
    totalTime: "Total time",
    learningTime: "Learning time",
    modulesDone: "Modules done",
    overall: "Overall",
    overallProgress: "Overall progress",
    submittedTasks: "Submitted tasks",
    minWeekGoal: "Min/week goal",
    // Week labels
    week: "Week",
    items: "items",
    complete: "complete",
    // Weekly progress
    thisWeek: "This week",
    goalMet: "Goal met 🎉",
    onTrack: "On track",
    behind: "Behind",
    noSessions: "No sessions",
    sessionLeft: "session left",
    sessionsLeft: "sessions left",
    min: "min",
    // Tutor dashboard
    welcomeBack: "Welcome back",
    readyToTeach: "Ready to teach?",
    courses: "Courses",
    students: "Students",
    modules: "Modules",
    viewAll: "View All",
    addStudent: "+ Add Student",
    quickActions: "Quick Actions",
    logSession: "Log a Session",
    logSessionDesc: "Record a learning session",
    addStudentDesc: "Create student account",
    coursesDesc: "Manage course catalogue",
    manageAccounts: "Manage Accounts",
    manageAccountsDesc: "Students & parents",
    // Student card
    totalTimeLabel: "total",
    modulesStarted: "modules started",
    active: "Active",
    inProgress: "In Progress",
    justStarted: "Just Started",
    // Student dashboard
    hiGreeting: "Hi",
    enrolled: "enrolled",
    coursesEnrolled: "courses enrolled · Keep it up!",
    noCoursesYet: "You haven't been enrolled in any courses yet.",
    askTutorEnroll: "Ask your tutor to enroll you in a course.",
    recentSessions: "Recent Sessions",
    noSessionsYet: "No sessions yet. Your tutor will log sessions after each lesson.",
    percentComplete: "% complete",
    moduleProgress: "Module Progress",
    noModulesYet: "No modules added yet.",
    // Parent dashboard
    progressReport: "Progress Report for",
    noStudentLinked: "No student linked yet",
    noStudentLinkedDesc: "Ask your tutor to link your account to your child's profile.",
    gradedAssignments: "Graded Assignments",
    // Module detail
    sessionsLabel: "Sessions",
    checklistProgress: "Checklist Progress",
    studentChecklist: "Student Checklist",
    tutorChecklist: "Tutor Checklist",
    noChecklistItems: "No checklist items for this module yet.",
    quizzes: "Quizzes",
    notAttempted: "Not attempted",
    noSessionsModule: "No sessions logged for this module yet.",
    // Log session
    logFirstSession: "Log First Session",
    // Accounts
    manageAccountsTitle: "Manage Accounts",
    manageAccountsSubtitle: "View and manage student & parent accounts",
    addAccount: "+ Add Account",
    // Dashboard breadcrumb
    dashboard: "← Dashboard",
  },
  id: {
    signOut: "Keluar",
    langToggle: "EN",
    roletutor: "Tutor",
    rolestudent: "Siswa",
    roleparent: "Orang Tua",
    sessions: "Sesi",
    totalTime: "Total waktu",
    learningTime: "Waktu belajar",
    modulesDone: "Modul selesai",
    overall: "Keseluruhan",
    overallProgress: "Progres keseluruhan",
    submittedTasks: "Tugas dikumpulkan",
    minWeekGoal: "Menit/minggu target",
    week: "Minggu",
    items: "item",
    complete: "selesai",
    thisWeek: "Minggu ini",
    goalMet: "Target tercapai 🎉",
    onTrack: "Sesuai target",
    behind: "Tertinggal",
    noSessions: "Belum ada sesi",
    sessionLeft: "sesi lagi",
    sessionsLeft: "sesi lagi",
    min: "mnt",
    welcomeBack: "Selamat datang kembali",
    readyToTeach: "Siap mengajar?",
    courses: "Kursus",
    students: "Siswa",
    modules: "Modul",
    viewAll: "Lihat Semua",
    addStudent: "+ Tambah Siswa",
    quickActions: "Aksi Cepat",
    logSession: "Catat Sesi",
    logSessionDesc: "Rekam sesi pembelajaran",
    addStudentDesc: "Buat akun siswa",
    coursesDesc: "Kelola katalog kursus",
    manageAccounts: "Kelola Akun",
    manageAccountsDesc: "Siswa & orang tua",
    totalTimeLabel: "total",
    modulesStarted: "modul dimulai",
    active: "Aktif",
    inProgress: "Sedang Belajar",
    justStarted: "Baru Mulai",
    hiGreeting: "Halo",
    enrolled: "terdaftar",
    coursesEnrolled: "kursus terdaftar · Terus semangat!",
    noCoursesYet: "Kamu belum terdaftar di kursus apapun.",
    askTutorEnroll: "Minta tutormu untuk mendaftarkan kamu ke kursus.",
    recentSessions: "Sesi Terbaru",
    noSessionsYet: "Belum ada sesi. Tutor akan mencatat sesi setelah setiap pelajaran.",
    percentComplete: "% selesai",
    moduleProgress: "Progres Modul",
    noModulesYet: "Belum ada modul yang ditambahkan.",
    progressReport: "Laporan Kemajuan untuk",
    noStudentLinked: "Belum ada siswa yang ditautkan",
    noStudentLinkedDesc: "Minta tutor untuk menautkan akun Anda ke profil anak Anda.",
    gradedAssignments: "Tugas Dinilai",
    sessionsLabel: "Sesi",
    checklistProgress: "Progres Daftar Periksa",
    studentChecklist: "Daftar Periksa Siswa",
    tutorChecklist: "Daftar Periksa Tutor",
    noChecklistItems: "Belum ada item checklist untuk modul ini.",
    quizzes: "Kuis",
    notAttempted: "Belum dikerjakan",
    noSessionsModule: "Belum ada sesi yang dicatat untuk modul ini.",
    logFirstSession: "Catat Sesi Pertama",
    manageAccountsTitle: "Kelola Akun",
    manageAccountsSubtitle: "Lihat dan kelola akun siswa & orang tua",
    addAccount: "+ Tambah Akun",
    dashboard: "← Dasbor",
  },
} as const;

export type TranslationKey = keyof typeof translations.en;

export function t(lang: Lang, key: TranslationKey): string {
  return (translations[lang] as Record<string, string>)[key] ?? (translations.en as Record<string, string>)[key] ?? key;
}

/** Read language from cookie — use inside Server Components only */
export function getLang(): Lang {
  try {
    const val = cookies().get("lang")?.value;
    return val === "id" ? "id" : "en";
  } catch {
    return "en";
  }
}
