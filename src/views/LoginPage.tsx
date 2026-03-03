import * as React from "react";
import { useNavigate, useLocation } from "react-router-dom";
import { useAuth } from "../state/auth";
import { useI18n } from "../state/i18n";
import { PATHS } from "../routes/paths";

export default function LoginPage() {
  const { signIn } = useAuth();
  const { t } = useI18n();
  const navigate = useNavigate();
  const location = useLocation() as unknown as { state?: { from?: string } };
  const [name, setName] = React.useState("Aung Min");

  function onSubmit(e: React.FormEvent) {
    e.preventDefault();
    signIn(name);
    navigate(location.state?.from ?? PATHS.commandCenter, { replace: true });
  }

  return (
    <div className="loginWrap">
      <div className="loginCard">
        <div className="loginTitle">{t("loginTitle")}</div>
        <div className="muted">{t("loginDesc")}</div>
        <form onSubmit={onSubmit} className="loginForm">
          <label className="label">
            <span className="labelText">Name</span>
            <input className="input" value={name} onChange={(e) => setName(e.target.value)} />
          </label>
          <button type="submit" className="btn btnPrimary">{t("signIn")}</button>
        </form>
      </div>
    </div>
  );
}
