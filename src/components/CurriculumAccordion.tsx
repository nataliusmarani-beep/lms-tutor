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
      (c) => c.item_key === itemKey && (c.course_module_id === moduleId)
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

      <div className="space-y-1">
        {modules.map((m) => {
          const isOpen = openId === m.id;
          const isCurrent = m.id === currentModuleId;
          const pct = modulePct(m.id);
          const items = getItems(m.id);
          const studentItems = items.filter((i) => i.item_type === "student");
          const teacherItems = items.filter((i) => i.item_type === "teacher");

          return (
            <div
              key={m.id}
              className={`rounded-xl border transition-colors ${
                isCurrent
                  ? "border-indigo-200 bg-indigo-50"
                  : "border-slate-100 bg-white"
              }`}
            >
              {/* Row header — click to expand */}
              <button
                onClick={() => setOpenId(isOpen ? null : m.id)}
                className="w-full flex items-center gap-3 p-3 text-left"
              >
                <span className="text-xl shrink-0">{m.icon}</span>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center gap-2 flex-wrap">
                    {m.week_number && (
                      <span
                        className={`text-xs font-semibold px-2 py-0.5 rounded-full ${
                          isCurrent
                            ? "bg-indigo-100 text-indigo-700"
                            : "bg-slate-100 text-slate-500"
                        }`}
                      >
                        {lang === "id" ? "Minggu" : "Week"} {m.week_number}
                      </span>
                    )}
                    {isCurrent && (
                      <span className="text-xs font-semibold text-indigo-500">
                        {lang === "id" ? "Dibuka" : "Current"}
                      </span>
                    )}
                  </div>
                  <div
                    className={`text-sm font-medium mt-0.5 truncate ${
                      isCurrent ? "text-indigo-800" : "text-slate-700"
                    }`}
                  >
                    {m.title}
                  </div>
                  {m.focus && !isOpen && (
                    <p className="text-xs text-slate-400 mt-0.5 line-clamp-1">
                      {m.focus}
                    </p>
                  )}
                </div>
                <div className="flex items-center gap-2 shrink-0">
                  {pct !== null && (
                    <span
                      className={`text-xs font-semibold ${
                        pct >= 100
                          ? "text-green-600"
                          : pct > 0
                          ? "text-blue-600"
                          : "text-slate-400"
                      }`}
                    >
                      {pct}%
                    </span>
                  )}
                  <span
                    className={`text-slate-400 text-sm transition-transform duration-200 ${
                      isOpen ? "rotate-90" : ""
                    }`}
                  >
                    ›
                  </span>
                </div>
              </button>

              {/* Expanded content */}
              {isOpen && (
                <div className="px-3 pb-3 space-y-3">
                  {m.focus && (
                    <p className="text-xs text-slate-500 ml-9">{m.focus}</p>
                  )}

                  {/* Progress bar */}
                  {pct !== null && (
                    <div className="ml-9">
                      <div className="w-full bg-slate-200 rounded-full h-1.5">
                        <div
                          className={`h-1.5 rounded-full ${
                            pct >= 100 ? "bg-green-500" : "bg-blue-500"
                          }`}
                          style={{ width: `${pct}%` }}
                        />
                      </div>
                    </div>
                  )}

                  {/* Student items */}
                  {studentItems.length > 0 && (
                    <div className="ml-9">
                      <p className="text-xs font-semibold text-slate-400 uppercase tracking-wide mb-1.5">
                        {lang === "id" ? "Aktivitas Siswa" : "Student Activities"}
                      </p>
                      <ul className="space-y-1.5">
                        {studentItems.map((item) => {
                          const done = isDone(m.id, item.item_key);
                          return (
                            <li key={item.item_key} className="flex items-start gap-2">
                              <span
                                className={`mt-0.5 shrink-0 w-4 h-4 rounded-full flex items-center justify-center text-xs ${
                                  done
                                    ? "bg-green-500 text-white"
                                    : "bg-slate-200 text-slate-300"
                                }`}
                              >
                                {done ? "✓" : ""}
                              </span>
                              <span
                                className={`text-xs ${
                                  done
                                    ? "text-slate-400 line-through"
                                    : "text-slate-600"
                                }`}
                              >
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
                    <div className="ml-9">
                      <p className="text-xs font-semibold text-slate-400 uppercase tracking-wide mb-1.5">
                        {lang === "id" ? "Materi Tutor" : "Tutor-Led Topics"}
                      </p>
                      <ul className="space-y-1.5">
                        {teacherItems.map((item) => {
                          const done = isDone(m.id, item.item_key);
                          return (
                            <li key={item.item_key} className="flex items-start gap-2">
                              <span
                                className={`mt-0.5 shrink-0 w-4 h-4 rounded-full flex items-center justify-center text-xs ${
                                  done
                                    ? "bg-indigo-500 text-white"
                                    : "bg-slate-200 text-slate-300"
                                }`}
                              >
                                {done ? "✓" : ""}
                              </span>
                              <span
                                className={`text-xs ${
                                  done
                                    ? "text-slate-400 line-through"
                                    : "text-slate-600"
                                }`}
                              >
                                {item.label}
                              </span>
                            </li>
                          );
                        })}
                      </ul>
                    </div>
                  )}

                  {items.length === 0 && (
                    <p className="text-xs text-slate-400 italic ml-9">
                      {lang === "id" ? "Belum ada materi." : "No topics yet."}
                    </p>
                  )}

                  {/* View detail link */}
                  <div className="ml-9 pt-1">
                    <Link
                      href={`/parent/courses/${courseId}/modules/${m.id}`}
                      className="text-xs text-indigo-600 hover:text-indigo-800 font-medium"
                    >
                      {lang === "id" ? "Lihat detail →" : "View details →"}
                    </Link>
                  </div>
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}
