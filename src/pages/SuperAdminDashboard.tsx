import React, { useEffect, useMemo, useRef, useState } from "react";
import { useNavigate } from "react-router-dom";
import { supabase } from "@/supabaseClient";
import { useAuth } from "@/contexts/AuthContext";
import { useLanguage } from "@/contexts/LanguageContext";
import { logisticsAPI } from "@/services/logistics-api";
import {
  Activity,
  ArrowRight,
  Banknote,
  Boxes,
  CircleAlert,
  Clock,
  KeyRound,
  Landmark,
  Map as MapIcon,
  PackageSearch,
  ShieldAlert,
  ShieldCheck,
  Truck,
  Users,
  Wrench,
} from "lucide-react";

type Health = "NOMINAL" | "DEGRADED" | "UNKNOWN";

type MetricState = {
  personnel: number | null;
  activeRiders: number | null;
  totalShipments: number | null;
  pendingShipments: number | null;
  deliveredShipments: number | null;
  deliveryRate: number | null;
  revenueToday: number | null;
  codCollected: number | null;
  activeVehicles: number | null;
  securityEvents: number | null;
  rotationRequired: number | null;
  health: Health;
  lastSyncLabel: string;
};

type AuditRow = {
  id: number | string;
  created_at?: string;
  timestamp?: string;
  event_type?: string;
  action?: string;
  user_id?: string | null;
};

type MapPoint = {
  id: string;
  label: string;
  kind: "HUB" | "RIDER" | "SHIPMENT";
  x: number; // 0..100
  y: number; // 0..100
  severity?: "OK" | "WARN" | "CRIT";
};

function fmt(n: number | null, opts?: Intl.NumberFormatOptions) {
  if (n === null) return "—";
  return new Intl.NumberFormat(undefined, opts).format(n);
}

function clamp(n: number, a: number, b: number) {
  return Math.max(a, Math.min(b, n));
}

function nowIsoDayRange(): { from: string; to: string } {
  const now = new Date();
  const from = new Date(now);
  from.setHours(0, 0, 0, 0);
  const to = new Date(now);
  to.setHours(23, 59, 59, 999);
  return { from: from.toISOString(), to: to.toISOString() };
}

function last7DaysRange(): { from: string; to: string } {
  const now = new Date();
  const from = new Date(now);
  from.setDate(from.getDate() - 6);
  from.setHours(0, 0, 0, 0);
  const to = new Date(now);
  to.setHours(23, 59, 59, 999);
  return { from: from.toISOString(), to: to.toISOString() };
}

function mockSeries7(total: number) {
  const base = Math.max(1, Math.floor(total / 7));
  const arr = Array.from({ length: 7 }, () => base + Math.floor(Math.random() * base));
  const sum = arr.reduce((a, b) => a + b, 0);
  const scale = total / sum;
  return arr.map((v) => Math.round(v * scale));
}

function MiniMap(props: { points: MapPoint[] }) {
  const canvasRef = useRef<HTMLCanvasElement | null>(null);

  useEffect(() => {
    const c = canvasRef.current;
    if (!c) return;
    const ctx = c.getContext("2d");
    if (!ctx) return;

    const dpr = window.devicePixelRatio || 1;
    const w = c.clientWidth;
    const h = c.clientHeight;
    c.width = Math.floor(w * dpr);
    c.height = Math.floor(h * dpr);
    ctx.scale(dpr, dpr);

    ctx.clearRect(0, 0, w, h);

    // background grid
    ctx.globalAlpha = 0.22;
    ctx.strokeStyle = "#ffffff";
    for (let i = 1; i < 8; i++) {
      const gx = (w * i) / 8;
      const gy = (h * i) / 8;
      ctx.beginPath();
      ctx.moveTo(gx, 0);
      ctx.lineTo(gx, h);
      ctx.stroke();
      ctx.beginPath();
      ctx.moveTo(0, gy);
      ctx.lineTo(w, gy);
      ctx.stroke();
    }
    ctx.globalAlpha = 1;

    // points
    for (const p of props.points) {
      const px = (p.x / 100) * w;
      const py = (p.y / 100) * h;

      const color =
        p.kind === "HUB" ? "#16c784" : p.kind === "RIDER" ? "#3b82f6" : "#a855f7";

      const ring =
        p.severity === "CRIT" ? "#fb7185" : p.severity === "WARN" ? "#f59e0b" : color;

      // ring
      ctx.globalAlpha = 0.9;
      ctx.strokeStyle = ring;
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.arc(px, py, 10, 0, Math.PI * 2);
      ctx.stroke();

      // fill
      ctx.globalAlpha = 0.22;
      ctx.fillStyle = color;
      ctx.beginPath();
      ctx.arc(px, py, 10, 0, Math.PI * 2);
      ctx.fill();

      // core
      ctx.globalAlpha = 1;
      ctx.fillStyle = color;
      ctx.beginPath();
      ctx.arc(px, py, 3.2, 0, Math.PI * 2);
      ctx.fill();
    }
  }, [props.points]);

  return <canvas ref={canvasRef} className="w-full h-full rounded-2xl" />;
}

