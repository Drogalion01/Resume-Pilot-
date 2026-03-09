import { useState } from "react";
import { motion } from "framer-motion";
import { Plus, MoreVertical, FileText, Copy, Trash2, Eye, Pencil, ChevronRight } from "lucide-react";
import ScreenHeader from "@/components/ScreenHeader";
import MobileCard from "@/components/MobileCard";
import ScoreRing from "@/components/ScoreRing";
import BottomNav from "@/components/BottomNav";
import FAB from "@/components/FAB";
import SearchBar from "@/components/SearchBar";
import Chip from "@/components/Chip";
import { Badge } from "@/components/ui/badge";
import { useNavigate } from "react-router-dom";
import { useSimulatedLoad } from "@/hooks/use-simulated-load";
import { ListSkeleton } from "@/components/LoadingSkeletons";
import { Skeleton } from "@/components/ui/skeleton";
import { useToast } from "@/hooks/use-toast";
import {
  DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger, DropdownMenuSeparator,
} from "@/components/ui/dropdown-menu";

const versions = [
  { name: "Software Engineer v2", company: "Google", role: "Software Engineer", ats: 78, recruiter: 85, date: "Mar 5, 2026", tag: "tailored" },
  { name: "Frontend Developer", company: "Notion", role: "Frontend Engineer", ats: 82, recruiter: 79, date: "Mar 1, 2026", tag: "tailored" },
  { name: "General Resume", company: "—", role: "General use", ats: 65, recruiter: 70, date: "Feb 22, 2026", tag: "general" },
  { name: "Product Designer v1", company: "Stripe", role: "Product Designer", ats: 88, recruiter: 91, date: "Feb 18, 2026", tag: "tailored" },
  { name: "Backend Engineer", company: "Vercel", role: "Backend Engineer", ats: 71, recruiter: 74, date: "Feb 10, 2026", tag: "tailored" },
];

type FilterType = "all" | "tailored" | "general";

const ResumeVersions = () => {
  const navigate = useNavigate();
  const { toast } = useToast();
  const { isLoading } = useSimulatedLoad(800);
  const [search, setSearch] = useState("");
  const [filter, setFilter] = useState<FilterType>("all");

  const filtered = versions.filter((v) => {
    const matchSearch = !search || v.name.toLowerCase().includes(search.toLowerCase()) || v.company.toLowerCase().includes(search.toLowerCase()) || v.role.toLowerCase().includes(search.toLowerCase());
    const matchFilter = filter === "all" || v.tag === filter;
    return matchSearch && matchFilter;
  });

  const counts = { all: versions.length, tailored: versions.filter((v) => v.tag === "tailored").length, general: versions.filter((v) => v.tag === "general").length };
  const avgAts = Math.round(versions.reduce((s, v) => s + v.ats, 0) / versions.length);

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background pb-24">
        <ScreenHeader title="My Resumes" subtitle="Loading…" />
        <div className="px-5 mt-3"><Skeleton className="h-10 w-full rounded-xl" /></div>
        <div className="px-5 mt-4"><ListSkeleton count={3} /></div>
        <BottomNav />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background pb-24">
      <ScreenHeader title="My Resumes" subtitle={`${versions.length} versions · Avg ATS ${avgAts}`} />
      <div className="px-5 mt-1">
        <SearchBar value={search} onChange={setSearch} placeholder="Search by name, company, role…" />
      </div>
      <div className="flex items-center gap-2 px-5 mt-3 overflow-x-auto no-scrollbar">
        {(["all", "tailored", "general"] as FilterType[]).map((f) => (
          <Chip key={f} label={f === "all" ? "All" : f === "tailored" ? "Tailored" : "General"} active={filter === f} onClick={() => setFilter(f)} count={counts[f]} />
        ))}
      </div>

      <div className="px-5 mt-4 space-y-3">
        {filtered.length === 0 && (
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="py-16 text-center">
            <FileText className="h-10 w-10 text-foreground-quaternary mx-auto mb-3" />
            <p className="text-body-medium text-foreground-tertiary">No resumes match your search</p>
            <p className="text-caption text-foreground-quaternary mt-1">Try a different search term or filter</p>
          </motion.div>
        )}

        {filtered.map((v, i) => (
          <motion.div key={v.name} initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: i * 0.05 }}>
            <MobileCard className="space-y-3" onClick={() => navigate("/resumes/1")}>
              <div className="flex items-start justify-between">
                <div className="flex items-center gap-3 min-w-0 flex-1">
                  <div className="w-9 h-9 rounded-lg bg-primary-light flex items-center justify-center shrink-0">
                    <FileText className="h-4 w-4 text-primary" />
                  </div>
                  <div className="min-w-0 flex-1">
                    <p className="text-body-medium text-foreground truncate">{v.name}</p>
                    <div className="flex items-center gap-1.5 mt-0.5">
                      <span className="text-caption text-foreground-quaternary truncate">{v.role}</span>
                      {v.company !== "—" && (<><span className="text-foreground-quaternary text-[10px]">·</span><span className="text-caption text-foreground-quaternary truncate">{v.company}</span></>)}
                    </div>
                  </div>
                </div>
                <DropdownMenu>
                  <DropdownMenuTrigger asChild>
                    <button className="p-1.5 rounded-lg hover:bg-muted active:scale-95 transition-transform shrink-0" onClick={(e) => e.stopPropagation()}>
                      <MoreVertical className="h-4 w-4 text-foreground-quaternary" />
                    </button>
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="end" className="min-w-[160px]">
                    <DropdownMenuItem onClick={() => navigate("/analysis")}><Eye className="mr-2 h-4 w-4" /> View Analysis</DropdownMenuItem>
                    <DropdownMenuItem onClick={() => toast({ title: "Opening editor…" })}><Pencil className="mr-2 h-4 w-4" /> Edit</DropdownMenuItem>
                    <DropdownMenuItem onClick={() => toast({ title: "Resume duplicated" })}><Copy className="mr-2 h-4 w-4" /> Duplicate</DropdownMenuItem>
                    <DropdownMenuSeparator />
                    <DropdownMenuItem className="text-destructive focus:text-destructive" onClick={() => toast({ title: "Resume deleted", variant: "destructive" })}><Trash2 className="mr-2 h-4 w-4" /> Delete</DropdownMenuItem>
                  </DropdownMenuContent>
                </DropdownMenu>
              </div>
              <div className="flex items-center gap-5">
                <ScoreRing score={v.ats} label="ATS" size={52} strokeWidth={4} />
                <ScoreRing score={v.recruiter} label="Recruiter" size={52} strokeWidth={4} />
                <div className="flex-1 min-w-0 ml-1">
                  <div className="flex items-center gap-2 mb-1">
                    <Badge variant={v.tag === "tailored" ? "default" : "secondary"} size="sm">{v.tag === "tailored" ? "Tailored" : "General"}</Badge>
                  </div>
                  <p className="text-caption text-foreground-quaternary">Updated {v.date}</p>
                </div>
                <ChevronRight className="h-4 w-4 text-foreground-quaternary shrink-0" />
              </div>
            </MobileCard>
          </motion.div>
        ))}
      </div>
      <FAB onClick={() => navigate("/upload")} label="New Resume" icon={<Plus className="h-5 w-5" strokeWidth={2.5} />} />
      <BottomNav />
    </div>
  );
};

export default ResumeVersions;
