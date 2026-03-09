import { StickyNote, Pencil } from "lucide-react";
import MobileCard from "@/components/MobileCard";
import SectionHeader from "@/components/SectionHeader";
import type { ApplicationNotes } from "./types";

interface Props {
  notes: ApplicationNotes | null;
  onEdit: () => void;
}

const NotesSection = ({ notes, onEdit }: Props) => (
  <div>
    <SectionHeader title="Notes" action={{ label: "Edit", onClick: onEdit }} />
    <MobileCard variant="elevated" padding="spacious" className="mt-2.5">
      {!notes || !notes.text ? (
        <div className="py-4 text-center">
          <div className="w-10 h-10 rounded-xl bg-surface-secondary flex items-center justify-center mx-auto mb-2.5">
            <StickyNote className="h-4 w-4 text-foreground-quaternary" />
          </div>
          <p className="text-caption text-foreground-tertiary">No notes yet</p>
          <p className="text-micro text-foreground-quaternary mt-1">Add recruiter or follow-up notes here</p>
        </div>
      ) : (
        <div>
          <p className="text-caption text-foreground-secondary leading-relaxed whitespace-pre-line">{notes.text}</p>
          <p className="text-micro text-foreground-quaternary mt-3">Last updated {notes.updated_at}</p>
        </div>
      )}
    </MobileCard>
  </div>
);

export default NotesSection;
