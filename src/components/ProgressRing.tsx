interface ProgressRingProps {
  percent: number;
  size?: number;
  strokeWidth?: number;
  label?: string;
  /** dark = placed on a dark/navy background, light = placed on white/light bg */
  variant?: "dark" | "light";
}

export default function ProgressRing({ percent, size = 72, strokeWidth = 7, label, variant = "light" }: ProgressRingProps) {
  const radius = (size - strokeWidth) / 2;
  const circumference = 2 * Math.PI * radius;
  const offset = circumference - (percent / 100) * circumference;

  // Progress arc: always vivid so it pops on both backgrounds
  const arcColor =
    percent >= 80 ? "#4ade80" : percent >= 50 ? "#60a5fa" : percent >= 20 ? "#fbbf24" : "#94a3b8";

  // Track ring + label text adapt to background
  const trackColor  = variant === "dark" ? "rgba(255,255,255,0.15)" : "#e2e8f0";
  const textColor   = variant === "dark" ? "#ffffff" : "#1e293b";
  const labelColor  = variant === "dark" ? "#bfdbfe" : "#64748b";

  return (
    <div className="flex flex-col items-center gap-1">
      <svg width={size} height={size}>
        {/* Track */}
        <circle
          cx={size / 2} cy={size / 2} r={radius}
          fill="none" stroke={trackColor} strokeWidth={strokeWidth}
        />
        {/* Progress arc */}
        <circle
          cx={size / 2} cy={size / 2} r={radius}
          fill="none" stroke={arcColor} strokeWidth={strokeWidth}
          strokeDasharray={circumference} strokeDashoffset={offset}
          strokeLinecap="round"
          style={{ transform: "rotate(-90deg)", transformOrigin: "50% 50%", transition: "stroke-dashoffset 0.5s ease" }}
        />
        {/* Percentage label */}
        <text x="50%" y="50%" dominantBaseline="middle" textAnchor="middle" fontSize="14" fontWeight="700" fill={textColor}>
          {percent}%
        </text>
      </svg>
      {label && <span className="text-xs text-center" style={{ color: labelColor }}>{label}</span>}
    </div>
  );
}
