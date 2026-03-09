import { useState } from "react";
import { motion } from "framer-motion";
import {
  Building2, Briefcase, Calendar as CalendarIcon, FileText, StickyNote,
  Clock, Video, Phone, MapPin, ChevronDown, Loader2, AlertCircle, Check, Lightbulb
} from "lucide-react";
import { format } from "date-fns";
import ScreenHeader from "@/components/ScreenHeader";
import MobileCard from "@/components/MobileCard";
import SectionHeader from "@/components/SectionHeader";
import StatusBadge, { type AppStatus } from "@/components/StatusBadge";
import BottomNav from "@/components/BottomNav";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { Switch } from "@/components/ui/switch";
import { Calendar } from "@/components/ui/calendar";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { cn } from "@/lib/utils";
import { useNavigate } from "react-router-dom";
import { useToast } from "@/hooks/use-toast";
import ScoreRing from "@/components/ScoreRing";

const statusOptions: { value: AppStatus; label: string }[] = [
  { value: "saved", label: "Saved" },
  { value: "applied", label: "Applied" },
  { value: "assessment", label: "OA/Assessment" },
  { value: "hr", label: "HR Interview" },
  { value: "technical", label: "Technical" },
  { value: "final", label: "Final Round" },
  { value: "offer", label: "Offer" },
  { value: "rejected", label: "Rejected" },
];

const interviewTypes = [
  { value: "phone", label: "Phone", icon: Phone },
  { value: "video", label: "Video", icon: Video },
  { value: "onsite", label: "Onsite", icon: MapPin },
];

const timeSlots = Array.from({ length: 28 }, (_, i) => {
  const hour = Math.floor(i / 2) + 7;
  const min = i % 2 === 0 ? "00" : "30";
  const h12 = hour > 12 ? hour - 12 : hour;
  const ampm = hour >= 12 ? "PM" : "AM";
  return { value: `${String(hour).padStart(2, "0")}:${min}`, label: `${h12}:${min} ${ampm}` };
});

const mockResumes = [
  { id: "1", name: "Software Engineer v2", ats: 78, recruiter: 85 },
  { id: "2", name: "Frontend Developer", ats: 82, recruiter: 79 },
  { id: "3", name: "General Resume", ats: 65, recruiter: 72 },
];

const stagger = (i: number) => ({
  initial: { opacity: 0, y: 8 },
  animate: { opacity: 1, y: 0 },
  transition: { delay: i * 0.05 },
});

