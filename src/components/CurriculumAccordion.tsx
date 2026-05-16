"use client";
import { useState } from "react";
import Link from "next/link";

interface Module {
  id: string;
  title: string;
  focus: string | null;
  icon: string;
  week_number: number | null;
}

interface ChecklistItem {
  course_module_id: string;
  item_key: string;
  label: string;
  item_type: string;
}

interface Completion {
  item_key: string;
  course_module_id: string | null;
  module_id: number | null;
}

interface Props {
  courseId: string;
  currentModuleId: string;
  modules: Module[];
  allItems: ChecklistItem[];
  completions: Completion[];
  lang: "en" | "id";
}

export default function CurriculumAccordion({
  courseId,
  currentModuleId,
  modules,
  allItems,
  completions,
  lang,
}: Props) {
  const [openId, setOpenId] = useState<string | null>(currentModuleId);

  function getItems(moduleId: string) {
    return allItems.filter((i) => i.course_module_id === moduleId);
  }

  function isDone(moduleId: string, itemKey: string) {
    return completions.some(
      (c) => c.item_key === itemKey && c.course_module_id === moduleId
    );
  }

  function modulePct(moduleId: string) {
    const items = getItems(moduleId);
    if (items.length === 0) return null;
    const done = items.filter((i) => isDone(moduleId, i.item_key)).length;
    return Math.round((done / items.length) * 100);
  }

  return (
    <div className="card">
      <h2 className="font-semibold text-slate-700 mb-4 flex items-center justify-between">
        <span className="flex items-center gap-2">
          <span>📚</span>
          {lang === "id" ? "Kurikulum Kursus" : "Course Curriculum"}
        </span>
        <span className="badge-gray text-xs">
          {modules.length} {lang === "id" ? "modul" : "modules"}
        </span>
      </h2>

      <div className="divide-y divide-slate-100">
        {modules.map((m) => {
          const isOpen = openId === m.id;
          const isCurrent = m.id === currentModuleId;
          const pct = modulePct(m.id);
          const items = getItems(m.id);
          const studentItems = items.filter((i) => i.item_type === "student");
          const teacherItems = items.filter((i) => i.item_type === "teacher");

          return (
            <div key={m.id}>
              {/* Row header */}
              <button
                onClick={() => setOpenId(isOpen ? null : m.id)}
                className={`w-full flex items-center gap-3 py-3 px-2 text-left rounded-xl transition-colors ${
                  isOpen && isCurrent ? "bg-indigo-50" : isOpen ? "bg-slate-50" : "hover:bg-slate-50"
                }`}
              >
                {/* Chevron */}
                <svg
                  className={`w-4 h-4 shrink-0 text-slate-400 transition-transform duration-200 ${isOpen ? "rotate-90" : ""}`}
                  fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}
                >
                  <path strokeLinecap="round" strokeLinejoin="round" d="M9 5l7 7-7 7" />
                </svg>

                <span className="text-xl shrink-0">{m.icon}</span>

                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 flex-wrap">
                    {m.week_number && (
                      <span className={`text-xs font-semibold px-2 py-0.5 rounded-full ${
                        isCurrent ? "bg-indigo-100 text-indigo-700" : "bg-slate-100 text-slate-500"
                      }`}>
                        {lang === "id" ? "Minggu" : "Week"} {m.week_number}
                      </span>
                    )}
                    {isCurrent && (
                      <span className="text-xs font-semibold text-indigo-500">
                        {lang === "id" ? "● Dibuka" : "● Current"}
                      </span>
                    )}
                  </div>
                  <div className={`text-sm font-medium leading-tight mt-0.5 ${isCurrent ? "text-indigo-800" : "text-slate-700"}`}>
                    {m.title}
                  </div>
                  {/* Focus always visible */}
                  {m.focus && (
                    <p className={`text-xs text-slate-400 mt-0.5 ${isOpen ? "" : "line-clamp-1"}`}>
                      {m.focus}
                    </p>
                  )}
                </div>

                {pct !== null && (
                  <span className={`text-xs font-bold shrink-0 ${
                    pct >= 100 ? "text-green-600" : pct > 0 ? "text-blue-600" : "text-slate-400"
                  }`}>
                    {pct}%
                  </span>
                )}
              </button>

              {/* Expanded body */}
              {isOpen && (
                <div className="pb-3 pl-9 pr-2 space-y-3">
                  {/* Progress bar */}
                  {pct !== null && (
                    <div className="w-full bg-slate-200 rounded-full h-1.5">
                      <div
                        className={`h-1.5 rounded-full ${pct >= 100 ? "bg-green-500" : "bg-blue-500"}`}
                        style={{ width: `${pct}%` }}
                      />
                    </div>
                  )}

                  {/* Student items */}
                  {studentItems.length > 0 && (
                    <div>
                      <p className="text-xs font-semibold text-slate-400 uppercase tracking-wide mb-2">
                        {lang === "id" ? "Aktivitas Siswa" : "Student Activities"}
                      </p>
                      <ul className="space-y-1.5">
                        {studentItems.map((item) => {
                          const done = isDone(m.id, item.item_key);
                          return (
                            <li key={item.item_key} className="flex items-start gap-2">
                              <span className={`mt-0.5 shrink-0 w-4 h-4 rounded-full flex items-center justify-center text-xs font-bold ${
                                done ? "bg-green-500 text-white" : "border-2 border-slate-300"
                              }`}>
                                {done ? "✓" : ""}
                              </span>
                              <span className={`text-xs leading-relaxed ${done ? "text-slate-400 line-through" : "text-slate-600"}`}>
                                {item.label}
                              </span>
                            </li>
                          );
                        })}
                      </ul>
                    </div>
                  )}

                  {/* Teacher items */}
                  {teacherItems.length > 0 && (
                    <div>
                      <p className="text-xs font-semibold text-slate-400 uppercase tracking-wide mb-2">
                        {lang === "id" ? "Materi Tutor" : "Tutor-Led Topics"}
                      </p>
                      <ul className="space-y-1.5">
                        {teacherItems.map((item) => {
                          const done = isDone(m.id, item.item_key);
                          return (
                            <li key={item.item_key} className="flex items-start gap-2">
                              <span className={`mt-0.5 shrink-0 w-4 h-4 rounded-full flex items-center justify-center text-xs font-bold ${
                                done ? "bg-indigo-500 text-white" : "border-2 border-slate-300"
                              }`}>
                                {done ? "✓" : ""}
                              </span>
                              <span className={`text-xs leading-relaxed ${done ? "text-slate-400 line-through" : "text-slate-600"}`}>
                                {item.label}
                              </span>
                            </li>
                          );
                        })}
                      </ul>
                    </div>
                  )}

                  {items.length === 0 && (
                    <p className="text-xs text-slate-400 italic">
                      {lang === "id" ? "Belum ada materi." : "No topics yet."}
                    </p>
                  )}

                  <Link
                    href={`/parent/courses/${courseId}/modules/${m.id}`}
                    className="inline-block text-xs text-indigo-600 hover:text-indigo-800 font-medium pt-1"
                  >
                    {lang === "id" ? "Lihat detail sesi & kuis →" : "View sessions & quizzes →"}
                  </Link>
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}
