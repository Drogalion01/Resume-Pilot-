import * as React from "react";

import { cn } from "@/lib/utils";

export interface InputProps extends React.ComponentProps<"input"> {
  leftIcon?: React.ReactNode;
  rightIcon?: React.ReactNode;
}

const Input = React.forwardRef<HTMLInputElement, InputProps>(
  ({ className, type, leftIcon, rightIcon, ...props }, ref) => {
    if (leftIcon || rightIcon) {
      return (
        <div className={cn(
          "flex items-center gap-2.5 h-[52px] w-full rounded-xl border border-border bg-surface-primary px-4 text-[15px] text-foreground transition-all",
          "focus-within:ring-2 focus-within:ring-primary/25 focus-within:border-primary/60 focus-within:shadow-[0_0_0_3px_hsl(var(--primary)/0.08)]",
          "has-[:disabled]:opacity-40 has-[:disabled]:cursor-not-allowed",
          className
        )}>
          {leftIcon && <span className="text-foreground-tertiary/70 shrink-0 [&_svg]:size-[18px]">{leftIcon}</span>}
          <input
            type={type}
            className="flex-1 bg-transparent outline-none placeholder:text-foreground-tertiary min-w-0 text-[15px]"
            ref={ref}
            {...props}
          />
          {rightIcon && <span className="text-foreground-tertiary/70 shrink-0 [&_svg]:size-[18px]">{rightIcon}</span>}
        </div>
      );
    }

    return (
      <input
        type={type}
        className={cn(
          "flex h-[52px] w-full rounded-xl border border-border bg-surface-primary px-4 text-[15px] text-foreground transition-all",
          "placeholder:text-foreground-tertiary",
          "focus:outline-none focus:ring-2 focus:ring-primary/25 focus:border-primary/60 focus:shadow-[0_0_0_3px_hsl(var(--primary)/0.08)]",
          "disabled:cursor-not-allowed disabled:opacity-40",
          className,
        )}
        ref={ref}
        {...props}
      />
    );
  },
);
Input.displayName = "Input";

export { Input };
