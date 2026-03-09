import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { ArrowLeft, ArrowRight, Mail, CheckCircle2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

const ForgotPassword = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [sent, setSent] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setSent(true);
  };

  return (
    <div className="min-h-screen bg-background flex flex-col">
      {/* Header */}
      <div className="px-5 pt-14">
        <button
          onClick={() => navigate(-1)}
          className="flex items-center justify-center w-9 h-9 -ml-1 rounded-xl hover:bg-muted transition-colors press-scale"
        >
          <ArrowLeft className="h-5 w-5 text-foreground" />
        </button>
      </div>

      <div className="flex-1 flex flex-col px-6 pt-6">
        {!sent ? (
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            className="flex-1 flex flex-col"
          >
            <h1 className="text-display text-foreground">Reset your{"\n"}password</h1>
            <p className="text-body text-foreground-tertiary mt-2 mb-8">
              Enter your email and we'll send you a link to reset your password.
            </p>

            <form onSubmit={handleSubmit} className="space-y-6">
              <div>
                <label className="text-caption text-foreground-secondary mb-1.5 block">Email</label>
                <Input
                  leftIcon={<Mail />}
                  type="email"
                  placeholder="alex@email.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  autoComplete="email"
                />
              </div>

              <Button variant="premium" size="full" type="submit">
                Send Reset Link
                <ArrowRight className="ml-1 h-4 w-4" />
              </Button>
            </form>

            <div className="mt-auto pb-10 pt-6">
              <p className="text-caption text-foreground-tertiary text-center">
                Remember your password?{" "}
                <button
                  type="button"
                  onClick={() => navigate("/login")}
                  className="text-primary font-semibold press-scale"
                >
                  Sign in
                </button>
              </p>
            </div>
          </motion.div>
        ) : (
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            className="flex-1 flex flex-col items-center justify-center text-center px-4"
          >
            <div className="w-16 h-16 rounded-2xl bg-score-excellent-bg flex items-center justify-center mb-6">
              <CheckCircle2 className="w-7 h-7 text-score-excellent" />
            </div>
            <h2 className="text-headline text-foreground mb-2">Check your email</h2>
            <p className="text-body text-foreground-tertiary leading-relaxed max-w-[280px]">
              We sent a password reset link to{" "}
              <span className="text-foreground font-medium">{email}</span>
            </p>

            <div className="w-full mt-10 space-y-3">
              <Button variant="soft" size="full" onClick={() => navigate("/login")}>
                Back to Sign In
              </Button>
              <button
                onClick={() => setSent(false)}
                className="text-caption text-foreground-tertiary mx-auto block press-scale"
              >
                Didn't receive it? Try again
              </button>
            </div>
          </motion.div>
        )}
      </div>
    </div>
  );
};

export default ForgotPassword;