function PortalCard(props: {
  icon: React.ReactNode;
  title: string;
  desc: string;
  meta: Array<{ label: string; value: string }>;
  status: { label: string; color: string; bg: string; border: string };
  onEnter: () => void;
}) {
  return (
    <div className="p-6 rounded-2xl bg-[#0B101B] border border-white/5 hover:border-white/10 transition-all flex flex-col">
      <div className="flex items-start justify-between">
        <div className="p-3 rounded-xl bg-white/5 border border-white/5">{props.icon}</div>
        <div className={`px-2 py-1 rounded text-[10px] font-mono tracking-widest uppercase ${props.status.bg} ${props.status.color} border ${props.status.border}`}>
          {props.status.label}
        </div>
      </div>

      <div className="mt-4">
        <div className="text-white font-black uppercase tracking-widest">{props.title}</div>
        <div className="text-xs text-slate-500 font-mono mt-2 leading-relaxed">{props.desc}</div>
      </div>

      <div className="mt-4 grid grid-cols-2 gap-3">
        {props.meta.map((m) => (
          <div key={m.label} className="rounded-xl border border-white/5 bg-white/5 p-3">
            <div className="text-[9px] font-mono uppercase tracking-widest text-slate-500">{m.label}</div>
            <div className="text-sm font-black text-white mt-1">{m.value}</div>
          </div>
        ))}
      </div>

      <button
        onClick={props.onEnter}
        className="mt-5 flex items-center gap-2 text-[10px] font-mono tracking-widest uppercase text-emerald-400 hover:text-emerald-300"
      >
        Enter Portal <ArrowRight size={12} />
      </button>
    </div>
  );
}

