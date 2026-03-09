import React from "react";
import { cn } from "@/lib/utils";
import { Search, X } from "lucide-react";

interface SearchBarProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  className?: string;
}

const SearchBar: React.FC<SearchBarProps> = ({ value, onChange, placeholder = "Search...", className }) => {
  return (
    <div className={cn(
      "flex items-center gap-2.5 h-11 w-full rounded-xl bg-surface-secondary px-3.5 transition-all border border-transparent",
      "focus-within:bg-surface-primary focus-within:ring-2 focus-within:ring-primary/20 focus-within:border-primary/30 focus-within:shadow-sm",
      className
    )}>
      <Search className="h-[18px] w-[18px] text-foreground-tertiary/70 shrink-0" />
      <input
        type="text"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder={placeholder}
        className="flex-1 bg-transparent outline-none text-[15px] text-foreground placeholder:text-foreground-tertiary min-w-0"
      />
      {value && (
        <button
          onClick={() => onChange("")}
          className="p-0.5 rounded-full hover:bg-muted transition-colors"
        >
          <X className="h-3.5 w-3.5 text-foreground-tertiary" />
        </button>
      )}
    </div>
  );
};

export default SearchBar;
