import React from "react";
import { Skeleton } from "@/components/ui/skeleton";
import { StatsSkeleton, ListSkeleton } from "@/components/LoadingSkeletons";

const HomeSkeleton: React.FC = () => (
  <div>
    {/* Hero skeleton */}
    <div className="rounded-b-3xl bg-muted px-5 pt-14 pb-6 space-y-2">
      <Skeleton className="h-4 w-24 rounded-md" />
      <Skeleton className="h-8 w-16 rounded-md" />
      <Skeleton className="h-4 w-56 rounded-md" />
    </div>

    <div className="px-5 mt-5">
      <StatsSkeleton />
    </div>

    {/* Quick actions skeleton */}
    <div className="px-5 mt-5 flex gap-2.5">
      {[1, 2, 3].map((i) => (
        <Skeleton key={i} className="h-10 w-36 rounded-xl shrink-0" />
      ))}
    </div>

    <div className="px-5 mt-6 space-y-2">
      <Skeleton className="h-5 w-32 rounded-md" />
      <ListSkeleton count={2} />
    </div>

    <div className="px-5 mt-6 space-y-2">
      <Skeleton className="h-5 w-40 rounded-md" />
      <ListSkeleton count={2} />
    </div>
  </div>
);

export default HomeSkeleton;
