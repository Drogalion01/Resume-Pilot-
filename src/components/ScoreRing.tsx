import React from "react";
import { cn } from "@/lib/utils";

interface ScoreRingProps {
  score: number;
  label: string;
  size?: number;
  strokeWidth?: number;
  showLabel?: boolean;
  className?: string;
}

const ScoreRing: React.FC<ScoreRingProps> = ({
  score,
  label,
  size = 100,
  strokeWidth = 6,
  showLabel = true,
  className,
}) => {
  const radius = (size - strokeWidth) / 2;
  const circumference = 2 * Math.PI * radius;
  const offset = circumference - (score / 100) * circumference;

  const getScoreColor = (s: number) => {
    if (s >= 80) return { text: "text-score-excellent", stroke: "stroke-score-excellent", track: "stroke-score-excellent/15" };
    if (s >= 60) return { text: "text-score-good", stroke: "stroke-score-good", track: "stroke-score-good/15" };
    if (s >= 40) return { text: "text-score-average", stroke: "stroke-score-average", track: "stroke-score-average/15" };
    return { text: "text-score-poor", stroke: "stroke-score-poor", track: "stroke-score-poor/15" };
  };

  const colors = getScoreColor(score);
  const fontSize = size <= 56 ? "text-[13px]" : size <= 80 ? "text-lg" : "text-xl";

  return (
    <div className={cn("flex flex-col items-center gap-1.5", className)}>
      <div className="relative" style={{ width: size, height: size }}>
        <svg width={size} height={size} className="-rotate-90">
          <circle
            cx={size / 2}
            cy={size / 2}
            r={radius}
            fill="none"
            className={colors.track}
            strokeWidth={strokeWidth}
          />
          <circle
            cx={size / 2}
            cy={size / 2}
            r={radius}
            fill="none"
            className={cn(colors.stroke)}
            strokeWidth={strokeWidth}
            strokeLinecap="round"
            strokeDasharray={circumference}
            strokeDashoffset={circumference}
            style={{
              animation: `score-fill-to-${score} 600ms cubic-bezier(0.25, 0.1, 0.25, 1) forwards`,
              // @ts-ignore CSS custom property
              "--target-offset": offset,
            } as React.CSSProperties}
          />
        </svg>
        <style>{`
          @keyframes score-fill-to-${score} {
            from { stroke-dashoffset: ${circumference}; }
            to { stroke-dashoffset: ${offset}; }
          }
        `}</style>
        <div className="absolute inset-0 flex items-center justify-center">
          <span className={cn("font-extrabold tabular-nums", fontSize, colors.text)}>{score}</span>
        </div>
      </div>
      {showLabel && (
        <span className="text-caption text-foreground-tertiary">{label}</span>
      )}
    </div>
  );
};

export default ScoreRing;
