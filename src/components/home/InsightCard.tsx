import React from "react";
import { TrendingUp, Sparkles, ArrowUpRight } from "lucide-react";
import MobileCard from "@/components/MobileCard";

interface Insight {
  icon: "trending" | "spark" | "arrow";
  text: string;
}

interface InsightCardProps {
  insight?: Insight;
}

const icons = {
  trending: TrendingUp,
  spark: Sparkles,
  arrow: ArrowUpRight,
};

const InsightCard: React.FC<InsightCardProps> = ({ insight }) => {
  if (!insight) return null;

  const Icon = icons[insight.icon];

  return (
    <div className="px-5">
      <MobileCard variant="default" padding="compact" className="flex items-center gap-3">
        <div className="w-8 h-8 rounded-lg bg-gold-light flex items-center justify-center shrink-0">
          <Icon className="h-3.5 w-3.5 text-gold" />
        </div>
        <p className="text-caption text-foreground-secondary flex-1">{insight.text}</p>
      </MobileCard>
    </div>
  );
};

export default InsightCard;
