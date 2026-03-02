import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
import "./index.css";

import { ErrorBoundary } from "@/components/ErrorBoundary";
import { AuthProvider } from "@/auth/AuthProvider";

const root = document.getElementById("root");

if (root) {
  ReactDOM.createRoot(root).render(
    <React.StrictMode>
      <ErrorBoundary>
        <AuthProvider>
          <App />
        </AuthProvider>
      </ErrorBoundary>
    </React.StrictMode>
  );
}
