import React from "react";
import { useNavigate } from "react-router-dom";
import BottomNav from "@/components/BottomNav";
import { useSimulatedLoad } from "@/hooks/use-simulated-load";
import HomeSkeleton from "@/components/home/HomeSkeleton";
import HomeError from "@/components/home/HomeError";
import HeroSection from "@/components/home/HeroSection";
import QuickStats from "@/components/home/QuickStats";
import QuickActions from "@/components/home/QuickActions";
import InsightCard from "@/components/home/InsightCard";
import ResumeHealthSection from "@/components/home/ResumeHealthSection";
import InterviewsSection from "@/components/home/InterviewsSection";
import ApplicationsSection from "@/components/home/ApplicationsSection";

// Shape mirrors GET /api/dashboard response
interface DashboardResponse {
  user: { name: string; initials: string };
  stats: { resumes: number; applications: number; interviews: number };
  summary: { interviewsThisWeek: number; pendingOffers: number };
  insight: { icon: "trending" | "spark" | "arrow"; text: string } | null;
  recentResumes: Array<{
    id: string;
    name: string;
    atsScore: number;
    recruiterScore: number;
    updatedAt: string;
  }>;
  upcomingInterviews: Array<{
    id: string;
    company: string;
    round: string;
    date: string;
    time: string;
    type: "video" | "phone" | "onsite";
  }>;
  recentApplications: Array<{
    id: string;
    company: string;
    role: string;
    status: string;
    date: string;
  }>;
}

const Dashboard = () => {
  const navigate = useNavigate();
  const { isLoading, isError } = useSimulatedLoad(900);

  // Mock — replace with: const { data, isLoading, isError } = useQuery({ queryKey: ["dashboard"], queryFn: fetchDashboard })
  const data: DashboardResponse = {
    user: { name: "Alex", initials: "AJ" },
    stats: { resumes: 3, applications: 12, interviews: 4 },
    summary: { interviewsThisWeek: 2, pendingOffers: 1 },
    insight: { icon: "trending", text: "Your ATS score improved 12% this week" },
    recentResumes: [
      { id: "1", name: "Software Engineer v2", atsScore: 78, recruiterScore: 85, updatedAt: "2 days ago" },
      { id: "2", name: "Frontend Developer", atsScore: 82, recruiterScore: 79, updatedAt: "5 days ago" },
    ],
    upcomingInterviews: [
      { id: "1", company: "Google", round: "Technical Round 2", date: "Mar 10", time: "2:00 PM", type: "video" },
      { id: "2", company: "Linear", round: "HR Screen", date: "Mar 12", time: "11:00 AM", type: "phone" },
    ],
    recentApplications: [
      { id: "1", company: "Google", role: "Software Engineer", status: "technical", date: "Mar 5" },
      { id: "2", company: "Stripe", role: "Frontend Developer", status: "applied", date: "Mar 3" },
      { id: "3", company: "Notion", role: "Product Designer", status: "saved", date: "Mar 1" },
      { id: "4", company: "Linear", role: "Software Engineer", status: "offer", date: "Feb 25" },
    ],
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background pb-24">
        <HomeSkeleton />
        <BottomNav />
      </div>
    );
  }

  if (isError) {
    return (
      <div className="min-h-screen bg-background pb-24">
        <HomeError onRetry={() => window.location.reload()} />
        <BottomNav />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background pb-24">
      <HeroSection
        userName={data.user.name}
        userInitials={data.user.initials}
        interviewsThisWeek={data.summary.interviewsThisWeek}
        pendingOffers={data.summary.pendingOffers}
      />

      <div className="space-y-6 mt-5">
        <InsightCard insight={data.insight ?? undefined} />
        <QuickStats stats={data.stats} navigate={navigate} />
        <QuickActions navigate={navigate} />
        <ResumeHealthSection resumes={data.recentResumes} navigate={navigate} />
        <InterviewsSection interviews={data.upcomingInterviews} navigate={navigate} />
        <ApplicationsSection applications={data.recentApplications} navigate={navigate} />
      </div>

      <div className="h-4" />
      <BottomNav />
    </div>
  );
};

export default Dashboard;
