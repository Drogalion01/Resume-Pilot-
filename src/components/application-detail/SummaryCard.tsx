import { Building2, MapPin, User, Link2, Calendar } from "lucide-react";
import MobileCard from "@/components/MobileCard";
import type { ApplicationData } from "./types";

interface Props {
  app: ApplicationData;
}

const InfoRow = ({ icon: Icon, label, value }: { icon: React.ElementType; label: string; value: string }) => (
  <div className="flex items-center gap-3 py-2">
    <div className="w-8 h-8 rounded-lg bg-surface-secondary flex items-center justify-center shrink-0">
      <Icon className="h-3.5 w-3.5 text-foreground-tertiary/70" />
    </div>
    <div className="flex-1 min-w-0">
      <p className="text-micro text-foreground-quaternary uppercase tracking-wider">{label}</p>
      <p className="text-caption text-foreground font-medium truncate mt-0.5">{value}</p>
    </div>
  </div>
);

const SummaryCard = ({ app }: Props) => {
  const rows = [
    { icon: Calendar, label: "Applied", value: app.applied_date },
    app.source ? { icon: Link2, label: "Source", value: app.source } : null,
    app.location ? { icon: MapPin, label: "Location", value: app.location } : null,
    app.recruiter_name ? { icon: User, label: "Recruiter", value: app.recruiter_name } : null,
  ].filter(Boolean) as { icon: React.ElementType; label: string; value: string }[];

  return (
    <MobileCard variant="elevated" padding="spacious">
      <div className="divide-y divide-border-subtle">
        {rows.map((row) => (
          <InfoRow key={row.label} {...row} />
        ))}
      </div>
    </MobileCard>
  );
};

export default SummaryCard;
