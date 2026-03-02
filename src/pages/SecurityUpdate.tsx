import * as React from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/auth/AuthProvider";

export default function SecurityUpdate() {
  const { updatePassword, mustChangePassword } = useAuth();
  const nav = useNavigate();
  const [p1, setP1] = React.useState("");
  const [p2, setP2] = React.useState("");
  const [msg, setMsg] = React.useState<string | null>(null);
  const [busy, setBusy] = React.useState(false);

  React.useEffect(() => {
    // If policy no longer requires update, go to dashboard
    if (!mustChangePassword) nav("/admin/dashboard", { replace: true });
  }, [mustChangePassword, nav]);

  async function submit(e: React.FormEvent) {
    e.preventDefault();
    setMsg(null);

    if (p1.length < 12) return setMsg("Password must be at least 12 characters.");
    if (p1 !== p2) return setMsg("Passwords do not match.");

    setBusy(true);
    const res = await updatePassword(p1);
    setBusy(false);

    if (!res.ok) return setMsg(res.message || "Password update failed.");
    nav("/admin/dashboard", { replace: true });
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-[#05080F] text-white p-6">
      <div className="w-full max-w-md border border-amber-500/30 rounded-2xl p-6 bg-black/40">
        <h1 className="text-sm font-black tracking-widest uppercase text-amber-400">Security Update Required</h1>
        <p className="text-xs opacity-80 mt-2">Please rotate your password to continue.</p>

        <form onSubmit={submit} className="mt-5 space-y-3">
          <input
            className="w-full rounded-xl bg-white/5 border border-white/10 p-3 text-sm"
            type="password"
            placeholder="New password (min 12 chars)"
            value={p1}
            onChange={(e) => setP1(e.target.value)}
          />
          <input
            className="w-full rounded-xl bg-white/5 border border-white/10 p-3 text-sm"
            type="password"
            placeholder="Confirm new password"
            value={p2}
            onChange={(e) => setP2(e.target.value)}
          />
          {msg && <div className="text-xs text-amber-300">{msg}</div>}
          <button
            disabled={busy}
            className="w-full rounded-xl bg-amber-500 text-black font-bold py-3 text-sm disabled:opacity-60"
          >
            {busy ? "Updating…" : "Update Password"}
          </button>
        </form>

        <div className="text-[11px] opacity-60 mt-4">
          Enterprise note: backend should clear the policy flag + revoke sessions server-side.
        </div>
      </div>
    </div>
  );
}
