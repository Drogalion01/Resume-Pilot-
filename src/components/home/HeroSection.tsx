import React from "react";

interface HeroSectionProps {
  userName: string;
  userInitials: string;
  interviewsThisWeek: number;
  pendingOffers: number;
}

const HeroSection: React.FC<HeroSectionProps> = ({
  userName,
  userInitials,
  interviewsThisWeek,
  pendingOffers,
}) => {
  const greeting = (() => {
    const h = new Date().getHours();
    if (h < 12) return "Good morning";
    if (h < 18) return "Good afternoon";
    return "Good evening";
  })();

  const hasSummary = interviewsThisWeek > 0 || pendingOffers > 0;

  return (
    <div className="hero-gradient relative overflow-hidden rounded-b-3xl px-5 pt-14 pb-7">
      <div className="relative z-10 flex items-start justify-between">
        <div>
          <p className="text-caption text-foreground-secondary">{greeting}</p>
          <h1 className="text-display text-foreground mt-1">{userName}</h1>
        </div>
        <div className="relative mt-1">
          <div className="absolute -inset-3 rounded-2xl bg-primary/8 blur-xl" />
          <div className="relative w-11 h-11 rounded-xl bg-card/85 backdrop-blur-md flex items-center justify-center shadow-sm border border-border-subtle/50">
            <span className="text-body-medium font-bold text-primary">{userInitials}</span>
          </div>
        </div>
      </div>

      {hasSummary && (
        <p className="relative z-10 text-body text-foreground-secondary mt-2">
          You have{" "}
          {interviewsThisWeek > 0 && (
            <span className="text-foreground font-semibold">
              {interviewsThisWeek} interview{interviewsThisWeek > 1 ? "s" : ""} this week
            </span>
          )}
          {interviewsThisWeek > 0 && pendingOffers > 0 && " and "}
          {pendingOffers > 0 && (
            <span className="text-foreground font-semibold">
              {pendingOffers} offer{pendingOffers > 1 ? "s" : ""} pending
            </span>
          )}
          .
        </p>
      )}
    </div>
  );
};

export default HeroSection;
