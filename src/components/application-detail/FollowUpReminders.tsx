import { Bell, Calendar } from "lucide-react";
import MobileCard from "@/components/MobileCard";
import SectionHeader from "@/components/SectionHeader";
import EmptyState from "@/components/EmptyState";
import { Switch } from "@/components/ui/switch";
import { cn } from "@/lib/utils";
import type { Reminder } from "./types";

interface Props {
  reminders: Reminder[];
  onAddReminder: () => void;
}

const FollowUpReminders = ({ reminders, onAddReminder }: Props) => (
  <div>
    <SectionHeader title="Reminders" action={{ label: "+ Add", onClick: onAddReminder }} />
    {reminders.length === 0 ? (
      <MobileCard variant="elevated" className="mt-2.5">
        <EmptyState
          icon={<Bell />}
          title="No reminders"
          description="Set follow-up reminders to stay on track"
          className="py-6"
        />
      </MobileCard>
    ) : (
      <MobileCard variant="elevated" padding="spacious" className="mt-2.5">
        <div className="space-y-0 divide-y divide-border-subtle">
          {reminders.map((reminder) => (
            <div key={reminder.id} className="flex items-center gap-3.5 py-3.5 first:pt-0 last:pb-0">
              <div className={cn(
                "w-9 h-9 rounded-lg flex items-center justify-center shrink-0",
                reminder.is_enabled ? "bg-primary/10" : "bg-surface-secondary"
              )}>
                <Bell className={cn(
                  "h-4 w-4",
                  reminder.is_enabled ? "text-primary" : "text-foreground-quaternary"
                )} />
              </div>
              <div className="flex-1 min-w-0">
                <p className={cn(
                  "text-body-medium font-medium truncate",
                  reminder.is_enabled ? "text-foreground" : "text-foreground-tertiary"
                )}>{reminder.title}</p>
                <div className="flex items-center gap-1.5 mt-1">
                  <Calendar className="h-3 w-3 text-foreground-quaternary" />
                  <span className="text-micro text-foreground-quaternary">{reminder.scheduled_for}</span>
                </div>
              </div>
              <Switch checked={reminder.is_enabled} className="shrink-0" />
            </div>
          ))}
        </div>
      </MobileCard>
    )}
  </div>
);

export default FollowUpReminders;
