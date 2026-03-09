import { Phone, Video, MapPin, CheckCircle, Clock, RefreshCw, ChevronRight } from "lucide-react";
import MobileCard from "@/components/MobileCard";
import SectionHeader from "@/components/SectionHeader";
import EmptyState from "@/components/EmptyState";
import { cn } from "@/lib/utils";
import type { Interview } from "./types";

const typeIcons: Record<string, React.ElementType> = { phone: Phone, video: Video, onsite: MapPin };
const typeLabels: Record<string, string> = { phone: "Phone", video: "Video", onsite: "Onsite" };
const statusConfig: Record<string, { label: string; icon: React.ElementType; bg: string; text: string }> = {
  completed: { label: "Done", icon: CheckCircle, bg: "bg-score-good/10", text: "text-score-good" },
  scheduled: { label: "Upcoming", icon: Clock, bg: "bg-primary/10", text: "text-primary" },
  rescheduled: { label: "Moved", icon: RefreshCw, bg: "bg-score-average/10", text: "text-score-average" },
};

interface Props {
  interviews: Interview[];
  onAddInterview: () => void;
}

const InterviewStages = ({ interviews, onAddInterview }: Props) => (
  <div>
    <SectionHeader title="Interviews" action={{ label: "+ Add", onClick: onAddInterview }} />
    {interviews.length === 0 ? (
      <MobileCard variant="elevated" className="mt-2.5">
        <EmptyState
          icon={<Video />}
          title="No interviews yet"
          description="Schedule your first interview round"
          className="py-6"
        />
      </MobileCard>
    ) : (
      <div className="mt-2.5 space-y-2.5">
        {interviews.map((interview, i) => {
          const TypeIcon = typeIcons[interview.interview_type] || Video;
          const statusInfo = statusConfig[interview.status];
          const StatusIcon = statusInfo.icon;
          const isUpcoming = interview.status === "scheduled";
          return (
            <MobileCard
              key={interview.id}
              variant="elevated"
              padding="spacious"
              className={cn(
                "active:scale-[0.98] transition-all cursor-pointer",
                isUpcoming && "ring-1 ring-primary/15"
              )}
            >
              {/* Round number + status badge row */}
              <div className="flex items-center justify-between mb-3">
                <div className="flex items-center gap-2">
                  <span className="text-micro text-foreground-quaternary font-semibold uppercase tracking-wider">
                    Round {i + 1}
                  </span>
                  <span className="w-1 h-1 rounded-full bg-border-subtle" />
                  <span className="text-micro text-foreground-quaternary">{typeLabels[interview.interview_type]}</span>
                </div>
                <div className={cn("flex items-center gap-1 px-2 py-0.5 rounded-full text-micro font-semibold", statusInfo.bg, statusInfo.text)}>
                  <StatusIcon className="h-3 w-3" />
                  {statusInfo.label}
                </div>
              </div>

              {/* Main content */}
              <div className="flex items-center gap-3.5">
                <div className={cn(
                  "w-11 h-11 rounded-xl flex items-center justify-center shrink-0",
                  isUpcoming ? "bg-primary/10" : "bg-surface-secondary"
                )}>
                  <TypeIcon className={cn(
                    "h-5 w-5",
                    isUpcoming ? "text-primary" : "text-foreground-tertiary"
                  )} />
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-body-medium text-foreground font-semibold truncate">{interview.round_name}</p>
                  <div className="flex items-center gap-2 mt-1">
                    <span className="text-caption text-foreground-tertiary">{interview.date}</span>
                    <span className="w-1 h-1 rounded-full bg-border-subtle" />
                    <span className="text-caption text-foreground-tertiary">{interview.time}</span>
                    {interview.interviewer_name && (
                      <>
                        <span className="w-1 h-1 rounded-full bg-border-subtle" />
                        <span className="text-caption text-foreground-tertiary truncate">{interview.interviewer_name}</span>
                      </>
                    )}
                  </div>
                </div>
                <ChevronRight className="h-4 w-4 text-foreground-quaternary shrink-0" />
              </div>
            </MobileCard>
          );
        })}
      </div>
    )}
  </div>
);

export default InterviewStages;
