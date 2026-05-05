import React from "react";
import { NavLink, Outlet } from "react-router-dom";
import { useLanguage } from "@/contexts/LanguageContext";
import { SUPER_ADMIN_NAV } from "../navigation/navItems";
import { Globe } from "lucide-react";

function cx(...classes: Array<string | false | undefined | null>) {
  return classes.filter(Boolean).join(" ");
}

export default function SuperAdminShell() {
  const { lang, toggleLang } = useLanguage();
  const t = (en: string, my: string) => (lang === "en" ? en : my);

  return (
    <div className="min-h-screen bg-[#05080F] text-white">
      {/* Top subtle gradient */}
      <div className="pointer-events-none fixed inset-0 opacity-60">
        <div className="absolute -top-48 left-1/2 h-[520px] w-[920px] -translate-x-1/2 rounded-full bg-emerald-500/10 blur-3xl" />
        <div className="absolute -top-72 left-10 h-[420px] w-[620px] rounded-full bg-blue-500/10 blur-3xl" />
      </div>

      <div className="relative flex">
        {/* Sidebar */}
        <aside className="hidden lg:flex lg:w-[320px] lg:flex-col lg:gap-6 lg:px-6 lg:py-7">
          <div className="flex items-center gap-3 px-2">
            <div className="h-10 w-10 rounded-2xl bg-emerald-500/15 border border-emerald-500/20 grid place-items-center">
              <span className="text-emerald-400 font-black">B</span>
            </div>
            <div>
              <div className="text-lg font-black tracking-wide uppercase">
                Britium <span className="text-emerald-400">L5</span>
              </div>
              <div className="text-[11px] text-slate-500">{t("Super Admin Console", "စူပါအက်မင် ကွန်ဆိုလ်")}</div>
            </div>
          </div>

          <nav className="flex flex-col gap-6 mt-4">
            {SUPER_ADMIN_NAV.map((sec) => (
              <div key={sec.sectionKey}>
                <div className="px-2 text-[11px] font-black uppercase tracking-widest text-slate-500">
                  {t(sec.label.en, sec.label.my)}
                </div>

                <div className="mt-2 flex flex-col gap-2">
                  {sec.items.map((item) => {
                    const Icon = item.icon;
                    return (
                      <NavLink
                        key={item.key}
                        to={item.to}
                        className={({ isActive }) =>
                          cx(
                            "group flex items-center gap-3 rounded-2xl px-4 py-3 border transition-all",
                            isActive
                              ? "bg-emerald-500/10 border-emerald-500/20 text-emerald-300 shadow-lg shadow-emerald-500/10"
                              : "bg-white/[0.02] border-white/5 text-slate-300 hover:bg-white/[0.04] hover:border-white/10"
                          )
                        }
                      >
                        <div className="h-10 w-10 rounded-2xl bg-white/5 border border-white/10 grid place-items-center">
                          <Icon className="h-5 w-5 text-slate-300 group-hover:text-white" />
                        </div>

                        <div className="flex-1 min-w-0">
                          <div className="flex items-center gap-2">
                            <div className="font-bold truncate">{t(item.label.en, item.label.my)}</div>
                            {item.badge && (
                              <span className="text-[10px] font-black px-2 py-0.5 rounded-full bg-rose-500/15 border border-rose-500/25 text-rose-300">
                                {item.badge}
                              </span>
                            )}
                          </div>
                          {item.description && (
                            <div className="text-[11px] text-slate-500 truncate">
                              {t(item.description.en, item.description.my)}
                            </div>
                          )}
                        </div>
                      </NavLink>
                    );
                  })}
                </div>
              </div>
            ))}
          </nav>
        </aside>

        {/* Main */}
        <main className="flex-1 px-4 sm:px-6 lg:px-10 py-6 lg:py-8">
          {/* Topbar */}
          <div className="flex items-center justify-between gap-4">
            <div className="hidden lg:block" />
            <button
              onClick={toggleLang}
              className="ml-auto inline-flex items-center gap-2 rounded-2xl border border-white/15 bg-white/[0.03] px-4 py-2 text-sm font-black hover:bg-white/[0.06] transition-all"
              title={t("Switch language", "ဘာသာစကား ပြောင်းရန်")}
            >
              <Globe className="h-4 w-4 text-emerald-300" />
              {lang === "en" ? "EN / MY" : "MY / EN"}
            </button>
          </div>

          <div className="mt-6">
            <Outlet />
          </div>
        </main>
      </div>
    </div>
  );
}
