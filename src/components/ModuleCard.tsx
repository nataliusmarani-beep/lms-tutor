import Link from "next/link";
import type { CourseModule } from "@/types";
import type { ModuleProgress } from "@/types";

interface ModuleCardProps {
  module: CourseModule;
  progress?: ModuleProgress;
  href: string;
  lang?: "en" | "id";
}

export default function ModuleCard({ module, progress, href, lang = "en" }: ModuleCardProps) {
  const title = lang === "id" ? module.titleId : module.title;
  const focus = lang === "id" ? module.focusId : module.focus;
  const pct = progress?.percentComplete ?? 0;

  const statusColor =
    pct >= 100 ? "border-green-400 bg-green-50" :
    pct > 0 ? "border-blue-400 bg-blue-50" :
    "border-slate-200 bg-white";

  return (
    <Link href={href} className={`block rounded-2xl border-2 ${statusColor} p-4 hover:shadow-md transition-shadow`}>
      <div className="flex items-start justify-between gap-2">
        <div className="flex-1">
          <div className="flex items-center gap-2 mb-1">
            <span className="text-2xl">{module.icon}</span>
            <span className="text-xs font-semibold text-slate-400 uppercase tracking-wide">
              Week {module.week}
            </span>
          </div>
          <h3 className="font-semibold text-slate-800 text-sm leading-snug">{title}</h3>
          <p className="text-xs text-slate-500 mt-1 line-clamp-2">{focus}</p>
        </div>
        {progress && (
          <div className="text-right shrink-0">
            <span className={`text-lg font-bold ${pct >= 100 ? "text-green-600" : "text-blue-600"}`}>
              {pct}%
            </span>
            <div className="text-xs text-slate-400">{progress.sessionsCount} sessions</div>
          </div>
        )}
      </div>
      {progress && (
        <div className="mt-3">
          <div className="flex justify-between text-xs text-slate-500 mb-1">
            <span>Student: {progress.studentChecksCompleted}/{progress.studentChecksTotal}</span>
            <span>Tutor: {progress.teacherChecksCompleted}/{progress.teacherChecksTotal}</span>
          </div>
          <div className="w-full bg-slate-200 rounded-full h-1.5">
            <div
              className={`h-1.5 rounded-full transition-all ${pct >= 100 ? "bg-green-500" : "bg-blue-500"}`}
              style={{ width: `${pct}%` }}
            />
          </div>
        </div>
      )}
    </Link>
  );
}
