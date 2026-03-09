import React from "react";
import { Upload, Plus, Calendar } from "lucide-react";
import type { NavigateFunction } from "react-router-dom";

interface QuickActionsProps {
  navigate: NavigateFunction;
}

const actions = [
  { label: "Upload Resume", icon: Upload, path: "/upload" },
  { label: "Add Application", icon: Plus, path: "/applications/add" },
  { label: "Add Interview", icon: Calendar, path: "/applications/add" },
];

const QuickActions: React.FC<QuickActionsProps> = ({ navigate }) => (
  <div className="px-5">
    <div className="flex gap-2.5 overflow-x-auto no-scrollbar pb-0.5">
      {actions.map((action) => (
          <button
          key={action.label}
          onClick={() => navigate(action.path)}
          className="flex items-center gap-2.5 px-4 py-3 bg-card rounded-xl shadow-card whitespace-nowrap press-scale shrink-0 border border-border-subtle/50"
        >
          <div className="w-8 h-8 rounded-lg bg-primary-light flex items-center justify-center">
            <action.icon className="h-4 w-4 text-primary" />
          </div>
          <span className="text-caption text-foreground font-semibold">{action.label}</span>
        </button>
      ))}
    </div>
  </div>
);

export default QuickActions;
