import React from "react";
import { cn } from "@/lib/utils";

interface ScoreCardProps {
  score: number;
  label: string;
  description?: string;
  trend?: { value: number; positive: boolean };
  className?: string;
}

const ScoreCard: React.FC<ScoreCardProps> = ({ score, label, description, trend, className }) => {
  const getScoreStyles = (s: number) => {
    if (s >= 80) return { bg: "bg-score-excellent-bg", text: "text-score-excellent", bar: "bg-score-excellent" };
    if (s >= 60) return { bg: "bg-score-good-bg", text: "text-score-good", bar: "bg-score-good" };
    if (s >= 40) return { bg: "bg-score-average-bg", text: "text-score-average", bar: "bg-score-average" };
    return { bg: "bg-score-poor-bg", text: "text-score-poor", bar: "bg-score-poor" };
  };

  const styles = getScoreStyles(score);

  return (
    <div className={cn("bg-card rounded-xl p-4 shadow-card space-y-3", className)}>
      <div className="flex items-start justify-between">
        <div>
          <p className="text-overline text-foreground-tertiary">{label}</p>
          <div className="flex items-baseline gap-1.5 mt-1">
            <span className={cn("text-display", styles.text)}>{score}</span>
            <span className="text-caption text-foreground-quaternary">/100</span>
          </div>
        </div>
        {trend && (
          <span className={cn(
            "text-caption font-semibold px-2 py-0.5 rounded-md",
            trend.positive ? "text-score-excellent bg-score-excellent-bg" : "text-score-poor bg-score-poor-bg"
          )}>
            {trend.positive ? "+" : ""}{trend.value}
          </span>
        )}
      </div>

      {/* Progress Bar */}
      <div className="space-y-1.5">
        <div className={cn("h-2 rounded-full w-full", styles.bg)}>
          <div
            className={cn("h-2 rounded-full transition-all duration-700 ease-out", styles.bar)}
            style={{ width: `${score}%` }}
          />
        </div>
        {description && (
          <p className="text-caption text-foreground-tertiary">{description}</p>
        )}
      </div>
    </div>
  );
};

export default ScoreCard;
