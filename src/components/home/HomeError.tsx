import React from "react";
import { AlertCircle, RefreshCw } from "lucide-react";
import MobileCard from "@/components/MobileCard";

interface HomeErrorProps {
  onRetry: () => void;
}

const HomeError: React.FC<HomeErrorProps> = ({ onRetry }) => (
  <div className="flex flex-col items-center justify-center min-h-[60vh] px-8">
    <MobileCard variant="sunken" className="flex flex-col items-center text-center py-10 px-6">
      <div className="w-14 h-14 rounded-2xl bg-destructive-light flex items-center justify-center mb-4">
        <AlertCircle className="h-6 w-6 text-destructive" />
      </div>
      <h3 className="text-title text-foreground mb-1">Something went wrong</h3>
      <p className="text-body text-foreground-tertiary max-w-[240px]">
        We couldn't load your dashboard. Check your connection and try again.
      </p>
      <button
        onClick={onRetry}
        className="mt-5 flex items-center gap-2 px-5 py-2.5 bg-primary text-primary-foreground rounded-xl text-caption font-semibold press-scale shadow-sm"
      >
        <RefreshCw className="h-3.5 w-3.5" />
        Retry
      </button>
    </MobileCard>
  </div>
);

export default HomeError;
