"use client";

/**
 * NotesList — renders a notes string as a labelled bullet-point list,
 * styled like the checklist progress section.
 *
 * Splits on newlines and common bullet prefixes (-, •, *, 1. 2. etc.)
 * Single-line notes show as one bullet. Empty lines are ignored.
 */

interface NotesListProps {
  label: string;
  text: string | null | undefined;
  variant?: "tutor" | "student";
}

function parseLines(text: string): string[] {
  return text
    .split(/\n+/)
    .map((line) => line.replace(/^[\s]*[-•*]\s*/, "").replace(/^[\s]*\d+[.)]\s*/, "").trim())
    .filter(Boolean);
}

export default function NotesList({ label, text, variant = "tutor" }: NotesListProps) {
  if (!text?.trim()) return null;

  const lines = parseLines(text);
  if (lines.length === 0) return null;

  const dotColor   = variant === "student" ? "bg-teal-400"   : "bg-slate-400";
  const labelColor = variant === "student" ? "text-teal-600" : "text-slate-500";
  const textColor  = variant === "student" ? "text-teal-800" : "text-slate-700";

  return (
    <div className="mt-2">
      <p className={`text-[10px] font-bold uppercase tracking-wide mb-1.5 ${labelColor}`}>
        {label}
      </p>
      <ul className="space-y-1">
        {lines.map((line, i) => (
          <li key={i} className="flex items-start gap-2">
            <span className={`mt-1.5 w-1.5 h-1.5 rounded-full shrink-0 ${dotColor}`} />
            <span className={`text-xs leading-relaxed ${textColor}`}>{line}</span>
          </li>
        ))}
      </ul>
    </div>
  );
}
