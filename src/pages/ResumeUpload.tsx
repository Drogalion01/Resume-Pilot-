import { useState, useRef } from "react";
import {
  Upload, FileText, ClipboardPaste, ArrowRight, X,
  CheckCircle2, Briefcase, Building2, ChevronDown, ChevronUp, Info, Sparkles, Loader2
} from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import ScreenHeader from "@/components/ScreenHeader";
import MobileCard from "@/components/MobileCard";
import BottomNav from "@/components/BottomNav";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Badge } from "@/components/ui/badge";
import { useNavigate } from "react-router-dom";
import { useToast } from "@/hooks/use-toast";

const ResumeUpload = () => {
  const [mode, setMode] = useState<"upload" | "paste" | null>(null);
  const [pasteContent, setPasteContent] = useState("");
  const [fileName, setFileName] = useState<string | null>(null);
  const [showOptional, setShowOptional] = useState(false);
  const [targetRole, setTargetRole] = useState("");
  const [companyName, setCompanyName] = useState("");
  const [jobDescription, setJobDescription] = useState("");
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [fileError, setFileError] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const navigate = useNavigate();
  const { toast } = useToast();

  const hasResume = mode === "upload" ? !!fileName : pasteContent.trim().length > 30;

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    setFileError(null);
    if (file) {
      if (file.size > 5 * 1024 * 1024) {
        setFileError("File size must be under 5MB");
        return;
      }
      const ext = file.name.split(".").pop()?.toLowerCase();
      if (!["pdf", "docx", "doc"].includes(ext || "")) {
        setFileError("Only PDF and DOCX files are supported");
        return;
      }
      setFileName(file.name);
    }
  };

  const clearFile = () => {
    setFileName(null);
    setFileError(null);
    if (fileInputRef.current) fileInputRef.current.value = "";
  };

  const selectMode = (m: "upload" | "paste") => {
    setMode(m);
    setFileName(null);
    setPasteContent("");
    setFileError(null);
  };

  const handleAnalyze = () => {
    setIsAnalyzing(true);
    setTimeout(() => {
      setIsAnalyzing(false);
      toast({ title: "Analysis complete!", description: "Your resume has been scored." });
      navigate("/analysis");
    }, 2500);
  };

  return (
    <div className="min-h-screen bg-background pb-36">
      <ScreenHeader title="Analyze Resume" subtitle="Get your ATS & Recruiter scores" showBack />

      {/* Analyzing overlay */}
      <AnimatePresence>
        {isAnalyzing && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 z-50 bg-background/95 flex flex-col items-center justify-center px-8"
          >
            <motion.div
              initial={{ scale: 0.9 }}
              animate={{ scale: 1 }}
              className="flex flex-col items-center text-center"
            >
              <div className="w-16 h-16 rounded-2xl bg-primary-light flex items-center justify-center mb-6">
                <Loader2 className="h-7 w-7 text-primary animate-spin" />
              </div>
              <h2 className="text-headline text-foreground mb-2">Analyzing your resume…</h2>
              <p className="text-body text-foreground-tertiary leading-relaxed max-w-[260px]">
                Checking ATS compatibility, keyword matching, and recruiter readability.
              </p>
              <div className="mt-8 w-48 h-1.5 rounded-full bg-muted overflow-hidden">
                <motion.div
                  className="h-full rounded-full bg-primary"
                  initial={{ width: "0%" }}
                  animate={{ width: "100%" }}
                  transition={{ duration: 2.5, ease: "easeInOut" }}
                />
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      <div className="px-5 mt-3 space-y-5">
        {/* STEP 1 */}
        <section>
          <div className="flex items-center gap-2 mb-3">
            <div className="w-5 h-5 rounded-full bg-primary flex items-center justify-center">
              <span className="text-[10px] font-bold text-primary-foreground">1</span>
            </div>
            <span className="text-title text-foreground">Add your resume</span>
          </div>

          <div className="flex gap-2 mb-3">
            {(["upload", "paste"] as const).map((m) => (
              <button key={m} onClick={() => selectMode(m)}
                className={`flex-1 flex items-center justify-center gap-2 py-3 rounded-xl text-caption font-semibold transition-all press-scale ${
                  mode === m ? "bg-primary text-primary-foreground shadow-sm" : "bg-card text-foreground-secondary shadow-card"
                }`}>
                {m === "upload" ? <Upload className="h-4 w-4" /> : <ClipboardPaste className="h-4 w-4" />}
                {m === "upload" ? "Upload File" : "Paste Text"}
              </button>
            ))}
          </div>

          <AnimatePresence mode="wait">
            {mode === "upload" && (
              <motion.div key="upload" initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -4 }} transition={{ duration: 0.2 }}>
                {!fileName ? (
                  <button onClick={() => fileInputRef.current?.click()}
                    className="w-full border-2 border-dashed border-border hover:border-primary/30 rounded-2xl p-7 flex flex-col items-center gap-2.5 bg-surface-secondary transition-colors press-scale">
                    <div className="w-12 h-12 rounded-2xl bg-primary-light flex items-center justify-center">
                      <FileText className="h-5 w-5 text-primary" />
                    </div>
                    <div className="text-center">
                      <p className="text-body-medium text-foreground">Tap to select file</p>
                      <p className="text-caption text-foreground-quaternary mt-0.5">PDF or DOCX · Max 5MB</p>
                    </div>
                  </button>
                ) : (
                  <MobileCard className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-xl bg-score-excellent-bg flex items-center justify-center shrink-0">
                      <CheckCircle2 className="h-[18px] w-[18px] text-score-excellent" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="text-body-medium text-foreground truncate">{fileName}</p>
                      <p className="text-caption text-foreground-tertiary">Ready for analysis</p>
                    </div>
                    <button onClick={clearFile} className="p-1.5 rounded-lg hover:bg-muted press-scale">
                      <X className="h-4 w-4 text-foreground-tertiary" />
                    </button>
                  </MobileCard>
                )}
                {fileError && (
                  <p className="text-micro text-destructive flex items-center gap-1 mt-2 px-1">
                    <Info className="h-3 w-3" /> {fileError}
                  </p>
                )}
                <input ref={fileInputRef} type="file" accept=".pdf,.docx,.doc" onChange={handleFileSelect} className="hidden" />
              </motion.div>
            )}

            {mode === "paste" && (
              <motion.div key="paste" initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -4 }} transition={{ duration: 0.2 }}>
                <div className="relative">
                  <Textarea rows={7}
                    placeholder="Paste your full resume text here...&#10;&#10;Include your experience, education, skills, and any relevant information."
                    value={pasteContent} onChange={(e) => setPasteContent(e.target.value)} className="pb-8 min-h-[180px]" />
                  {pasteContent.length > 0 && (
                    <div className="absolute bottom-3 right-3 flex items-center gap-2">
                      <span className="text-micro text-foreground-quaternary">{pasteContent.length.toLocaleString()} chars</span>
                      {pasteContent.length > 30 && <CheckCircle2 className="h-3.5 w-3.5 text-score-excellent" />}
                    </div>
                  )}
                </div>
                {pasteContent.length > 0 && pasteContent.length <= 30 && (
                  <p className="text-micro text-score-average flex items-center gap-1 mt-1.5 px-1">
                    <Info className="h-3 w-3" /> Need at least 30 characters for analysis
                  </p>
                )}
              </motion.div>
            )}
          </AnimatePresence>

          {!mode && (
            <MobileCard variant="sunken" className="flex items-center gap-3">
              <Info className="h-4 w-4 text-foreground-quaternary shrink-0" />
              <p className="text-caption text-foreground-tertiary">Choose how you'd like to add your resume above.</p>
            </MobileCard>
          )}
        </section>

        {/* STEP 2 */}
        <section>
          <button onClick={() => setShowOptional(!showOptional)} className="flex items-center gap-2 w-full press-scale">
            <div className={`w-5 h-5 rounded-full flex items-center justify-center ${showOptional ? "bg-primary" : "bg-border"}`}>
              <span className={`text-[10px] font-bold ${showOptional ? "text-primary-foreground" : "text-foreground-tertiary"}`}>2</span>
            </div>
            <span className="text-title text-foreground flex-1 text-left">Target this analysis</span>
            <Badge variant="secondary" size="sm">Optional</Badge>
            {showOptional ? <ChevronUp className="h-4 w-4 text-foreground-quaternary" /> : <ChevronDown className="h-4 w-4 text-foreground-quaternary" />}
          </button>
          <AnimatePresence>
            {showOptional && (
              <motion.div initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: "auto" }} exit={{ opacity: 0, height: 0 }} transition={{ duration: 0.25 }} className="overflow-hidden">
                <div className="pt-3 space-y-3">
                  <MobileCard variant="sunken" padding="compact" className="flex items-start gap-2.5">
                    <Sparkles className="h-4 w-4 text-primary shrink-0 mt-0.5" />
                    <p className="text-caption text-foreground-tertiary leading-relaxed">Adding a target role or job description helps us give you more specific, relevant scoring and recommendations.</p>
                  </MobileCard>
                  <div>
                    <label className="text-caption text-foreground-secondary mb-1.5 block">Target Role</label>
                    <Input leftIcon={<Briefcase />} placeholder="e.g. Software Engineer" value={targetRole} onChange={(e) => setTargetRole(e.target.value)} />
                  </div>
                  <div>
                    <label className="text-caption text-foreground-secondary mb-1.5 block">Company</label>
                    <Input leftIcon={<Building2 />} placeholder="e.g. Google" value={companyName} onChange={(e) => setCompanyName(e.target.value)} />
                  </div>
                  <div>
                    <label className="text-caption text-foreground-secondary mb-1.5 block">Job Description</label>
                    <Textarea rows={5} placeholder="Paste the full job description here…" value={jobDescription} onChange={(e) => setJobDescription(e.target.value)} className="min-h-[120px]" />
                  </div>
                </div>
              </motion.div>
            )}
          </AnimatePresence>
        </section>

        {/* GUIDANCE */}
        <section>
          <MobileCard variant="outlined" padding="compact">
            <p className="text-overline text-foreground-tertiary mb-2">Tips for best results</p>
            <div className="space-y-2">
              {["Use the same resume you'd submit to this role", "Include all sections — summary, experience, skills, education", "Adding a job description dramatically improves keyword feedback"].map((tip, i) => (
                <div key={i} className="flex items-start gap-2">
                  <div className="w-1 h-1 rounded-full bg-foreground-quaternary mt-[7px] shrink-0" />
                  <p className="text-caption text-foreground-tertiary leading-relaxed">{tip}</p>
                </div>
              ))}
            </div>
          </MobileCard>
        </section>
      </div>

      {/* STICKY CTA */}
      <div className="fixed bottom-[60px] left-1/2 -translate-x-1/2 w-full max-w-[430px] z-40 px-5 pb-5 pt-3 bg-gradient-to-t from-background via-background to-transparent">
        <Button variant="premium" size="full" onClick={handleAnalyze} disabled={!hasResume || isAnalyzing}>
          {isAnalyzing ? <Loader2 className="h-4 w-4 animate-spin mr-1.5" /> : <Sparkles className="mr-1.5 h-4 w-4" />}
          {isAnalyzing ? "Analyzing…" : "Analyze Resume"}
          {!isAnalyzing && <ArrowRight className="ml-1 h-4 w-4" />}
        </Button>
        {!hasResume && mode && (
          <p className="text-micro text-foreground-quaternary text-center mt-2">
            {mode === "upload" ? "Select a file to continue" : "Paste at least 30 characters to continue"}
          </p>
        )}
      </div>

      <BottomNav />
    </div>
  );
};

export default ResumeUpload;
