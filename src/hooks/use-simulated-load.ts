import { useState, useEffect, useCallback } from "react";

type LoadingState = "loading" | "success" | "error" | "idle";

/**
 * Simulates async data fetching for frontend demo purposes.
 * In production, replace with real API calls.
 */
export function useSimulatedLoad(delayMs = 1200) {
  const [state, setState] = useState<LoadingState>("loading");

  useEffect(() => {
    const timer = setTimeout(() => setState("success"), delayMs);
    return () => clearTimeout(timer);
  }, [delayMs]);

  return { state, isLoading: state === "loading", isError: state === "error", isSuccess: state === "success" };
}

/**
 * Simulates an async action (form submit, save, etc.)
 */
export function useSimulatedAction(delayMs = 1500) {
  const [state, setState] = useState<LoadingState>("idle");

  const execute = useCallback(async () => {
    setState("loading");
    return new Promise<void>((resolve) => {
      setTimeout(() => {
        setState("success");
        resolve();
      }, delayMs);
    });
  }, [delayMs]);

  const reset = useCallback(() => setState("idle"), []);

  return { state, isLoading: state === "loading", isSuccess: state === "success", isError: state === "error", execute, reset };
}
