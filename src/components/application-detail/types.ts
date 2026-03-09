import { type AppStatus } from "@/components/StatusBadge";

export interface ApplicationData {
  id: string;
  company_name: string;
  role: string;
  status: AppStatus;
  applied_date: string;
  source: string | null;
  location: string | null;
  recruiter_name: string | null;
}

export interface TimelineEvent {
  id: string;
  type: string;
  title: string;
  metadata: string;
  timestamp: string;
}

export interface Interview {
  id: string;
  round_name: string;
  interview_type: "phone" | "video" | "onsite";
  date: string;
  time: string;
  interviewer_name: string | null;
  status: "scheduled" | "completed" | "rescheduled";
}

export interface Reminder {
  id: string;
  title: string;
  scheduled_for: string;
  is_enabled: boolean;
}

export interface ResumeVersion {
  id: string;
  name: string;
  ats_score: number;
  recruiter_score: number;
  updated_at: string;
}

export interface ApplicationNotes {
  text: string;
  updated_at: string;
}
