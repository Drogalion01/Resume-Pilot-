import * as React from "react";
import { Slot } from "@radix-ui/react-slot";
import { cva, type VariantProps } from "class-variance-authority";

import { cn } from "@/lib/utils";

const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 whitespace-nowrap font-semibold ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-40 [&_svg]:pointer-events-none [&_svg]:shrink-0",
  {
    variants: {
      variant: {
        default:
          "bg-primary text-primary-foreground hover:bg-primary-hover active:scale-[0.97] shadow-sm",
        secondary:
          "bg-secondary text-secondary-foreground hover:bg-secondary/80 active:scale-[0.98]",
        outline:
          "border border-border bg-surface-primary text-foreground hover:bg-muted active:scale-[0.98]",
        ghost:
          "text-foreground hover:bg-muted active:scale-[0.98]",
        destructive:
          "bg-destructive text-destructive-foreground hover:bg-destructive/90 active:scale-[0.97]",
        "destructive-ghost":
          "text-destructive hover:bg-destructive-light active:scale-[0.98]",
        link:
          "text-primary underline-offset-4 hover:underline p-0 h-auto",
        premium:
          "bg-primary text-primary-foreground shadow-elevated hover:bg-primary-hover active:scale-[0.96] transition-all",
        soft:
          "bg-primary-light text-primary hover:bg-primary-muted active:scale-[0.98]",
      },
      size: {
        default: "h-12 px-5 text-[15px] rounded-xl [&_svg]:size-[18px]",
        sm: "h-9 px-3.5 text-[13px] rounded-lg [&_svg]:size-4",
        lg: "h-14 px-8 text-base rounded-xl [&_svg]:size-5",
        icon: "h-10 w-10 rounded-xl [&_svg]:size-5",
        "icon-sm": "h-8 w-8 rounded-lg [&_svg]:size-4",
        "icon-lg": "h-12 w-12 rounded-xl [&_svg]:size-5",
        full: "h-14 w-full px-8 text-base rounded-xl [&_svg]:size-5",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  },
);

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean;
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, ...props }, ref) => {
    const Comp = asChild ? Slot : "button";
    return <Comp className={cn(buttonVariants({ variant, size, className }))} ref={ref} {...props} />;
  },
);
Button.displayName = "Button";

export { Button, buttonVariants };
