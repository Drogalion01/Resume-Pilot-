import React from "react";
import { cn } from "@/lib/utils";
import { Plus } from "lucide-react";

interface FABProps {
  onClick?: () => void;
  icon?: React.ReactNode;
  label?: string;
  className?: string;
}

const FAB: React.FC<FABProps> = ({ onClick, icon, label, className }) => {
  const isExtended = !!label;

  return (
    <div className="fixed bottom-24 left-1/2 -translate-x-1/2 w-full max-w-[430px] z-40 pointer-events-none">
      <button
        onClick={onClick}
        className={cn("absolute bottom-0 right-5 flex items-center justify-center text-primary-foreground shadow-fab active:scale-[0.94] transition-all pointer-events-auto bg-primary",

        isExtended ?
        "gap-2 px-6 h-14 rounded-2xl font-semibold text-[15px]" :
        "h-14 w-14 rounded-2xl",
        className
        )}>
        
        {icon || <Plus className="h-5 w-5" strokeWidth={2.5} />}
        {label}
      </button>
    </div>);

};

export default FAB;