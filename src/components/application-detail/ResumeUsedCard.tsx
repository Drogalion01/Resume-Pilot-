import { FileText, ExternalLink, Sparkles } from "lucide-react";
import MobileCard from "@/components/MobileCard";
import SectionHeader from "@/components/SectionHeader";
import ScoreRing from "@/components/ScoreRing";
import type { ResumeVersion } from "./types";

interface Props {
  resume: ResumeVersion | null;
  onViewResume: () => void;
}

const ResumeUsedCard = ({ resume, onViewResume }: Props) => (
  <div>
    <SectionHeader title="Resume Used" />
    {!resume ? (
      <MobileCard variant="elevated" className="mt-2.5">
        <div className="py-6 text-center">
          <div className="w-12 h-12 rounded-xl bg-surface-secondary flex items-center justify-center mx-auto mb-3">
            <FileText className="h-5 w-5 text-foreground-quaternary" />
          </div>
          <p className="text-body-medium text-foreground-tertiary">No resume linked</p>
          <p className="text-caption text-foreground-quaternary mt-1">Attach a resume to this application</p>
        </div>
      </MobileCard>
    ) : (
      <MobileCard variant="elevated" padding="none" className="mt-2.5 overflow-hidden">
        {/* Resume header with accent strip */}
        <div className="relative px-5 pt-5 pb-4">
          <div className="absolute inset-x-0 top-0 h-1 bg-gradient-to-r from-primary/40 via-primary to-primary/40" />
          <div className="flex items-center gap-4">
            <div className="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center shrink-0 shadow-[0_0_12px_hsl(var(--primary)/0.1)]">
              <FileText className="h-5 w-5 text-primary" />
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-body-medium text-foreground font-bold truncate">{resume.name}</p>
              <p className="text-micro text-foreground-quaternary mt-0.5">Updated {resume.updated_at}</p>
            </div>
          </div>
        </div>

        {/* Score rings */}
        <div className="flex items-center justify-center gap-10 px-5 py-4 bg-surface-secondary/50">
          <ScoreRing score={resume.ats_score} label="ATS Score" size={72} strokeWidth={5} />
          <ScoreRing score={resume.recruiter_score} label="Recruiter" size={72} strokeWidth={5} />
        </div>

        {/* CTA */}
        <button
          onClick={onViewResume}
          className="flex items-center justify-center gap-2 w-full py-3.5 border-t border-border-subtle text-caption text-primary font-semibold press-scale hover:bg-primary/[0.03] transition-colors"
        >
          View Resume Details <ExternalLink className="h-3.5 w-3.5" />
        </button>
      </MobileCard>
    )}
  </div>
);

export default ResumeUsedCard;
