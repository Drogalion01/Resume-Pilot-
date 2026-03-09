import { useState } from "react";
import { motion } from "framer-motion";
import { Calendar as CalendarIcon, Clock, Globe, Link2, User, FileText, Bell, Loader2, AlertCircle } from "lucide-react";
import { format } from "date-fns";
import ScreenHeader from "@/components/ScreenHeader";
import MobileCard from "@/components/MobileCard";
import SectionHeader from "@/components/SectionHeader";
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

const timezones = [
  { value: "PST", label: "PST (UTC−8)" },
  { value: "MST", label: "MST (UTC−7)" },
  { value: "CST", label: "CST (UTC−6)" },
  { value: "EST", label: "EST (UTC−5)" },
  { value: "UTC", label: "UTC" },
  { value: "IST", label: "IST (UTC+5:30)" },
];

const timeSlots = Array.from({ length: 28 }, (_, i) => {
  const hour = Math.floor(i / 2) + 7;
  const min = i % 2 === 0 ? "00" : "30";
  const h12 = hour > 12 ? hour - 12 : hour;
  const ampm = hour >= 12 ? "PM" : "AM";
  return { value: `${String(hour).padStart(2, "0")}:${min}`, label: `${h12}:${min} ${ampm}` };
});

const stagger = (i: number) => ({ initial: { opacity: 0, y: 8 }, animate: { opacity: 1, y: 0 }, transition: { delay: i * 0.05 } });

