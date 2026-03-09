import { Skeleton } from "@/components/ui/skeleton";

const DetailSkeleton = () => (
  <div className="px-5 space-y-5 mt-4">
    {/* Hero */}
    <div className="bg-card rounded-xl p-5 shadow-card space-y-3">
      <div className="flex items-center gap-3.5">
        <Skeleton className="w-12 h-12 rounded-xl" />
        <div className="flex-1 space-y-2">
          <Skeleton className="h-5 w-2/3 rounded-md" />
          <Skeleton className="h-4 w-1/2 rounded-md" />
          <Skeleton className="h-5 w-20 rounded-full" />
        </div>
      </div>
    </div>
    {/* Summary */}
    <div className="bg-card rounded-xl p-5 shadow-card space-y-3">
      {[1, 2, 3, 4].map(i => (
        <div key={i} className="flex items-center gap-3">
          <Skeleton className="w-8 h-8 rounded-lg" />
          <div className="flex-1 space-y-1.5">
            <Skeleton className="h-3 w-16 rounded-md" />
            <Skeleton className="h-4 w-32 rounded-md" />
          </div>
        </div>
      ))}
    </div>
    {/* Timeline */}
    <div className="space-y-2">
      <Skeleton className="h-5 w-20 rounded-md" />
      <div className="bg-card rounded-xl p-5 shadow-card space-y-4">
        {[1, 2, 3].map(i => (
          <div key={i} className="flex gap-3">
            <Skeleton className="w-8 h-8 rounded-full shrink-0" />
            <div className="flex-1 space-y-1.5">
              <Skeleton className="h-4 w-3/4 rounded-md" />
              <Skeleton className="h-3 w-1/2 rounded-md" />
            </div>
          </div>
        ))}
      </div>
    </div>
  </div>
);

export default DetailSkeleton;
