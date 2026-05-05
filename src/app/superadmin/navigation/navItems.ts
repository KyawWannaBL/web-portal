import {
  LayoutDashboard,
  BadgeCheck,
  Truck,
  Shield,
  Activity,
  Settings,
  Users,
  Building2,
  KeyRound,
  PlugZap,
  ClipboardList,
  DollarSign,
  Boxes,
  MapPin,
  Flag,
  Bell,
  Lock,
  Languages,
} from "lucide-react";
import { PATHS, type PathValue } from "./paths";

export type NavSection = {
  sectionKey: string;
  label: { en: string; my: string };
  items: NavItem[];
};

export type NavItem = {
  key: string;
  label: { en: string; my: string };
  to: PathValue;
  icon: any;
  description?: { en: string; my: string };
  badge?: string;
};

export const SUPER_ADMIN_NAV: NavSection[] = [
  {
    sectionKey: "command",
    label: { en: "Command", my: "ညွှန်ကြားရေး" },
    items: [
      {
        key: "command-center",
        label: { en: "Command Center", my: "ညွှန်ကြားရေးစင်တာ" },
        to: PATHS.commandCenter,
        icon: LayoutDashboard,
        description: {
          en: "Enterprise overview and fast module entry.",
          my: "စနစ်အနှံ့ အကျဉ်းချုပ်နှင့် မော်ဂျူးများသို့ အမြန်ဝင်ရောက်ရန်။",
        },
      },
    ],
  },

  {
    sectionKey: "approvals",
    label: { en: "Approvals", my: "အတည်ပြုချက်များ" },
    items: [
      {
        key: "account-approvals",
        label: { en: "Account Approvals", my: "အကောင့် အတည်ပြုခြင်း" },
        to: PATHS.approvals.accounts,
        icon: BadgeCheck,
        description: {
          en: "Review and approve access requests.",
          my: "ဝင်ရောက်ခွင့် တောင်းဆိုမှုများကို စစ်ဆေး/အတည်ပြုပါ။",
        },
        badge: "3",
      },
    ],
  },

  {
    sectionKey: "operations",
    label: { en: "Operations", my: "လုပ်ငန်းစဉ်များ" },
    items: [
      {
        key: "shipments",
        label: { en: "Shipment Control", my: "ပို့ဆောင်မှု ထိန်းချုပ်ရေး" },
        to: PATHS.operations.shipments,
        icon: Truck,
        description: {
          en: "Create, route, dispatch, and manage shipments.",
          my: "ပို့ဆောင်မှု ဖန်တီး၊ လမ်းကြောင်းချ၊ တင်ပို့၊ စီမံခန့်ခွဲပါ။",
        },
      },
      {
        key: "fleet",
        label: { en: "Fleet Command", my: "ယာဉ်အုပ်စု စီမံခန့်ခွဲရေး" },
        to: PATHS.operations.fleet,
        icon: Activity,
        description: {
          en: "Riders, vehicles, assignments, and capacity.",
          my: "ရိုက်ဒါများ၊ ယာဉ်များ၊ တာဝန်ခန့်ထားမှုနှင့် စွမ်းဆောင်ရည်။",
        },
      },
      {
        key: "hubs",
        label: { en: "Network Hubs", my: "ကွန်ရက် ဟပ်များ" },
        to: PATHS.operations.hubs,
        icon: MapPin,
        description: {
          en: "Stations, substations, coverage, and routing nodes.",
          my: "စခန်းများ၊ ဆပ်စတေရှင်များ၊ ကာဗရိဂျ်နှင့် ရောတ်တင်နိုဒ်များ။",
        },
      },
      {
        key: "warehouses",
        label: { en: "Warehouses", my: "ဂိုဒေါင်များ" },
        to: PATHS.operations.warehouses,
        icon: Boxes,
        description: {
          en: "Inventory, inbound/outbound, and scanning flows.",
          my: "ပစ္စည်းစာရင်း၊ ဝင်/ထွက်၊ စကန်ဖလိုများ။",
        },
      },
    ],
  },

  {
    sectionKey: "finance",
    label: { en: "Finance", my: "ငွေကြေး" },
    items: [
      {
        key: "finance-overview",
        label: { en: "Global Finance", my: "ငွေကြေး အကျဉ်းချုပ်" },
        to: PATHS.finance.overview,
        icon: DollarSign,
        description: {
          en: "Revenue, costs, invoices, and settlements.",
          my: "ဝင်ငွေ၊ ကုန်ကျစရိတ်၊ ဘောက်ချာများနှင့် ငွေရှင်းတမ်းများ။",
        },
      },
      {
        key: "billing",
        label: { en: "Billing & Plans", my: "ဘီလ်နှင့် ပလန်များ" },
        to: PATHS.finance.billing,
        icon: ClipboardList,
        description: {
          en: "Enterprise billing rules and plans.",
          my: "စီးပွားရေးအဆင့် ဘီလ်စည်းမျဉ်းများနှင့် ပလန်များ။",
        },
      },
    ],
  },

  {
    sectionKey: "telemetry",
    label: { en: "Telemetry", my: "တယ်လီမေတာရီ" },
    items: [
      {
        key: "live-telemetry",
        label: { en: "Live Telemetry", my: "တိုက်ရိုက် တယ်လီမေတာရီ" },
        to: PATHS.telemetry.live,
        icon: Activity,
        description: {
          en: "Events, pings, and real-time operations health.",
          my: "အဖြစ်အပျက်များ၊ ပင့်ဂ်များ၊ လုပ်ငန်းစဉ်အခြေအနေ (Realtime)။",
        },
      },
      {
        key: "monitoring",
        label: { en: "Monitoring", my: "စောင့်ကြည့်မှု" },
        to: PATHS.telemetry.monitoring,
        icon: Shield,
        description: {
          en: "SLA, incidents, uptime, and alerts.",
          my: "SLA၊ အရေးပေါ်ဖြစ်ရပ်များ၊ uptime နှင့် အချက်ပေးချက်များ။",
        },
      },
    ],
  },

  {
    sectionKey: "administration",
    label: { en: "Administration", my: "စီမံခန့်ခွဲမှု" },
    items: [
      {
        key: "tenants",
        label: { en: "Tenants / Orgs", my: "အဖွဲ့အစည်း / တင်နန့်များ" },
        to: PATHS.admin.tenants,
        icon: Building2,
        description: {
          en: "Enterprise orgs, environments, and limits.",
          my: "အဖွဲ့အစည်းများ၊ အင်ဗာယာမင့်များနှင့် ကန့်သတ်ချက်များ။",
        },
      },
      {
        key: "users",
        label: { en: "Users & Access", my: "အသုံးပြုသူများနှင့် ဝင်ရောက်ခွင့်" },
        to: PATHS.admin.users,
        icon: Users,
      },
      {
        key: "roles",
        label: { en: "Roles & RBAC", my: "အခန်းကဏ္ဍများနှင့် RBAC" },
        to: PATHS.admin.roles,
        icon: Shield,
      },
      {
        key: "audit",
        label: { en: "Audit Log", my: "စစ်ဆေးမှတ်တမ်း" },
        to: PATHS.admin.audit,
        icon: ClipboardList,
      },
      {
        key: "api-keys",
        label: { en: "API Keys", my: "API ကီးများ" },
        to: PATHS.admin.apiKeys,
        icon: KeyRound,
      },
      {
        key: "integrations",
        label: { en: "Integrations", my: "ပေါင်းစည်းမှုများ" },
        to: PATHS.admin.integrations,
        icon: PlugZap,
      },
    ],
  },

  {
    sectionKey: "system",
    label: { en: "System", my: "စနစ်" },
    items: [
      {
        key: "settings-home",
        label: { en: "System Settings", my: "စနစ် သတ်မှတ်ချက်များ" },
        to: PATHS.system.settingsHome,
        icon: Settings,
      },
      {
        key: "tariffs",
        label: { en: "Tariff Settings", my: "ခနှုန်းထား သတ်မှတ်ချက်" },
        to: PATHS.system.tariffs,
        icon: DollarSign,
        description: {
          en: "Local zones, international rates, and hub expansion.",
          my: "ပြည်တွင်းဇုန်များ၊ နိုင်ငံတကာနှုန်းထားများနှင့် ဟပ်တိုးချဲ့မှု။",
        },
      },
      {
        key: "shipping-calculator",
        label: { en: "Shipping Calculator", my: "ပို့ဆောင်ခ တွက်ချက်ရေး" },
        to: PATHS.system.shippingCalculator,
        icon: Boxes,
      },
      {
        key: "feature-flags",
        label: { en: "Feature Flags", my: "အင်္ဂါရပ် ခလုတ်များ" },
        to: PATHS.system.featureFlags,
        icon: Flag,
      },
      {
        key: "notifications",
        label: { en: "Notifications", my: "အသိပေးချက်များ" },
        to: PATHS.system.notifications,
        icon: Bell,
      },
      {
        key: "security",
        label: { en: "Security", my: "လုံခြုံရေး" },
        to: PATHS.system.security,
        icon: Lock,
      },
      {
        key: "localization",
        label: { en: "Localization", my: "ဘာသာစကား/ဒေသဆိုင်ရာ" },
        to: PATHS.system.localization,
        icon: Languages,
      },
    ],
  },

  {
    sectionKey: "reports",
    label: { en: "Insights", my: "အချက်အလက်/သုံးသပ်ချက်" },
    items: [
      {
        key: "reports",
        label: { en: "Reports", my: "အစီရင်ခံစာများ" },
        to: PATHS.reports,
        icon: ClipboardList,
      },
    ],
  },
];
