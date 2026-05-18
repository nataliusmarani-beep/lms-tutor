"use client";
import { useRef, useState, useEffect, useCallback } from "react";
import { useRouter, useParams } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/client";
import toast from "react-hot-toast";

interface CourseModule {
  id: string;
  title: string;
  title_id?: string | null;
  focus: string | null;
  focus_id?: string | null;
  icon: string;
  week_number: number | null;
  sort_order: number;
  legacy_module_id: number | null;
}

interface EnrolledStudent {
  id: string;
  student_id: string;
  profiles: { id: string; name: string };
}

interface AllStudent {
  id: string;
  name: string;
}

interface Course {
  id: string;
  title: string;
  description: string | null;
  icon: string;
  icon_url?: string | null;
}

export default function CourseDetailPage() {
  const params = useParams();
  const courseId = params.courseId as string;
  const router = useRouter();
  const supabase = createClient();

  const [course, setCourse] = useState<Course | null>(null);
  const [modules, setModules] = useState<CourseModule[]>([]);
  const [enrolled, setEnrolled] = useState<EnrolledStudent[]>([]);
  const [allStudents, setAllStudents] = useState<AllStudent[]>([]);
  const [loading, setLoading] = useState(true);

  // Course edit state
  const [courseTitle,    setCourseTitle]    = useState("");
  const [courseDesc,     setCourseDesc]     = useState("");
  const [courseIcon,     setCourseIcon]     = useState("");
  const [courseIconUrl,  setCourseIconUrl]  = useState<string | null>(null);
  const [iconFile,       setIconFile]       = useState<File | null>(null);
  const [iconPreview,    setIconPreview]    = useState<string | null>(null);
  const [savingCourse,   setSavingCourse]   = useState(false);
  const iconFileRef = useRef<HTMLInputElement>(null);

  // New module state
  const [newModIcon, setNewModIcon] = useState("📚");
  const [newModTitle, setNewModTitle] = useState("");
  const [newModFocus, setNewModFocus] = useState("");
  const [newModWeek, setNewModWeek] = useState<number | "">("");
  const [addingModule, setAddingModule] = useState(false);

  // Enroll state
  const [selectedStudentId, setSelectedStudentId] = useState("");
  const [enrolling, setEnrolling] = useState(false);

  const [lang, setLang] = useState<"en" | "id">("en");
  useEffect(() => {
    const m = document.cookie.match(/(?:^|;\s*)lang=([^;]*)/);
    setLang(m?.[1] === "id" ? "id" : "en");
  }, []);

  const loadData = useCallback(async () => {
    const [{ data: courseData }, { data: moduleData }, { data: enrollData }, { data: studentsData }] = await Promise.all([
      supabase.from("courses").select("*").eq("id", courseId).single(),
      supabase.from("course_modules").select("*").eq("course_id", courseId).order("sort_order"),
      supabase
        .from("course_enrollments")
        .select("id, student_id, profiles(id, name)")
        .eq("course_id", courseId),
      supabase.from("profiles").select("id, name").eq("role", "student").order("name"),
    ]);

    if (courseData) {
      setCourse(courseData);
      setCourseTitle(courseData.title);
      setCourseDesc(courseData.description ?? "");
      setCourseIcon(courseData.icon);
      setCourseIconUrl(courseData.icon_url ?? null);
    }
    setModules((moduleData ?? []) as CourseModule[]);
    setEnrolled((enrollData ?? []) as unknown as EnrolledStudent[]);
    setAllStudents((studentsData ?? []) as AllStudent[]);
    setLoading(false);
  }, [courseId]);

  useEffect(() => { loadData(); }, [loadData]);

  function handleIconFileChange(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    if (file.size > 2 * 1024 * 1024) { toast.error("Image must be under 2 MB"); return; }
    if (iconPreview) URL.revokeObjectURL(iconPreview);
    setIconFile(file);
    setIconPreview(URL.createObjectURL(file));
  }

  function removeIconImage() {
    setIconFile(null);
    if (iconPreview) URL.revokeObjectURL(iconPreview);
    setIconPreview(null);
    setCourseIconUrl(null);
    if (iconFileRef.current) iconFileRef.current.value = "";
  }

  async function handleSaveCourse(e: React.FormEvent) {
    e.preventDefault();
    setSavingCourse(true);

    let newIconUrl: string | null | undefined = undefined;

    if (iconFile) {
      const ext  = iconFile.name.split(".").pop();
      const path = `${courseId}.${ext}`;
      const { error: upErr } = await supabase.storage
        .from("course-icons").upload(path, iconFile, { upsert: true });
      if (upErr) { toast.error("Image upload failed: " + upErr.message); setSavingCourse(false); return; }
      const { data: urlData } = supabase.storage.from("course-icons").getPublicUrl(path);
      newIconUrl = `${urlData.publicUrl}?t=${Date.now()}`;
      setIconPreview(null);
      setIconFile(null);
      setCourseIconUrl(newIconUrl);
    } else if (!iconPreview && !courseIconUrl) {
      newIconUrl = null;
    }

    const updatePayload: Record<string, unknown> = {
      title: courseTitle.trim(),
      description: courseDesc.trim() || null,
      icon: courseIcon.trim() || "📚",
    };
    if (newIconUrl !== undefined) updatePayload.icon_url = newIconUrl;

    const { error } = await supabase.from("courses").update(updatePayload).eq("id", courseId);
    setSavingCourse(false);
    if (error) { toast.error(error.message); return; }
    toast.success("Course saved!");
    setCourse((prev) => prev ? { ...prev, title: courseTitle, description: courseDesc || null, icon: courseIcon, icon_url: newIconUrl ?? prev.icon_url } : prev);
  }

  async function handleAddModule(e: React.FormEvent) {
    e.preventDefault();
    if (!newModTitle.trim()) { toast.error("Title is required"); return; }
    setAddingModule(true);
    const maxOrder = modules.reduce((m, mod) => Math.max(m, mod.sort_order), 0);
    const { data, error } = await supabase
      .from("course_modules")
      .insert({
        course_id: courseId,
        title: newModTitle.trim(),
        focus: newModFocus.trim() || null,
        icon: newModIcon.trim() || "📚",
        week_number: newModWeek !== "" ? newModWeek : null,
        sort_order: maxOrder + 1,
      })
      .select()
      .single();
    setAddingModule(false);
    if (error) { toast.error(error.message); return; }
    setModules((prev) => [...prev, data as CourseModule]);
    setNewModTitle("");
    setNewModFocus("");
    setNewModIcon("📚");
    setNewModWeek("");
    toast.success("Module added!");
  }

  async function handleDeleteCourse() {
    if (!confirm(`Delete "${course?.title}"? This will remove all modules and enrollments. This cannot be undone.`)) return;
    const { error } = await supabase.from("courses").delete().eq("id", courseId);
    if (error) { toast.error(error.message); return; }
    toast.success("Course deleted");
    router.push("/tutor/courses");
  }

  async function handleDeleteModule(moduleId: string) {
    if (!confirm("Delete this module? This cannot be undone.")) return;
    const { error } = await supabase.from("course_modules").delete().eq("id", moduleId);
    if (error) { toast.error(error.message); return; }
    setModules((prev) => prev.filter((m) => m.id !== moduleId));
    toast.success("Module deleted");
  }

  async function handleEnroll(e: React.FormEvent) {
    e.preventDefault();
    if (!selectedStudentId) { toast.error("Select a student"); return; }
    setEnrolling(true);
    const { error } = await supabase
      .from("course_enrollments")
      .insert({ course_id: courseId, student_id: selectedStudentId });
    setEnrolling(false);
    if (error) { toast.error(error.message); return; }
    toast.success("Student enrolled!");
    setSelectedStudentId("");
    await loadData();
  }

  async function handleRemoveEnrollment(enrollmentId: string) {
    if (!confirm("Remove this student from the course?")) return;
    const { error } = await supabase.from("course_enrollments").delete().eq("id", enrollmentId);
    if (error) { toast.error(error.message); return; }
    setEnrolled((prev) => prev.filter((e) => e.id !== enrollmentId));
    toast.success("Student removed");
  }

  const enrolledIds = new Set(enrolled.map((e) => e.student_id));
  const unenrolledStudents = allStudents.filter((s) => !enrolledIds.has(s.id));

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className="text-slate-400">Loading...</p>
      </div>
    );
  }

  if (!course) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <p className="text-slate-500">Course not found.</p>
      </div>
    );
  }

  return (
    <div className="min-h-screen">
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-8">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2 text-sm text-slate-400">
            <Link href="/tutor" className="hover:text-slate-600">Dashboard</Link>
            <span>›</span>
            <Link href="/tutor/courses" className="hover:text-slate-600">Courses</Link>
            <span>›</span>
            <span className="text-slate-600">{course.title}</span>
          </div>
          <button
            onClick={handleDeleteCourse}
            className="text-sm text-red-400 hover:text-red-600"
          >
            Delete Course
          </button>
        </div>

        {/* Course Info */}
        <form onSubmit={handleSaveCourse} className="card space-y-4">
          <h2 className="font-semibold text-slate-700">Course Information</h2>

          {/* Icon */}
          <div>
            <label className="label">Course Icon Image</label>
            <div className="flex items-center gap-4">
              <div
                className="w-16 h-16 rounded-2xl overflow-hidden bg-slate-100 flex items-center justify-center shrink-0 border-2 border-dashed border-slate-300 cursor-pointer hover:border-teal-400 transition-colors"
                onClick={() => iconFileRef.current?.click()}
              >
                {iconPreview ? (
                  <img src={iconPreview} alt="" className="w-full h-full object-cover" />
                ) : courseIconUrl ? (
                  <img src={courseIconUrl} alt="" className="w-full h-full object-cover"
                    onError={() => setCourseIconUrl(null)} />
                ) : (
                  <span className="text-2xl text-slate-400">🖼️</span>
                )}
              </div>
              <div className="space-y-1">
                <div className="flex items-center gap-2">
                  <button type="button" onClick={() => iconFileRef.current?.click()} className="btn-secondary text-xs py-1.5 px-3">
                    {iconPreview || courseIconUrl ? "Replace" : "Upload Image"}
                  </button>
                  {(iconPreview || courseIconUrl) && (
                    <button type="button" onClick={removeIconImage} className="text-xs text-red-500 hover:text-red-700">Remove</button>
                  )}
                </div>
                <p className="text-xs text-slate-400">PNG or JPG, max 2 MB</p>
              </div>
            </div>
            <input ref={iconFileRef} type="file" accept="image/*" className="hidden" onChange={handleIconFileChange} />
          </div>

          <div>
            <label className="label">Title *</label>
            <input className="input" value={courseTitle} onChange={(e) => setCourseTitle(e.target.value)} required />
          </div>
          <div>
            <label className="label">Description</label>
            <textarea
              className="input resize-none"
              rows={2}
              value={courseDesc}
              onChange={(e) => setCourseDesc(e.target.value)}
              placeholder="Course description..."
            />
          </div>
          <button type="submit" className="btn-primary" disabled={savingCourse}>
            {savingCourse ? "Saving..." : "Save Changes"}
          </button>
        </form>

        {/* Modules Section */}
        <div className="card space-y-4">
          <div className="flex items-center justify-between">
            <h2 className="font-semibold text-slate-700">Modules</h2>
            <span className="badge-blue">{modules.length} module{modules.length !== 1 ? "s" : ""}</span>
          </div>

          {modules.length === 0 ? (
            <p className="text-sm text-slate-400 italic">No modules yet. Add the first one below.</p>
          ) : (
            <ul className="space-y-2">
              {modules.map((mod) => (
                <li key={mod.id} className="bg-slate-50 rounded-xl px-4 py-3 flex items-center gap-3">
                  <span className="text-xl">{mod.icon}</span>
                  <div className="flex-1 min-w-0">
                    <div className="font-medium text-slate-800 truncate">
                      {(lang === "id" && mod.title_id) ? mod.title_id : mod.title}
                    </div>
                    {(mod.focus || mod.focus_id) && (
                      <p className="text-xs text-slate-500 mt-0.5 truncate">
                        {(lang === "id" && mod.focus_id) ? mod.focus_id : mod.focus}
                      </p>
                    )}
                    {mod.week_number && (
                      <span className="badge-gray text-xs mt-1 inline-block">Week {mod.week_number}</span>
                    )}
                  </div>
                  <div className="flex items-center gap-2 shrink-0">
                    <Link
                      href={`/tutor/courses/${courseId}/modules/${mod.id}/edit`}
                      className="text-blue-500 hover:text-blue-700 text-sm"
                    >
                      Edit
                    </Link>
                    <button
                      onClick={() => handleDeleteModule(mod.id)}
                      className="text-red-400 hover:text-red-600 text-sm"
                    >
                      Delete
                    </button>
                  </div>
                </li>
              ))}
            </ul>
          )}

          {/* Add Module Form */}
          <form onSubmit={handleAddModule} className="border-t border-slate-200 pt-4 space-y-3">
            <h3 className="text-sm font-medium text-slate-600">Add New Module</h3>
            <div className="flex gap-3">
              <div className="w-20">
                <label className="label text-xs">Icon</label>
                <input
                  className="input text-xl text-center py-1.5"
                  value={newModIcon}
                  onChange={(e) => setNewModIcon(e.target.value)}
                  maxLength={8}
                />
              </div>
              <div className="flex-1">
                <label className="label text-xs">Title *</label>
                <input
                  className="input"
                  value={newModTitle}
                  onChange={(e) => setNewModTitle(e.target.value)}
                  placeholder="Module title"
                  required
                />
              </div>
              <div className="w-24">
                <label className="label text-xs">Week</label>
                <input
                  className="input"
                  type="number"
                  min={1}
                  value={newModWeek}
                  onChange={(e) => setNewModWeek(e.target.value === "" ? "" : parseInt(e.target.value))}
                  placeholder="1"
                />
              </div>
            </div>
            <div>
              <label className="label text-xs">Focus / Description</label>
              <input
                className="input"
                value={newModFocus}
                onChange={(e) => setNewModFocus(e.target.value)}
                placeholder="What this module covers..."
              />
            </div>
            <button type="submit" className="btn-primary text-sm" disabled={addingModule}>
              {addingModule ? "Adding..." : "+ Add Module"}
            </button>
          </form>
        </div>

        {/* Enrolled Students Section */}
        <div className="card space-y-4">
          <div className="flex items-center justify-between">
            <h2 className="font-semibold text-slate-700">Enrolled Students</h2>
            <span className="badge-green">{enrolled.length} student{enrolled.length !== 1 ? "s" : ""}</span>
          </div>

          {enrolled.length === 0 ? (
            <p className="text-sm text-slate-400 italic">No students enrolled yet.</p>
          ) : (
            <ul className="space-y-2">
              {enrolled.map((enrollment) => (
                <li key={enrollment.id} className="flex items-center justify-between bg-slate-50 rounded-xl px-4 py-2">
                  <div className="flex items-center gap-3">
                    <div className="w-8 h-8 rounded-full bg-blue-100 flex items-center justify-center font-bold text-blue-700 text-sm">
                      {enrollment.profiles?.name?.[0]?.toUpperCase() ?? "?"}
                    </div>
                    <span className="text-sm font-medium text-slate-700">{enrollment.profiles?.name}</span>
                  </div>
                  <button
                    onClick={() => handleRemoveEnrollment(enrollment.id)}
                    className="text-red-400 hover:text-red-600 text-xs"
                  >
                    Remove
                  </button>
                </li>
              ))}
            </ul>
          )}

          {unenrolledStudents.length > 0 && (
            <form onSubmit={handleEnroll} className="flex gap-3 pt-2 border-t border-slate-100">
              <select
                className="input flex-1"
                value={selectedStudentId}
                onChange={(e) => setSelectedStudentId(e.target.value)}
              >
                <option value="">Select a student to enroll...</option>
                {unenrolledStudents.map((s) => (
                  <option key={s.id} value={s.id}>{s.name}</option>
                ))}
              </select>
              <button type="submit" className="btn-primary shrink-0" disabled={enrolling}>
                {enrolling ? "Enrolling..." : "Enroll"}
              </button>
            </form>
          )}
        </div>
      </div>
    </div>
  );
}
