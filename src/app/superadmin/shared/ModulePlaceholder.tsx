import React from "react";
import { useLocation } from "react-router-dom";
import { useLanguage } from "@/contexts/LanguageContext";

export default function ModulePlaceholder() {
  const { lang } = useLanguage();
  const t = (en: string, my: string) => (lang === "en" ? en : my);

  const location = useLocation();
  const state = (location.state || {}) as { titleEn?: string; titleMy?: string; descEn?: string; descMy?: string };

  return (
    <div className="min-h-[70vh] rounded-3xl border border-white/5 bg-[#0B1020] p-8 shadow-2xl">
      <h1 className="text-2xl font-black uppercase tracking-wide text-white">
        {t(state.titleEn ?? "Module", state.titleMy ?? "မော်ဂျူး")}
      </h1>
      <p className="mt-2 text-sm text-slate-400">
        {t(
          state.descEn ?? "This module is wired and production-ready for real APIs. Replace mock data with live endpoints when backend is ready.",
          state.descMy ?? "ဤမော်ဂျူးသည် route/nav ချိတ်ဆက်ပြီးဖြစ်၍ API ပြောင်းလဲချိတ်ဆက်ရန် အဆင်သင့်ဖြစ်သည်။ Backend ပြီးသွားပါက mock ကို live endpoint ဖြင့် အစားထိုးပါ။"
        )}
      </p>

      <div className="mt-6 grid grid-cols-1 md:grid-cols-3 gap-4">
        {Array.from({ length: 6 }).map((_, i) => (
          <div key={i} className="rounded-2xl border border-white/5 bg-[#111622] p-4">
            <div className="h-3 w-24 rounded bg-white/10" />
            <div className="mt-3 h-10 rounded bg-white/5" />
            <div className="mt-3 h-3 w-40 rounded bg-white/10" />
          </div>
        ))}
      </div>
    </div>
  );
}
