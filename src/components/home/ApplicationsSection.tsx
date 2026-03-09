import React from "react";
import { Briefcase } from "lucide-react";
import MobileCard from "@/components/MobileCard";
import SectionHeader from "@/components/SectionHeader";
import StatusBadge from "@/components/StatusBadge";
import EmptyState from "@/components/EmptyState";
import type { AppStatus } from "@/components/StatusBadge";
import type { NavigateFunction } from "react-router-dom";

interface Application {
  id: string;
  company: string;
  role: string;
  status: string;
  date: string;
}

interface ApplicationsSectionProps {
  applications: Application[];
  navigate: NavigateFunction;
}

const ApplicationsSection: React.FC<ApplicationsSectionProps> = ({ applications, navigate }) => (
  <div className="px-5">
    <SectionHeader
      title="Recent Applications"
      action={{ label: "See all", onClick: () => navigate("/applications") }}
      className="mb-3"
    />

    {applications.length === 0 ? (
      <EmptyState
        icon={<Briefcase />}
        title="No applications yet"
        description="Start tracking your job applications to stay organized."
        action={
          <button onClick={() => navigate("/applications")} className="text-caption text-primary font-semibold press-scale">
            Add Application
          </button>
        }
      />
    ) : (
      <MobileCard padding="none" className="divide-y divide-border-subtle overflow-hidden">
        {applications.map((app) => (
          <button
            key={app.id}
            onClick={() => navigate(`/applications/${app.id}`)}
            className="flex items-center gap-3 w-full px-4 py-3 text-left press-scale"
          >
            <div className="w-9 h-9 rounded-lg bg-primary-light flex items-center justify-center shrink-0">
              <Briefcase className="h-4 w-4 text-primary" />
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-body-medium text-foreground truncate">{app.company}</p>
              <p className="text-caption text-foreground-tertiary truncate">{app.role}</p>
            </div>
            <div className="flex flex-col items-end gap-0.5 shrink-0">
              <StatusBadge status={app.status as AppStatus} />
              <span className="text-micro text-foreground-quaternary">{app.date}</span>
            </div>
          </button>
        ))}
      </MobileCard>
    )}
  </div>
);

export default ApplicationsSection;
