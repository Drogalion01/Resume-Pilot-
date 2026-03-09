import React from "react";
import { cn } from "@/lib/utils";

interface EmptyStateProps {
  icon: React.ReactNode;
  title: string;
  description: string;
  action?: React.ReactNode;
  className?: string;
}

const EmptyState: React.FC<EmptyStateProps> = ({ icon, title, description, action, className }) => {
  return (
    <div className={cn("flex flex-col items-center text-center py-12 px-8", className)}>
      <div className="w-14 h-14 rounded-2xl bg-primary-light flex items-center justify-center mb-4 [&_svg]:size-6 text-primary">
        {icon}
      </div>
      <h3 className="text-title text-foreground mb-1.5">{title}</h3>
      <p className="text-caption text-foreground-tertiary max-w-[240px] leading-relaxed">{description}</p>
      {action && <div className="mt-4">{action}</div>}
    </div>
  );
};

export default EmptyState;
