import { useState } from "react";
import { motion } from "framer-motion";
import { FileText, Copy, Pencil, Download, Share2, Briefcase, Building2, Calendar, Clock, ChevronDown, ChevronUp, Sparkles, ChevronRight } from "lucide-react";
import ScreenHeader from "@/components/ScreenHeader";
import MobileCard from "@/components/MobileCard";
import ScoreRing from "@/components/ScoreRing";
import SectionHeader from "@/components/SectionHeader";
import BottomNav from "@/components/BottomNav";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";

const versionData = {
  name: "Software Engineer v2",
  company: "Google",
  role: "Software Engineer",
  ats: 78,
  recruiter: 85,
  tag: "tailored",
  createdAt: "Feb 28, 2026",
  updatedAt: "Mar 5, 2026",
  fileType: "PDF",
  wordCount: 487,
  pages: 1,
  feedback: "Strong technical focus with good keyword alignment. Consider adding more quantified impact metrics and leadership examples to push recruiter score above 90.",
  sections: [
    { title: "Summary", content: "Results-driven software engineer with 4+ years of experience building scalable web applications. Proficient in React, TypeScript, Node.js, and cloud infrastructure. Passionate about clean architecture and developer experience." },
    { title: "Experience", content: "Senior Frontend Engineer — Acme Corp (2023–Present)\n• Led migration of legacy jQuery codebase to React, reducing load times by 40%\n• Designed component library adopted by 3 product teams\n• Mentored 2 junior engineers through structured code review process\n\nSoftware Engineer — BuildCo (2021–2023)\n• Built real-time collaboration features using WebSockets\n• Reduced API response times by 35% through query optimization\n• Shipped 12 features across 4 product releases" },
    { title: "Skills", content: "React, TypeScript, Node.js, Python, PostgreSQL, AWS, Docker, CI/CD, GraphQL, REST APIs, System Design, Agile" },
    { title: "Education", content: "B.S. Computer Science — University of Washington, 2021" },
  ],
};

const stagger = (i: number) => ({ initial: { opacity: 0, y: 8 }, animate: { opacity: 1, y: 0 }, transition: { delay: i * 0.06 } });

