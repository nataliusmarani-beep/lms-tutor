"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { createClient } from "@/lib/supabase/client";
import type { Assignment, Submission, Profile } from "@/types";
import toast from "react-hot-toast";
import { format } from "date-fns";

interface AssignmentPanelProps {
  moduleId: number;
  assignments: (Assignment & { submissions: (Submission & { profiles: Profile })[] })[];
  currentUserId: string;
  currentUserRole: string;
  studentId?: string;
}

export default function AssignmentPanel({
  moduleId, assignments, currentUserId, currentUserRole, studentId,
}: AssignmentPanelProps) {
  const [showForm, setShowForm] = useState(false);
  const router = useRouter();
  const supabase = createClient();

  function onRefresh() { router.refresh(); }

  const targetStudentId = studentId ?? currentUserId;

  async function handleCreateAssignment(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const fd = new FormData(e.currentTarget);
    const { error } = await supabase.from("assignments").insert({
      module_id: moduleId,
      title: fd.get("title") as string,
      description: fd.get("description") as string || null,
      due_date: fd.get("due_date") as string || null,
      created_by: currentUserId,
    });
    if (error) { toast.error(error.message); return; }
    toast.success("Assignment created!");
    setShowForm(false);
    onRefresh();
  }

  async function handleSubmitAssignment(assignmentId: string, e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const fd = new FormData(e.currentTarget);
    const { error } = await supabase.from("submissions").insert({
      assignment_id: assignmentId,
      student_id: targetStudentId,
      file_link: fd.get("file_link") as string || null,
      notes: fd.get("notes") as string || null,
    });
    if (error) { toast.error(error.message); return; }
    toast.success("Submitted!");
    onRefresh();
  }

  async function handleGrade(submissionId: string, e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const fd = new FormData(e.currentTarget);
    const { error } = await supabase
      .from("submissions")
      .update({
        grade: fd.get("grade") as string,
        feedback: fd.get("feedback") as string || null,
        graded_at: new Date().toISOString(),
      })
      .eq("id", submissionId);
    if (error) { toast.error(error.message); return; }
    toast.success("Graded!");
    onRefresh();
  }

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h3 className="font-semibold text-slate-700">📋 Assignments</h3>
        {currentUserRole === "tutor" && (
          <button className="btn-primary text-sm py-1.5" onClick={() => setShowForm(!showForm)}>
            {showForm ? "Cancel" : "+ New Assignment"}
          </button>
        )}
      </div>

      {showForm && (
        <form onSubmit={handleCreateAssignment} className="card border-blue-200 space-y-3">
          <h4 className="font-medium text-sm text-blue-700">Create Assignment</h4>
          <div>
            <label className="label">Title *</label>
            <input name="title" className="input" required placeholder="e.g. Build a budget spreadsheet" />
          </div>
          <div>
            <label className="label">Description</label>
            <textarea name="description" className="input resize-none" rows={2} placeholder="Instructions..." />
          </div>
          <div>
            <label className="label">Due Date</label>
            <input name="due_date" type="date" className="input" />
          </div>
          <button className="btn-primary" type="submit">Create</button>
        </form>
      )}

      {assignments.length === 0 ? (
        <p className="text-sm text-slate-400 italic">No assignments for this module yet.</p>
      ) : (
        assignments.map((a) => {
          const mySubmission = a.submissions.find((s) => s.student_id === targetStudentId);
          const isOverdue = a.due_date && new Date(a.due_date) < new Date() && !mySubmission;

          return (
            <div key={a.id} className={`card ${isOverdue ? "border-red-200" : ""}`}>
              <div className="flex items-start justify-between gap-2 mb-2">
                <div>
                  <h4 className="font-medium text-slate-800">{a.title}</h4>
                  {a.description && <p className="text-sm text-slate-500 mt-0.5">{a.description}</p>}
                </div>
                <div className="shrink-0 text-right">
                  {a.due_date && (
                    <span className={`badge ${isOverdue ? "badge-red" : "badge-gray"}`}>
                      Due {format(new Date(a.due_date), "MMM d")}
                    </span>
                  )}
                </div>
              </div>

              {mySubmission ? (
                <div className="mt-3 bg-green-50 rounded-xl p-3">
                  <p className="text-xs font-semibold text-green-700 mb-1">✓ Submitted {format(new Date(mySubmission.submitted_at), "MMM d, yyyy")}</p>
                  {mySubmission.file_link && (
                    <a href={mySubmission.file_link} target="_blank" rel="noopener noreferrer"
                      className="text-xs text-blue-600 underline break-all"
                    >
                      {mySubmission.file_link}
                    </a>
                  )}
                  {mySubmission.notes && <p className="text-xs text-slate-600 mt-1">{mySubmission.notes}</p>}
                  {mySubmission.grade ? (
                    <div className="mt-2 pt-2 border-t border-green-200">
                      <span className="badge-green mr-2">Grade: {mySubmission.grade}</span>
                      {mySubmission.feedback && <span className="text-xs text-slate-600">{mySubmission.feedback}</span>}
                    </div>
                  ) : currentUserRole === "tutor" ? (
                    <form onSubmit={(e) => handleGrade(mySubmission.id, e)} className="mt-2 pt-2 border-t border-green-200 flex gap-2 items-end">
                      <div className="flex-1">
                        <label className="label text-xs">Grade</label>
                        <input name="grade" className="input py-1 text-xs" placeholder="A, B+, 90..." required />
                      </div>
                      <div className="flex-1">
                        <label className="label text-xs">Feedback</label>
                        <input name="feedback" className="input py-1 text-xs" placeholder="Optional..." />
                      </div>
                      <button className="btn-primary text-xs py-1 px-3" type="submit">Grade</button>
                    </form>
                  ) : (
                    <p className="text-xs text-slate-400 mt-2 italic">Awaiting grade...</p>
                  )}
                </div>
              ) : currentUserRole === "student" ? (
                <form onSubmit={(e) => handleSubmitAssignment(a.id, e)} className="mt-3 space-y-2">
                  <div>
                    <label className="label text-xs">Google Drive / OneDrive Link *</label>
                    <input name="file_link" type="url" className="input text-sm" required
                      placeholder="https://drive.google.com/..." />
                  </div>
                  <div>
                    <label className="label text-xs">Notes (optional)</label>
                    <textarea name="notes" className="input resize-none text-sm" rows={1} placeholder="Any notes for your tutor..." />
                  </div>
                  <button className="btn-primary text-sm py-1.5" type="submit">Submit Assignment</button>
                </form>
              ) : (
                <div className="mt-2">
                  {a.submissions.length === 0 ? (
                    <p className="text-xs text-slate-400 italic">No submissions yet.</p>
                  ) : (
                    a.submissions.map((s) => (
                      <div key={s.id} className="mt-2 bg-slate-50 rounded-lg p-2 text-xs">
                        <span className="font-medium">{s.profiles?.name ?? "Student"}:</span>{" "}
                        {s.file_link ? (
                          <a href={s.file_link} target="_blank" rel="noopener noreferrer" className="text-blue-600 underline">View file</a>
                        ) : "No file"}
                        {s.grade && <span className="ml-2 badge-green">Grade: {s.grade}</span>}
                      </div>
                    ))
                  )}
                </div>
              )}
            </div>
          );
        })
      )}
    </div>
  );
}
