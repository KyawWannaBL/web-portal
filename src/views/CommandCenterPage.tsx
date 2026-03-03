import { Link } from "react-router-dom";
import { PATHS } from "../routes/paths";
import { useI18n } from "../state/i18n";

function Stat({ value, label }: { value: string; label: string }) {
  return <div className="stat"><div className="statValue">{value}</div><div className="statLabel">{label}</div></div>;
}

function ActionCard({ title, desc, to, cta }: { title: string; desc: string; to: string; cta: string }) {
  return (
    <Link to={to} className="card cardLink">
      <div className="cardTitle">{title}</div><div className="cardDesc">{desc}</div><div className="cardCta">{cta} →</div>
    </Link>
  );
}

export default function CommandCenterPage() {
  const { t } = useI18n();
  return (
    <section className="page">
      <div className="gridStats">
        <Stat value="1" label={t("totalPersonnel")} />
        <Stat value="—" label={t("activeRiders")} />
        <Stat value="0" label={t("securityEvents")} />
        <Stat value="0" label={t("rotationRequired")} />
      </div>
      <div className="sectionTitle">{t("quickActions")}</div>
      <div className="grid2">
        <ActionCard title={t("accountControl")} desc={t("accountControlDesc")} to={PATHS.accountControl} cta={t("launchModule")} />
        <ActionCard title={t("hrPortal")} desc={t("hrPortalDesc")} to={PATHS.hrPortal} cta={t("launchModule")} />
      </div>
      <div className="sectionTitle">{t("liveAuditFeed")}</div>
      <div className="card"><div className="muted">{t("noAuditEvents")}</div></div>
    </section>
  );
}
