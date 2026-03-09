import React from "react";
import { cn } from "@/lib/utils";

interface MobileCardProps {
  children: React.ReactNode;
  className?: string;
  onClick?: () => void;
  variant?: "default" | "outlined" | "elevated" | "sunken";
  padding?: "default" | "compact" | "spacious" | "none";
}

const MobileCard: React.FC<MobileCardProps> = ({
  children,
  className,
  onClick,
  variant = "default",
  padding = "default",
}) => {
  const variantStyles = {
    default: "bg-card shadow-card dark:border dark:border-border-subtle",
    outlined: "bg-card border border-border",
    elevated: "bg-card shadow-elevated dark:border dark:border-border-subtle",
    sunken: "bg-surface-secondary",
  };

  const paddingStyles = {
    default: "px-4 py-3.5",
    compact: "px-3 py-2.5",
    spacious: "p-5",
    none: "",
  };

  return (
    <div
      onClick={onClick}
      className={cn(
        "rounded-xl transition-all",
        variantStyles[variant],
        paddingStyles[padding],
        onClick && "cursor-pointer active:scale-[0.98] active:shadow-xs hover:shadow-card-hover",
        className
      )}
    >
      {children}
    </div>
  );
};

export default MobileCard;
