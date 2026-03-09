import React from "react";
import { Video, Phone, MapPin, Clock, Calendar } from "lucide-react";
import MobileCard from "@/components/MobileCard";
import SectionHeader from "@/components/SectionHeader";
import EmptyState from "@/components/EmptyState";
import { Badge } from "@/components/ui/badge";
import type { NavigateFunction } from "react-router-dom";

interface Interview {
  id: string;
  company: string;
  round: string;
  date: string;
  time: string;
  type: "video" | "phone" | "onsite";
}

interface InterviewsSectionProps {
  interviews: Interview[];
  navigate: NavigateFunction;
}

const typeConfig = {
  video: { icon: Video, label: "Video" },
  phone: { icon: Phone, label: "Phone" },
  onsite: { icon: MapPin, label: "Onsite" },
} as const;

const InterviewsSection: React.FC<InterviewsSectionProps> = ({ interviews, navigate }) => (
  <div className="px-5">
    <SectionHeader
      title="Upcoming Interviews"
      action={{ label: "See all", onClick: () => navigate("/applications") }}
      className="mb-3"
    />

    {interviews.length === 0 ? (
      <EmptyState
        icon={<Calendar />}
        title="No upcoming interviews"
        description="When you schedule interviews, they'll show up here."
      />
    ) : (
      <div className="space-y-2.5">
        {interviews.map((interview) => {
          const config = typeConfig[interview.type];
          const TypeIcon = config.icon;
          return (
            <MobileCard key={interview.id} onClick={() => navigate(`/applications/${interview.id}`)} className="flex items-center gap-3.5">
              <div className="w-10 h-10 rounded-xl bg-primary-light flex items-center justify-center shrink-0">
                <TypeIcon className="h-[18px] w-[18px] text-primary" />
              </div>
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2">
                  <p className="text-body-medium text-foreground truncate">{interview.company}</p>
                  <Badge variant="technical" size="sm">{config.label}</Badge>
                </div>
                <p className="text-caption text-foreground-tertiary mt-0.5">{interview.round}</p>
              </div>
              <div className="flex flex-col items-end shrink-0">
                <span className="text-caption text-foreground font-semibold">{interview.date}</span>
                <div className="flex items-center gap-1 mt-0.5">
                  <Clock className="h-3 w-3 text-foreground-quaternary" />
                  <span className="text-micro text-foreground-tertiary">{interview.time}</span>
                </div>
              </div>
            </MobileCard>
          );
        })}
      </div>
    )}
  </div>
);

export default InterviewsSection;
