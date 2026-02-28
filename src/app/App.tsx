import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { HashRouter, Routes, Route, Navigate } from "react-router-dom";
import { ROUTE_PATHS } from "@/lib/index";
import Login from "@/pages/Login";
import Dashboard from "@/pages/Dashboard";

// Initialize the enterprise-grade query client for standardized data fetching
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000, // 5 minutes
      retry: 1,
      refetchOnWindowFocus: false,
    },
  },
});

/**
 * App Component
 * 
 * The root configuration for Britium Express Logistics Intelligence Platform.
 * Manages global providers, enterprise routing hierarchy, and system-wide notifications.
 * 
 * © 2026 Britium Express. All rights reserved.
 */
const App = () => {
  return (
    <QueryClientProvider client={queryClient}>
      <TooltipProvider delayDuration={300}>
        <HashRouter>
          <Routes>
            {/* 
              The Home path serves as the high-impact enterprise cover page.
              By default, we route users to the Secure Login Portal.
            */}
            <Route path={ROUTE_PATHS.HOME} element={<Login />} />
            <Route path={ROUTE_PATHS.LOGIN} element={<Login />} />

            {/* 
              Central operational hub for authenticated users.
              Role-based access is managed within the page and its sub-components.
            */}
            <Route path={ROUTE_PATHS.DASHBOARD} element={<Dashboard />} />

            {/* 
              Redirect all undefined paths to the Home/Login portal.
              This maintains a strict security perimeter for the enterprise system.
            */}
            <Route path="*" element={<Navigate to={ROUTE_PATHS.HOME} replace />} />
          </Routes>
        </HashRouter>

        {/* Global Toast notifications for operational feedback */}
        <Toaster />
        
        {/* Sonner provides rich, interactive notifications suitable for high-density logistics data */}
        <Sonner 
          position="top-right" 
          expand={false} 
          richColors 
          closeButton
          theme="dark"
        />
      </TooltipProvider>
    </QueryClientProvider>
  );
};

export default App;