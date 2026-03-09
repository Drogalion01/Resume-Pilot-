import React from "react";
import { cn } from "@/lib/utils";

interface ChipProps {
  label: string;
  active?: boolean;
  onClick?: () => void;
  count?: number;
  icon?: React.ReactNode;
  className?: string;
}

const Chip: React.FC<ChipProps> = ({ label, active = false, onClick, count, icon, className }) => {
  return (
    <button
      onClick={onClick}
      className={cn(
        "inline-flex items-center gap-1.5 h-[34px] px-3.5 rounded-full text-[13px] font-semibold whitespace-nowrap transition-all press-scale border",
        active
          ? "bg-primary text-primary-foreground shadow-xs border-primary"
          : "bg-surface-secondary text-foreground-secondary hover:bg-muted border-transparent",
        className
      )}
    >
      {icon && <span className="[&_svg]:size-3.5">{icon}</span>}
      {label}
      {count !== undefined && (
        <span className={cn(
          "ml-0.5 text-[10px] font-bold rounded-full min-w-[18px] h-[18px] flex items-center justify-center px-1",
          active ? "bg-primary-foreground/20 text-primary-foreground" : "bg-border text-foreground-tertiary"
        )}>
          {count}
        </span>
      )}
    </button>
  );
};

export default Chip;
