import { useLocation, useNavigate } from "react-router-dom";
import { Home, FileText, Briefcase, Calendar, Settings } from "lucide-react";
import { cn } from "@/lib/utils";
import { motion } from "framer-motion";

const navItems = [
  { path: "/", icon: Home, label: "Home" },
  { path: "/resumes", icon: FileText, label: "Resumes" },
  { path: "/applications", icon: Briefcase, label: "Applications" },
  { path: "/settings", icon: Settings, label: "Settings" },
];

const BottomNav = () => {
  const location = useLocation();
  const navigate = useNavigate();

  return (
    <nav className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-[430px] z-50 bg-card/98 backdrop-blur-xl border-t border-border-subtle shadow-nav pb-safe">
      <div className="flex items-center justify-around h-[62px] px-2">
        {navItems.map(({ path, icon: Icon, label }) => {
          const isActive = location.pathname === path ||
            (path !== "/" && location.pathname.startsWith(path));
          return (
            <button
              key={path}
              onClick={() => navigate(path)}
              className={cn(
                "relative flex flex-col items-center gap-[2px] py-1.5 px-3 rounded-xl transition-colors min-w-[52px]",
                isActive ? "text-primary" : "text-foreground-quaternary"
              )}
            >
              <div className="relative">
                <Icon className={cn("h-[21px] w-[21px]", isActive ? "stroke-[2.4px]" : "stroke-[1.7px]")} />
                {isActive && (
                  <motion.div
                    layoutId="nav-dot"
                    className="absolute -bottom-1 left-1/2 -translate-x-1/2 w-1 h-1 rounded-full bg-primary"
                    transition={{ type: "spring", stiffness: 500, damping: 35 }}
                  />
                )}
              </div>
              <span className={cn(
                "text-micro leading-tight",
                isActive ? "font-bold" : "font-medium"
              )}>
                {label}
              </span>
            </button>
          );
        })}
      </div>
    </nav>
  );
};

export default BottomNav;
