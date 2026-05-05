import { PATHS } from "../navigation/paths";

export type Kpi = { key: string; labelEn: string; labelMy: string; value: string; to: string };
export type AuditEvent = { id: string; at: string; actor: string; actionEn: string; actionMy: string; severity: "info"|"warn"|"critical" };

export const KPIS: Kpi[] = [
  { key: "personnel", labelEn: "Total Personnel", labelMy: "ဝန်ထမ်းစုစုပေါင်း", value: "1", to: PATHS.admin.users },
  { key: "riders", labelEn: "Active Riders", labelMy: "လက်ရှိ ရိုက်ဒါ", value: "—", to: PATHS.operations.fleet },
  { key: "security", labelEn: "Security Events", labelMy: "လုံခြုံရေး ဖြစ်ရပ်", value: "0", to: PATHS.system.security },
  { key: "rotation", labelEn: "Rotation Required", labelMy: "ပြောင်းလဲရန် လိုအပ်", value: "0", to: PATHS.admin.roles },
];

export const QUICK_ACTIONS = [
  { key: "account", titleEn: "Account Control", titleMy: "အကောင့် ထိန်းချုပ်ရေး", descEn: "Manage roles, clearances, and access levels.", descMy: "အခန်းကဏ္ဍ၊ ခွင့်ပြုချက်နှင့် ဝင်ရောက်ခွင့်အဆင့်များ စီမံပါ။", to: PATHS.admin.users },
  { key: "shipments", titleEn: "Shipment Control", titleMy: "ပို့ဆောင်မှု ထိန်းချုပ်ရေး", descEn: "Create, route, dispatch, and monitor deliveries.", descMy: "ပို့ဆောင်မှု ဖန်တီး၊ လမ်းကြောင်းချ၊ တင်ပို့၊ စောင့်ကြည့်ပါ။", to: PATHS.operations.shipments },
  { key: "fleet", titleEn: "Fleet Command", titleMy: "ယာဉ်အုပ်စု စီမံခန့်ခွဲရေး", descEn: "Capacity, assignments, rider health, and locations.", descMy: "စွမ်းဆောင်ရည်၊ တာဝန်ခန့်ထားမှု၊ ရိုက်ဒါအခြေအနေ၊ တည်နေရာများ။", to: PATHS.operations.fleet },
  { key: "tariffs", titleEn: "System Tariffs", titleMy: "စနစ် ခနှုန်းထားများ", descEn: "Local pricing zones and international air cargo rates.", descMy: "ပြည်တွင်းဇုန်ဈေးနှုန်းများနှင့် နိုင်ငံတကာ လေကြောင်းနှုန်းထားများ။", to: PATHS.system.tariffs },
  { key: "calc", titleEn: "Shipping Calculator", titleMy: "ပို့ဆောင်ခ တွက်ချက်ရေး", descEn: "Instant quotes using your configured tariffs.", descMy: "သတ်မှတ်ထားသော ခနှုန်းထားဖြင့် ချက်ချင်းဈေးနှုန်းတွက်ပါ။", to: PATHS.system.shippingCalculator },
];

export const AUDIT_FEED: AuditEvent[] = [
  { id: "evt_001", at: "2026-03-01 09:14", actor: "superadmin", actionEn: "Updated Yangon Zone 2 tariff to 2,500 MMK", actionMy: "ရန်ကုန် ဇုန် ၂ ခနှုန်းထားကို ၂,၅၀၀ ကျပ်သို့ ပြင်ဆင်ခဲ့သည်", severity: "info" },
  { id: "evt_002", at: "2026-03-01 09:16", actor: "superadmin", actionEn: "Added international route: Singapore", actionMy: "နိုင်ငံတကာ လမ်းကြောင်း (စင်္ကာပူ) ထည့်သွင်းခဲ့သည်", severity: "warn" },
  { id: "evt_003", at: "2026-03-01 09:20", actor: "system", actionEn: "All systems nominal", actionMy: "စနစ် အားလုံး ပုံမှန်", severity: "info" },
];
