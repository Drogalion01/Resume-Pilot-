import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { motion } from "framer-motion";
import { ArrowRight, Eye, EyeOff, Mail, Lock, User, AlertCircle, Loader2, WifiOff } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Checkbox } from "@/components/ui/checkbox";
import MobileCard from "@/components/MobileCard";
import { useToast } from "@/hooks/use-toast";

type SignUpError = "email-exists" | "network" | null;

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

const SignUp = () => {
  const navigate = useNavigate();
  const { toast } = useToast();
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [form, setForm] = useState({ name: "", email: "", password: "", confirmPassword: "" });
  const [agreed, setAgreed] = useState(false);
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({});
  const [isLoading, setIsLoading] = useState(false);
  const [signUpError, setSignUpError] = useState<SignUpError>(null);

  const handleChange = (field: string) => (e: React.ChangeEvent<HTMLInputElement>) => {
    setForm((prev) => ({ ...prev, [field]: e.target.value }));
    if (fieldErrors[field]) setFieldErrors((prev) => ({ ...prev, [field]: "" }));
    if (signUpError) setSignUpError(null);
  };

  const passwordStrength = (() => {
    const p = form.password;
    if (!p) return null;
    let score = 0;
    if (p.length >= 8) score++;
    if (/[A-Z]/.test(p)) score++;
    if (/[0-9]/.test(p)) score++;
    if (/[^A-Za-z0-9]/.test(p)) score++;
    if (score <= 1) return { label: "Weak", color: "bg-score-poor", width: "w-1/4" };
    if (score === 2) return { label: "Fair", color: "bg-score-average", width: "w-2/4" };
    if (score === 3) return { label: "Good", color: "bg-score-good", width: "w-3/4" };
    return { label: "Strong", color: "bg-score-excellent", width: "w-full" };
  })();

  const validate = () => {
    const errs: Record<string, string> = {};
    if (!form.name.trim()) errs.name = "Name is required";
    else if (form.name.trim().length < 2) errs.name = "Name must be at least 2 characters";
    if (!form.email.trim()) errs.email = "Email is required";
    else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) errs.email = "Enter a valid email";
    if (!form.password) errs.password = "Password is required";
    else if (form.password.length < 8) errs.password = "Password must be at least 8 characters";
    if (!form.confirmPassword) errs.confirmPassword = "Please confirm your password";
    else if (form.password !== form.confirmPassword) errs.confirmPassword = "Passwords do not match";
    setFieldErrors(errs);
    return Object.keys(errs).length === 0;
  };

  const handleSignUp = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validate()) return;
    setIsLoading(true);
    setSignUpError(null);

    // Simulate POST /auth/register — replace with actual fetch
    setTimeout(() => {
      setIsLoading(false);
      toast({ title: "Account created!", description: "Welcome to ResumePilot." });
      navigate("/");
    }, 1500);
  };

  return (
    <div className="min-h-screen bg-background flex flex-col">
      {/* Hero gradient header */}
      <div className="hero-gradient relative overflow-hidden rounded-b-3xl px-5 pt-14 pb-10">
        <motion.div {...stagger(0)} className="relative z-10">
          <div className="flex items-center gap-2 mb-6">
            <div className="w-9 h-9 rounded-xl bg-card/80 backdrop-blur-sm flex items-center justify-center shadow-sm">
              <span className="text-[13px] font-extrabold text-primary">R</span>
            </div>
            <span className="text-body-medium text-foreground">ResumePilot</span>
          </div>

          <h1 className="text-display text-foreground">Create your{"\n"}account</h1>
          <p className="text-body text-foreground-secondary mt-1.5">
            Start optimizing your resumes and tracking your applications.
          </p>
        </motion.div>
      </div>

      {/* Form card */}
      <motion.div {...stagger(1)} className="px-5 -mt-4 relative z-20">
        <MobileCard variant="elevated" padding="spacious">
          {/* Global error banners */}
          {signUpError === "email-exists" && (
            <motion.div
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: "auto" }}
              className="flex items-start gap-2.5 bg-destructive-light rounded-xl px-3.5 py-3 mb-4"
            >
              <AlertCircle className="h-4 w-4 text-destructive shrink-0 mt-0.5" />
              <div>
                <p className="text-caption text-destructive font-semibold">Email already registered</p>
                <p className="text-micro text-foreground-tertiary mt-0.5">
                  Try signing in instead, or use a different email.
                </p>
              </div>
            </motion.div>
          )}

          {signUpError === "network" && (
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

          <form onSubmit={handleSignUp} className="space-y-4">
            {/* Full Name */}
            <div>
              <label className="text-caption text-foreground-secondary mb-1.5 block">Full Name</label>
              <Input
                leftIcon={<User />}
                placeholder="Alex Johnson"
                value={form.name}
                onChange={handleChange("name")}
                autoComplete="name"
                className={fieldErrors.name ? "border-destructive focus-within:ring-destructive/20" : ""}
              />
              <FieldError msg={fieldErrors.name} />
            </div>

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
              <label className="text-caption text-foreground-secondary mb-1.5 block">Password</label>
              <Input
                leftIcon={<Lock />}
                type={showPassword ? "text" : "password"}
                placeholder="Min 8 characters"
                value={form.password}
                onChange={handleChange("password")}
                autoComplete="new-password"
                className={fieldErrors.password ? "border-destructive focus-within:ring-destructive/20" : ""}
                rightIcon={
                  <button type="button" onClick={() => setShowPassword(!showPassword)} className="press-scale">
                    {showPassword ? <EyeOff /> : <Eye />}
                  </button>
                }
              />
              <FieldError msg={fieldErrors.password} />
              {passwordStrength && !fieldErrors.password && (
                <div className="mt-2 space-y-1">
                  <div className="h-1 rounded-full bg-muted overflow-hidden">
                    <div className={`h-full rounded-full transition-all duration-300 ${passwordStrength.color} ${passwordStrength.width}`} />
                  </div>
                  <p className="text-micro text-foreground-quaternary">{passwordStrength.label} password</p>
                </div>
              )}
            </div>

            {/* Confirm Password */}
            <div>
              <label className="text-caption text-foreground-secondary mb-1.5 block">Confirm Password</label>
              <Input
                leftIcon={<Lock />}
                type={showConfirm ? "text" : "password"}
                placeholder="Re-enter your password"
                value={form.confirmPassword}
                onChange={handleChange("confirmPassword")}
                autoComplete="new-password"
                className={fieldErrors.confirmPassword ? "border-destructive focus-within:ring-destructive/20" : ""}
                rightIcon={
                  <button type="button" onClick={() => setShowConfirm(!showConfirm)} className="press-scale">
                    {showConfirm ? <EyeOff /> : <Eye />}
                  </button>
                }
              />
              <FieldError msg={fieldErrors.confirmPassword} />
            </div>

            {/* Terms checkbox */}
            <div className="flex items-start gap-2.5 pt-1">
              <Checkbox
                id="terms"
                checked={agreed}
                onCheckedChange={(v) => setAgreed(v === true)}
                className="mt-0.5"
              />
              <label htmlFor="terms" className="text-caption text-foreground-tertiary leading-relaxed cursor-pointer">
                I agree to the <span className="text-primary font-semibold">Terms of Service</span> and{" "}
                <span className="text-primary font-semibold">Privacy Policy</span>
              </label>
            </div>

            {/* Submit */}
            <div className="pt-1">
              <Button variant="premium" size="full" type="submit" disabled={isLoading}>
                {isLoading ? <Loader2 className="h-4 w-4 animate-spin mr-1.5" /> : null}
                {isLoading ? "Creating account…" : "Create Account"}
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
          Already have an account?{" "}
          <button type="button" onClick={() => navigate("/login")} className="text-primary font-semibold press-scale">
            Sign in
          </button>
        </p>
      </div>
    </div>
  );
};

export default SignUp;
