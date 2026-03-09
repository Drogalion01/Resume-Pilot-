import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Welcome from "./pages/Welcome";
import Onboarding from "./pages/Onboarding";
import SignUp from "./pages/SignUp";
import Login from "./pages/Login";
import ForgotPassword from "./pages/ForgotPassword";
import Index from "./pages/Index";
import ResumeUpload from "./pages/ResumeUpload";
import ResumeAnalysis from "./pages/ResumeAnalysis";
import ResumeVersions from "./pages/ResumeVersions";
import ResumeVersionDetail from "./pages/ResumeVersionDetail";
import ApplicationsTracker from "./pages/ApplicationsTracker";
import ApplicationDetail from "./pages/ApplicationDetail";
import AddInterview from "./pages/AddInterview";
import AddApplication from "./pages/AddApplication";
import SettingsPage from "./pages/SettingsPage";
import UserProfile from "./pages/UserProfile";
import DesignSystem from "./pages/DesignSystem";
import NotFound from "./pages/NotFound";

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Index />} />
          <Route path="/welcome" element={<Welcome />} />
          <Route path="/onboarding" element={<Onboarding />} />
          <Route path="/signup" element={<SignUp />} />
          <Route path="/login" element={<Login />} />
          <Route path="/forgot-password" element={<ForgotPassword />} />
          <Route path="/upload" element={<ResumeUpload />} />
          <Route path="/analysis" element={<ResumeAnalysis />} />
          <Route path="/resumes" element={<ResumeVersions />} />
          <Route path="/resumes/:id" element={<ResumeVersionDetail />} />
          <Route path="/applications" element={<ApplicationsTracker />} />
          <Route path="/applications/add" element={<AddApplication />} />
          <Route path="/applications/:id" element={<ApplicationDetail />} />
          <Route path="/applications/:id/interviews/add" element={<AddInterview />} />
          <Route path="/settings" element={<SettingsPage />} />
          <Route path="/profile" element={<UserProfile />} />
          <Route path="/design" element={<DesignSystem />} />
          <Route path="*" element={<NotFound />} />
        </Routes>
      </BrowserRouter>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;
