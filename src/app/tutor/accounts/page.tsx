import { redirect } from "next/navigation";
import Link from "next/link";
import { createClient } from "@/lib/supabase/server";
import Navbar from "@/components/Navbar";

interface Profile {
  id: string;
  name: string;
  role: string;
}

interface ParentStudent {
  parent_id: string;
  student_id: string;
}

export default async function AccountsPage() {
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) redirect("/login");

  const { data: tutor } = await supabase.from("profiles").select("*").eq("id", user.id).single();
  if (!tutor || tutor.role !== "tutor") redirect("/login");

  const [{ data: students }, { data: parents }, { data: links }] = await Promise.all([
    supabase.from("profiles").select("*").eq("role", "student").order("name"),
    supabase.from("profiles").select("*").eq("role", "parent").order("name"),
    supabase.from("parent_student").select("*"),
  ]);

  const studentList = (students ?? []) as Profile[];
  const parentList = (parents ?? []) as Profile[];
  const linkList = (links ?? []) as ParentStudent[];

  const linkedStudentIds = (parentId: string) =>
    linkList.filter((l) => l.parent_id === parentId).map((l) => l.student_id);

  const linkedParentIds = (studentId: string) =>
    linkList.filter((l) => l.student_id === studentId).map((l) => l.parent_id);

  return (
    <div className="min-h-screen bg-slate-50">
      <Navbar name={tutor.name} role="tutor" />
      <div className="max-w-5xl mx-auto px-4 py-8 space-y-8">

        <div className="flex items-center justify-between">
          <div>
            <Link href="/tutor" className="text-sm text-slate-400 hover:text-slate-600">← Dashboard</Link>
            <h1 className="text-2xl font-bold text-slate-800 mt-1">Manage Accounts</h1>
            <p className="text-slate-500 text-sm mt-0.5">View and manage student & parent accounts</p>
          </div>
          <Link href="/tutor/students/new" className="btn-primary text-sm">
            + Add Account
          </Link>
        </div>

        {/* Students */}
        <div>
          <div className="flex items-center gap-2 mb-3">
            <h2 className="text-lg font-semibold text-slate-700">Students</h2>
            <span className="badge-blue">{studentList.length}</span>
          </div>
          {studentList.length === 0 ? (
            <div className="card text-center py-10">
              <p className="text-slate-400">No students yet.</p>
              <Link href="/tutor/students/new" className="btn-primary mt-3 inline-block text-sm">Add First Student</Link>
            </div>
          ) : (
            <div className="space-y-2">
              {studentList.map((s) => {
                const theirParents = linkedParentIds(s.id)
                  .map((pid) => parentList.find((p) => p.id === pid)?.name)
                  .filter(Boolean);
                return (
                  <div key={s.id} className="card flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-indigo-100 text-indigo-700 flex items-center justify-center font-bold text-sm shrink-0">
                      {s.name[0]?.toUpperCase()}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="font-semibold text-slate-800">{s.name}</div>
                      <div className="text-xs text-slate-400 truncate">ID: {s.id}</div>
                      {theirParents.length > 0 && (
                        <div className="text-xs text-slate-500 mt-0.5">
                          Parent: {theirParents.join(", ")}
                        </div>
                      )}
                    </div>
                    <div className="flex items-center gap-2 shrink-0">
                      <span className="badge-green">Student</span>
                      <Link
                        href={`/tutor/students/${s.id}`}
                        className="btn-secondary text-xs py-1 px-3"
                      >
                        View Progress
                      </Link>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* Parents */}
        <div>
          <div className="flex items-center gap-2 mb-3">
            <h2 className="text-lg font-semibold text-slate-700">Parents</h2>
            <span className="badge-blue">{parentList.length}</span>
          </div>
          {parentList.length === 0 ? (
            <div className="card text-center py-10">
              <p className="text-slate-400">No parent accounts yet.</p>
              <Link href="/tutor/students/new" className="btn-primary mt-3 inline-block text-sm">Add Parent</Link>
            </div>
          ) : (
            <div className="space-y-2">
              {parentList.map((p) => {
                const theirStudents = linkedStudentIds(p.id)
                  .map((sid) => studentList.find((s) => s.id === sid)?.name)
                  .filter(Boolean);
                return (
                  <div key={p.id} className="card flex items-center gap-4">
                    <div className="w-10 h-10 rounded-full bg-amber-100 text-amber-700 flex items-center justify-center font-bold text-sm shrink-0">
                      {p.name[0]?.toUpperCase()}
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="font-semibold text-slate-800">{p.name}</div>
                      <div className="text-xs text-slate-400 truncate">ID: {p.id}</div>
                      {theirStudents.length > 0 && (
                        <div className="text-xs text-slate-500 mt-0.5">
                          Student: {theirStudents.join(", ")}
                        </div>
                      )}
                    </div>
                    <div className="shrink-0">
                      <span className="badge-yellow">Parent</span>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* Summary */}
        <div className="card bg-indigo-50 border-indigo-100">
          <h3 className="font-semibold text-indigo-800 mb-3">Account Summary</h3>
          <div className="grid grid-cols-3 gap-4 text-center">
            <div>
              <div className="text-2xl font-bold text-indigo-600">{studentList.length}</div>
              <div className="text-xs text-indigo-500 mt-0.5">Students</div>
            </div>
            <div>
              <div className="text-2xl font-bold text-indigo-600">{parentList.length}</div>
              <div className="text-xs text-indigo-500 mt-0.5">Parents</div>
            </div>
            <div>
              <div className="text-2xl font-bold text-indigo-600">{linkList.length}</div>
              <div className="text-xs text-indigo-500 mt-0.5">Parent–Student Links</div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
