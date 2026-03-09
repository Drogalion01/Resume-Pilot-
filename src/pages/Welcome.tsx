import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";

const Welcome = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-background flex flex-col">
      {/* Top section — brand mark + hero */}
      <div className="flex-1 flex flex-col items-center justify-center px-8">
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.5, ease: [0.25, 0.1, 0.25, 1] }}
          className="flex flex-col items-center text-center"
        >
          {/* Brand Mark */}
          <div className="relative mb-10">
            <div className="w-[72px] h-[72px] rounded-[22px] bg-primary flex items-center justify-center shadow-lg">
              <span className="text-[28px] font-extrabold text-primary-foreground tracking-tight">R</span>
            </div>
            <div className="absolute -bottom-1 -right-1 w-5 h-5 rounded-full bg-score-excellent border-[3px] border-background" />
          </div>

          {/* Title */}
          <motion.h1
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.15, duration: 0.4 }}
            className="text-display text-foreground mb-2"
          >
            ResumePilot
          </motion.h1>

          <motion.p
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.25, duration: 0.4 }}
            className="text-body text-foreground-tertiary leading-relaxed max-w-[260px]"
          >
            Land your dream job with AI-powered resume analysis and smart application tracking.
          </motion.p>

          {/* Trust indicators */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.45, duration: 0.4 }}
            className="flex items-center gap-5 mt-8"
          >
            {[
              { value: "10k+", label: "Users" },
              { value: "85%", label: "ATS Pass Rate" },
              { value: "4.9", label: "Rating" },
            ].map((stat) => (
              <div key={stat.label} className="flex flex-col items-center">
                <span className="text-title text-foreground">{stat.value}</span>
                <span className="text-micro text-foreground-quaternary">{stat.label}</span>
              </div>
            ))}
          </motion.div>
        </motion.div>
      </div>

      {/* Bottom section — CTAs */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.5, duration: 0.4 }}
        className="px-6 pb-12 space-y-3"
      >
        <Button
          variant="premium"
          size="full"
          onClick={() => navigate("/signup")}
        >
          Get Started
          <ArrowRight className="ml-1 h-4 w-4" />
        </Button>
        <Button
          variant="ghost"
          size="full"
          className="text-foreground-secondary"
          onClick={() => navigate("/login")}
        >
          I already have an account
        </Button>
      </motion.div>
    </div>
  );
};

export default Welcome;
