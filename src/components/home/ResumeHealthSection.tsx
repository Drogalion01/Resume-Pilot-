import React from "react";
import { ChevronRight, FileText } from "lucide-react";
import MobileCard from "@/components/MobileCard";
import ScoreRing from "@/components/ScoreRing";
import SectionHeader from "@/components/SectionHeader";
import EmptyState from "@/components/EmptyState";
import type { NavigateFunction } from "react-router-dom";

interface Resume {
  id: string;
  name: string;
  atsScore: number;
  recruiterScore: number;
  updatedAt: string;
}

interface ResumeHealthSectionProps {
  resumes: Resume[];
  navigate: NavigateFunction;
}

const ResumeHealthSection: React.FC<ResumeHealthSectionProps> = ({ resumes, navigate }) => (
  <div className="px-5">
    <SectionHeader
      title="Resume Health"
      action={{ label: "All resumes", onClick: () => navigate("/resumes") }}
      className="mb-3"
    />

    {resumes.length === 0 ? (
      <EmptyState
        icon={<FileText />}
        title="No resumes yet"
        description="Upload your first resume to get an ATS and recruiter score."
        action={
          <button onClick={() => navigate("/upload")} className="text-caption text-primary font-semibold press-scale">
            Upload Resume
          </button>
        }
      />
    ) : (
      <div className="card-gap">
        {resumes.map((resume) => (
          <MobileCard key={resume.id} onClick={() => navigate(`/resumes/${resume.id}`)} className="flex items-center gap-3.5">
            <div className="flex gap-2">
              <ScoreRing score={resume.atsScore} label="ATS" size={48} strokeWidth={4} />
              <ScoreRing score={resume.recruiterScore} label="Recruiter" size={48} strokeWidth={4} />
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-body-medium text-foreground truncate">{resume.name}</p>
              <p className="text-caption text-foreground-quaternary mt-0.5">Updated {resume.updatedAt}</p>
            </div>
            <ChevronRight className="h-4 w-4 text-foreground-quaternary shrink-0" />
          </MobileCard>
        ))}
      </div>
    )}
  </div>
);

export default ResumeHealthSection;
