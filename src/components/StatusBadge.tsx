import React from "react";
import { Badge } from "@/components/ui/badge";
import { cn } from "@/lib/utils";

export type AppStatus = "saved" | "applied" | "assessment" | "hr" | "technical" | "final" | "offer" | "rejected";

const statusLabels: Record<AppStatus, string> = {
  saved: "Saved",
  applied: "Applied",
  assessment: "OA/Assessment",
  hr: "HR Interview",
  technical: "Technical",
  final: "Final Round",
  offer: "Offer",
  rejected: "Rejected",
};

interface StatusBadgeProps {
  status: AppStatus;
  size?: "default" | "sm" | "lg" | "pill";
  className?: string;
}

const StatusBadge: React.FC<StatusBadgeProps> = ({ status, size = "pill", className }) => {
  return (
    <Badge variant={status as any} size={size} className={cn(className)}>
      {statusLabels[status]}
    </Badge>
  );
};

export default StatusBadge;
