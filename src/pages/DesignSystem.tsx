import { useState } from "react";
import { Search, Bell, Plus, Upload, FileText, Briefcase, ChevronRight, Heart, Star, Check, X, AlertCircle } from "lucide-react";
import ScreenHeader from "@/components/ScreenHeader";
import SectionHeader from "@/components/SectionHeader";
import MobileCard from "@/components/MobileCard";
import ScoreRing from "@/components/ScoreRing";
import ScoreCard from "@/components/ScoreCard";
import StatusBadge from "@/components/StatusBadge";
import SearchBar from "@/components/SearchBar";
import Chip from "@/components/Chip";
import FAB from "@/components/FAB";
import ListItem from "@/components/ListItem";
import EmptyState from "@/components/EmptyState";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import BottomNav from "@/components/BottomNav";

const DesignSystem = () => {
  const [search, setSearch] = useState("");
  const [activeChip, setActiveChip] = useState("all");

  return (
    <div className="min-h-screen bg-background pb-24">
      <ScreenHeader title="Design System" subtitle="ResumePilot Components" large />

      <div className="px-5 space-y-8">

        {/* ─── COLOR PALETTE ─── */}
        <section>
          <SectionHeader title="Color Palette" className="mb-3" />
          <MobileCard className="space-y-4">
            <p className="text-overline text-foreground-tertiary">Primary</p>
            <div className="flex gap-2">
              <div className="flex-1 h-12 rounded-xl bg-primary" />
              <div className="flex-1 h-12 rounded-xl bg-primary-hover" />
              <div className="flex-1 h-12 rounded-xl bg-primary-light" />
              <div className="flex-1 h-12 rounded-xl bg-primary-muted" />
            </div>
            <p className="text-overline text-foreground-tertiary">Scores</p>
            <div className="flex gap-2">
              <div className="flex-1 h-10 rounded-lg bg-score-excellent flex items-center justify-center text-micro text-primary-foreground">Excellent</div>
              <div className="flex-1 h-10 rounded-lg bg-score-good flex items-center justify-center text-micro text-primary-foreground">Good</div>
              <div className="flex-1 h-10 rounded-lg bg-score-average flex items-center justify-center text-micro text-primary-foreground">Average</div>
              <div className="flex-1 h-10 rounded-lg bg-score-poor flex items-center justify-center text-micro text-primary-foreground">Poor</div>
            </div>
            <p className="text-overline text-foreground-tertiary">Status</p>
            <div className="flex gap-2">
              <div className="flex-1 h-10 rounded-lg bg-status-applied flex items-center justify-center text-micro text-primary-foreground">Applied</div>
              <div className="flex-1 h-10 rounded-lg bg-status-interview flex items-center justify-center text-micro text-primary-foreground">Interview</div>
              <div className="flex-1 h-10 rounded-lg bg-status-offer flex items-center justify-center text-micro text-primary-foreground">Offer</div>
            </div>
            <p className="text-overline text-foreground-tertiary">Surfaces</p>
            <div className="flex gap-2">
              <div className="flex-1 h-10 rounded-lg bg-background border border-border flex items-center justify-center text-micro text-foreground-tertiary">Background</div>
              <div className="flex-1 h-10 rounded-lg bg-surface-primary border border-border flex items-center justify-center text-micro text-foreground-tertiary">Surface</div>
              <div className="flex-1 h-10 rounded-lg bg-surface-secondary flex items-center justify-center text-micro text-foreground-tertiary">Secondary</div>
              <div className="flex-1 h-10 rounded-lg bg-surface-sunken flex items-center justify-center text-micro text-foreground-tertiary">Sunken</div>
            </div>
          </MobileCard>
        </section>

        {/* ─── TYPOGRAPHY ─── */}
        <section>
          <SectionHeader title="Typography" className="mb-3" />
          <MobileCard className="space-y-4">
            <div>
              <span className="text-micro text-foreground-quaternary">Display — 28/34 ExtraBold</span>
              <p className="text-display text-foreground">Dashboard</p>
            </div>
            <div className="border-t border-border-subtle pt-3">
              <span className="text-micro text-foreground-quaternary">Headline — 20/28 Bold</span>
              <p className="text-headline text-foreground">Your Resumes</p>
            </div>
            <div className="border-t border-border-subtle pt-3">
              <span className="text-micro text-foreground-quaternary">Title — 16/24 Semibold</span>
              <p className="text-title text-foreground">Software Engineer v2</p>
            </div>
            <div className="border-t border-border-subtle pt-3">
              <span className="text-micro text-foreground-quaternary">Body — 15/22 Regular</span>
              <p className="text-body text-foreground">Your resume scores well for recruiter readability.</p>
            </div>
            <div className="border-t border-border-subtle pt-3">
              <span className="text-micro text-foreground-quaternary">Body Medium — 15/22 Medium</span>
              <p className="text-body-medium text-foreground">Google · Software Engineer</p>
            </div>
            <div className="border-t border-border-subtle pt-3">
              <span className="text-micro text-foreground-quaternary">Caption — 13/18 Medium</span>
              <p className="text-caption text-foreground-tertiary">Updated 2 days ago</p>
            </div>
            <div className="border-t border-border-subtle pt-3">
              <span className="text-micro text-foreground-quaternary">Overline — 11/16 Semibold Uppercase</span>
              <p className="text-overline text-foreground-tertiary">ATS Score</p>
            </div>
            <div className="border-t border-border-subtle pt-3">
              <span className="text-micro text-foreground-quaternary">Micro — 10/14 Semibold</span>
              <p className="text-micro text-foreground-tertiary">Mar 5</p>
            </div>
          </MobileCard>

          <MobileCard className="mt-3 space-y-1">
            <p className="text-overline text-foreground-tertiary mb-2">Text Hierarchy</p>
            <p className="text-body text-foreground">Primary text — foreground</p>
            <p className="text-body text-foreground-secondary">Secondary — foreground-secondary</p>
            <p className="text-body text-foreground-tertiary">Tertiary — foreground-tertiary</p>
            <p className="text-body text-foreground-quaternary">Quaternary — foreground-quaternary</p>
          </MobileCard>
        </section>

        {/* ─── BUTTONS ─── */}
        <section>
          <SectionHeader title="Buttons" className="mb-3" />
          <MobileCard className="space-y-4">
            <p className="text-overline text-foreground-tertiary">Variants</p>
            <div className="space-y-2.5">
              <Button variant="default" size="full">Primary Button</Button>
              <Button variant="premium" size="full">Premium Action</Button>
              <Button variant="soft" size="full">Soft / Tinted</Button>
              <Button variant="secondary" size="full">Secondary</Button>
              <Button variant="outline" size="full">Outline</Button>
              <Button variant="ghost" size="full">Ghost</Button>
              <Button variant="destructive" size="full">Destructive</Button>
              <Button variant="destructive-ghost" size="full">Destructive Ghost</Button>
            </div>
            <p className="text-overline text-foreground-tertiary pt-2">Sizes</p>
            <div className="flex items-center gap-2 flex-wrap">
              <Button size="sm">Small</Button>
              <Button size="default">Default</Button>
              <Button size="lg">Large</Button>
              <Button size="icon"><Plus /></Button>
              <Button size="icon-sm" variant="ghost"><Bell /></Button>
              <Button size="icon-lg" variant="outline"><Search /></Button>
            </div>
            <p className="text-overline text-foreground-tertiary pt-2">With Icons</p>
            <div className="space-y-2">
              <Button size="full"><Upload className="mr-1" /> Upload Resume</Button>
              <Button variant="soft" size="full"><FileText className="mr-1" /> View Analysis</Button>
            </div>
            <p className="text-overline text-foreground-tertiary pt-2">Disabled</p>
            <Button size="full" disabled>Disabled Button</Button>
          </MobileCard>
        </section>

        {/* ─── INPUTS ─── */}
        <section>
          <SectionHeader title="Inputs" className="mb-3" />
          <MobileCard className="space-y-4">
            <div>
              <label className="text-caption text-foreground-secondary mb-1.5 block">Default Input</label>
              <Input placeholder="Enter your name" />
            </div>
            <div>
              <label className="text-caption text-foreground-secondary mb-1.5 block">With Left Icon</label>
              <Input leftIcon={<Search />} placeholder="Search companies..." />
            </div>
            <div>
              <label className="text-caption text-foreground-secondary mb-1.5 block">With Both Icons</label>
              <Input leftIcon={<Briefcase />} rightIcon={<ChevronRight />} placeholder="Select position..." />
            </div>
            <div>
              <label className="text-caption text-foreground-secondary mb-1.5 block">Disabled</label>
              <Input placeholder="Disabled input" disabled />
            </div>
            <div>
              <label className="text-caption text-foreground-secondary mb-1.5 block">Textarea</label>
              <Textarea placeholder="Paste your resume content here..." rows={4} />
            </div>
          </MobileCard>
        </section>

        {/* ─── SEARCH BAR ─── */}
        <section>
          <SectionHeader title="Search Bar" className="mb-3" />
          <SearchBar value={search} onChange={setSearch} placeholder="Search resumes, companies..." />
        </section>

        {/* ─── CHIPS / FILTER PILLS ─── */}
        <section>
          <SectionHeader title="Chips & Filter Pills" className="mb-3" />
          <div className="flex gap-2 flex-wrap">
            {["all", "applied", "interview", "offer", "saved"].map(c => (
              <Chip
                key={c}
                label={c.charAt(0).toUpperCase() + c.slice(1)}
                active={activeChip === c}
                onClick={() => setActiveChip(c)}
                count={c === "all" ? 12 : undefined}
              />
            ))}
          </div>
        </section>

        {/* ─── BADGES ─── */}
        <section>
          <SectionHeader title="Badges" className="mb-3" />
          <MobileCard className="space-y-3">
            <p className="text-overline text-foreground-tertiary">Status Badges</p>
            <div className="flex flex-wrap gap-2">
              <StatusBadge status="applied" />
              <StatusBadge status="technical" />
              <StatusBadge status="offer" />
              <StatusBadge status="rejected" />
              <StatusBadge status="saved" />
            </div>
            <p className="text-overline text-foreground-tertiary pt-2">Semantic Badges</p>
            <div className="flex flex-wrap gap-2">
              <Badge variant="default">Primary</Badge>
              <Badge variant="secondary">Secondary</Badge>
              <Badge variant="success">Success</Badge>
              <Badge variant="warning">Warning</Badge>
              <Badge variant="error">Error</Badge>
              <Badge variant="outline">Outline</Badge>
            </div>
            <p className="text-overline text-foreground-tertiary pt-2">Sizes</p>
            <div className="flex flex-wrap items-center gap-2">
              <Badge variant="default" size="sm">Small</Badge>
              <Badge variant="default" size="default">Default</Badge>
              <Badge variant="default" size="pill">Pill</Badge>
              <Badge variant="default" size="lg">Large</Badge>
            </div>
          </MobileCard>
        </section>

        {/* ─── SCORE DISPLAYS ─── */}
        <section>
          <SectionHeader title="Score Displays" className="mb-3" />
          <MobileCard>
            <p className="text-overline text-foreground-tertiary mb-4">Score Rings</p>
            <div className="flex items-center justify-around">
              <ScoreRing score={92} label="Excellent" size={80} strokeWidth={5} />
              <ScoreRing score={72} label="Good" size={80} strokeWidth={5} />
              <ScoreRing score={48} label="Average" size={80} strokeWidth={5} />
              <ScoreRing score={25} label="Poor" size={80} strokeWidth={5} />
            </div>
          </MobileCard>
          <div className="grid grid-cols-2 gap-3 mt-3">
            <ScoreCard score={85} label="ATS Score" description="Keyword match" trend={{ value: 12, positive: true }} />
            <ScoreCard score={42} label="Recruiter" description="Needs work" trend={{ value: 5, positive: false }} />
          </div>
        </section>

        {/* ─── CARDS ─── */}
        <section>
          <SectionHeader title="Card Variants" className="mb-3" />
          <div className="space-y-3">
            <MobileCard variant="default">
              <p className="text-body-medium text-foreground">Default Card</p>
              <p className="text-caption text-foreground-tertiary">Subtle shadow, white background</p>
            </MobileCard>
            <MobileCard variant="outlined">
              <p className="text-body-medium text-foreground">Outlined Card</p>
              <p className="text-caption text-foreground-tertiary">Border, no shadow</p>
            </MobileCard>
            <MobileCard variant="elevated">
              <p className="text-body-medium text-foreground">Elevated Card</p>
              <p className="text-caption text-foreground-tertiary">Stronger shadow for emphasis</p>
            </MobileCard>
            <MobileCard variant="sunken">
              <p className="text-body-medium text-foreground">Sunken Card</p>
              <p className="text-caption text-foreground-tertiary">Recessed surface for grouping</p>
            </MobileCard>
            <MobileCard variant="default" onClick={() => {}}>
              <p className="text-body-medium text-foreground">Interactive Card</p>
              <p className="text-caption text-foreground-tertiary">Tap me — press-scale + hover shadow</p>
            </MobileCard>
          </div>
        </section>

        {/* ─── LIST ITEMS ─── */}
        <section>
          <SectionHeader title="List Items" className="mb-3" />
          <MobileCard padding="none" className="divide-y divide-border-subtle overflow-hidden">
            <div className="px-4">
              <ListItem
                icon={<Briefcase className="text-foreground-tertiary" />}
                title="Google"
                subtitle="Software Engineer · Mountain View"
                trailing={<StatusBadge status="technical" />}
              />
            </div>
            <div className="px-4">
              <ListItem
                icon={<FileText className="text-primary" />}
                iconBg="bg-primary-light"
                title="Frontend Developer Resume"
                subtitle="Updated 2 days ago"
                trailing={<ChevronRight className="h-4 w-4 text-foreground-quaternary" />}
              />
            </div>
            <div className="px-4">
              <ListItem
                icon={<Bell className="text-foreground-tertiary" />}
                title="Notifications"
                subtitle="Reminders & alerts"
                trailing={<ChevronRight className="h-4 w-4 text-foreground-quaternary" />}
                onClick={() => {}}
              />
            </div>
          </MobileCard>
        </section>

        {/* ─── EMPTY STATE ─── */}
        <section>
          <SectionHeader title="Empty State" className="mb-3" />
          <MobileCard>
            <EmptyState
              icon={<Briefcase />}
              title="No applications yet"
              description="Start tracking your job applications by adding your first one"
              action={<Button variant="soft" size="sm"><Plus className="mr-1" /> Add Application</Button>}
            />
          </MobileCard>
        </section>

        {/* ─── FAB ─── */}
        <section>
          <SectionHeader title="Floating Action Button" className="mb-3" />
          <MobileCard>
            <p className="text-body text-foreground-tertiary mb-3">The FAB is positioned fixed at bottom-right, above the nav bar. See the + button on this page.</p>
            <div className="flex gap-3">
              <div className="w-14 h-14 rounded-2xl bg-primary shadow-fab flex items-center justify-center">
                <Plus className="h-5 w-5 text-primary-foreground" strokeWidth={2.5} />
              </div>
              <div className="h-14 rounded-2xl bg-primary shadow-fab flex items-center gap-2 px-5">
                <Plus className="h-5 w-5 text-primary-foreground" strokeWidth={2.5} />
                <span className="text-body-medium text-primary-foreground">New Resume</span>
              </div>
            </div>
          </MobileCard>
        </section>

        {/* ─── SPACING & RADIUS ─── */}
        <section>
          <SectionHeader title="Spacing & Radius" className="mb-3" />
          <MobileCard className="space-y-4">
            <div>
              <p className="text-overline text-foreground-tertiary mb-2">Corner Radius Scale</p>
              <div className="flex items-end gap-3">
                <div className="w-10 h-10 bg-primary-light rounded-xs flex items-center justify-center text-micro text-primary">xs</div>
                <div className="w-10 h-10 bg-primary-light rounded-sm flex items-center justify-center text-micro text-primary">sm</div>
                <div className="w-10 h-10 bg-primary-light rounded-md flex items-center justify-center text-micro text-primary">md</div>
                <div className="w-10 h-10 bg-primary-light rounded-lg flex items-center justify-center text-micro text-primary">lg</div>
                <div className="w-10 h-10 bg-primary-light rounded-xl flex items-center justify-center text-micro text-primary">xl</div>
                <div className="w-10 h-10 bg-primary-light rounded-2xl flex items-center justify-center text-micro text-primary">2xl</div>
                <div className="w-10 h-10 bg-primary-light rounded-full flex items-center justify-center text-micro text-primary">full</div>
              </div>
            </div>
            <div>
              <p className="text-overline text-foreground-tertiary mb-2">Shadow Scale</p>
              <div className="flex gap-3">
                <div className="w-16 h-16 bg-card rounded-xl shadow-xs flex items-center justify-center text-micro text-foreground-tertiary">xs</div>
                <div className="w-16 h-16 bg-card rounded-xl shadow-sm flex items-center justify-center text-micro text-foreground-tertiary">sm</div>
                <div className="w-16 h-16 bg-card rounded-xl shadow-card flex items-center justify-center text-micro text-foreground-tertiary">card</div>
                <div className="w-16 h-16 bg-card rounded-xl shadow-elevated flex items-center justify-center text-micro text-foreground-tertiary">elev</div>
              </div>
            </div>
          </MobileCard>
        </section>

        {/* ─── ICON STYLE ─── */}
        <section>
          <SectionHeader title="Icon Style" className="mb-3" />
          <MobileCard>
            <p className="text-body text-foreground-tertiary mb-3">Lucide icons · 1.8px stroke default · 2.2px active · Rounded line-cap · Always inside icon containers</p>
            <div className="flex items-center gap-4">
              <div className="w-10 h-10 rounded-xl bg-primary-light flex items-center justify-center">
                <FileText className="h-[18px] w-[18px] text-primary" />
              </div>
              <div className="w-10 h-10 rounded-xl bg-muted flex items-center justify-center">
                <Briefcase className="h-[18px] w-[18px] text-foreground-tertiary" />
              </div>
              <div className="w-10 h-10 rounded-xl bg-score-excellent-bg flex items-center justify-center">
                <Check className="h-[18px] w-[18px] text-score-excellent" />
              </div>
              <div className="w-10 h-10 rounded-xl bg-score-average-bg flex items-center justify-center">
                <AlertCircle className="h-[18px] w-[18px] text-score-average" />
              </div>
              <div className="w-10 h-10 rounded-xl bg-score-poor-bg flex items-center justify-center">
                <X className="h-[18px] w-[18px] text-score-poor" />
              </div>
            </div>
          </MobileCard>
        </section>

      </div>

      <FAB />
      <BottomNav />
    </div>
  );
};

export default DesignSystem;
