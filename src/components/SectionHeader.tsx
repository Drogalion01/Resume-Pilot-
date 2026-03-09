import React from "react";
import { cn } from "@/lib/utils";

interface SectionHeaderProps {
  title: string;
  action?: { label: string; onClick: () => void };
  className?: string;
}

const SectionHeader: React.FC<SectionHeaderProps> = ({ title, action, className }) => {
  return (
    <div className={cn("flex items-center justify-between", className)}>
      <h2 className="text-title text-foreground tracking-[-0.01em]">{title}</h2>
      {action && (
        <button
          onClick={action.onClick}
          className="text-caption text-primary font-semibold press-scale hover:text-primary-hover transition-colors"
        >
          {action.label}
        </button>
      )}
    </div>
  );
};

export default SectionHeader;
