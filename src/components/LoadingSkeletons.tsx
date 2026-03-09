import React from "react";
import { Skeleton } from "@/components/ui/skeleton";
import { cn } from "@/lib/utils";

interface CardSkeletonProps {
  lines?: number;
  showAvatar?: boolean;
  className?: string;
}

export const CardSkeleton: React.FC<CardSkeletonProps> = ({ lines = 2, showAvatar = true, className }) => (
  <div className={cn("bg-card rounded-xl p-4 shadow-card space-y-3", className)}>
    <div className="flex items-center gap-3">
      {showAvatar && <Skeleton className="w-10 h-10 rounded-xl shrink-0" />}
      <div className="flex-1 space-y-2">
        <Skeleton className="h-4 w-3/4 rounded-md" />
        {lines > 1 && <Skeleton className="h-3 w-1/2 rounded-md" />}
      </div>
    </div>
    {lines > 2 && (
      <div className="flex items-center gap-3 pt-1">
        <Skeleton className="w-12 h-12 rounded-full" />
        <Skeleton className="w-12 h-12 rounded-full" />
        <div className="flex-1 space-y-2">
          <Skeleton className="h-3 w-2/3 rounded-md" />
          <Skeleton className="h-3 w-1/3 rounded-md" />
        </div>
      </div>
    )}
  </div>
);

export const ListSkeleton: React.FC<{ count?: number; className?: string }> = ({ count = 3, className }) => (
  <div className={cn("space-y-2.5", className)}>
    {Array.from({ length: count }).map((_, i) => (
      <CardSkeleton key={i} lines={2} />
    ))}
  </div>
);

export const StatsSkeleton: React.FC = () => (
  <div className="grid grid-cols-3 gap-2.5">
    {[1, 2, 3].map((i) => (
      <div key={i} className="bg-card rounded-xl p-3 shadow-card flex flex-col items-center gap-2">
        <Skeleton className="w-8 h-8 rounded-lg" />
        <Skeleton className="h-5 w-8 rounded-md" />
        <Skeleton className="h-3 w-14 rounded-md" />
      </div>
    ))}
  </div>
);

export const ScoreSkeleton: React.FC = () => (
  <div className="bg-card rounded-xl p-5 shadow-elevated space-y-4">
    <div className="flex items-center justify-between">
      <div className="space-y-2">
        <Skeleton className="h-6 w-24 rounded-lg" />
        <Skeleton className="h-3 w-40 rounded-md" />
      </div>
      <Skeleton className="h-10 w-16 rounded-md" />
    </div>
    <div className="flex items-center justify-center gap-8 py-2">
      <Skeleton className="w-24 h-24 rounded-full" />
      <Skeleton className="w-24 h-24 rounded-full" />
    </div>
  </div>
);
