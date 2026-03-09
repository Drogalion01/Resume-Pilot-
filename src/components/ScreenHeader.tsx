import React from "react";
import { cn } from "@/lib/utils";
import { ChevronLeft } from "lucide-react";
import { useNavigate } from "react-router-dom";

interface ScreenHeaderProps {
  title: string;
  subtitle?: string;
  showBack?: boolean;
  rightAction?: React.ReactNode;
  large?: boolean;
  className?: string;
}

const ScreenHeader: React.FC<ScreenHeaderProps> = ({
  title,
  subtitle,
  showBack,
  rightAction,
  large = false,
  className,
}) => {
  const navigate = useNavigate();

  return (
    <div className={cn("flex items-center gap-3 px-5 pt-14 pb-3", className)}>
      {showBack && (
        <button
          onClick={() => navigate(-1)}
          className="flex items-center justify-center w-9 h-9 -ml-1 rounded-xl hover:bg-muted transition-colors press-scale"
        >
          <ChevronLeft className="h-5 w-5 text-foreground" />
        </button>
      )}
      <div className="flex-1 min-w-0">
        <h1 className={cn(
          "text-foreground truncate",
          large ? "text-display" : "text-headline"
        )}>
          {title}
        </h1>
        {subtitle && (
          <p className="text-caption text-foreground-tertiary mt-0.5">{subtitle}</p>
        )}
      </div>
      {rightAction && <div className="shrink-0">{rightAction}</div>}
    </div>
  );
};

export default ScreenHeader;
