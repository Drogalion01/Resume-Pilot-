import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";

const badgeVariants = cva(
  "inline-flex items-center font-semibold transition-colors",
  {
    variants: {
      variant: {
        default: "bg-primary-light text-primary",
        secondary: "bg-secondary text-secondary-foreground",
        destructive: "bg-destructive-light text-destructive",
        outline: "border border-border text-foreground-secondary",
        success: "bg-score-excellent-bg text-score-excellent",
        warning: "bg-score-average-bg text-score-average",
        error: "bg-score-poor-bg text-score-poor",
        // Status variants
        applied: "bg-status-applied-bg text-status-applied",
        interview: "bg-status-interview-bg text-status-interview",
        offer: "bg-status-offer-bg text-status-offer",
        rejected: "bg-status-rejected-bg text-status-rejected",
        saved: "bg-status-saved-bg text-status-saved",
        assessment: "bg-status-assessment-bg text-status-assessment",
        hr: "bg-status-hr-bg text-status-hr",
        technical: "bg-status-technical-bg text-status-technical",
        final: "bg-status-final-bg text-status-final",
      },
      size: {
        default: "h-6 px-2.5 text-[11px] rounded-md",
        sm: "h-5 px-2 text-[10px] rounded-sm",
        lg: "h-8 px-3.5 text-xs rounded-full",
        pill: "h-6 px-3 text-[11px] rounded-full",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "pill",
    },
  },
);

export interface BadgeProps extends React.HTMLAttributes<HTMLSpanElement>, VariantProps<typeof badgeVariants> {}

function Badge({ className, variant, size, ...props }: BadgeProps) {
  return <span className={cn(badgeVariants({ variant, size }), className)} {...props} />;
}

export { Badge, badgeVariants };
