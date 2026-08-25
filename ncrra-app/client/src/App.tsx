/**
 * NCRRA Trusted Member Utility design system.
 * Light, high-trust, mobile-first prototype with calm ivory surfaces, navy type and teal action states.
 */
import { Toaster } from "@/components/ui/sonner";
import ErrorBoundary from "./components/ErrorBoundary";
import { ThemeProvider } from "./contexts/ThemeContext";
import Home from "./pages/Home";

export default function App() {
  return (
    <ErrorBoundary>
      <ThemeProvider defaultTheme="light">
        <Home />
        <Toaster position="top-center" />
      </ThemeProvider>
    </ErrorBoundary>
  );
}