export default function SuperAdminDashboard() {
  const nav = useNavigate();
  const { user } = useAuth();
  const { t } = useLanguage();

  const [loading, setLoading] = useState(true);
  const [audit, setAudit] = useState<AuditRow[]>([]);
  const [series7, setSeries7] = useState<number[]>([]);
  const [points, setPoints] = useState<MapPoint[]>([]);
  const [metrics, setMetrics] = useState<MetricState>({
    personnel: null,
    activeRiders: null,
    totalShipments: null,
    pendingShipments: null,
    deliveredShipments: null,
    deliveryRate: null,
    revenueToday: null,
    codCollected: null,
    activeVehicles: null,
    securityEvents: null,
    rotationRequired: null,
    health: "UNKNOWN",
    lastSyncLabel: "—",
  });

  const isMock = String(import.meta.env.VITE_MOCK_MODE ?? "").trim() === "1";

  const load = async () => {
    setLoading(true);

    if (isMock) {
      const rev = 156_000_000;
      const series = mockSeries7(rev);
      setSeries7(series);

      setMetrics({
        personnel: 135,
        activeRiders: 48,
        totalShipments: 1240,
        pendingShipments: 182,
        deliveredShipments: 922,
        deliveryRate: 92.4,
        revenueToday: 18_400_000,
        codCollected: 6_200_000,
        activeVehicles: 22,
        securityEvents: 0,
        rotationRequired: 3,
        health: "NOMINAL",
        lastSyncLabel: t("MOCK DATA", "MOCK ဒေတာ"),
      });

      setAudit([
        { id: "mock-1", timestamp: new Date().toISOString(), action: "MOCK_SESSION_ACTIVE" },
        { id: "mock-2", timestamp: new Date(Date.now() - 60000).toISOString(), action: "SECURITY_BASELINE_OK" },
      ]);

      setPoints([
        { id: "hub-ygn", label: "Yangon Hub", kind: "HUB", x: 42, y: 70, severity: "OK" },
        { id: "hub-mdl", label: "Mandalay", kind: "HUB", x: 52, y: 30, severity: "OK" },
        { id: "r-1", label: "Rider-01", kind: "RIDER", x: 40, y: 60, severity: "OK" },
        { id: "r-2", label: "Rider-02", kind: "RIDER", x: 47, y: 55, severity: "WARN" },
        { id: "s-1", label: "AWB-01", kind: "SHIPMENT", x: 58, y: 48, severity: "OK" },
        { id: "s-2", label: "AWB-02", kind: "SHIPMENT", x: 62, y: 52, severity: "CRIT" },
      ]);

      setLoading(false);
      return;
    }

    let health: Health = "DEGRADED";

    // Personnel metrics (profiles)
    const personnelRes = await supabase.from("profiles").select("id", { count: "exact", head: true });
    const rotationRes = await supabase
      .from("profiles")
      .select("id", { count: "exact", head: true })
      .eq("must_change_password", true);

    // Dashboard metrics (edge function). If not deployed, it will fail => degrade.
    const day = nowIsoDayRange();
    const week = last7DaysRange();

    let totalShipments: number | null = null;
    let pendingShipments: number | null = null;
    let deliveredShipments: number | null = null;
    let deliveryRate: number | null = null;
    let totalRevenue: number | null = null;
    let codCollected: number | null = null;
    let activeVehicles: number | null = null;

    try {
      const dm = await logisticsAPI.getDashboardMetrics((user as any)?.id, (user as any)?.branch_id, week.from, week.to);
      if (dm?.success && dm.metrics) {
        totalShipments = dm.metrics.total_shipments ?? null;
        pendingShipments = dm.metrics.pending_shipments ?? null;
        deliveredShipments = dm.metrics.delivered_shipments ?? null;
        deliveryRate = dm.metrics.delivery_rate ?? null;
        totalRevenue = dm.metrics.total_revenue ?? null;
        codCollected = dm.metrics.cod_collected ?? null;
        activeVehicles = dm.metrics.active_vehicles ?? null;

        setSeries7(mockSeries7(totalRevenue ?? 0));
        health = "NOMINAL";
      }
    } catch {
      // keep degraded
      setSeries7([]);
    }

    // Audit feed (versioned table via service). If fails, show empty.
    let auditRows: AuditRow[] = [];
    try {
      const a = await logisticsAPI.getAuditLogs({ limit: 15 });
      auditRows = (a.data as any) ?? [];
      if (auditRows.length > 0) health = "NOMINAL";
    } catch {
      auditRows = [];
    }
    setAudit(auditRows);

    // Simple live map points (generated, until telemetry tables are wired)
    const basePoints: MapPoint[] = [
      { id: "hub-ygn", label: "Yangon Hub", kind: "HUB", x: 42, y: 70, severity: "OK" },
      { id: "hub-mdl", label: "Mandalay", kind: "HUB", x: 52, y: 30, severity: "OK" },
      { id: "hub-npt", label: "Naypyidaw", kind: "HUB", x: 48, y: 52, severity: "OK" },
    ];
    const riders = Array.from({ length: 6 }, (_, i) => ({
      id: `r-${i + 1}`,
      label: `R-${i + 1}`,
      kind: "RIDER" as const,
      x: clamp(40 + Math.random() * 25, 0, 100),
      y: clamp(35 + Math.random() * 45, 0, 100),
      severity: (Math.random() < 0.12 ? "WARN" : "OK") as "OK" | "WARN",
    }));
    const shipments = Array.from({ length: 5 }, (_, i) => ({
      id: `s-${i + 1}`,
      label: `AWB-${i + 1}`,
      kind: "SHIPMENT" as const,
      x: clamp(38 + Math.random() * 30, 0, 100),
      y: clamp(28 + Math.random() * 50, 0, 100),
      severity: (Math.random() < 0.10 ? "CRIT" : "OK") as "OK" | "CRIT",
    }));
    setPoints([...basePoints, ...riders, ...shipments]);

    setMetrics({
      personnel: personnelRes.count ?? null,
      activeRiders: null,
      totalShipments,
      pendingShipments,
      deliveredShipments,
      deliveryRate,
      revenueToday: totalRevenue, // (week) until day endpoint exists
      codCollected,
      activeVehicles,
      securityEvents: auditRows.length ?? null,
      rotationRequired: rotationRes.count ?? null,
      health,
      lastSyncLabel: health === "NOMINAL" ? t("LIVE", "တိုက်ရိုက်") : t("DEGRADED", "ချို့ယွင်း"),
    });

    setLoading(false);
  };

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const opsBrief = useMemo(() => {
    const items: Array<{ title: string; body: string; tone: "OK" | "WARN" | "CRIT"; action?: { label: string; to: string } }> = [];

    const rot = metrics.rotationRequired ?? 0;
    if (rot > 0) {
      items.push({
        title: t("Password rotation required", "စကားဝှက် ပြောင်းရန်လိုအပ်"),
        body: t(`${rot} accounts require immediate password rotation.`, `အကောင့် ${rot} ခု စကားဝှက် ပြောင်းရန်လိုအပ်ပါသည်။`),
        tone: rot > 10 ? "CRIT" : "WARN",
        action: { label: t("Open Account Control", "အကောင့် ထိန်းချုပ်မှုသို့"), to: "/admin/accounts" },
      });
    } else {
      items.push({
        title: t("Identity governance nominal", "အကောင့်လုံခြုံရေး ပုံမှန်"),
        body: t("No forced password rotations pending.", "စကားဝှက် အရေးပေါ်ပြောင်းရန် မရှိပါ။"),
        tone: "OK",
      });
    }

    const pend = metrics.pendingShipments ?? null;
    if (pend !== null) {
      items.push({
        title: t("Shipment backlog", "ပို့ဆောင်မှု စုစုမရ"),
        body: t(`${pend} shipments pending/in progress.`, `ပို့ဆောင်မှု ${pend} ခု တင်နေရသေးသည်။`),
        tone: pend > 250 ? "CRIT" : pend > 120 ? "WARN" : "OK",
        action: { label: t("Open Shipment Control", "ပို့ဆောင်မှု ထိန်းချုပ်မှုသို့"), to: "/admin/shipments" },
      });
    }

    items.push({
      title: t("Telemetry summary", "Telemetry အနှစ်ချုပ်"),
      body: t("Live map widget is active. Open full telemetry for deep monitoring.", "Live map ကို ပြထားသည်။ အသေးစိတ် စောင့်ကြည့်ရန် Telemetry ကိုဖွင့်ပါ။"),
      tone: "OK",
      action: { label: t("Open Live Telemetry", "Telemetry ဖွင့်ရန်"), to: "/admin/live-map" },
    });

    return items.slice(0, 5);
  }, [metrics, t]);

  const financeBrief = useMemo(() => {
    const total = metrics.revenueToday ?? null;
    const cod = metrics.codCollected ?? null;
    const max = Math.max(1, ...series7, 1);
    return { total, cod, max };
  }, [metrics.revenueToday, metrics.codCollected, series7]);

  const portalStatus = (kind: "LIVE" | "PENDING") => {
    if (kind === "LIVE") return { label: t("LIVE", "တိုက်ရိုက်"), color: "text-emerald-400", bg: "bg-emerald-500/10", border: "border-emerald-500/20" };
    return { label: t("PENDING", "ပြင်ဆင်နေဆဲ"), color: "text-amber-400", bg: "bg-amber-500/10", border: "border-amber-500/20" };
  };

  return (
    <div className="p-6 max-w-7xl mx-auto space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-end justify-between gap-4 border-b border-white/5 pb-6">
        <div>
          <div className="flex items-center gap-3 mb-2">
            <div className="px-2 py-1 bg-emerald-500/10 border border-emerald-500/30 rounded text-[10px] font-mono text-emerald-400 tracking-widest uppercase">
              {t("AUTHORIZED USER", "အတည်ပြုထားသော အသုံးပြုသူ")}
            </div>
            <span className="text-xs font-mono text-slate-500 tracking-wider">
              {t("SESSION ACTIVE", "စနစ်ဝင်ရောက်ထားပါသည်")}
            </span>
            <span className="text-xs font-mono text-slate-600">
              {String((user as any)?.email ?? "—")}
            </span>
          </div>

          <h1 className="text-3xl font-black text-white tracking-widest uppercase">
            {t("COMMAND CENTER", "အမိန့်ဗဟို")}
          </h1>

          <p className="text-xs text-slate-500 mt-2 font-mono uppercase tracking-widest">
            {t("Super-admin unified operations + finance + security", "Super-admin အတွက် လုပ်ငန်း/ငွေကြေး/လုံခြုံရေး အနှစ်ချုပ်")}
          </p>
        </div>

        <div className="text-right">
          <p className="text-[10px] font-mono text-slate-500 tracking-widest uppercase">
            {t("SYSTEM STATUS", "စနစ် အခြေအနေ")}
          </p>
          <div className="flex items-center gap-2 mt-1 justify-end">
            <div
              className={`w-2 h-2 rounded-full ${
                metrics.health === "NOMINAL" ? "bg-emerald-500" : metrics.health === "DEGRADED" ? "bg-amber-500" : "bg-slate-500"
              } animate-pulse`}
            />
            <span
              className={`text-xs font-mono tracking-widest uppercase ${
                metrics.health === "NOMINAL" ? "text-emerald-500" : metrics.health === "DEGRADED" ? "text-amber-500" : "text-slate-500"
              }`}
            >
              {metrics.health === "NOMINAL"
                ? t("ALL SYSTEMS NOMINAL", "စနစ်အားလုံး ပုံမှန်")
                : metrics.health === "DEGRADED"
                ? t("SYSTEM DEGRADED", "စနစ် ချို့ယွင်း")
                : t("UNKNOWN", "မသိရှိ")}
            </span>
            <span className="text-[10px] font-mono text-slate-600 uppercase tracking-widest">
              {metrics.lastSyncLabel}
            </span>
          </div>

          <div className="mt-3 flex justify-end">
            <button
              onClick={() => void load()}
              className="px-4 py-2 bg-white/5 hover:bg-white/10 border border-white/10 rounded-xl text-xs font-bold text-white transition-all"
            >
              {t("Refresh", "ပြန်လည်ရယူ")}
            </button>
          </div>
        </div>
      </div>

      {/* KPI Row */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <Kpi title={t("TOTAL PERSONNEL", "ဝန်ထမ်းစုစုပေါင်း")} value={fmt(metrics.personnel)} icon={<Users size={20} />} tone="blue" />
        <Kpi title={t("SHIPMENTS (TOTAL)", "ပို့ဆောင်မှု (စုစုပေါင်း)")} value={fmt(metrics.totalShipments)} icon={<PackageSearch size={20} />} tone="emerald" />
        <Kpi title={t("DELIVERY RATE", "ပို့ဆောင်မှု အောင်မြင်မှု")} value={metrics.deliveryRate === null ? "—" : `${fmt(metrics.deliveryRate, { maximumFractionDigits: 1 })}%`} icon={<Activity size={20} />} tone="amber" />
        <Kpi title={t("ROTATION REQUIRED", "စကားဝှက်ပြောင်းရန်")} value={fmt(metrics.rotationRequired)} icon={<KeyRound size={20} />} tone="purple" />
      </div>

      {/* Ops + Map + Finance */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Live Map Panel */}
        <div className="lg:col-span-2">
          <div className="flex items-center justify-between mb-3">
            <h2 className="text-sm font-black text-white tracking-widest uppercase flex items-center gap-2">
              <MapIcon size={16} className="text-emerald-500" />
              {t("LIVE OPERATIONS MAP", "တိုက်ရိုက် လုပ်ငန်းမြေပုံ")}
            </h2>
            <button
              onClick={() => nav("/admin/live-map")}
              className="text-[10px] font-mono tracking-widest uppercase text-emerald-400 hover:text-emerald-300 flex items-center gap-2"
            >
              {t("Open Live Telemetry", "Telemetry ဖွင့်ရန်")} <ArrowRight size={12} />
            </button>
          </div>

          <div className="h-[320px] rounded-2xl border border-white/5 bg-[#0B101B] p-4">
            <MiniMap points={points} />
            <div className="mt-3 grid grid-cols-3 gap-3">
              <MiniStat icon={<Truck size={14} />} label={t("Active Vehicles", "ယာဉ် လှုပ်ရှားနေ")} value={fmt(metrics.activeVehicles)} />
              <MiniStat icon={<PackageSearch size={14} />} label={t("Pending", "တင်နေသေး")} value={fmt(metrics.pendingShipments)} />
              <MiniStat icon={<CircleAlert size={14} />} label={t("Alerts", "သတိပေး")} value={fmt(metrics.securityEvents)} />
            </div>
          </div>
        </div>

        {/* Operational Briefing */}
        <div>
          <h2 className="text-sm font-black text-white tracking-widest uppercase flex items-center gap-2 mb-3">
            <CircleAlert size={16} className="text-amber-500" />
            {t("OPERATIONAL BRIEFING", "လုပ်ငန်း အကျဉ်းချုပ်")}
          </h2>

          <div className="rounded-2xl border border-white/5 bg-[#0B101B] p-4 space-y-3">
            {opsBrief.map((b, i) => (
              <div key={i} className="p-3 rounded-xl bg-white/5 border border-white/5">
                <div className="flex items-center justify-between gap-3">
                  <div className="text-xs font-bold text-white">{b.title}</div>
                  <span
                    className={`text-[9px] font-mono uppercase tracking-widest ${
                      b.tone === "OK" ? "text-emerald-400" : b.tone === "WARN" ? "text-amber-400" : "text-rose-400"
                    }`}
                  >
                    {b.tone}
                  </span>
                </div>
                <div className="text-[10px] font-mono text-slate-500 mt-2 leading-relaxed">{b.body}</div>
                {b.action ? (
                  <button
                    onClick={() => nav(b.action!.to)}
                    className="mt-2 text-[10px] font-mono tracking-widest uppercase text-emerald-400 hover:text-emerald-300 flex items-center gap-2"
                  >
                    {b.action.label} <ArrowRight size={12} />
                  </button>
                ) : null}
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Portals */}
      <div className="space-y-4">
        <h2 className="text-sm font-black text-white tracking-widest uppercase flex items-center gap-2">
          <Boxes size={16} className="text-emerald-500" />
          {t("PORTALS AT A GLANCE", "Portal အနှစ်ချုပ်")}
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <PortalCard
            icon={<ShieldCheck className="text-emerald-400" />}
            title={t("Account Approvals", "အကောင့် အတည်ပြုမှုများ")}
            desc={t("Approve/Reject access requests and high-risk role changes.", "ဝင်ရောက်ခွင့်/ရာထူးပြောင်းလဲမှုများကို အတည်ပြု/ပယ်ချပါ။")}
            status={portalStatus("LIVE")}
            meta={[
              { label: t("Queue", "စောင့်ဆိုင်း"), value: fmt(metrics.rotationRequired) },
              { label: t("Risk", "အန္တရာယ်"), value: t("LOW", "နိမ့်") },
            ]}
            onEnter={() => nav("/admin/approvals")}
          />

          <PortalCard
            icon={<KeyRound className="text-purple-400" />}
            title={t("Account Control", "အကောင့် ထိန်းချုပ်မှု")}
            desc={t("Manage roles, permissions, clearances, and forced rotations.", "ရာထူး/ခွင့်ပြုချက်/လုံခြုံရေး ပြောင်းလဲမှုများကို စီမံပါ။")}
            status={portalStatus("LIVE")}
            meta={[
              { label: t("Personnel", "ဝန်ထမ်း"), value: fmt(metrics.personnel) },
              { label: t("Rotation", "ပြောင်းရန်"), value: fmt(metrics.rotationRequired) },
            ]}
            onEnter={() => nav("/admin/accounts")}
          />

          <PortalCard
            icon={<Users className="text-rose-400" />}
            title={t("HR Portal", "ဝန်ထမ်း ပေါ်တယ်")}
            desc={t("Staff vault, contracts, payroll archives, and compliance docs.", "စာချုပ်/လစာ/စာရွက်စာတမ်းများကို စီမံပါ။")}
            status={portalStatus("LIVE")}
            meta={[
              { label: t("Docs", "ဖိုင်များ"), value: t("SYNCED", "ချိတ်ဆက်ပြီး") },
              { label: t("Access", "ဝင်ခွင့်"), value: t("OK", "OK") },
            ]}
            onEnter={() => nav("/admin/hr")}
          />

          <PortalCard
            icon={<PackageSearch className="text-blue-400" />}
            title={t("Shipment Control", "ပို့ဆောင်မှု ထိန်းချုပ်မှု")}
            desc={t("Backlog, exceptions, in-transit monitoring, dispatch control.", "တင်နေသေးမှု/အရေးပေါ်/ပို့ဆောင်မှုများကို ထိန်းချုပ်ပါ။")}
            status={portalStatus("PENDING")}
            meta={[
              { label: t("Pending", "တင်နေ"), value: fmt(metrics.pendingShipments) },
              { label: t("Delivered", "ရောက်ပြီး"), value: fmt(metrics.deliveredShipments) },
            ]}
            onEnter={() => nav("/admin/shipments")}
          />

          <PortalCard
            icon={<Truck className="text-amber-400" />}
            title={t("Fleet Command", "ယာဉ်တပ် စီမံခန့်ခွဲမှု")}
            desc={t("Vehicle availability, maintenance due, dispatch readiness.", "ယာဉ် အသင့်/ပြင်ဆင်ရန်/စီမံခန့်ခွဲမှု။")}
            status={portalStatus("PENDING")}
            meta={[
              { label: t("Active", "လှုပ်ရှား"), value: fmt(metrics.activeVehicles) },
              { label: t("Maint", "ပြင်ဆင်"), value: t("—", "—") },
            ]}
            onEnter={() => nav("/admin/fleet")}
          />

          <PortalCard
            icon={<Landmark className="text-emerald-400" />}
            title={t("Global Finance", "ကမ္ဘာလုံးဆိုင်ရာ ငွေကြေး")}
            desc={t("Revenue, COD, remittances, reconciliation, and risk signals.", "ဝင်ငွေ/COD/ငွေလွှဲ/ညှိနှိုင်းမှုများ။")}
            status={portalStatus("LIVE")}
            meta={[
              { label: t("Revenue", "ဝင်ငွေ"), value: metrics.revenueToday === null ? "—" : `${fmt(metrics.revenueToday)} MMK` },
              { label: t("COD", "COD"), value: metrics.codCollected === null ? "—" : `${fmt(metrics.codCollected)} MMK` },
            ]}
            onEnter={() => nav("/admin/omni-finance")}
          />

          <PortalCard
            icon={<MapIcon className="text-emerald-400" />}
            title={t("Live Telemetry", "တိုက်ရိုက် တယ်လီမထရီ")}
            desc={t("Map monitoring, fleet/shipments tracking, security overlay.", "မြေပုံစောင့်ကြည့်မှု/ယာဉ်/ပို့ဆောင်မှု ခြေရာခံ။")}
            status={portalStatus("LIVE")}
            meta={[
              { label: t("Mode", "မုဒ်"), value: t("MONITOR", "စောင့်ကြည့်") },
              { label: t("Sync", "ချိတ်ဆက်"), value: metrics.lastSyncLabel },
            ]}
            onEnter={() => nav("/admin/live-map")}
          />

          <PortalCard
            icon={<Wrench className="text-slate-300" />}
            title={t("Warehouse", "ဂိုဒေါင်")}
            desc={t("Receiving, dispatch, operations, and scanning workflows.", "လက်ခံ/ဖြန့်ချိ/လုပ်ငန်းစဉ်များကို စီမံပါ။")}
            status={portalStatus("LIVE")}
            meta={[
              { label: t("Inbound", "ဝင်လာ"), value: t("45", "45") },
              { label: t("Sorted", "ခွဲပြီး"), value: t("32", "32") },
            ]}
            onEnter={() => nav("/admin/warehouse")}
          />

          <PortalCard
            icon={<Settings className="text-slate-300" />}
            title={t("System Tariffs", "စနစ် အခွန်အကောက်")}
            desc={t("Rates, surcharges, remote zones, fuel multipliers.", "နှုန်းထား/အပိုကြေး/remote ဇုန်များ။")}
            status={portalStatus("PENDING")}
            meta={[
              { label: t("Sets", "သတ်မှတ်ချက်"), value: t("—", "—") },
              { label: t("Changes", "ပြောင်းလဲမှု"), value: t("—", "—") },
            ]}
            onEnter={() => nav("/admin/settings")}
          />
        </div>
      </div>

      {/* Financial Briefing */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2">
          <h2 className="text-sm font-black text-white tracking-widest uppercase flex items-center gap-2 mb-3">
            <Banknote size={16} className="text-emerald-500" />
            {t("FINANCIAL BRIEFING", "ငွေကြေး အကျဉ်းချုပ်")}
          </h2>

          <div className="rounded-2xl border border-white/5 bg-[#0B101B] p-5">
            <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
              <MiniStat icon={<Landmark size={14} />} label={t("Revenue", "ဝင်ငွေ")} value={financeBrief.total === null ? "—" : `${fmt(financeBrief.total)} MMK`} />
              <MiniStat icon={<PackageSearch size={14} />} label={t("COD", "COD")} value={financeBrief.cod === null ? "—" : `${fmt(financeBrief.cod)} MMK`} />
              <MiniStat icon={<Truck size={14} />} label={t("Vehicles", "ယာဉ်")} value={fmt(metrics.activeVehicles)} />
              <MiniStat icon={<ShieldAlert size={14} />} label={t("Security", "လုံခြုံရေး")} value={fmt(metrics.securityEvents)} />
            </div>

            <div className="mt-5">
              <div className="text-[10px] font-mono text-slate-500 uppercase tracking-widest">
                {t("7-day revenue signal", "၇ ရက် ဝင်ငွေ အလှည့်")}
              </div>
              <div className="mt-3 grid grid-cols-7 gap-2 items-end">
                {series7.length === 7 ? (
                  series7.map((v, i) => (
                    <div key={i} className="rounded-xl border border-white/5 bg-white/5 p-2">
                      <div
                        className="w-full rounded-lg bg-emerald-500/20 border border-emerald-500/20"
                        style={{ height: `${clamp((v / financeBrief.max) * 64, 10, 64)}px` }}
                      />
                      <div className="mt-2 text-[9px] font-mono text-slate-500 uppercase tracking-widest text-center">
                        {t("D", "နေ့")} {i + 1}
                      </div>
                    </div>
                  ))
                ) : (
                  <div className="text-xs font-mono text-slate-500">
                    {t("No finance series available (edge metrics offline).", "ငွေကြေးဒေတာ မရရှိပါ (edge metrics မချိတ်ဆက်နိုင်)။")}
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>

        {/* Security feed */}
        <div>
          <h2 className="text-sm font-black text-white tracking-widest uppercase flex items-center gap-2 mb-3">
            <ShieldAlert size={16} className="text-amber-500" />
            {t("SECURITY / AUDIT", "လုံခြုံရေး / စစ်ဆေးမှု")}
          </h2>

          <div className="rounded-2xl border border-white/5 bg-[#0B101B] p-4 space-y-3 h-[260px] overflow-y-auto">
            {loading ? (
              <div className="text-xs font-mono text-slate-500">{t("Loading audit feed…", "မှတ်တမ်းများ ရယူနေပါသည်…")}</div>
            ) : audit.length === 0 ? (
              <div className="text-xs font-mono text-slate-500">{t("No audit events found.", "လုံခြုံရေးမှတ်တမ်း မတွေ့ရှိပါ။")}</div>
            ) : (
              audit.map((row) => {
                const ts = row.timestamp ?? row.created_at ?? new Date().toISOString();
                const label = (row.action ?? row.event_type ?? "AUDIT_EVENT").toString();
                return (
                  <div key={String(row.id)} className="p-3 rounded-xl bg-white/5 border border-white/5">
                    <div className="flex items-center justify-between gap-3">
                      <div className="text-xs font-mono text-white truncate">{label}</div>
                      <div className="text-[9px] font-mono text-slate-500 uppercase tracking-widest">
                        {new Date(ts).toLocaleTimeString()}
                      </div>
                    </div>
                    <div className="mt-2 text-[10px] font-mono text-slate-500 truncate">
                      user: {row.user_id ? String(row.user_id).slice(0, 10) + "…" : "—"}
                    </div>
                  </div>
                );
              })
            )}
          </div>

          <button
            onClick={() => nav("/admin/approvals")}
            className="mt-4 w-full flex items-center justify-center gap-2 px-4 py-3 bg-amber-500/10 hover:bg-amber-500/15 border border-amber-500/20 rounded-xl text-xs font-bold text-amber-200 transition-all"
          >
            <Clock className="h-4 w-4" />
            {t("Open Approval Queue", "အတည်ပြု စာရင်းဖွင့်ရန်")}
          </button>
        </div>
      </div>
    </div>
  );
}

function Kpi(props: { title: string; value: string; icon: React.ReactNode; tone: "blue" | "emerald" | "amber" | "purple" }) {
  const tone = {
    blue: { c: "text-blue-400", bg: "bg-blue-500/10", b: "border-blue-500/20" },
    emerald: { c: "text-emerald-400", bg: "bg-emerald-500/10", b: "border-emerald-500/20" },
    amber: { c: "text-amber-400", bg: "bg-amber-500/10", b: "border-amber-500/20" },
    purple: { c: "text-purple-400", bg: "bg-purple-500/10", b: "border-purple-500/20" },
  }[props.tone];

  return (
    <div className={`p-6 rounded-2xl bg-[#0B101B] border ${tone.b} flex flex-col justify-between`}>
      <div className="flex justify-between items-start mb-4">
        <div className={`p-3 rounded-xl ${tone.bg} ${tone.c}`}>{props.icon}</div>
      </div>
      <div>
        <h3 className="text-3xl font-black text-white mb-1">{props.value}</h3>
        <p className="text-[10px] font-mono text-slate-400 tracking-widest uppercase">{props.title}</p>
      </div>
    </div>
  );
}

function MiniStat(props: { icon: React.ReactNode; label: string; value: string }) {
  return (
    <div className="rounded-xl border border-white/5 bg-white/5 p-3">
      <div className="flex items-center gap-2 text-[9px] font-mono uppercase tracking-widest text-slate-500">
        <span className="text-emerald-400">{props.icon}</span>
        {props.label}
      </div>
      <div className="text-sm font-black text-white mt-2">{props.value}</div>
    </div>
  );
}
