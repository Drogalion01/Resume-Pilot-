import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import {
  AlertTriangle, Save, TrendingUp, Search, Lightbulb, Shield, Eye,
  Sparkles, Copy, RotateCcw, ChevronDown, ChevronRight, Target,
  CheckCircle2, ArrowRight, Zap
} from "lucide-react";
import ScreenHeader from "@/components/ScreenHeader";
import ScoreRing from "@/components/ScoreRing";
import MobileCard from "@/components/MobileCard";
import SectionHeader from "@/components/SectionHeader";
import BottomNav from "@/components/BottomNav";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { cn } from "@/lib/utils";
import { useSimulatedLoad } from "@/hooks/use-simulated-load";
import { ScoreSkeleton, ListSkeleton } from "@/components/LoadingSkeletons";
import { Skeleton } from "@/components/ui/skeleton";
import { useToast } from "@/hooks/use-toast";

const fadeUp = (i: number) => ({
  initial: { opacity: 0, y: 12 },
  animate: { opacity: 1, y: 0 },
  transition: { delay: 0.1 + i * 0.06, duration: 0.4, ease: [0.25, 0.1, 0.25, 1] as const },
});

// ─── Score helper ───
const getOverallLabel = (avg: number) => {
  if (avg >= 85) return { label: "Strong", variant: "success" as const, desc: "Highly competitive — ready to submit" };
  if (avg >= 70) return { label: "Competitive", variant: "default" as const, desc: "Good foundation, a few tweaks away from great" };
  if (avg >= 50) return { label: "Needs Work", variant: "warning" as const, desc: "Several areas need attention before submitting" };
  return { label: "Weak", variant: "error" as const, desc: "Significant improvements recommended" };
};

const getScoreColor = (s: number) => {
  if (s >= 80) return "text-score-excellent";
  if (s >= 60) return "text-score-good";
  if (s >= 40) return "text-score-average";
  return "text-score-poor";
};

// ─── Mock Data ───
const atsScore = 78;
const recruiterScore = 85;
const overallAvg = Math.round((atsScore + recruiterScore) / 2);
const overall = getOverallLabel(overallAvg);

const breakdownItems = [
  { label: "Keyword Match", score: 72, icon: Search, tip: "Add missing technical terms" },
  { label: "Formatting", score: 90, icon: Shield, tip: "Clean and ATS-friendly" },
  { label: "Impact & Metrics", score: 80, icon: TrendingUp, tip: "Quantify 2 more bullets" },
  { label: "Readability", score: 88, icon: Eye, tip: "Clear and concise" },
  { label: "Relevance", score: 68, icon: Target, tip: "Align with job requirements" },
];

const topIssues = [
  { severity: "high" as const, title: "Missing 5 key technical keywords", detail: "Add CI/CD, microservices, agile methodology, system design, and cloud infrastructure to your resume.", fixLabel: "See keywords" },
  { severity: "high" as const, title: "Experience bullets lack quantification", detail: "3 of 6 bullets don't include measurable outcomes. Add percentages, dollar amounts, or user counts.", fixLabel: "See rewrites" },
  { severity: "medium" as const, title: "Skills section needs restructuring", detail: "Group skills into Technical, Tools, and Soft Skills for easier scanning.", fixLabel: "Fix now" },
  { severity: "low" as const, title: "Summary could be stronger", detail: "Tailor it to mention the specific role and 2-3 standout qualifications.", fixLabel: "Fix now" },
];

const missingKeywords = [
  { word: "CI/CD", priority: "high" },
  { word: "Microservices", priority: "high" },
  { word: "System Design", priority: "high" },
  { word: "Agile", priority: "medium" },
  { word: "Cloud Infrastructure", priority: "medium" },
  { word: "REST APIs", priority: "medium" },
  { word: "TypeScript", priority: "low" },
  { word: "Docker", priority: "low" },
];

const rewriteSuggestions = [
  {
    original: "Worked on backend services and helped improve performance",
    rewritten: "Redesigned 3 core backend microservices, reducing API response time by 40% and supporting 2x user traffic growth",
  },
  {
    original: "Led a team to deliver a new feature for the product",
    rewritten: "Led a cross-functional team of 5 to ship a real-time notification system, adopted by 12K+ users within 2 weeks of launch",
  },
  {
    original: "Responsible for testing and fixing bugs in the application",
    rewritten: "Implemented automated test suite covering 85% of critical paths, reducing production bugs by 60% quarter-over-quarter",
  },
];

