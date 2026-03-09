import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import {
  ArrowLeft, Pencil, Camera, FileText, Briefcase, CalendarCheck,
  Lock, ShieldCheck, LogOut, Trash2, AlertCircle, WifiOff, Loader2, Check, X, ChevronRight,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import MobileCard from "@/components/MobileCard";
import ListItem from "@/components/ListItem";
import { useToast } from "@/hooks/use-toast";
import { useSimulatedLoad } from "@/hooks/use-simulated-load";
import { Skeleton } from "@/components/ui/skeleton";

type ProfileError = "network" | "validation" | null;

const stagger = (i: number) => ({
  initial: { opacity: 0, y: 6 },
  animate: { opacity: 1, y: 0 },
  transition: { delay: i * 0.05 },
});

// Mock data — maps to GET /user/profile
const mockProfile = {
  name: "Alex Johnson",
  email: "alex.johnson@email.com",
  createdAt: "January 12, 2025",
  totalResumes: 4,
  totalApplications: 12,
  activeInterviews: 3,
};

const UserProfile = () => {
  const navigate = useNavigate();
  const { toast } = useToast();
  const { isLoading: pageLoading } = useSimulatedLoad(500);

  const [isEditing, setIsEditing] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const [profileError, setProfileError] = useState<ProfileError>(null);
  const [editName, setEditName] = useState(mockProfile.name);
  const [nameError, setNameError] = useState("");

  const handleSave = () => {
    if (!editName.trim()) {
      setNameError("Name is required");
      return;
    }
    if (editName.trim().length < 2) {
      setNameError("Name must be at least 2 characters");
      return;
    }
    setNameError("");
    setIsSaving(true);
    setProfileError(null);

    // Simulate PATCH /user/profile
    setTimeout(() => {
      setIsSaving(false);
      setIsEditing(false);
      toast({ title: "Profile updated", description: "Your changes have been saved." });
    }, 1000);
  };

  const handleCancel = () => {
    setIsEditing(false);
    setEditName(mockProfile.name);
    setNameError("");
    setProfileError(null);
  };

  if (pageLoading) {
    return (
      <div className="min-h-screen bg-background">
        <div className="hero-gradient relative overflow-hidden rounded-b-3xl px-5 pt-14 pb-16">
          <div className="flex items-center gap-3">
            <Skeleton className="w-9 h-9 rounded-xl" />
            <Skeleton className="h-5 w-24 rounded-md" />
          </div>
          <div className="flex flex-col items-center mt-6 gap-3">
            <Skeleton className="w-20 h-20 rounded-full" />
            <Skeleton className="h-5 w-32 rounded-md" />
            <Skeleton className="h-3 w-40 rounded-md" />
          </div>
        </div>
        <div className="px-5 -mt-4 space-y-4">
          <Skeleton className="h-40 w-full rounded-xl" />
          <Skeleton className="h-24 w-full rounded-xl" />
        </div>
      </div>
    );
  }

  const statItems = [
    { icon: FileText, label: "Resumes", value: mockProfile.totalResumes, bg: "bg-primary-light", color: "text-primary" },
    { icon: Briefcase, label: "Applications", value: mockProfile.totalApplications, bg: "bg-status-applied-bg", color: "text-status-applied" },
    { icon: CalendarCheck, label: "Interviews", value: mockProfile.activeInterviews, bg: "bg-status-interview-bg", color: "text-status-interview" },
  ];

  return (
    <div className="min-h-screen bg-background pb-10">
      {/* Hero header */}
      <div className="hero-gradient relative overflow-hidden rounded-b-3xl px-5 pt-14 pb-16">
        <motion.div {...stagger(0)} className="relative z-10">
          {/* Top bar */}
          <div className="flex items-center justify-between">
            <button
              onClick={() => navigate("/settings")}
              className="w-9 h-9 rounded-xl bg-card/80 backdrop-blur-sm flex items-center justify-center shadow-sm active:scale-[0.98] transition-transform"
            >
              <ArrowLeft className="h-4 w-4 text-foreground" />
            </button>
            <span className="text-body-medium text-foreground">Profile</span>
            {!isEditing ? (
              <button
                onClick={() => setIsEditing(true)}
                className="w-9 h-9 rounded-xl bg-card/80 backdrop-blur-sm flex items-center justify-center shadow-sm active:scale-[0.98] transition-transform"
              >
                <Pencil className="h-4 w-4 text-primary" />
              </button>
            ) : (
              <div className="w-9" />
            )}
          </div>

          {/* Avatar & info */}
          <div className="flex flex-col items-center mt-6">
            <div className="relative">
              <div className="w-20 h-20 rounded-full bg-primary-light flex items-center justify-center shadow-elevated">
                <span className="text-2xl font-bold text-primary">
                  {mockProfile.name.split(" ").map((n) => n[0]).join("")}
                </span>
              </div>
              {isEditing && (
                <button className="absolute -bottom-1 -right-1 w-7 h-7 rounded-full bg-primary flex items-center justify-center shadow-sm active:scale-[0.98] transition-transform">
                  <Camera className="h-3.5 w-3.5 text-primary-foreground" />
                </button>
              )}
            </div>
            <h1 className="text-headline text-foreground mt-3">{mockProfile.name}</h1>
            <p className="text-caption text-foreground-secondary mt-0.5">{mockProfile.email}</p>
          </div>
        </motion.div>
      </div>

      {/* Profile Information Card */}
      <motion.div {...stagger(1)} className="px-5 -mt-4 relative z-20">
        <MobileCard variant="elevated" padding="spacious">
          {/* Error banner inside card */}
          {profileError === "network" && (
            <motion.div
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: "auto" }}
              className="flex items-start gap-2.5 bg-score-average-bg rounded-xl px-3.5 py-3 mb-4"
            >
              <WifiOff className="h-4 w-4 text-score-average shrink-0 mt-0.5" />
              <div>
                <p className="text-caption text-score-average font-semibold">Connection failed</p>
                <p className="text-micro text-foreground-tertiary mt-0.5">Please check your internet and try again.</p>
              </div>
            </motion.div>
          )}

          <p className="text-overline text-foreground-tertiary tracking-[0.08em] mb-4">PROFILE INFORMATION</p>

          {isEditing ? (
            <div className="space-y-4">
              <div>
                <label className="text-caption text-foreground-secondary mb-1.5 block">Full Name</label>
                <Input
                  value={editName}
                  onChange={(e) => {
                    setEditName(e.target.value);
                    if (nameError) setNameError("");
                  }}
                  placeholder="Your name"
                  className={nameError ? "border-destructive focus-within:ring-destructive/20" : ""}
                />
                {nameError && (
                  <p className="text-micro text-destructive flex items-center gap-1 mt-1.5">
                    <AlertCircle className="h-3 w-3" /> {nameError}
                  </p>
                )}
              </div>
              <div>
                <label className="text-caption text-foreground-secondary mb-1.5 block">Email</label>
                <Input value={mockProfile.email} disabled className="opacity-50" />
                <p className="text-micro text-foreground-quaternary mt-1.5">Email can be changed in account settings.</p>
              </div>
              <div>
                <label className="text-caption text-foreground-secondary mb-1.5 block">Member Since</label>
                <Input value={mockProfile.createdAt} disabled className="opacity-50" />
              </div>
              <div className="flex gap-3 pt-1">
                <Button variant="outline" size="default" className="flex-1" onClick={handleCancel} disabled={isSaving}>
                  <X className="h-4 w-4 mr-1" /> Cancel
                </Button>
                <Button variant="premium" size="default" className="flex-1" onClick={handleSave} disabled={isSaving}>
                  {isSaving ? <Loader2 className="h-4 w-4 animate-spin mr-1" /> : <Check className="h-4 w-4 mr-1" />}
                  {isSaving ? "Saving…" : "Save"}
                </Button>
              </div>
            </div>
          ) : (
            <div className="space-y-4">
              <ProfileField label="Full Name" value={mockProfile.name} />
              <ProfileField label="Email Address" value={mockProfile.email} />
              <ProfileField label="Member Since" value={mockProfile.createdAt} />
            </div>
          )}
        </MobileCard>
      </motion.div>

      {/* Account Stats Card */}
      <motion.div {...stagger(2)} className="px-5 mt-4">
        <MobileCard variant="elevated" padding="spacious">
          <p className="text-overline text-foreground-tertiary tracking-[0.08em] mb-4">ACCOUNT ACTIVITY</p>
          <div className="grid grid-cols-3 gap-3">
            {statItems.map((item) => (
              <div key={item.label} className="flex flex-col items-center gap-2 py-3 rounded-xl bg-surface-secondary">
                <div className={`w-9 h-9 rounded-lg ${item.bg} flex items-center justify-center`}>
                  <item.icon className={`h-4 w-4 ${item.color}`} />
                </div>
                <span className="text-headline text-foreground">{item.value}</span>
                <span className="text-micro text-foreground-quaternary">{item.label}</span>
              </div>
            ))}
          </div>
        </MobileCard>
      </motion.div>

      {/* Security Card */}
      <motion.div {...stagger(3)} className="px-5 mt-4">
        <MobileCard variant="elevated" padding="none" className="divide-y divide-border-subtle overflow-hidden">
          <p className="text-overline text-foreground-tertiary tracking-[0.08em] px-4 pt-4 pb-2">SECURITY</p>
          <div className="px-4">
            <ListItem
              icon={<Lock className="text-primary" />}
              iconBg="bg-primary-light"
              title="Change Password"
              subtitle="Update your account password"
              trailing={<ChevronRight className="h-4 w-4 text-foreground-quaternary" />}
              onClick={() => navigate("/change-password")}
            />
          </div>
          <div className="px-4 opacity-60">
            <ListItem
              icon={<ShieldCheck className="text-status-interview" />}
              iconBg="bg-status-interview-bg"
              title="Two-Factor Authentication"
              subtitle="Coming soon"
            />
          </div>
        </MobileCard>
      </motion.div>

      {/* Account Actions */}
      <motion.div {...stagger(4)} className="px-5 mt-6 space-y-1">
        <button
          onClick={() => toast({ title: "Signed out" })}
          className="flex items-center gap-3.5 w-full px-4 py-3.5 rounded-xl hover:bg-destructive-light active:scale-[0.98] transition-all"
        >
          <LogOut className="h-4 w-4 text-destructive" />
          <span className="text-body-medium text-destructive">Sign Out</span>
        </button>
        <button
          onClick={() => toast({ title: "This action requires confirmation", variant: "destructive" })}
          className="flex items-center gap-3.5 w-full px-4 py-3.5 rounded-xl hover:bg-muted active:scale-[0.98] transition-all"
        >
          <Trash2 className="h-4 w-4 text-foreground-quaternary" />
          <span className="text-body-medium text-foreground-quaternary">Delete Account</span>
        </button>
      </motion.div>
    </div>
  );
};

const ProfileField = ({ label, value }: { label: string; value: string }) => (
  <div>
    <p className="text-caption text-foreground-quaternary mb-0.5">{label}</p>
    <p className="text-body text-foreground">{value}</p>
  </div>
);

export default UserProfile;
