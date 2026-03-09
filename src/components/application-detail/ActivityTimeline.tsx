import { FileText, Phone, Video, Bell, Plus, CheckCircle, Circle } from "lucide-react";
import MobileCard from "@/components/MobileCard";
import SectionHeader from "@/components/SectionHeader";
import { cn } from "@/lib/utils";
import type { TimelineEvent } from "./types";

const iconMap: Record<string, React.ElementType> = {
  created: Plus,
  resume: FileText,
  hr: Phone,
  interview: Video,
  reminder: Bell,
};

interface Props {
  events: TimelineEvent[];
}

const ActivityTimeline = ({ events }: Props) => (
  <div>
    <SectionHeader title="Activity" />
    <MobileCard variant="elevated" padding="spacious" className="mt-2.5">
      <div>
        {events.map((event, i) => {
          const isLast = i === events.length - 1;
          const isFirst = i === 0;
          const Icon = iconMap[event.type] || CheckCircle;
          return (
            <div key={event.id} className="flex gap-3.5">
              {/* Track column */}
              <div className="flex flex-col items-center w-8">
                <div className={cn(
                  "w-8 h-8 rounded-full flex items-center justify-center shrink-0 ring-2 ring-background",
                  isFirst ? "bg-primary text-primary-foreground" : "bg-primary/10"
                )}>
                  <Icon className={cn("h-3.5 w-3.5", isFirst ? "text-primary-foreground" : "text-primary")} />
                </div>
                {!isLast && (
                  <div className="w-px flex-1 min-h-[20px] bg-gradient-to-b from-primary/20 to-border-subtle" />
                )}
              </div>
              {/* Content column */}
              <div className={cn("pt-1 min-w-0", isLast ? "pb-0" : "pb-5")}>
                <p className={cn(
                  "text-body-medium font-semibold",
                  isFirst ? "text-foreground" : "text-foreground-secondary"
                )}>{event.title}</p>
                <div className="flex items-center gap-1.5 mt-1">
                  <span className="text-micro text-foreground-quaternary">{event.timestamp}</span>
                  <span className="w-0.5 h-0.5 rounded-full bg-foreground-quaternary" />
                  <span className="text-micro text-foreground-quaternary truncate">{event.metadata}</span>
                </div>
              </div>
            </div>
          );
        })}
      </div>
    </MobileCard>
  </div>
);

export default ActivityTimeline;
