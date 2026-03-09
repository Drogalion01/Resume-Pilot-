import type { ApplicationData, TimelineEvent, Interview, Reminder, ResumeVersion, ApplicationNotes } from "./types";

export const mockApplication: ApplicationData = {
  id: "1",
  company_name: "Google",
  role: "Software Engineer",
  status: "technical",
  applied_date: "Mar 5, 2026",
  source: "Referral",
  location: "Mountain View, CA",
  recruiter_name: "Emily Chen",
};

export const mockTimeline: TimelineEvent[] = [
  { id: "t1", type: "created", title: "Application created", metadata: "Via referral from Sarah", timestamp: "Mar 5, 2026" },
  { id: "t2", type: "resume", title: "Resume attached", metadata: "Software Engineer v2", timestamp: "Mar 5, 2026" },
  { id: "t3", type: "hr", title: "HR screening completed", metadata: "30 min call with Emily", timestamp: "Mar 8, 2026" },
  { id: "t4", type: "interview", title: "Technical interview scheduled", metadata: "System design + coding", timestamp: "Mar 15, 2026" },
  { id: "t5", type: "reminder", title: "Follow-up reminder set", metadata: "Send thank-you email", timestamp: "Mar 16, 2026" },
];

export const mockInterviews: Interview[] = [
  { id: "i1", round_name: "HR Screening", interview_type: "phone", date: "Mar 8, 2026", time: "10:00 AM", interviewer_name: "Emily Chen", status: "completed" },
  { id: "i2", round_name: "Technical Round", interview_type: "video", date: "Mar 15, 2026", time: "2:00 PM", interviewer_name: "Alex Park", status: "scheduled" },
];

export const mockReminders: Reminder[] = [
  { id: "r1", title: "Send thank-you email", scheduled_for: "Mar 16, 2026", is_enabled: true },
  { id: "r2", title: "Follow up on status", scheduled_for: "Mar 22, 2026", is_enabled: true },
];

export const mockResume: ResumeVersion = {
  id: "1",
  name: "Software Engineer v2",
  ats_score: 78,
  recruiter_score: 85,
  updated_at: "Mar 3, 2026",
};

export const mockNotes: ApplicationNotes = {
  text: "Referred by Sarah from the Cloud team. Recruiter mentioned they're looking for strong systems design skills. Salary range discussed: $180k–$220k. Follow up after technical round with thank-you note.",
  updated_at: "Mar 10, 2026",
};
