import * as React from "react";
import { cn } from "@/lib/utils";

export function Badge(props: React.HTMLAttributes<HTMLSpanElement>) {
  return (
    <span
      {...props}
      className={cn(
        "inline-flex items-center rounded-lg border border-white/10 bg-white/5 px-2 py-1 text-[10px] font-mono uppercase tracking-widest text-slate-300",
        props.className
      )}
    />
  );
}
