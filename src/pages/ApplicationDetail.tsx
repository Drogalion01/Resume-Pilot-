import { motion } from "framer-motion";
import { Building2, Calendar, Pencil, AlertCircle, RefreshCw } from "lucide-react";
import ScreenHeader from "@/components/ScreenHeader";
import MobileCard from "@/components/MobileCard";
import StatusBadge from "@/components/StatusBadge";
import BottomNav from "@/components/BottomNav";
import { Button } from "@/components/ui/button";
import { useNavigate } from "react-router-dom";
import { useSimulatedLoad } from "@/hooks/use-simulated-load";
import { useToast } from "@/hooks/use-toast";

import SummaryCard from "@/components/application-detail/SummaryCard";
import ActivityTimeline from "@/components/application-detail/ActivityTimeline";
import InterviewStages from "@/components/application-detail/InterviewStages";
import FollowUpReminders from "@/components/application-detail/FollowUpReminders";
import ResumeUsedCard from "@/components/application-detail/ResumeUsedCard";
import NotesSection from "@/components/application-detail/NotesSection";
import PrimaryActions from "@/components/application-detail/PrimaryActions";
import DetailSkeleton from "@/components/application-detail/DetailSkeleton";
import { mockApplication, mockTimeline, mockInterviews, mockReminders, mockResume, mockNotes } from "@/components/application-detail/mockData";

const stagger = (i: number) => ({
  initial: { opacity: 0, y: 8 },
  animate: { opacity: 1, y: 0 },
  transition: { delay: i * 0.05 },
});

const ApplicationDetail = () => {
  const navigate = useNavigate();
  const { toast } = useToast();
  const { isLoading, isError } = useSimulatedLoad(800);

  const app = mockApplication;

  const handleAction = (msg: string) => () => {
    toast({ title: msg, description: "This feature will connect to the backend." });
  };

  if (isError) {
    return (
      <div className="min-h-screen bg-background pb-24">
        <ScreenHeader title="Application" showBack />
        <div className="flex flex-col items-center justify-center px-8 pt-20 text-center">
          <div className="w-14 h-14 rounded-xl bg-destructive/10 flex items-center justify-center mb-4">
            <AlertCircle className="h-6 w-6 text-destructive" />
          </div>
          <h3 className="text-title text-foreground mb-1">Failed to load</h3>
          <p className="text-body text-foreground-quaternary mb-4">Could not fetch application details.</p>
          <Button variant="outline" size="sm" onClick={() => window.location.reload()}>
            <RefreshCw className="h-3.5 w-3.5 mr-1.5" /> Retry
          </Button>
        </div>
        <BottomNav />
      </div>
    );
  }

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background pb-24">
        <ScreenHeader title="Application" showBack />
        <DetailSkeleton />
        <BottomNav />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background pb-32">
      {/* Header with gradient */}
      <div className="hero-gradient relative">
        <ScreenHeader
          title="Application"
          showBack
          rightAction={
            <Button variant="ghost" size="icon-sm" onClick={handleAction("Edit application")}>
              <Pencil className="h-4 w-4" />
            </Button>
          }
        />

        {/* Hero Card — overlaps gradient */}
        <motion.div {...stagger(0)} className="px-5 pb-4">
          <MobileCard variant="elevated" padding="spacious">
            <div className="flex items-start gap-3.5">
              <div className="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center shrink-0">
                <Building2 className="h-5 w-5 text-primary" />
              </div>
              <div className="flex-1 min-w-0">
                <h2 className="text-title text-foreground font-bold">{app.company_name}</h2>
                <p className="text-body text-foreground-secondary mt-0.5">{app.role}</p>
                <div className="flex items-center gap-2.5 mt-2.5">
                  <StatusBadge status={app.status} />
                  <span className="text-micro text-foreground-quaternary flex items-center gap-1">
                    <Calendar className="h-3 w-3" /> {app.applied_date}
                  </span>
                </div>
              </div>
            </div>
          </MobileCard>
        </motion.div>
      </div>

      {/* Section 2 — Summary */}
      <motion.div {...stagger(1)} className="px-5 mt-3">
        <SummaryCard app={app} />
      </motion.div>

      {/* Section 3 — Timeline */}
      <motion.div {...stagger(2)} className="px-5 mt-7">
        <ActivityTimeline events={mockTimeline} />
      </motion.div>

      {/* Section 4 — Interviews */}
      <motion.div {...stagger(3)} className="px-5 mt-7">
        <InterviewStages
          interviews={mockInterviews}
          onAddInterview={() => navigate(`/applications/${app.id}/interviews/add`)}
        />
      </motion.div>

      {/* Section 5 — Reminders */}
      <motion.div {...stagger(4)} className="px-5 mt-7">
        <FollowUpReminders reminders={mockReminders} onAddReminder={handleAction("Add reminder")} />
      </motion.div>

      {/* Section 6 — Resume Used */}
      <motion.div {...stagger(5)} className="px-5 mt-7">
        <ResumeUsedCard resume={mockResume} onViewResume={() => navigate(`/resumes/${mockResume.id}`)} />
      </motion.div>

      {/* Section 7 — Notes */}
      <motion.div {...stagger(6)} className="px-5 mt-7">
        <NotesSection notes={mockNotes} onEdit={handleAction("Edit notes")} />
      </motion.div>

      {/* Section 8 — Actions */}
      <motion.div {...stagger(7)} className="px-5 mt-8 mb-6">
        <PrimaryActions
          onEdit={handleAction("Edit application")}
          onAddInterview={() => navigate(`/applications/${app.id}/interviews/add`)}
          onAddReminder={handleAction("Add reminder")}
          onArchive={handleAction("Application archived")}
          onDelete={handleAction("Application deleted")}
        />
      </motion.div>

      <BottomNav />
    </div>
  );
};

export default ApplicationDetail;
