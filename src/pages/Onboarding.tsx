import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import { ArrowRight, FileText, BarChart3, Layers, Target } from "lucide-react";
import { Button } from "@/components/ui/button";

const steps = [
  {
    icon: FileText,
    badge: "Upload",
    title: "Your resume,\nanalyzed instantly",
    description: "Upload or paste any resume and get detailed, actionable feedback in seconds.",
  },
  {
    icon: BarChart3,
    badge: "Score",
    title: "Two scores\nthat matter",
    description: "See how your resume performs with ATS systems and what recruiters actually notice.",
  },
  {
    icon: Layers,
    badge: "Versions",
    title: "One resume\nwon't cut it",
    description: "Save tailored versions for each role. The right resume for the right job, every time.",
  },
  {
    icon: Target,
    badge: "Track",
    title: "Every application,\norganized",
    description: "Track where you applied, interview schedules, and follow-ups — all in one calm space.",
  },
];

const slideVariants = {
  enter: { opacity: 0, x: 40 },
  center: { opacity: 1, x: 0 },
  exit: { opacity: 0, x: -40 },
};

const Onboarding = () => {
  const [step, setStep] = useState(0);
  const navigate = useNavigate();
  const current = steps[step];
  const isLast = step === steps.length - 1;

  const handleNext = () => {
    if (isLast) navigate("/signup");
    else setStep(step + 1);
  };

  return (
    <div className="min-h-screen bg-background flex flex-col overflow-hidden">
      {/* Top bar */}
      <div className="flex items-center justify-between px-5 pt-14">
        <div className="flex items-center gap-1.5">
          <div className="w-7 h-7 rounded-lg bg-primary flex items-center justify-center">
            <span className="text-[11px] font-extrabold text-primary-foreground">R</span>
          </div>
          <span className="text-body-medium text-foreground">ResumePilot</span>
        </div>
        <button
          onClick={() => navigate("/signup")}
          className="text-caption text-foreground-tertiary press-scale"
        >
          Skip
        </button>
      </div>

      {/* Content area */}
      <div className="flex-1 flex flex-col justify-center px-7 py-8">
        <AnimatePresence mode="wait">
          <motion.div
            key={step}
            variants={slideVariants}
            initial="enter"
            animate="center"
            exit="exit"
            transition={{ duration: 0.3, ease: [0.25, 0.1, 0.25, 1] }}
            className="space-y-6"
          >
            {/* Icon badge */}
            <div className="flex items-center gap-2.5">
              <div className="w-11 h-11 rounded-xl bg-primary-light flex items-center justify-center">
                <current.icon className="w-5 h-5 text-primary" />
              </div>
              <span className="text-caption text-primary font-semibold bg-primary-light px-2.5 py-1 rounded-md">
                {current.badge}
              </span>
            </div>

            {/* Headline */}
            <h2 className="text-[26px] leading-[32px] font-extrabold text-foreground tracking-tight whitespace-pre-line">
              {current.title}
            </h2>

            {/* Description */}
            <p className="text-body text-foreground-tertiary leading-relaxed max-w-[300px]">
              {current.description}
            </p>
          </motion.div>
        </AnimatePresence>
      </div>

      {/* Bottom area */}
      <div className="px-6 pb-12 space-y-6">
        {/* Progress dots */}
        <div className="flex items-center gap-2">
          {steps.map((_, i) => (
            <button
              key={i}
              onClick={() => setStep(i)}
              className={`h-[5px] rounded-full transition-all duration-300 ${
                i === step
                  ? "w-8 bg-primary"
                  : i < step
                  ? "w-[5px] bg-primary/40"
                  : "w-[5px] bg-border"
              }`}
            />
          ))}
        </div>

        {/* CTA */}
        <Button variant="premium" size="full" onClick={handleNext}>
          {isLast ? "Create Account" : "Continue"}
          <ArrowRight className="ml-1 h-4 w-4" />
        </Button>
      </div>
    </div>
  );
};

export default Onboarding;