const AddApplication = () => {
  const navigate = useNavigate();
  const { toast } = useToast();

  const [company, setCompany] = useState("");
  const [role, setRole] = useState("");
  const [status, setStatus] = useState<AppStatus>("applied");
  const [appDate, setAppDate] = useState<Date>(new Date());
  const [resumeId, setResumeId] = useState("");
  const [interviewEnabled, setInterviewEnabled] = useState(false);
  const [interviewDate, setInterviewDate] = useState<Date>();
  const [interviewTime, setInterviewTime] = useState("");
  const [interviewType, setInterviewType] = useState("video");
  const [notes, setNotes] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});

  const selectedResume = mockResumes.find((r) => r.id === resumeId);

  const validate = () => {
    const errs: Record<string, string> = {};
    if (!company.trim()) errs.company = "Company name is required";
    if (!role.trim()) errs.role = "Job title is required";
    if (interviewEnabled && !interviewDate) errs.interviewDate = "Interview date is required";
    if (interviewEnabled && !interviewTime) errs.interviewTime = "Interview time is required";
    setErrors(errs);
    return Object.keys(errs).length === 0;
  };

  const clearError = (key: string) => {
    if (errors[key]) setErrors((p) => ({ ...p, [key]: "" }));
  };

  const buildPayload = () => ({
    company_name: company.trim(),
    role: role.trim(),
    status,
    application_date: format(appDate, "yyyy-MM-dd"),
    resume_id: resumeId || null,
    interview_enabled: interviewEnabled,
    interview_date: interviewEnabled && interviewDate ? format(interviewDate, "yyyy-MM-dd") : null,
    interview_time: interviewEnabled && interviewTime ? interviewTime : null,
    interview_type: interviewEnabled ? interviewType : null,
    notes: notes.trim() || null,
  });

  const handleSave = () => {
    if (!validate()) return;
    setIsLoading(true);
    const payload = buildPayload();
    console.log("[AddApplication] payload:", payload);
    // TODO: replace with fetch("/api/applications", { method: "POST", body: JSON.stringify(payload) })
    setTimeout(() => {
      setIsLoading(false);
      toast({
        title: "Application saved",
        description: `${payload.role} at ${payload.company_name} added to your tracker`,
      });
      navigate("/applications");
    }, 1200);
  };

  const FieldError = ({ msg }: { msg?: string }) =>
    msg ? (
      <p className="text-micro text-destructive flex items-center gap-1 mt-1.5">
        <AlertCircle className="h-3 w-3" /> {msg}
      </p>
    ) : null;

  return (
    <div className="min-h-screen bg-background pb-44">
      {/* Header */}
      <div className="hero-gradient relative">
        <ScreenHeader title="Add Application" subtitle="Track a new job opportunity" showBack />
        <div className="h-4" />
      </div>

      {/* Section 1 — Application Details */}
      <motion.div {...stagger(0)} className="px-5 mt-6">
        <SectionHeader title="Application Details" />
        <MobileCard variant="elevated" padding="spacious" className="mt-3">
          <div className="space-y-4">
            <div>
              <p className="text-caption text-foreground-tertiary mb-1.5 font-medium">Company *</p>
              <Input
                leftIcon={<Building2 />}
                placeholder="e.g. Google, Stripe…"
                value={company}
                enterKeyHint="next"
                autoComplete="organization"
                onFocus={(e) => setTimeout(() => e.target.scrollIntoView({ behavior: "smooth", block: "center" }), 300)}
                onChange={(e) => { setCompany(e.target.value); clearError("company"); }}
                className={errors.company ? "border-destructive focus-within:ring-destructive/20" : ""}
              />
              <FieldError msg={errors.company} />
            </div>

            <div>
              <p className="text-caption text-foreground-tertiary mb-1.5 font-medium">Job Title *</p>
              <Input
                leftIcon={<Briefcase />}
                placeholder="e.g. Software Engineer"
                value={role}
                enterKeyHint="done"
                autoComplete="organization-title"
                onFocus={(e) => setTimeout(() => e.target.scrollIntoView({ behavior: "smooth", block: "center" }), 300)}
                onChange={(e) => { setRole(e.target.value); clearError("role"); }}
                className={errors.role ? "border-destructive focus-within:ring-destructive/20" : ""}
              />
              <FieldError msg={errors.role} />
            </div>

            {/* Status selector */}
            <div>
              <p className="text-caption text-foreground-tertiary mb-2.5 font-medium">Status</p>
              <div className="flex flex-wrap gap-3">
                {statusOptions.map((s) => (
                  <button
                    key={s.value}
                    type="button"
                    onClick={() => setStatus(s.value)}
                    className={cn(
                      "transition-all rounded-full active:scale-[0.95] duration-150",
                      status === s.value
                        ? "ring-2 ring-primary/40 ring-offset-2 ring-offset-card scale-[1.03] shadow-[0_0_8px_hsl(var(--primary)/0.15)]"
                        : "opacity-50 hover:opacity-80"
                    )}
                  >
                    <StatusBadge status={s.value} size="lg" />
                  </button>
                ))}
              </div>
            </div>

            {/* Divider */}
            <div className="border-t border-border-subtle" />

            {/* Application date */}
            <div>
              <p className="text-caption text-foreground-tertiary mb-1.5 font-medium">Application Date</p>
              <Popover>
                <PopoverTrigger asChild>
                  <button className="flex items-center gap-2.5 h-[52px] w-full rounded-xl border border-border bg-surface-primary px-4 text-[15px] text-foreground transition-all hover:border-primary/40 focus-within:ring-2 focus-within:ring-primary/25 focus-within:border-primary/60 focus-within:shadow-[0_0_0_3px_hsl(var(--primary)/0.08)]">
                    <CalendarIcon className="h-[18px] w-[18px] text-foreground-tertiary/70 shrink-0" />
                    {format(appDate, "MMM d, yyyy")}
                  </button>
                </PopoverTrigger>
                <PopoverContent className="w-auto p-0" align="start">
                  <Calendar
                    mode="single"
                    selected={appDate}
                    onSelect={(d) => d && setAppDate(d)}
                    initialFocus
                    className="p-3 pointer-events-auto"
                  />
                </PopoverContent>
              </Popover>
            </div>
          </div>
        </MobileCard>
      </motion.div>

      {/* Section 2 — Resume Used */}
      <motion.div {...stagger(1)} className="px-5 mt-7">
        <SectionHeader title="Resume Used" />
        <MobileCard variant="elevated" padding="spacious" className="mt-3">
          {mockResumes.length === 0 ? (
            <div className="py-6 text-center">
              <div className="w-12 h-12 rounded-xl bg-surface-secondary flex items-center justify-center mx-auto mb-3">
                <FileText className="h-5 w-5 text-foreground-quaternary" />
              </div>
              <p className="text-body-medium text-foreground-tertiary">No resumes available</p>
              <p className="text-caption text-foreground-quaternary mt-1">Upload a resume first</p>
            </div>
          ) : (
            <div className="space-y-3">
              <p className="text-caption text-foreground-tertiary font-medium">Select the resume you used</p>
              {mockResumes.map((resume) => (
                <button
                  key={resume.id}
                  type="button"
                  onClick={() => setResumeId(resume.id)}
                  className={cn(
                    "w-full flex items-center gap-3.5 p-4 rounded-xl transition-all duration-150 active:scale-[0.98]",
                    resumeId === resume.id
                      ? "bg-primary/[0.06] border-2 border-primary/35 shadow-[0_0_8px_hsl(var(--primary)/0.1)]"
                      : "bg-surface-secondary border-2 border-transparent hover:bg-muted"
                  )}
                >
                  <div className={cn(
                    "w-10 h-10 rounded-xl flex items-center justify-center shrink-0 transition-colors",
                    resumeId === resume.id ? "bg-primary/15" : "bg-muted"
                  )}>
                    <FileText className={cn(
                      "h-[18px] w-[18px] transition-colors",
                      resumeId === resume.id ? "text-primary" : "text-foreground-tertiary"
                    )} />
                  </div>
                  <div className="flex-1 min-w-0 text-left">
                    <p className={cn(
                      "text-body-medium font-semibold truncate",
                      resumeId === resume.id ? "text-foreground" : "text-foreground"
                    )}>{resume.name}</p>
                    <div className="flex items-center gap-2.5 mt-1">
                      <span className="text-micro text-foreground-tertiary">ATS <span className="font-semibold text-foreground-secondary">{resume.ats}</span></span>
                      <span className="w-1 h-1 rounded-full bg-border-subtle" />
                      <span className="text-micro text-foreground-tertiary">Recruiter <span className="font-semibold text-foreground-secondary">{resume.recruiter}</span></span>
                    </div>
                  </div>
                  {resumeId === resume.id && (
                    <div className="w-5 h-5 rounded-full bg-primary flex items-center justify-center shrink-0">
                      <Check className="h-3 w-3 text-primary-foreground" />
                    </div>
                  )}
                </button>
              ))}
            </div>
          )}
        </MobileCard>

        {/* Resume tip */}
        <div className="mt-3 flex items-start gap-2.5 rounded-xl bg-primary/[0.06] px-3.5 py-3">
          <Lightbulb className="h-4 w-4 text-primary/60 shrink-0 mt-0.5" />
          <p className="text-caption text-foreground-secondary leading-snug">
            <span className="font-semibold">Tip:</span> Using a tailored resume increases your chances of getting an interview.
          </p>
        </div>
      </motion.div>

      {/* Section 3 — Interview Information */}
      <motion.div {...stagger(2)} className="px-5 mt-7">
        <SectionHeader title="Interview" />
        <MobileCard variant="elevated" padding="spacious" className="mt-3">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 rounded-lg bg-status-interview-bg flex items-center justify-center shrink-0">
                <Video className="h-4 w-4 text-status-interview" />
              </div>
              <div>
                <p className="text-body-medium text-foreground">Interview scheduled</p>
                <p className="text-caption text-foreground-tertiary">Add date and details</p>
              </div>
            </div>
            <Switch checked={interviewEnabled} onCheckedChange={setInterviewEnabled} />
          </div>

          {interviewEnabled && (
            <motion.div
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: "auto" }}
              transition={{ duration: 0.2 }}
              className="mt-5 space-y-4 border-t border-border-subtle pt-5"
            >
              {/* Interview date */}
              <div>
                <p className="text-caption text-foreground-tertiary mb-1.5 font-medium">Date *</p>
                <Popover>
                  <PopoverTrigger asChild>
                    <button className={cn(
                      "flex items-center gap-2.5 h-[52px] w-full rounded-xl border bg-surface-primary px-4 text-[15px] transition-all hover:border-primary/40",
                      errors.interviewDate ? "border-destructive" : "border-border",
                      "focus-within:ring-2 focus-within:ring-primary/25 focus-within:border-primary/60 focus-within:shadow-[0_0_0_3px_hsl(var(--primary)/0.08)]",
                      !interviewDate && "text-foreground-tertiary"
                    )}>
                      <CalendarIcon className="h-[18px] w-[18px] text-foreground-tertiary/70 shrink-0" />
                      {interviewDate ? format(interviewDate, "EEEE, MMM d, yyyy") : "Select interview date"}
                    </button>
                  </PopoverTrigger>
                  <PopoverContent className="w-auto p-0" align="start">
                    <Calendar
                      mode="single"
                      selected={interviewDate}
                      onSelect={(d) => { setInterviewDate(d); clearError("interviewDate"); }}
                      initialFocus
                      className="p-3 pointer-events-auto"
                      disabled={(d) => d < new Date(new Date().setHours(0, 0, 0, 0))}
                    />
                  </PopoverContent>
                </Popover>
                <FieldError msg={errors.interviewDate} />
              </div>

              {/* Interview time */}
              <div>
                <p className="text-caption text-foreground-tertiary mb-1.5 font-medium">Time *</p>
                <Select value={interviewTime} onValueChange={(v) => { setInterviewTime(v); clearError("interviewTime"); }}>
                  <SelectTrigger className={cn(
                    "h-[52px] rounded-xl bg-surface-primary text-[15px]",
                    errors.interviewTime ? "border-destructive" : "border-border"
                  )}>
                    <div className="flex items-center gap-2.5">
                      <Clock className="h-[18px] w-[18px] text-foreground-tertiary/70 shrink-0" />
                      <SelectValue placeholder="Select interview time" />
                    </div>
                  </SelectTrigger>
                  <SelectContent>
                    {timeSlots.map((t) => (
                      <SelectItem key={t.value} value={t.value}>{t.label}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
                <FieldError msg={errors.interviewTime} />
              </div>

              {/* Interview type */}
              <div>
                <p className="text-caption text-foreground-tertiary mb-2 font-medium">Type</p>
                <div className="flex gap-2.5">
                  {interviewTypes.map((t) => {
                    const Icon = t.icon;
                    return (
                      <button
                        key={t.value}
                        type="button"
                        onClick={() => setInterviewType(t.value)}
                        className={cn(
                          "flex-1 flex items-center justify-center gap-2 h-11 rounded-xl text-caption font-semibold transition-all active:scale-[0.97]",
                          interviewType === t.value
                            ? "bg-primary text-primary-foreground shadow-sm"
                            : "bg-surface-secondary text-foreground-secondary hover:bg-muted border border-transparent"
                        )}
                      >
                        <Icon className="h-4 w-4" />
                        {t.label}
                      </button>
                    );
                  })}
                </div>
              </div>
            </motion.div>
          )}
        </MobileCard>
      </motion.div>

      {/* Section 4 — Notes */}
      <motion.div {...stagger(3)} className="px-5 mt-7">
        <SectionHeader title="Notes" />
        <MobileCard variant="elevated" padding="spacious" className="mt-3">
          <p className="text-caption text-foreground-tertiary mb-1.5 font-medium">Additional details</p>
          <Textarea
            placeholder="Add any helpful details — referral contact, recruiter name, job posting link, team info…"
            value={notes}
            enterKeyHint="done"
            onFocus={(e) => setTimeout(() => e.target.scrollIntoView({ behavior: "smooth", block: "center" }), 300)}
            onChange={(e) => setNotes(e.target.value)}
            className="min-h-[140px]"
          />
        </MobileCard>
      </motion.div>

      {/* Section 5 — Save Action */}
      <div className="fixed bottom-[60px] left-1/2 -translate-x-1/2 w-full max-w-[430px] z-40 px-5 pb-5 pt-4 bg-gradient-to-t from-background via-background/95 to-transparent">
        <Button
          size="full"
          variant="premium"
          disabled={isLoading}
          onClick={handleSave}
          className="h-12 shadow-[0_4px_16px_hsl(var(--primary)/0.25)] active:scale-[0.97] transition-all duration-150"
        >
          {isLoading ? <Loader2 className="h-4 w-4 animate-spin mr-1.5" /> : null}
          {isLoading ? "Saving…" : "Save Application"}
        </Button>
        <button
          onClick={() => navigate(-1)}
          className="w-full mt-2.5 h-10 text-caption text-foreground-tertiary font-semibold hover:text-foreground transition-colors active:scale-[0.98]"
        >
          Cancel
        </button>
      </div>

      <BottomNav />
    </div>
  );
};

export default AddApplication;
