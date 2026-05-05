import React, { useEffect, useMemo, useState } from "react";
import { useLanguage } from "@/contexts/LanguageContext";
import { Calculator, MapPin, Box, Truck } from "lucide-react";

const BASE_WEIGHT_KG = 1;
const EXTRA_WEIGHT_FEE_MMK = 500;

const YANGON_ZONES = [
  { label: "Zone 1 - Downtown & Inner City", rate: 3000 },
  { label: "Zone 2 - Outer City", rate: 3500 },
  { label: "Zone 3 - Periphery", rate: 4500 },
];

export default function ShippingCalculatorAdmin() {
  const { lang } = useLanguage();
  const t = (en: string, my: string) => (lang === "en" ? en : my);

  const [region, setRegion] = useState<"yangon" | "mandalay" | "other">("yangon");
  const [townshipRate, setTownshipRate] = useState<number | "">("");
  const [weight, setWeight] = useState<number | "">(1);

  const [totalPrice, setTotalPrice] = useState<number | null>(null);
  const [deliveryTime, setDeliveryTime] = useState<string>("");

  useEffect(() => {
    if (region === "yangon") {
      if (townshipRate !== "") {
        const safeWeight = Number(weight) || 0;
        const extraWeight = safeWeight > BASE_WEIGHT_KG ? safeWeight - BASE_WEIGHT_KG : 0;
        const extraCost = extraWeight * EXTRA_WEIGHT_FEE_MMK;
        setTotalPrice(Number(townshipRate) + extraCost);
        setDeliveryTime(t("1-2 Business Days", "၁-၂ အလုပ်လုပ်ရက်"));
      } else {
        setTotalPrice(null);
        setDeliveryTime(t("Select a Zone", "ဇုန် ရွေးချယ်ပါ"));
      }
    } else if (region === "mandalay") {
      setTotalPrice(3000);
      setDeliveryTime(t("2-3 Business Days", "၂-၃ အလုပ်လုပ်ရက်"));
    } else {
      setTotalPrice(null);
      setDeliveryTime(t("Remote Area (Call for Quote)", "နယ်ဝေး (ဈေးနှုန်းအတွက် ဆက်သွယ်ပါ)"));
    }
  }, [region, townshipRate, weight, lang]);

  const hint = useMemo(
    () =>
      t(
        "*Base rate covers 1st Kg. Additional weight +500 MMK/Kg. Final price subject to actual measurements.",
        "*အခြေခံနှုန်းထားသည် ပထမ ၁ ကီလိုဂရမ်အတွက် ဖြစ်သည်။ အပိုအလေးချိန် ၁ ကီလိုဂရမ်လျှင် +၅၀၀ ကျပ် ထပ်ဆောင်းပါမည်။"
      ),
    [lang]
  );

  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      <div>
        <h2 className="text-2xl font-black uppercase tracking-wide text-white">
          {t("Shipping Rate Calculator", "ပို့ဆောင်ခ တွက်ချက်ရေး")}
        </h2>
        <p className="mt-1 text-sm text-slate-400">
          {t(
            "Admin calculator uses configured tariffs. Replace constants with live tariff API when ready.",
            "Admin calculator သည် သတ်မှတ်ထားသော ခနှုန်းထားကို အသုံးပြုသည်။ Ready ဖြစ်ပါက constants ကို live tariff API ဖြင့် အစားထိုးပါ။"
          )}
        </p>
      </div>

      <div className="rounded-3xl border border-white/5 bg-[#111622] shadow-2xl overflow-hidden">
        <div className="grid grid-cols-1 lg:grid-cols-3">
          {/* Form */}
          <div className="p-6 lg:p-8 lg:col-span-2">
            <div className="flex items-center gap-3 mb-6">
              <Calculator className="text-emerald-300" />
              <h3 className="text-lg font-black text-white">{t("Shipment Details", "ပို့ဆောင်မည့် အချက်အလက်များ")}</h3>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {/* Origin */}
              <div className="space-y-2">
                <label className="text-xs font-black uppercase tracking-widest text-slate-400">{t("Origin", "စတင်မည့် နေရာ")}</label>
                <div className="relative">
                  <MapPin className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500 h-5 w-5" />
                  <select disabled className="w-full h-12 pl-12 pr-4 bg-[#05080F] border border-white/10 rounded-2xl text-slate-400 font-bold">
                    <option>{t("From: Yangon", "ရန်ကုန်မြို့မှ")}</option>
                  </select>
                </div>
              </div>

              {/* Region */}
              <div className="space-y-2">
                <label className="text-xs font-black uppercase tracking-widest text-slate-400">{t("Destination Region", "ပို့ဆောင်မည့် တိုင်းဒေသကြီး")}</label>
                <select
                  value={region}
                  onChange={(e) => {
                    setRegion(e.target.value as any);
                    setTownshipRate("");
                  }}
                  className="w-full h-12 px-4 bg-[#05080F] border border-white/10 rounded-2xl text-white font-bold outline-none focus:border-emerald-500"
                >
                  <option value="yangon">{t("Yangon Region", "ရန်ကုန်တိုင်းဒေသကြီး")}</option>
                  <option value="mandalay">{t("Mandalay Region", "မန္တလေးတိုင်းဒေသကြီး")}</option>
                  <option value="other">{t("Other States/Regions", "အခြား ပြည်နယ်/တိုင်းဒေသကြီးများ")}</option>
                </select>
              </div>

              {/* Zone */}
              <div className="space-y-2">
                <label className="text-xs font-black uppercase tracking-widest text-slate-400">{t("Zone", "ဇုန်")}</label>
                <select
                  value={townshipRate}
                  onChange={(e) => setTownshipRate(e.target.value === "" ? "" : Number(e.target.value))}
                  disabled={region !== "yangon"}
                  className="w-full h-12 px-4 bg-[#05080F] border border-white/10 rounded-2xl text-white font-bold outline-none focus:border-emerald-500 disabled:opacity-50"
                >
                  <option value="" disabled>
                    {region === "yangon" ? t("-- Select Zone --", "-- ဇုန် ရွေးပါ --") : t("N/A for this region", "ဤတိုင်းဒေသကြီးတွင် မလိုပါ")}
                  </option>
                  {region === "yangon" &&
                    YANGON_ZONES.map((z) => (
                      <option key={z.label} value={z.rate}>
                        {z.label} — {z.rate.toLocaleString()} MMK
                      </option>
                    ))}
                </select>
              </div>

              {/* Weight */}
              <div className="space-y-2">
                <label className="text-xs font-black uppercase tracking-widest text-slate-400">{t("Weight (Kg)", "အလေးချိန် (ကီလိုဂရမ်)")}</label>
                <div className="relative">
                  <Box className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500 h-5 w-5" />
                  <input
                    type="number"
                    min="0.5"
                    step="0.5"
                    value={weight}
                    onChange={(e) => setWeight(e.target.value === "" ? "" : Number(e.target.value))}
                    className="w-full h-12 pl-12 pr-16 bg-[#05080F] border border-white/10 rounded-2xl text-white font-black outline-none focus:border-emerald-500"
                  />
                  <span className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 font-black">Kg</span>
                </div>
              </div>
            </div>

            <p className="mt-6 text-xs text-slate-500">{hint}</p>
          </div>

          {/* Result */}
          <div className="p-6 lg:p-8 border-t lg:border-t-0 lg:border-l border-white/5 bg-[#0B1020] flex flex-col justify-center">
            <div className="text-center">
              <div className="text-[11px] font-black uppercase tracking-widest text-slate-500">
                {t("Estimated Cost", "ခန့်မှန်း ကုန်ကျစရိတ်")}
              </div>

              <div className="mt-4">
                {totalPrice ? (
                  <div className="text-4xl font-black text-emerald-300">
                    {totalPrice.toLocaleString()} <span className="text-lg text-slate-500">MMK</span>
# ===============================
# 1) Create branch
# ===============================
git checkout -b feat/superadmin-command-center

# ===============================
# 2) Scaffold folders
# ===============================
mkdir -p src/app/superadmin/{layout,navigation,pages,router,settings,mock,shared}

# ===============================
# 3) Paths (single source of truth)
# ===============================
cat > src/app/superadmin/navigation/paths.ts <<'EOF'
export const PATHS = {
  commandCenter: "/command-center",

  approvals: {
    accounts: "/approvals/accounts",
  },

  operations: {
    shipments: "/operations/shipments",
    fleet: "/operations/fleet",
    hubs: "/operations/hubs",
    warehouses: "/operations/warehouses",
  },

  finance: {
    overview: "/finance/overview",
    billing: "/finance/billing",
  },

  telemetry: {
    live: "/telemetry/live",
    monitoring: "/telemetry/monitoring",
  },

  admin: {
    tenants: "/admin/tenants",
    users: "/admin/users",
    roles: "/admin/roles",
    audit: "/admin/audit",
    apiKeys: "/admin/api-keys",
    integrations: "/admin/integrations",
  },

  system: {
    settingsHome: "/system/settings",
    tariffs: "/system/settings/tariffs",
    shippingCalculator: "/system/settings/shipping-calculator",
    featureFlags: "/system/settings/feature-flags",
    notifications: "/system/settings/notifications",
    security: "/system/settings/security",
    localization: "/system/settings/localization",
  },

  reports: "/reports",
} as const;

export type PathValue =
  | typeof PATHS.commandCenter
  | typeof PATHS.approvals.accounts
  | typeof PATHS.operations.shipments
  | typeof PATHS.operations.fleet
  | typeof PATHS.operations.hubs
  | typeof PATHS.operations.warehouses
  | typeof PATHS.finance.overview
  | typeof PATHS.finance.billing
  | typeof PATHS.telemetry.live
  | typeof PATHS.telemetry.monitoring
  | typeof PATHS.admin.tenants
  | typeof PATHS.admin.users
  | typeof PATHS.admin.roles
  | typeof PATHS.admin.audit
  | typeof PATHS.admin.apiKeys
  | typeof PATHS.admin.integrations
  | typeof PATHS.system.settingsHome
  | typeof PATHS.system.tariffs
  | typeof PATHS.system.shippingCalculator
  | typeof PATHS.system.featureFlags
  | typeof PATHS.system.notifications
  | typeof PATHS.system.security
  | typeof PATHS.system.localization
  | typeof PATHS.reports;
