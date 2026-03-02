import React from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import { Card } from '@/components/ui/card';
import { MapPin, Globe, Calculator } from 'lucide-react';

export default function SystemTariffs() {
  const { lang } = useLanguage();
  const regions = [
    { name: "Yangon Region", color: "border-emerald-500", zones: [{n: "Zone 1: Downtown", r: "2,000"}, {n: "Zone 2: Inner City", r: "2,500"}]},
    { name: "Mandalay Region", color: "border-sky-500", zones: [{n: "Downtown Grid", r: "2,500"}, {n: "Industrial Zone", r: "3,000"}]},
    { name: "Nay Pyi Taw", color: "border-rose-500", zones: [{n: "Ministry Zone", r: "3,000"}]}
  ];

  return (
    <div className="p-10 space-y-10 bg-[#0B101B] min-h-screen">
      <div className="flex justify-between items-center bg-[#05080F] p-10 rounded-[3rem] border border-white/5 shadow-2xl">
        <div className="flex items-center gap-6">
          <div className="p-4 bg-emerald-500/10 rounded-2xl border border-emerald-500/20"><Calculator className="h-8 w-8 text-emerald-500"/></div>
          <div>
            <h1 className="text-4xl font-black text-white uppercase italic tracking-tighter">System Tariffs & Rates</h1>
            <p className="text-emerald-500 font-mono text-xs mt-1 uppercase tracking-widest">{lang === 'en' ? 'L5_FINANCIAL_CONFIGURATION' : 'အဆင့်_၅_ဘဏ္ဍာရေးသတ်မှတ်ချက်'}</p>
          </div>
        </div>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
        {regions.map((reg, i) => (
          <div key={i} className={`bg-[#05080F] rounded-[3rem] p-10 border-t-8 ${reg.color}`}>
            <h2 className="text-2xl font-black text-white mb-8">{reg.name}</h2>
            {reg.zones.map((z, j) => (
              <div key={j} className="bg-[#0B101B] p-6 rounded-2xl mb-4 flex justify-between items-center border border-white/5">
                <span className="text-slate-400 font-bold">{z.n}</span>
                <span className="text-emerald-400 font-black">{z.r} MMK</span>
              </div>
            ))}
          </div>
        ))}
      </div>
    </div>
  );
}