const AddInterview = () => {
  const navigate = useNavigate();
  const { toast } = useToast();
  const [roundName, setRoundName] = useState("");
  const [interviewer, setInterviewer] = useState("");
  const [date, setDate] = useState<Date>();
  const [time, setTime] = useState("");
  const [timezone, setTimezone] = useState("PST");
  const [meetingLink, setMeetingLink] = useState("");
  const [notes, setNotes] = useState("");
  const [reminder, setReminder] = useState(true);
  const [isLoading, setIsLoading] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});

  const validate = () => {
    const errs: Record<string, string> = {};
    if (!roundName.trim()) errs.roundName = "Round name is required";
    if (!date) errs.date = "Date is required";
    if (!time) errs.time = "Time is required";
    if (meetingLink && !/^https?:\/\//.test(meetingLink)) errs.meetingLink = "Enter a valid URL starting with https://";
    setErrors(errs);
    return Object.keys(errs).length === 0;
  };

  const handleSave = () => {
    if (!validate()) return;
    setIsLoading(true);
    setTimeout(() => {
      setIsLoading(false);
      toast({ title: "Interview saved", description: `${roundName} on ${format(date!, "MMM d, yyyy")} at ${time}` });
      navigate(-1);
    }, 1200);
  };

  const FieldError = ({ msg }: { msg?: string }) => msg ? (
    <p className="text-micro text-destructive flex items-center gap-1 mt-1.5"><AlertCircle className="h-3 w-3" /> {msg}</p>
  ) : null;

  return (
    <div className="min-h-screen bg-background pb-36">
      <ScreenHeader title="Add Interview" subtitle="Schedule a new interview round" showBack />

      <motion.div {...stagger(0)} className="px-5 mt-2">
        <SectionHeader title="Details" />
        <div className="mt-2.5 space-y-3">
          <div>
            <Input leftIcon={<FileText />} placeholder="Round name *" value={roundName}
              onChange={(e) => { setRoundName(e.target.value); if (errors.roundName) setErrors(p => ({ ...p, roundName: "" })); }}
              className={errors.roundName ? "border-destructive focus:ring-destructive/20" : ""} />
            <FieldError msg={errors.roundName} />
          </div>
          <Input leftIcon={<User />} placeholder="Interviewer (optional)" value={interviewer} onChange={(e) => setInterviewer(e.target.value)} />
        </div>
      </motion.div>

      <motion.div {...stagger(1)} className="px-5 mt-5">
        <SectionHeader title="Schedule" />
        <div className="mt-2.5 space-y-3">
          <div>
            <Popover>
              <PopoverTrigger asChild>
                <button className={cn(
                  "flex items-center gap-2.5 h-[52px] w-full rounded-xl border bg-surface-primary px-4 text-[15px] transition-all",
                  errors.date ? "border-destructive" : "border-border",
                  "focus-within:ring-2 focus-within:ring-primary/25 focus-within:border-primary/60 focus-within:shadow-[0_0_0_3px_hsl(var(--primary)/0.08)]",
                  !date && "text-foreground-quaternary"
                )}>
                  <CalendarIcon className="h-[18px] w-[18px] text-foreground-tertiary shrink-0" />
                  {date ? format(date, "EEEE, MMM d, yyyy") : "Select date *"}
                </button>
              </PopoverTrigger>
              <PopoverContent className="w-auto p-0" align="start">
                <Calendar mode="single" selected={date} onSelect={(d) => { setDate(d); if (errors.date) setErrors(p => ({ ...p, date: "" })); }}
                  initialFocus className={cn("p-3 pointer-events-auto")} disabled={(d) => d < new Date(new Date().setHours(0, 0, 0, 0))} />
              </PopoverContent>
            </Popover>
            <FieldError msg={errors.date} />
          </div>

          <div className="grid grid-cols-5 gap-2.5">
            <div className="col-span-3">
              <Select value={time} onValueChange={(v) => { setTime(v); if (errors.time) setErrors(p => ({ ...p, time: "" })); }}>
                <SelectTrigger className={cn("h-[52px] rounded-xl bg-surface-primary text-[15px]", errors.time ? "border-destructive" : "border-border")}>
                  <div className="flex items-center gap-2">
                    <Clock className="h-[18px] w-[18px] text-foreground-tertiary shrink-0" />
                    <SelectValue placeholder="Time *" />
                  </div>
                </SelectTrigger>
                <SelectContent>
                  {timeSlots.map((t) => (<SelectItem key={t.value} value={t.value}>{t.label}</SelectItem>))}
                </SelectContent>
              </Select>
              <FieldError msg={errors.time} />
            </div>
            <div className="col-span-2">
              <Select value={timezone} onValueChange={setTimezone}>
                <SelectTrigger className="h-[52px] rounded-xl border-border bg-surface-primary text-[15px]">
                  <div className="flex items-center gap-2">
                    <Globe className="h-[18px] w-[18px] text-foreground-tertiary shrink-0" />
                    <SelectValue />
                  </div>
                </SelectTrigger>
                <SelectContent>
                  {timezones.map((tz) => (<SelectItem key={tz.value} value={tz.value}>{tz.label}</SelectItem>))}
                </SelectContent>
              </Select>
            </div>
          </div>
        </div>
      </motion.div>

      <motion.div {...stagger(2)} className="px-5 mt-5">
        <SectionHeader title="Meeting" />
        <div className="mt-2.5">
          <Input leftIcon={<Link2 />} placeholder="Meeting link (optional)" value={meetingLink}
            onChange={(e) => { setMeetingLink(e.target.value); if (errors.meetingLink) setErrors(p => ({ ...p, meetingLink: "" })); }}
            type="url" className={errors.meetingLink ? "border-destructive focus:ring-destructive/20" : ""} />
          <FieldError msg={errors.meetingLink} />
        </div>
      </motion.div>

      <motion.div {...stagger(3)} className="px-5 mt-5">
        <SectionHeader title="Notes" />
        <div className="mt-2.5">
          <Textarea placeholder="Prep notes, topics to review, questions to ask…" value={notes} onChange={(e) => setNotes(e.target.value)}
            className="min-h-[100px]" />
        </div>
      </motion.div>

      <motion.div {...stagger(4)} className="px-5 mt-5">
        <MobileCard variant="outlined" padding="compact">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 rounded-lg bg-primary-light flex items-center justify-center">
                <Bell className="h-4 w-4 text-primary" />
              </div>
              <div>
                <p className="text-body-medium text-foreground">Reminder</p>
                <p className="text-caption text-foreground-tertiary">30 min before interview</p>
              </div>
            </div>
            <Switch checked={reminder} onCheckedChange={setReminder} />
          </div>
        </MobileCard>
      </motion.div>

      <div className="fixed bottom-[60px] left-1/2 -translate-x-1/2 w-full max-w-[430px] z-40 px-5 pb-5 pt-3 bg-gradient-to-t from-background via-background to-transparent">
        <Button size="full" variant="premium" disabled={isLoading} onClick={handleSave}>
          {isLoading ? <Loader2 className="h-4 w-4 animate-spin mr-1.5" /> : null}
          {isLoading ? "Saving…" : "Save Interview"}
        </Button>
      </div>

      <BottomNav />
    </div>
  );
};

export default AddInterview;