const ResumeVersionDetail = () => {
  const navigate = useNavigate();
  const [expandedSection, setExpandedSection] = useState<string | null>("Summary");
  const avg = Math.round((versionData.ats + versionData.recruiter) / 2);
  const label = avg >= 80 ? "Strong" : avg >= 65 ? "Competitive" : "Needs Work";
  const labelColor = avg >= 80 ? "text-score-excellent" : avg >= 65 ? "text-score-good" : "text-score-average";

  return (
    <div className="min-h-screen bg-background pb-24">
      <ScreenHeader title={versionData.name} showBack rightAction={
        <Button variant="ghost" size="icon-sm" onClick={() => {}}>
          <Share2 className="h-4 w-4" />
        </Button>
      } />

      {/* Score Hero */}
      <motion.div {...stagger(0)} className="px-5 mt-2">
        <MobileCard variant="elevated" padding="spacious" className="flex items-center gap-5">
          <ScoreRing score={versionData.ats} label="ATS" size={72} strokeWidth={5} />
          <ScoreRing score={versionData.recruiter} label="Recruiter" size={72} strokeWidth={5} />
          <div className="flex-1 min-w-0">
            <p className={`text-title font-bold ${labelColor}`}>{label}</p>
            <p className="text-caption text-foreground-tertiary mt-0.5">Avg score {avg}/100</p>
            <Button variant="soft" size="sm" className="mt-2.5 h-8 text-[12px]" onClick={() => navigate("/analysis")}>
              <Sparkles className="h-3.5 w-3.5 mr-1" /> Full Analysis
            </Button>
          </div>
        </MobileCard>
      </motion.div>

      {/* Metadata — vertical list instead of grid */}
      <motion.div {...stagger(1)} className="px-5 mt-3">
        <MobileCard variant="sunken" padding="none" className="divide-y divide-border-subtle">
          {[
            { icon: Briefcase, label: "Role", value: versionData.role },
            { icon: Building2, label: "Company", value: versionData.company },
            { icon: Calendar, label: "Updated", value: versionData.updatedAt },
          ].map((m) => (
            <div key={m.label} className="flex items-center gap-3 px-4 py-3">
              <m.icon className="h-4 w-4 text-foreground-quaternary shrink-0" />
              <span className="text-caption text-foreground-tertiary flex-1">{m.label}</span>
              <span className="text-caption text-foreground font-medium">{m.value}</span>
            </div>
          ))}
          <div className="flex items-center gap-2 px-4 py-3">
            <FileText className="h-4 w-4 text-foreground-quaternary shrink-0" />
            <span className="text-caption text-foreground-tertiary flex-1">Format</span>
            <div className="flex items-center gap-1.5">
              <Badge variant={versionData.tag === "tailored" ? "default" : "secondary"} size="sm">{versionData.tag === "tailored" ? "Tailored" : "General"}</Badge>
              <Badge variant="secondary" size="sm">{versionData.fileType}</Badge>
              <Badge variant="secondary" size="sm">{versionData.pages}pg · {versionData.wordCount}w</Badge>
            </div>
          </div>
        </MobileCard>
      </motion.div>

      {/* AI Feedback */}
      <motion.div {...stagger(2)} className="px-5 mt-5">
        <SectionHeader title="AI Feedback" />
        <MobileCard variant="sunken" padding="compact" className="mt-2">
          <p className="text-caption text-foreground-secondary leading-relaxed">{versionData.feedback}</p>
        </MobileCard>
      </motion.div>

      {/* Resume Preview */}
      <motion.div {...stagger(3)} className="px-5 mt-5">
        <SectionHeader title="Resume Preview" />
        <div className="mt-2 space-y-2">
          {versionData.sections.map((sec) => {
            const isOpen = expandedSection === sec.title;
            return (
              <MobileCard key={sec.title} padding="none" variant="outlined">
                <button
                  onClick={() => setExpandedSection(isOpen ? null : sec.title)}
                  className="flex items-center justify-between w-full px-4 py-3 text-left"
                >
                  <span className="text-body-medium text-foreground">{sec.title}</span>
                  {isOpen ? (
                    <ChevronUp className="h-4 w-4 text-foreground-quaternary" />
                  ) : (
                    <ChevronDown className="h-4 w-4 text-foreground-quaternary" />
                  )}
                </button>
                {isOpen && (
                  <motion.div
                    initial={{ opacity: 0, height: 0 }}
                    animate={{ opacity: 1, height: "auto" }}
                    className="px-4 pb-3 border-t border-border-subtle"
                  >
                    <p className="text-caption text-foreground-secondary leading-relaxed whitespace-pre-line pt-3">
                      {sec.content}
                    </p>
                  </motion.div>
                )}
              </MobileCard>
            );
          })}
        </div>
      </motion.div>

      {/* Actions — vertical list items */}
      <motion.div {...stagger(4)} className="px-5 mt-5">
        <SectionHeader title="Actions" />
        <MobileCard padding="none" className="mt-2 divide-y divide-border-subtle overflow-hidden">
          {[
            { icon: Pencil, label: "Edit Details", onClick: () => {} },
            { icon: Copy, label: "Duplicate Resume", onClick: () => {} },
            { icon: Download, label: "Download", onClick: () => {} },
            { icon: FileText, label: "Re-analyze", onClick: () => navigate("/upload") },
          ].map((action) => (
            <button
              key={action.label}
              onClick={action.onClick}
              className="flex items-center gap-3 w-full px-4 py-3.5 text-left press-scale"
            >
              <div className="w-9 h-9 rounded-lg bg-muted flex items-center justify-center shrink-0">
                <action.icon className="h-4 w-4 text-foreground-tertiary" />
              </div>
              <span className="text-body-medium text-foreground flex-1">{action.label}</span>
              <ChevronRight className="h-4 w-4 text-foreground-quaternary" />
            </button>
          ))}
        </MobileCard>
      </motion.div>

      <BottomNav />
    </div>
  );
};

export default ResumeVersionDetail;