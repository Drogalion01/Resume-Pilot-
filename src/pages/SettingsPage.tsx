import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { User, Mail, Bell, BellRing, Shield, HelpCircle, LogOut, ChevronRight, Smartphone, Trash2, FileText, Loader2, Moon, Sun, Monitor } from "lucide-react";
import { useTheme } from "@/hooks/use-theme";
import ScreenHeader from "@/components/ScreenHeader";
import MobileCard from "@/components/MobileCard";
import ListItem from "@/components/ListItem";
import BottomNav from "@/components/BottomNav";
import { Switch } from "@/components/ui/switch";
import { useToast } from "@/hooks/use-toast";
import { useSimulatedLoad } from "@/hooks/use-simulated-load";
import { Skeleton } from "@/components/ui/skeleton";

const stagger = (i: number) => ({ initial: { opacity: 0, y: 6 }, animate: { opacity: 1, y: 0 }, transition: { delay: i * 0.05 } });

const SettingsPage = () => {
  const navigate = useNavigate();
  const { toast } = useToast();
  const { isLoading } = useSimulatedLoad(600);
  const [emailWeekly, setEmailWeekly] = useState(true);
  const [emailTips, setEmailTips] = useState(false);
  const [reminderInterview, setReminderInterview] = useState(true);
  const [reminderFollowUp, setReminderFollowUp] = useState(true);
  const [reminderDeadline, setReminderDeadline] = useState(false);
  const [savingToggle, setSavingToggle] = useState<string | null>(null);

  const handleToggle = (key: string, setter: (v: boolean) => void, value: boolean) => {
    setSavingToggle(key);
    setter(value);
    setTimeout(() => {
      setSavingToggle(null);
      toast({ title: "Preference updated" });
    }, 600);
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background pb-24">
        <ScreenHeader title="Settings" />
        <div className="px-5 mt-2">
          <div className="bg-card rounded-xl p-4 shadow-card flex items-center gap-4">
            <Skeleton className="w-14 h-14 rounded-xl" />
            <div className="flex-1 space-y-2"><Skeleton className="h-5 w-32 rounded-md" /><Skeleton className="h-3 w-40 rounded-md" /></div>
          </div>
        </div>
        <div className="px-5 mt-8 space-y-3">
          <Skeleton className="h-4 w-32 rounded-md" />
          <Skeleton className="h-16 w-full rounded-xl" />
          <Skeleton className="h-16 w-full rounded-xl" />
        </div>
        <BottomNav />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background pb-24">
      <ScreenHeader title="Settings" />

      {/* Profile Card */}
      <motion.div {...stagger(0)} className="px-5 mt-2">
        <MobileCard onClick={() => navigate("/profile")} className="flex items-center gap-4">
          <div className="w-14 h-14 rounded-xl bg-primary-light flex items-center justify-center">
            <User className="h-6 w-6 text-primary" />
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-headline text-foreground">Alex Johnson</p>
            <p className="text-caption text-foreground-quaternary truncate mt-0.5">alex.johnson@email.com</p>
          </div>
          <ChevronRight className="h-4 w-4 text-foreground-quaternary shrink-0" />
        </MobileCard>
      </motion.div>

      {/* Email Preferences */}
      <motion.div {...stagger(1)} className="px-5 mt-8">
        <p className="text-overline text-foreground-tertiary mb-3 px-1 tracking-[0.08em]">EMAIL PREFERENCES</p>
        <MobileCard padding="none" className="divide-y divide-border-subtle">
          <ToggleRow icon={<Mail className="text-foreground-tertiary" />} iconBg="bg-status-applied-bg" title="Weekly Summary" subtitle="Resume scores & application stats"
            checked={emailWeekly} onChange={(v) => handleToggle("weekly", setEmailWeekly, v)} saving={savingToggle === "weekly"} />
          <ToggleRow icon={<FileText className="text-foreground-tertiary" />} iconBg="bg-primary-light" title="Resume Tips" subtitle="AI-powered improvement suggestions"
            checked={emailTips} onChange={(v) => handleToggle("tips", setEmailTips, v)} saving={savingToggle === "tips"} />
        </MobileCard>
      </motion.div>

      {/* Reminders */}
      <motion.div {...stagger(2)} className="px-5 mt-8">
        <p className="text-overline text-foreground-tertiary mb-3 px-1 tracking-[0.08em]">REMINDERS</p>
        <MobileCard padding="none" className="divide-y divide-border-subtle">
          <ToggleRow icon={<BellRing className="text-status-interview" />} iconBg="bg-status-interview-bg" title="Interview Reminders" subtitle="30 min before scheduled interviews"
            checked={reminderInterview} onChange={(v) => handleToggle("interview", setReminderInterview, v)} saving={savingToggle === "interview"} />
          <ToggleRow icon={<Bell className="text-gold" />} iconBg="bg-gold-light" title="Follow-up Nudges" subtitle="Remind to follow up after 5 days"
            checked={reminderFollowUp} onChange={(v) => handleToggle("followup", setReminderFollowUp, v)} saving={savingToggle === "followup"} />
          <ToggleRow icon={<Smartphone className="text-status-applied" />} iconBg="bg-status-applied-bg" title="Deadline Alerts" subtitle="Application deadline notifications"
            checked={reminderDeadline} onChange={(v) => handleToggle("deadline", setReminderDeadline, v)} saving={savingToggle === "deadline"} />
        </MobileCard>
      </motion.div>

      {/* Appearance */}
      <AppearanceSection stagger={stagger} />

      {/* Account */}
      <motion.div {...stagger(4)} className="px-5 mt-8">
        <p className="text-overline text-foreground-tertiary mb-3 px-1 tracking-[0.08em]">ACCOUNT</p>
        <MobileCard padding="none" className="divide-y divide-border-subtle overflow-hidden">
          <div className="px-4"><ListItem icon={<Shield className="text-foreground-tertiary" />} title="Privacy & Data" subtitle="Manage your data" trailing={<ChevronRight className="h-4 w-4 text-foreground-quaternary" />} onClick={() => {}} /></div>
          <div className="px-4"><ListItem icon={<HelpCircle className="text-foreground-tertiary" />} title="Help & Support" subtitle="FAQ and contact" trailing={<ChevronRight className="h-4 w-4 text-foreground-quaternary" />} onClick={() => {}} /></div>
        </MobileCard>
      </motion.div>

      {/* Danger Zone */}
      <motion.div {...stagger(5)} className="px-5 mt-8 space-y-1">
        <button onClick={() => toast({ title: "Signed out" })} className="flex items-center gap-3.5 w-full px-4 py-3.5 rounded-xl hover:bg-destructive-light active:scale-[0.98] transition-all">
          <LogOut className="h-4 w-4 text-destructive" />
          <span className="text-body-medium text-destructive">Sign Out</span>
        </button>
        <button onClick={() => toast({ title: "This action requires confirmation", variant: "destructive" })} className="flex items-center gap-3.5 w-full px-4 py-3.5 rounded-xl hover:bg-muted active:scale-[0.98] transition-all">
          <Trash2 className="h-4 w-4 text-foreground-quaternary" />
          <span className="text-body-medium text-foreground-quaternary">Delete Account</span>
        </button>
      </motion.div>

      <motion.div {...stagger(6)} className="px-5 mt-10 mb-4 text-center">
        <p className="text-caption text-foreground-quaternary">ResumePilot v1.0.0</p>
      </motion.div>

      <BottomNav />
    </div>
  );
};

