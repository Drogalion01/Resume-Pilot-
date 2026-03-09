import { Pencil, Video, Bell, Archive, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";

interface Props {
  onEdit: () => void;
  onAddInterview: () => void;
  onAddReminder: () => void;
  onArchive: () => void;
  onDelete: () => void;
}

const PrimaryActions = ({ onEdit, onAddInterview, onAddReminder, onArchive, onDelete }: Props) => (
  <div className="space-y-3">
    <div className="grid grid-cols-3 gap-2.5">
      {[
        { icon: Pencil, label: "Edit", onClick: onEdit },
        { icon: Video, label: "Interview", onClick: onAddInterview },
        { icon: Bell, label: "Reminder", onClick: onAddReminder },
      ].map(({ icon: Icon, label, onClick }) => (
        <button
          key={label}
          onClick={onClick}
          className="flex flex-col items-center gap-2 py-3.5 rounded-xl bg-card shadow-card dark:border dark:border-border-subtle active:scale-[0.97] transition-all"
        >
          <div className="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center">
            <Icon className="h-[18px] w-[18px] text-primary" />
          </div>
          <span className="text-caption text-foreground-secondary font-semibold">{label}</span>
        </button>
      ))}
    </div>
    <div className="flex items-center gap-3 pt-2">
      <button
        onClick={onArchive}
        className="flex-1 flex items-center justify-center gap-2 h-10 rounded-xl text-caption text-foreground-tertiary font-semibold hover:text-foreground transition-colors active:scale-[0.98]"
      >
        <Archive className="h-3.5 w-3.5" /> Archive
      </button>
      <div className="w-px h-5 bg-border-subtle" />
      <button
        onClick={onDelete}
        className="flex-1 flex items-center justify-center gap-2 h-10 rounded-xl text-caption text-destructive font-semibold hover:text-destructive/80 transition-colors active:scale-[0.98]"
      >
        <Trash2 className="h-3.5 w-3.5" /> Delete
      </button>
    </div>
  </div>
);

export default PrimaryActions;
