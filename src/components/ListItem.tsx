import React from "react";
import { cn } from "@/lib/utils";

interface ListItemProps {
  icon?: React.ReactNode;
  iconBg?: string;
  title: string;
  subtitle?: string;
  trailing?: React.ReactNode;
  onClick?: () => void;
  className?: string;
}

const ListItem: React.FC<ListItemProps> = ({
  icon,
  iconBg = "bg-muted",
  title,
  subtitle,
  trailing,
  onClick,
  className,
}) => {
  return (
    <div
      onClick={onClick}
      className={cn(
        "flex items-center gap-3.5 py-3",
        onClick && "cursor-pointer press-scale",
        className
      )}
    >
      {icon && (
        <div className={cn(
          "w-9 h-9 rounded-lg flex items-center justify-center shrink-0 [&_svg]:size-4",
          iconBg
        )}>
          {icon}
        </div>
      )}
      <div className="flex-1 min-w-0">
        <p className="text-body-medium text-foreground truncate">{title}</p>
        {subtitle && <p className="text-caption text-foreground-quaternary truncate mt-0.5">{subtitle}</p>}
      </div>
      {trailing && <div className="shrink-0">{trailing}</div>}
    </div>
  );
};

export default ListItem;