const ToggleRow = ({ icon, iconBg = "bg-muted", title, subtitle, checked, onChange, saving }: {
  icon: React.ReactNode; iconBg?: string; title: string; subtitle: string; checked: boolean; onChange: (v: boolean) => void; saving?: boolean;
}) => (
  <div className="flex items-center gap-3.5 px-4 py-4 active:bg-muted/50 transition-colors">
    <div className={`w-9 h-9 rounded-lg ${iconBg} flex items-center justify-center shrink-0 [&_svg]:size-4`}>{icon}</div>
    <div className="flex-1 min-w-0">
      <p className="text-body-medium text-foreground">{title}</p>
      <p className="text-caption text-foreground-tertiary mt-0.5">{subtitle}</p>
    </div>
    <div className="shrink-0 ml-2">
      {saving ? <Loader2 className="h-4 w-4 text-primary animate-spin" /> : <Switch checked={checked} onCheckedChange={onChange} />}
    </div>
  </div>
);

const AppearanceSection = ({ stagger }: { stagger: (i: number) => object }) => {
  const { theme, setTheme } = useTheme();

  const themeOptions = [
    { value: "light" as const, label: "Light", icon: Sun },
    { value: "dark" as const, label: "Dark", icon: Moon },
    { value: "system" as const, label: "System", icon: Monitor },
  ];

  return (
    <motion.div {...stagger(3)} className="px-5 mt-8">
      <p className="text-overline text-foreground-tertiary mb-3 px-1 tracking-[0.08em]">APPEARANCE</p>
      <MobileCard padding="none" className="p-1.5">
        <div className="grid grid-cols-3 gap-1.5">
          {themeOptions.map((opt) => {
            const isActive = theme === opt.value;
            return (
              <button
                key={opt.value}
                onClick={() => setTheme(opt.value)}
                className={`flex flex-col items-center gap-1.5 py-3.5 rounded-lg transition-all active:scale-[0.97] ${
                  isActive ? "bg-primary-light" : "bg-transparent hover:bg-muted"
                }`}
              >
                <opt.icon className={`h-5 w-5 ${isActive ? "text-primary" : "text-foreground-tertiary"}`} />
                <span className={`text-caption ${isActive ? "text-primary font-semibold" : "text-foreground-tertiary"}`}>
                  {opt.label}
                </span>
              </button>
            );
          })}
        </div>
      </MobileCard>
    </motion.div>
  );
};

export default SettingsPage;