const severityConfig = {
  high: { bg: "bg-score-poor-bg", text: "text-score-poor", dot: "bg-score-poor", badge: "error" as const },
  medium: { bg: "bg-score-average-bg", text: "text-score-average", dot: "bg-score-average", badge: "warning" as const },
  low: { bg: "bg-primary-light", text: "text-primary", dot: "bg-primary-muted", badge: "default" as const },
};

const priorityColors: Record<string, string> = {
  high: "bg-score-poor text-primary-foreground",
  medium: "bg-score-average text-primary-foreground",
  low: "bg-primary-muted text-primary",
};

const barColor = (s: number) => {
  if (s >= 80) return "bg-score-excellent";
  if (s >= 60) return "bg-score-good";
  if (s >= 40) return "bg-score-average";
  return "bg-score-poor";
};

const barTrack = (s: number) => {
  if (s >= 80) return "bg-score-excellent-bg";
  if (s >= 60) return "bg-score-good-bg";
  if (s >= 40) return "bg-score-average-bg";
  return "bg-score-poor-bg";
};

const ResumeAnalysis = () => {
  const { isLoading } = useSimulatedLoad(1200);
  const { toast } = useToast();
  const [expandedIssue, setExpandedIssue] = useState<number | null>(0);

  const handleCopy = (text: string) => {
    navigator.clipboard.writeText(text);
    toast({ title: "Copied to clipboard" });
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background pb-36">
        <ScreenHeader title="Analysis Results" showBack />
        <div className="px-5 mt-2"><ScoreSkeleton /></div>
        <div className="px-5 mt-6 space-y-2">
          <Skeleton className="h-5 w-36 rounded-md" />
          <Skeleton className="h-40 w-full rounded-2xl" />
        </div>
        <div className="px-5 mt-6 space-y-2">
          <Skeleton className="h-5 w-28 rounded-md" />
          <ListSkeleton count={3} />
        </div>
        <BottomNav />
      </div>
    );
  }

  const highCount = topIssues.filter(i => i.severity === "high").length;
  const potentialGain = 100 - overallAvg;

  return (
    <div className="min-h-screen bg-background pb-36">
      <ScreenHeader title="Analysis Results" showBack />

      {/* ═══════════════════════════════════════
          HERO: SCORE SUMMARY — large, confident, central
          ═══════════════════════════════════════ */}
      <div className="px-5 mt-2">
        <motion.div {...fadeUp(0)}>
          <MobileCard variant="elevated" padding="none" className="overflow-hidden">
            {/* Overall score — big centerpiece */}
            <div className="px-5 pt-7 pb-5 text-center">
              <motion.div
                initial={{ scale: 0.8, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                transition={{ delay: 0.2, duration: 0.5, ease: [0.34, 1.56, 0.64, 1] }}
                className="inline-flex flex-col items-center"
              >
                <span className={cn("text-[56px] font-extrabold leading-none tracking-tighter", getScoreColor(overallAvg))}>
                  {overallAvg}
                </span>
                <span className="text-micro text-foreground-quaternary mt-1 uppercase tracking-wider">Overall Score</span>
              </motion.div>
              <div className="mt-3">
                <Badge variant={overall.variant} size="pill">{overall.label}</Badge>
              </div>
              <p className="text-caption text-foreground-tertiary mt-2 max-w-[260px] mx-auto leading-relaxed">
                {overall.desc}
              </p>
            </div>

            {/* Dual rings — secondary detail */}
            <div className="flex items-center justify-center gap-6 pb-5">
              <ScoreRing score={atsScore} label="ATS" size={72} strokeWidth={5} />
              <div className="w-px h-10 bg-border-subtle" />
              <ScoreRing score={recruiterScore} label="Recruiter" size={72} strokeWidth={5} />
            </div>

            {/* Trend strip */}
            <div className="flex items-center justify-center gap-1.5 px-5 py-3 bg-score-excellent-bg border-t border-border-subtle">
              <TrendingUp className="h-3.5 w-3.5 text-score-excellent" />
              <span className="text-caption text-score-excellent font-semibold">+12 pts from last analysis</span>
            </div>
          </MobileCard>
        </motion.div>
      </div>

      {/* ═══════════════════════════════════════
          SCORE BREAKDOWN — compact horizontal bars
          ═══════════════════════════════════════ */}
      <div className="px-5 mt-7">
        <motion.div {...fadeUp(1)}>
          <SectionHeader title="Score Breakdown" className="mb-3" />
          <MobileCard padding="compact" className="divide-y divide-border-subtle">
            {breakdownItems.map((item, i) => (
              <div key={i} className={cn("flex items-center gap-3", i > 0 ? "pt-3" : "", i < breakdownItems.length - 1 ? "pb-3" : "")}>
                <div className={cn("w-8 h-8 rounded-lg flex items-center justify-center shrink-0", barTrack(item.score))}>
                  <item.icon className={cn("h-3.5 w-3.5", getScoreColor(item.score))} />
                </div>
                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between mb-1">
                    <span className="text-caption text-foreground font-medium">{item.label}</span>
                    <span className={cn("text-caption font-bold tabular-nums", getScoreColor(item.score))}>{item.score}</span>
                  </div>
                  <div className={cn("h-[5px] rounded-full w-full", barTrack(item.score))}>
                    <motion.div
                      className={cn("h-[5px] rounded-full", barColor(item.score))}
                      initial={{ width: 0 }}
                      animate={{ width: `${item.score}%` }}
                      transition={{ duration: 0.8, delay: 0.3 + i * 0.08, ease: [0.25, 0.1, 0.25, 1] }}
                    />
                  </div>
                  <p className="text-micro text-foreground-quaternary mt-0.5">{item.tip}</p>
                </div>
              </div>
            ))}
          </MobileCard>
        </motion.div>
      </div>

      {/* ═══════════════════════════════════════
          TOP ISSUES — accordion with severity ranking
          ═══════════════════════════════════════ */}
      <div className="px-5 mt-7">
        <motion.div {...fadeUp(2)}>
          <div className="flex items-center justify-between mb-3">
            <SectionHeader title="Issues to Fix" />
            <span className="text-micro text-foreground-quaternary">{highCount} high priority</span>
          </div>
          <MobileCard padding="none" className="overflow-hidden divide-y divide-border-subtle">
            {topIssues.map((issue, i) => {
              const config = severityConfig[issue.severity];
              const isOpen = expandedIssue === i;
              return (
                <button
                  key={i}
                  onClick={() => setExpandedIssue(isOpen ? null : i)}
                  className="w-full text-left px-4 py-3.5 press-scale"
                >
                  <div className="flex items-center gap-3">
                    <div className={cn("w-2 h-2 rounded-full shrink-0", config.dot)} />
                    <p className="text-body-medium text-foreground flex-1">{issue.title}</p>
                    <ChevronDown className={cn("h-4 w-4 text-foreground-quaternary shrink-0 transition-transform", isOpen && "rotate-180")} />
                  </div>
                  <AnimatePresence>
                    {isOpen && (
                      <motion.div
                        initial={{ height: 0, opacity: 0 }}
                        animate={{ height: "auto", opacity: 1 }}
                        exit={{ height: 0, opacity: 0 }}
                        transition={{ duration: 0.2 }}
                        className="overflow-hidden"
                      >
                        <p className="text-caption text-foreground-tertiary mt-2 pl-5 leading-relaxed">
                          {issue.detail}
                        </p>
                      </motion.div>
                    )}
                  </AnimatePresence>
                </button>
              );
            })}
          </MobileCard>
        </motion.div>
      </div>

      {/* ═══════════════════════════════════════
          MISSING KEYWORDS — clean chip grid
          ═══════════════════════════════════════ */}
      <div className="px-5 mt-7">
        <motion.div {...fadeUp(3)}>
          <SectionHeader title="Missing Keywords" className="mb-3" />
          <MobileCard>
            <div className="flex flex-wrap gap-2">
              {missingKeywords.map((kw, i) => (
                <motion.span
                  key={i}
                  initial={{ opacity: 0, scale: 0.9 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: 0.4 + i * 0.03 }}
                  className={cn(
                    "inline-flex items-center px-3 py-1.5 rounded-lg text-[12px] font-semibold",
                    priorityColors[kw.priority]
                  )}
                >
                  {kw.word}
                </motion.span>
              ))}
            </div>
            <div className="flex items-center gap-4 mt-3 pt-3 border-t border-border-subtle">
              {[
                { color: "bg-score-poor", label: "Critical" },
                { color: "bg-score-average", label: "Important" },
                { color: "bg-primary-muted", label: "Nice to have" },
              ].map((l, i) => (
                <div key={i} className="flex items-center gap-1.5">
                  <div className={cn("w-1.5 h-1.5 rounded-full", l.color)} />
                  <span className="text-micro text-foreground-quaternary">{l.label}</span>
                </div>
              ))}
            </div>
          </MobileCard>
        </motion.div>
      </div>

      {/* ═══════════════════════════════════════
          AI REWRITE SUGGESTIONS — before/after cards
          ═══════════════════════════════════════ */}
      <div className="px-5 mt-7">
        <motion.div {...fadeUp(4)}>
          <div className="flex items-center gap-2 mb-3">
            <SectionHeader title="AI Rewrites" className="flex-1" />
            <Badge variant="default" size="sm">
              <Sparkles className="h-3 w-3 mr-0.5" /> AI
            </Badge>
          </div>
          <div className="space-y-3">
            {rewriteSuggestions.map((item, i) => (
              <motion.div key={i} {...fadeUp(i + 5)}>
                <MobileCard padding="compact" className="space-y-2.5">
                  {/* Original — de-emphasized */}
                  <p className="text-caption text-foreground-quaternary leading-relaxed line-through decoration-foreground-quaternary/30">
                    {item.original}
                  </p>

                  {/* Rewritten — emphasized */}
                  <div className="pl-3 border-l-2 border-score-excellent/40">
                    <p className="text-body text-foreground leading-relaxed">
                      {item.rewritten}
                    </p>
                  </div>

                  {/* Copy action */}
                  <button
                    onClick={() => handleCopy(item.rewritten)}
                    className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-primary-light text-primary text-micro font-semibold press-scale"
                  >
                    <Copy className="h-3 w-3" /> Copy suggestion
                  </button>
                </MobileCard>
              </motion.div>
            ))}
          </div>
        </motion.div>
      </div>

      {/* ═══════════════════════════════════════
          ACTION PLAN — numbered steps
          ═══════════════════════════════════════ */}
      <div className="px-5 mt-7">
        <motion.div {...fadeUp(8)}>
          <SectionHeader title="Your Action Plan" className="mb-3" />
          <MobileCard variant="sunken" padding="compact" className="space-y-0">
            {[
              { step: "1", text: "Add the 3 critical missing keywords to your experience section", done: false },
              { step: "2", text: "Replace weak bullets with the AI-suggested rewrites above", done: false },
              { step: "3", text: "Restructure skills into Technical, Tools, and Soft Skills", done: false },
              { step: "4", text: "Re-analyze to target a score of 85+", done: false },
            ].map((item, i) => (
              <div key={i} className={cn("flex items-start gap-3 py-3", i > 0 && "border-t border-border-subtle")}>
                <div className="w-6 h-6 rounded-full bg-primary-light flex items-center justify-center shrink-0 mt-0.5">
                  <span className="text-micro text-primary font-bold">{item.step}</span>
                </div>
                <p className="text-caption text-foreground leading-relaxed flex-1">{item.text}</p>
              </div>
            ))}
          </MobileCard>

          {/* Potential gain callout */}
          <div className="flex items-center gap-2 mt-3 px-1">
            <Zap className="h-3.5 w-3.5 text-score-excellent" />
            <span className="text-caption text-foreground-tertiary">
              Following this plan could raise your score by up to <span className="font-bold text-score-excellent">{potentialGain} pts</span>
            </span>
          </div>
        </motion.div>
      </div>

      {/* ═══════════════════════════════════════
          STICKY CTAs
          ═══════════════════════════════════════ */}
      <div className="fixed bottom-[60px] left-1/2 -translate-x-1/2 w-full max-w-[430px] z-40 px-5 pb-5 pt-3 bg-gradient-to-t from-background via-background to-transparent">
        <div className="flex gap-2.5">
          <Button variant="outline" size="lg" className="flex-1" onClick={() => {}}>
            <RotateCcw className="mr-1.5 h-4 w-4" /> Re-analyze
          </Button>
          <Button variant="premium" size="lg" className="flex-[1.4]">
            <Save className="mr-1.5 h-4 w-4" /> Save Version
          </Button>
        </div>
      </div>

      <BottomNav />
    </div>
  );
};

export default ResumeAnalysis;
