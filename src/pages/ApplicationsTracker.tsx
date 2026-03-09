import { useState } from "react";
import { motion } from "framer-motion";
import { Plus, Building2, Calendar, FileText, ChevronRight, Clock, Video } from "lucide-react";
import ScreenHeader from "@/components/ScreenHeader";
import MobileCard from "@/components/MobileCard";
import StatusBadge, { type AppStatus } from "@/components/StatusBadge";
import Chip from "@/components/Chip";
import FAB from "@/components/FAB";
import SearchBar from "@/components/SearchBar";
import BottomNav from "@/components/BottomNav";
import { useNavigate } from "react-router-dom";
import { useSimulatedLoad } from "@/hooks/use-simulated-load";
import { ListSkeleton } from "@/components/LoadingSkeletons";
import { Skeleton } from "@/components/ui/skeleton";

type FilterValue = AppStatus | "all" | "interviews";

const filters: { label: string; value: FilterValue }[] = [
  { label: "All", value: "all" },
  { label: "Interviews", value: "interviews" },
  { label: "Applied", value: "applied" },
  { label: "OA", value: "assessment" },
  { label: "HR", value: "hr" },
  { label: "Technical", value: "technical" },
  { label: "Final", value: "final" },
  { label: "Offer", value: "offer" },
  { label: "Saved", value: "saved" },
  { label: "Rejected", value: "rejected" },
];

const applications = [
  { company: "Google", role: "Software Engineer", status: "technical" as AppStatus, date: "Mar 5", resume: "SE v2", interview: { date: "Mar 10", time: "2:00 PM" } },
  { company: "Stripe", role: "Frontend Developer", status: "applied" as AppStatus, date: "Mar 3", resume: "Frontend" },
  { company: "Notion", role: "Product Designer", status: "saved" as AppStatus, date: "Mar 1", resume: "General" },
  { company: "Vercel", role: "Full Stack Engineer", status: "hr" as AppStatus, date: "Feb 28", resume: "SE v2", interview: { date: "Mar 14", time: "10:00 AM" } },
  { company: "Linear", role: "Software Engineer", status: "offer" as AppStatus, date: "Feb 25", resume: "SE v2" },
  { company: "Meta", role: "ML Engineer", status: "rejected" as AppStatus, date: "Feb 20", resume: "General" },
  { company: "Figma", role: "Design Engineer", status: "assessment" as AppStatus, date: "Feb 18", resume: "Frontend" },
  { company: "Shopify", role: "Backend Engineer", status: "final" as AppStatus, date: "Feb 15", resume: "SE v2", interview: { date: "Mar 12", time: "3:00 PM" } },
];

const ApplicationsTracker = () => {
  const navigate = useNavigate();
  const { isLoading } = useSimulatedLoad(800);
  const [activeFilter, setActiveFilter] = useState<FilterValue>("all");
  const [search, setSearch] = useState("");

  const filtered = applications.filter((a) => {
    const matchFilter = activeFilter === "all" || (activeFilter === "interviews" ? !!a.interview : a.status === activeFilter);
    const matchSearch = !search || a.company.toLowerCase().includes(search.toLowerCase()) || a.role.toLowerCase().includes(search.toLowerCase());
    return matchFilter && matchSearch;
  });

  const activeCount = applications.filter((a) => !["rejected", "saved"].includes(a.status)).length;
  const interviewCount = applications.filter((a) => !!a.interview).length;

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background pb-24">
        <ScreenHeader title="Applications" subtitle="Loading…" />
        <div className="px-5 mt-3"><Skeleton className="h-10 w-full rounded-xl" /></div>
        <div className="px-5 mt-4"><ListSkeleton count={4} /></div>
        <BottomNav />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background pb-24">
      <ScreenHeader title="Applications" subtitle={`${activeCount} active · ${interviewCount} upcoming`} />

      <div className="px-5 mt-1">
        <SearchBar value={search} onChange={setSearch} placeholder="Search company or role…" />
      </div>

      <div className="flex items-center gap-2.5 px-5 mt-3.5 overflow-x-auto no-scrollbar pb-1">
        {filters.map((f) => (
          <Chip
            key={f.value}
            label={f.label}
            active={activeFilter === f.value}
            onClick={() => setActiveFilter(f.value)}
            icon={f.value === "interviews" ? <Video className="h-3.5 w-3.5" /> : undefined}
            count={f.value === "all" ? applications.length : f.value === "interviews" ? interviewCount : applications.filter((a) => a.status === f.value).length}
          />
        ))}
      </div>

      <div className="px-5 mt-4 space-y-3">
        {filtered.length === 0 && (
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="py-16 text-center">
            <Building2 className="h-10 w-10 text-foreground-quaternary mx-auto mb-3" />
            <p className="text-body-medium text-foreground-tertiary">No applications found</p>
            <p className="text-caption text-foreground-quaternary mt-1">Try adjusting your search or filters</p>
          </motion.div>
        )}

        {filtered.map((app, i) => (
          <motion.div key={`${app.company}-${app.role}`} initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.04 }}>
            <MobileCard onClick={() => navigate("/applications/1")}>
              <div className="flex items-center gap-3.5 min-w-0">
                <div className="w-9 h-9 rounded-lg bg-primary-light flex items-center justify-center shrink-0">
                  <Building2 className="h-4 w-4 text-primary" />
                </div>
                <div className="min-w-0 flex-1">
                  <div className="flex items-center justify-between gap-2">
                    <p className="text-body-medium text-foreground truncate">{app.company}</p>
                    <StatusBadge status={app.status} />
                  </div>
                  <p className="text-caption text-foreground-secondary font-medium truncate mt-1">{app.role}</p>
                </div>
              </div>

              {/* Meta row */}
              <div className="flex items-center justify-between mt-2.5 pl-[50px]">
                <div className="flex items-center gap-3 text-micro text-foreground-quaternary">
                  <span className="flex items-center gap-1"><Calendar className="h-3 w-3" />{app.date}</span>
                  <span className="flex items-center gap-1"><FileText className="h-3 w-3" />{app.resume}</span>
                </div>
                <ChevronRight className="h-3.5 w-3.5 text-foreground-quaternary shrink-0" />
              </div>

              {/* Interview indicator */}
              {app.interview && (
                <div className="mt-2.5 ml-[50px] flex items-center gap-2.5 px-3 py-2 rounded-lg bg-status-interview-bg">
                  <Video className="h-3.5 w-3.5 text-status-interview shrink-0" />
                  <span className="text-caption text-status-interview font-semibold">{app.interview.date}</span>
                  <span className="text-micro text-foreground-tertiary flex items-center gap-1">
                    <Clock className="h-3 w-3" />{app.interview.time}
                  </span>
                </div>
              )}
            </MobileCard>
          </motion.div>
        ))}
      </div>

      <FAB onClick={() => navigate("/applications/add")} label="Add Application" icon={<Plus className="h-5 w-5" strokeWidth={2.5} />} />
      <BottomNav />
    </div>
  );
};

export default ApplicationsTracker;
