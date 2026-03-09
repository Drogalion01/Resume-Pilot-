import React from "react";
import { FileText, Briefcase, Calendar } from "lucide-react";
import MobileCard from "@/components/MobileCard";
import type { NavigateFunction } from "react-router-dom";

interface QuickStatsProps {
  stats: { resumes: number; applications: number; interviews: number };
  navigate: NavigateFunction;
}

const items = [
  { key: "resumes", label: "Resumes", icon: FileText, tintBg: "bg-primary-light", iconClass: "text-primary", path: "/resumes" },
  { key: "applications", label: "Applications", icon: Briefcase, tintBg: "bg-status-applied-bg", iconClass: "text-status-applied", path: "/applications" },
  { key: "interviews", label: "Interviews", icon: Calendar, tintBg: "bg-status-hr-bg", iconClass: "text-status-hr", path: "/applications" },
] as const;

const QuickStats: React.FC<QuickStatsProps> = ({ stats, navigate }) => {
  const values = { resumes: stats.resumes, applications: stats.applications, interviews: stats.interviews };

  return (
    <div className="px-5">
      <div className="grid grid-cols-3 gap-3">
        {items.map((item) => (
          <MobileCard
            key={item.key}
            variant="default"
            padding="compact"
            onClick={() => navigate(item.path)}
            className="flex flex-col items-center py-3 gap-1.5"
          >
            <div className={`w-8 h-8 rounded-lg ${item.tintBg} flex items-center justify-center`}>
              <item.icon className={`h-3.5 w-3.5 ${item.iconClass}`} />
            </div>
            <span className="text-headline text-foreground">{values[item.key]}</span>
            <span className="text-micro text-foreground-quaternary">{item.label}</span>
          </MobileCard>
        ))}
      </div>
    </div>
  );
};

export default QuickStats;
