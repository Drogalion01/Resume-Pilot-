import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { ArrowRight, Eye, EyeOff, Mail, Lock, AlertCircle, Loader2, WifiOff } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import MobileCard from "@/components/MobileCard";
import { useToast } from "@/hooks/use-toast";

type LoginError = "credentials" | "network" | null;

const stagger = (i: number) => ({
  initial: { opacity: 0, y: 6 },
  animate: { opacity: 1, y: 0 },
  transition: { delay: i * 0.05 },
});

const FieldError = ({ msg }: { msg?: string }) =>
  msg ? (
    <p className="text-micro text-destructive flex items-center gap-1 mt-1.5">
      <AlertCircle className="h-3 w-3" /> {msg}
    </p>
  ) : null;

const Login = () => {
  const navigate = useNavigate();
  const { toast } = useToast();
  const [showPassword, setShowPassword] = useState(false);
  const [form, setForm] = useState({ email: "", password: "" });
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({});
  const [isLoading, setIsLoading] = useState(false);
  const [loginError, setLoginError] = useState<LoginError>(null);

  const handleChange = (field: string) => (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm((prev) => ({ ...prev, [field]: e.target.value }));
    if (fieldErrors[field]) setFieldErrors((prev) => ({ ...prev, [field]: "" }));
    if (loginError) setLoginError(null);
  };

  const validate = () => {
    const errs: Record<string, string> = {};
    if (!form.email.trim()) errs.email = "Email is required";
    else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) errs.email = "Enter a valid email";
    if (!form.password) errs.password = "Password is required";
    else if (form.password.length < 6) errs.password = "At least 6 characters";
    setFieldErrors(errs);
    return Object.keys(errs).length === 0;
  };

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validate()) return;
    setIsLoading(true);
    setLoginError(null);

    // Simulate API call — replace with fetch("/api/v1/auth/login", { ... })
    setTimeout(() => {
      setIsLoading(false);
      toast({ title: "Welcome back!", description: "You've signed in successfully." });
      navigate("/");
    }, 1500);
  };

  return (
    <div className="min-h-screen bg-background flex flex-col">
      {/* Hero gradient header */}
      <div className="hero-gradient relative overflow-hidden rounded-b-3xl px-5 pt-14 pb-10">
        <motion.div {...stagger(0)} className="relative z-10">
          {/* Brand mark */}
          <div className="flex items-center gap-2 mb-6">
            <div className="w-9 h-9 rounded-xl bg-card/80 backdrop-blur-sm flex items-center justify-center shadow-sm">
              <span className="text-[13px] font-extrabold text-primary">R</span>
            </div>
            <span className="text-body-medium text-foreground">ResumePilot</span>
          </div>

          <h1 className="text-display text-foreground">Welcome back</h1>
          <p className="text-body text-foreground-secondary mt-1.5">
            Optimize your resume. Track your applications.
          </p>
        </motion.div>
      </div>

      {/* Form card */}
      <motion.div {...stagger(1)} className="px-5 -mt-4 relative z-20">
        <MobileCard variant="elevated" padding="spacious">
          {/* Global error banners */}
          {loginError === "credentials" && (
            <motion.div
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: "auto" }}
              className="flex items-start gap-2.5 bg-destructive-light rounded-xl px-3.5 py-3 mb-4"
            >
              <AlertCircle className="h-4 w-4 text-destructive shrink-0 mt-0.5" />
              <div>
                <p className="text-caption text-destructive font-semibold">Invalid credentials</p>
                <p className="text-micro text-foreground-tertiary mt-0.5">Check your email and password, then try again.</p>
              </div>
            </motion.div>
          )}

          {loginError === "network" && (
            <motion.div
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: "auto" }}
              className="flex items-start gap-2.5 bg-score-average-bg rounded-xl px-3.5 py-3 mb-4"
            >
              <WifiOff className="h-4 w-4 text-score-average shrink-0 mt-0.5" />
              <div>
                <p className="text-caption text-score-average font-semibold">Connection failed</p>
                <p className="text-micro text-foreground-tertiary mt-0.5">Please check your internet and try again.</p>
              </div>
            </motion.div>
          )}

          <form onSubmit={handleLogin} className="space-y-4">
            {/* Email */}
            <div>
              <label className="text-caption text-foreground-secondary mb-1.5 block">Email</label>
              <Input
                leftIcon={<Mail />}
                type="email"
                placeholder="alex@email.com"
                value={form.email}
                onChange={handleChange("email")}
                autoComplete="email"
                className={fieldErrors.email ? "border-destructive focus-within:ring-destructive/20" : ""}
              />
              <FieldError msg={fieldErrors.email} />
            </div>

            {/* Password */}
            <div>
              <div className="flex items-center justify-between mb-1.5">
                <label className="text-caption text-foreground-secondary">Password</label>
                <button
                  type="button"
                  onClick={() => navigate("/forgot-password")}
                  className="text-caption text-primary font-semibold press-scale"
                >
                  Forgot?
                </button>
              </div>
              <Input
                leftIcon={<Lock />}
                type={showPassword ? "text" : "password"}
                placeholder="Enter your password"
                value={form.password}
                onChange={handleChange("password")}
                autoComplete="current-password"
                className={fieldErrors.password ? "border-destructive focus-within:ring-destructive/20" : ""}
                rightIcon={
                  <button type="button" onClick={() => setShowPassword(!showPassword)} className="press-scale">
                    {showPassword ? <EyeOff /> : <Eye />}
                  </button>
                }
              />
              <FieldError msg={fieldErrors.password} />
            </div>

            {/* Submit */}
            <div className="pt-1">
              <Button variant="premium" size="full" type="submit" disabled={isLoading}>
                {isLoading ? <Loader2 className="h-4 w-4 animate-spin mr-1.5" /> : null}
                {isLoading ? "Signing in…" : "Sign In"}
                {!isLoading && <ArrowRight className="ml-1 h-4 w-4" />}
              </Button>
            </div>
          </form>

          {/* Divider */}
          <div className="flex items-center gap-3 my-5">
            <div className="flex-1 h-px bg-border" />
            <span className="text-micro text-foreground-quaternary uppercase tracking-widest">or continue with</span>
            <div className="flex-1 h-px bg-border" />
          </div>

          {/* Social login */}
          <div className="flex gap-3">
            <Button variant="outline" size="default" className="flex-1" type="button">
              <svg viewBox="0 0 24 24" className="w-5 h-5" fill="none">
                <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z" fill="#4285F4" />
                <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853" />
                <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05" />
                <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335" />
              </svg>
              Google
            </Button>
            <Button variant="outline" size="default" className="flex-1" type="button">
              <svg viewBox="0 0 24 24" className="w-5 h-5" fill="currentColor">
                <path d="M17.05 20.28c-.98.95-2.05.88-3.08.4-1.09-.5-2.08-.48-3.24 0-1.44.62-2.2.44-3.06-.4C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z" />
              </svg>
              Apple
            </Button>
          </div>
        </MobileCard>
      </motion.div>

      {/* Bottom CTA */}
      <div className="mt-auto pb-10 pt-6 px-5">
        <p className="text-caption text-foreground-tertiary text-center">
          Don't have an account?{" "}
          <button type="button" onClick={() => navigate("/signup")} className="text-primary font-semibold press-scale">
            Create account
          </button>
        </p>
      </div>
    </div>
  );
};

export default Login;
