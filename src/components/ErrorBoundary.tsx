import * as React from "react";

type Props = { children: React.ReactNode };
type State = { hasError: boolean; message?: string };

export class ErrorBoundary extends React.Component<Props, State> {
  state: State = { hasError: false };

  static getDerivedStateFromError(err: any): State {
    return { hasError: true, message: String(err?.message ?? err) };
  }

  componentDidCatch(error: any, info: any) {
    // TODO: send to Sentry/Datadog/Otel
    console.error("[ErrorBoundary]", error, info);
  }

  render() {
    if (!this.state.hasError) return this.props.children;

    return (
      <div style={{ minHeight: "100vh", background: "#05080F", color: "#fff", padding: 24, fontFamily: "sans-serif" }}>
        <h1 style={{ color: "#f59e0b", letterSpacing: 2, fontWeight: 800 }}>SYSTEM_GUARD_FALLBACK</h1>
        <p style={{ marginTop: 12, opacity: 0.9 }}>Something went wrong. Please reload.</p>
        <button
          onClick={() => location.reload()}
          style={{ marginTop: 16, background: "#f59e0b", border: "none", padding: "10px 16px", borderRadius: 10, color: "#111" }}
        >
          RELOAD
        </button>
      </div>
    );
  }
}
