import * as React from "react";
import { Link, type To } from "react-router-dom";

export function cx(...parts: Array<string | false | undefined | null>) {
  return parts.filter(Boolean).join(" ");
}

type CommonProps = {
  className?: string;
  children: React.ReactNode;
};

type LinkProps = CommonProps & {
  to: To; // must be defined
  onClick?: never;
  disabled?: boolean;
};

type ButtonProps = CommonProps & {
  to?: never;
  onClick: React.MouseEventHandler<HTMLButtonElement>;
  disabled?: boolean;
};

export function AppButton(props: LinkProps | ButtonProps) {
  if ("to" in props) {
    const { to, className, children, disabled } = props;
    return (
      <Link
        to={to}
        className={cx("btn", className, disabled && "btnDisabled")}
        aria-disabled={disabled ? "true" : "false"}
        onClick={(e) => {
          if (disabled) e.preventDefault();
        }}
      >
        {children}
      </Link>
    );
  }

  const { onClick, className, children, disabled } = props;
  return (
    <button type="button" className={cx("btn", className)} onClick={onClick} disabled={disabled}>
      {children}
    </button>
  );
}

export function IconPill(props: { children: React.ReactNode; className?: string }) {
  return <span className={cx("pill", props.className)}>{props.children}</span>;
}
