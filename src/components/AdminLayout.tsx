import React, { useMemo, useRef, useState, useEffect } from "react";
import { useNavigate, useLocation, Outlet } from "react-router-dom";
import {
  LayoutDashboard,
  Landmark,
  Map,
  Settings,
  ShieldCheck,
  Globe,
  ChevronLeft,
  ChevronRight,
  PackageSearch,
  Truck,
  LogOut,
  UserCircle2,
} from "lucide-react";
import { useLanguage } from "@/contexts/LanguageContext";
import { useAuth } from "@/contexts/AuthContext";

type NavItem = {
  id: string;
  path: string;
  icon: React.ReactNode;
  label: { en: string; my: string };
};

const ROUTE_ORDER = [
  "/admin/dashboard",
  "/admin/approvals",
  "/admin/shipments",
  "/admin/fleet",
  "/admin/omni-finance",
  "/admin/live-map",
  "/admin/settings",
];

export default function AdminLayout() {
  const navigate = useNavigate();
  const location = useLocation();
  const { lang, toggleLang, t } = useLanguage();
  const { user, role, logout } = useAuth();

  const accountName = (user?.email?.split("@")[0] ?? user?.email ?? "—") as string;

  const menuItems: NavItem[] = useMemo(
    () => [
      {
        id: "dash",
        path: "/admin/dashboard",
        icon: <LayoutDashboard />,
        label: { en: "Executive Overview", my: "အမှုဆောင် ခြုံငုံသုံးသပ်ချက်" },
      },
      {
        id: "approvals",
        path: "/admin/approvals",
        icon: <ShieldCheck />,
        label: { en: "Account Approvals", my: "အကောင့် အတည်ပြုမှုများ" },
      },
      {
        id: "ship",
        path: "/admin/shipments",
        icon: <PackageSearch />,
        label: { en: "Shipment Control", my: "ပို့ဆောင်မှု ထိန်းချုပ်မှု" },
      },
      {
        id: "fleet",
        path: "/admin/fleet",
        icon: <Truck />,
        label: { en: "Fleet Command", my: "ယာဉ်တပ် စီမံခန့်ခွဲမှု" },
      },
      {
        id: "fin",
        path: "/admin/omni-finance",
        icon: <Landmark />,
        label: { en: "Global Finance", my: "ကမ္ဘာလုံးဆိုင်ရာ ငွေကြေး" },
      },
      {
        id: "map",
        path: "/admin/live-map",
        icon: <Map />,
        label: { en: "Live Telemetry", my: "တိုက်ရိုက် တယ်လီမထရီ" },
      },
      {
        id: "sets",
        path: "/admin/settings",
        icon: <Settings />,
        label: { en: "System Tariffs", my: "စနစ် အခွန်အကောက်" },
      },
    ],
    []
  );

  const idx = ROUTE_ORDER.indexOf(location.pathname);
  const prevPath = idx > 0 ? ROUTE_ORDER[idx - 1] : null;
  const nextPath = idx >= 0 && idx < ROUTE_ORDER.length - 1 ? ROUTE_ORDER[idx + 1] : null;

  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement | null>(null);

  useEffect(() => {
    function onDocClick(e: MouseEvent) {
      if (!ref.current) return;
      if (!ref.current.contains(e.target as Node)) setOpen(false);
    }
    document.addEventListener("mousedown", onDocClick);
    return () => document.removeEventListener("mousedown", onDocClick);
  }, []);

  const signOut = async () => {
    await logout();
    navigate("/login", { replace: true });
  };

  return (
    <div className="flex h-screen bg-[#0B101B] overflow-hidden font-sans text-slate-300">
      <aside className="w-80 bg-[#05080F]/80 backdrop-blur-xl border-r border-white/5 flex flex-col p-8 z-20">
        <div className="mb-12 flex items-center gap-3">
          <div className="h-10 w-10 bg-emerald-500 rounded-xl flex items-center justify-center">
            <ShieldCheck className="text-white" />
          </div>
          <span className="text-xl font-black text-white uppercase">
            Britium <span className="text-emerald-500">L5</span>
          </span>
        </div>

        <nav className="flex-1 space-y-2 overflow-y-auto pr-2">
          {menuItems.map((item) => (
            <button
              key={item.id}
              onClick={() => navigate(item.path)}
              className={`w-full flex items-center justify-between p-4 rounded-2xl transition-all group ${
                location.pathname === item.path
                  ? "bg-emerald-500/10 text-emerald-400 border border-emerald-500/20"
                  : "text-slate-500 hover:bg-white/5 hover:text-white"
              }`}
            >
              <div className="flex items-center gap-4 text-sm font-bold">
                <span
                  className={
                    location.pathname === item.path ? "text-emerald-400" : "group-hover:text-emerald-500"
                  }
                >
                  {item.icon}
                </span>
                {t(item.label.en, item.label.my)}
              </div>
            </button>
          ))}
        </nav>
      </aside>

      <main className="flex-1 flex flex-col relative overflow-hidden">
        <header className="h-20 bg-[#05080F]/50 backdrop-blur-md border-b border-white/5 flex items-center justify-between px-10 z-10">
          <div className="flex items-center gap-3">
            <button
              onClick={() => prevPath && navigate(prevPath)}
              disabled={!prevPath}
              className={`flex items-center gap-2 px-3 py-2 rounded-xl text-xs font-bold border transition-all ${
                prevPath
                  ? "bg-white/5 hover:bg-white/10 border-white/10 text-white"
                  : "bg-white/5 border-white/10 text-slate-600 cursor-not-allowed"
              }`}
            >
              <ChevronLeft className="h-4 w-4 text-emerald-500" />
              {t("Previous", "ယခင်")}
            </button>

            <button
              onClick={() => nextPath && navigate(nextPath)}
              disabled={!nextPath}
              className={`flex items-center gap-2 px-3 py-2 rounded-xl text-xs font-bold border transition-all ${
                nextPath
                  ? "bg-white/5 hover:bg-white/10 border-white/10 text-white"
                  : "bg-white/5 border-white/10 text-slate-600 cursor-not-allowed"
              }`}
            >
              {t("Next", "နောက်")}
              <ChevronRight className="h-4 w-4 text-emerald-500" />
            </button>
          </div>

          <div className="flex items-center gap-3">
            <button
              onClick={toggleLang}
              className="flex items-center gap-2 px-4 py-2 bg-white/5 hover:bg-white/10 border border-white/10 rounded-xl text-xs font-bold text-white transition-all"
            >
              <Globe className="h-4 w-4 text-emerald-500" />
              {lang === "en" ? "EN / MY" : "မြန်မာ / EN"}
            </button>

            <div className="relative" ref={ref}>
              <button
                onClick={() => setOpen((v) => !v)}
                className="flex items-center gap-2 px-4 py-2 bg-white/5 hover:bg-white/10 border border-white/10 rounded-xl text-xs font-bold text-white transition-all"
              >
                <UserCircle2 className="h-4 w-4 text-emerald-500" />
                <span className="max-w-[200px] truncate">{accountName}</span>
                {role ? <span className="text-[10px] text-slate-400">{String(role).toUpperCase()}</span> : null}
              </button>

              {open && (
                <div className="absolute right-0 mt-2 w-56 rounded-2xl border border-white/10 bg-[#05080F]/95 backdrop-blur-xl shadow-2xl overflow-hidden">
                  <button
                    onClick={() => (setOpen(false), navigate("/admin/accounts"))}
                    className="w-full px-4 py-3 text-left text-sm text-slate-200 hover:bg-white/5"
                  >
                    {t("Account Control", "အကောင့် ထိန်းချုပ်မှု")}
                  </button>
                  <button
                    onClick={() => (setOpen(false), navigate("/admin/hr"))}
                    className="w-full px-4 py-3 text-left text-sm text-slate-200 hover:bg-white/5"
                  >
                    {t("HR Portal", "ဝန်ထမ်း ပေါ်တယ်")}
                  </button>
                  <div className="h-px bg-white/10" />
                  <button
                    onClick={() => (setOpen(false), void signOut())}
                    className="w-full px-4 py-3 text-left text-sm text-rose-300 hover:bg-rose-500/10 flex items-center gap-2"
                  >
                    <LogOut className="h-4 w-4" />
                    {t("Sign out", "ထွက်ရန်")}
                  </button>
                </div>
              )}
            </div>

            <button
              onClick={() => void signOut()}
              className="flex items-center gap-2 px-4 py-2 bg-rose-500/10 hover:bg-rose-500/15 border border-rose-500/20 rounded-xl text-xs font-bold text-rose-200 transition-all"
            >
              <LogOut className="h-4 w-4" />
              {t("Sign out", "ထွက်ရန်")}
            </button>
          </div>
        </header>

        <div className="flex-1 overflow-y-auto p-10">
          <Outlet />
        </div>
      </main>
    </div>
  );
}
