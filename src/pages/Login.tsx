import React, { useState } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import { useLanguage } from "@/contexts/LanguageContext";
import { useAuth } from "@/contexts/AuthContext";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export default function Login() {
  const nav = useNavigate();
  const loc = useLocation() as unknown as { state?: { from?: string } };
  const { t } = useLanguage();
  const { login, isMock } = useAuth();

  const [email, setEmail] = useState("");
  const [pw, setPw] = useState("");
  const [err, setErr] = useState("");

  const onSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setErr("");
    const res = await login(email, pw);
    if (!res.success) {
      setErr(t("Invalid Credentials", "အချက်အလက် မှားယွင်းနေပါသည်"));
      return;
    }
    nav(loc.state?.from ?? "/admin/dashboard", { replace: true });
  };

  return (
    <div className="min-h-screen bg-[#0B101B] flex items-center justify-center p-6 text-slate-200">
      <form onSubmit={onSubmit} className="w-full max-w-md rounded-2xl border border-white/10 bg-[#05080F]/70 backdrop-blur-xl p-6">
        <div className="text-white font-black tracking-widest uppercase text-xl">BRITIUM L5</div>
        <div className="mt-2 text-xs font-mono text-slate-500">
          {isMock ? t("MOCK MODE: any email works", "MOCK မုဒ်: email တင်လိုပါသည်") : t("Secure login", "လုံခြုံသော ဝင်ရောက်မှု")}
        </div>

        <div className="mt-6 space-y-3">
          <Input value={email} onChange={(e) => setEmail(e.target.value)} placeholder="admin@britium.test" />
          <Input type="password" value={pw} onChange={(e) => setPw(e.target.value)} placeholder="••••••••" />
          {err ? <div className="text-rose-300 text-xs font-mono">{err}</div> : null}
          <Button type="submit" className="w-full">{t("Sign in", "ဝင်ရန်")}</Button>
        </div>
      </form>
    </div>
  );
}
