import React from "react";
import { Link } from "react-router-dom";
import { useLanguage } from "@/contexts/LanguageContext";
import { KPIS, QUICK_ACTIONS, AUDIT_FEED } from "../mock/mockData";
import {
  Users,
  Activity,
  Shield,
  KeyRound,
  ArrowRight,
} from "lucide-react";

function cx(...classes: Array<string | false | undefined | null>) {
  return classes.filter(Boolean).join(" ");
}

const KPI_ICONS: Record<string, any> = {
  personnel: Users,
  riders: Activity,
  security: Shield,
  rotation: KeyRound,
};

export default function CommandCenter() {
  const { lang } = useLanguage();
  const t = (en: string, my: string) => (lang === "en" ? en : my);

  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      {/* Header */}
      <div className="flex flex-col gap-3">
        <div className="flex items-center justify-between gap-4">
          <div className="flex items-center gap-3">
            <span className="text-[11px] font-black uppercase tracking-widest text-emerald-300 border border-emerald-500/25 bg-emerald-500/10 px-3 py-1 rounded-lg">
              {t("Authorized User", "ခွင့်ပြုထားသော အသုံးပြုသူ")}
            </span>
            <span className="text-[11px] font-black uppercase tracking-widest text-slate-500">
              {t("Session Active", "အလုပ်လည်နေသည်")}
            </span>
          </div>

          <div className="text-right">
            <div className="text-[11px] font-black uppercase tracking-widest text-slate-500">
              {t("System Status", "စနစ် အခြေအနေ")}
            </div>
            <div className="mt-1 inline-flex items-center gap-2 text-emerald-300 text-[11px] font-black uppercase tracking-widest">
              <span className="h-2 w-2 rounded-full bg-emerald-400" />
              {t("All Systems Nominal", "စနစ် အားလုံး ပုံမှန်")}
            </div>
          </div>
        </div>

        <h1 className="text-4xl md:text-5xl font-black uppercase tracking-wider text-white">
          {t("Command Center", "ညွှန်ကြားရေးစင်တာ")}
        </h1>
        <div className="h-px bg-white/5" />
      </div>

      {/* KPI cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-4 gap-5">
        {KPIS.map((kpi) => {
          const Icon = KPI_ICONS[kpi.key] ?? Activity;
          return (
            <Link
              key={kpi.key}
              to={kpi.to}
              className="group rounded-3xl border border-white/5 bg-[#111622] p-6 shadow-2xl hover:border-white/10 hover:bg-white/[0.03] transition-all"
            >
              <div className="flex items-center justify-between">
                <div className="h-12 w-12 rounded-2xl bg-white/5 border border-white/10 grid place-items-center">
                  <Icon className="h-6 w-6 text-emerald-300" />
                </div>
                <ArrowRight className="h-4 w-4 text-slate-600 group-hover:text-slate-300 transition-colors" />
              </div>

              <div className="mt-6 text-4xl font-black text-white">{kpi.value}</div>
              <div className="mt-1 text-[11px] font-black uppercase tracking-widest text-slate-500">
                {t(kpi.labelEn, kpi.labelMy)}
              </div>
            </Link>
          );
        })}
      </div>

      {/* Quick actions + Live audit feed */}
      <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
        {/* Quick actions */}
        <div className="xl:col-span-2">
          <div className="flex items-center gap-3 mb-4">
            <Activity className="h-5 w-5 text-emerald-300" />
            <div className="text-sm font-black uppercase tracking-widest text-white">
              {t("Quick Actions", "အမြန် လုပ်ဆောင်ချက်များ")}
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
            {QUICK_ACTIONS.map((a) => (
              <Link
                key={a.key}
                to={a.to}
                className={cx(
                  "group rounded-3xl border border-white/5 bg-[#111622] p-6 shadow-2xl transition-all",
                  "hover:border-white/10 hover:bg-white/[0.03]"
                )}
              >
                <div className="text-lg font-black text-white">{t(a.titleEn, a.titleMy)}</div>
                <p className="mt-2 text-sm text-slate-400 leading-relaxed">
                  {t(a.descEn, a.descMy)}
                </p>

                <div className="mt-5 inline-flex items-center gap-2 text-[11px] font-black uppercase tracking-widest text-emerald-300">
                  {t("Launch Module", "မော်ဂျူး ဝင်ရန်")} <ArrowRight className="h-4 w-4" />
                </div>
              </Link>
            ))}
          </div>
        </div>

        {/* Live audit feed */}
        <div className="rounded-3xl border border-white/5 bg-[#111622] p-6 shadow-2xl">
          <div className="flex items-center gap-3 mb-4">
            <Shield className="h-5 w-5 text-amber-300" />
            <div className="text-sm font-black uppercase tracking-widest text-white">
              {t("Live Audit Feed", "တိုက်ရိုက် စစ်ဆေးမှတ်တမ်း")}
            </div>
          </div>

          <div className="space-y-3">
            {AUDIT_FEED.map((e) => (
              <div key={e.id} className="rounded-2xl border border-white/5 bg-[#0B1020] p-4">
                <div className="flex items-center justify-between gap-3">
                  <div className="text-[11px] font-black uppercase tracking-widest text-slate-500">
                    {e.at} • {e.actor}
                  </div>
                  <span
                    className={cx(
                      "text-[10px] font-black px-2 py-0.5 rounded-full border",
                      e.severity === "critical" && "bg-rose-500/15 border-rose-500/25 text-rose-300",
                      e.severity === "warn" && "bg-amber-500/15 border-amber-500/25 text-amber-300",
                      e.severity === "info" && "bg-emerald-500/10 border-emerald-500/20 text-emerald-300"
                    )}
                  >
                    {e.severity.toUpperCase()}
                  </span>
                </div>
                <div className="mt-2 text-sm text-slate-300">
                  {t(e.actionEn, e.actionMy)}
                </div>
              </div>
            ))}
          </div>

          <Link
            to="/admin/audit"
            className="mt-5 inline-flex items-center gap-2 text-[11px] font-black uppercase tracking-widest text-slate-300 hover:text-white transition-colors"
          >
            {t("Open full audit log", "စစ်ဆေးမှတ်တမ်း အပြည့်အစုံ ကြည့်ရန်")}
            <ArrowRight className="h-4 w-4" />
          </Link>
        </div>
      </div>
    </div>
  );
}
