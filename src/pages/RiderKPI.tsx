import React, { useState } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { 
  Trophy, Timer, Zap, Wallet, 
  Search, Globe, Filter, ArrowUpRight, 
  ChevronRight, Star 
} from 'lucide-react';

export default function RiderKPI() {
  const { toggleLang, lang } = useLanguage();
  
  // Enterprise Mock Data for Rider Performance
  const riderStats = [
    { id: 'RDR-001', name: 'Zayar Min', success: 98.4, avgTime: '18m', earnings: '145,000', rating: 4.9 },
    { id: 'RDR-002', name: 'Kyaw Kyaw', success: 94.2, avgTime: '22m', earnings: '112,500', rating: 4.7 },
    { id: 'RDR-003', name: 'Aung Ko', success: 89.1, avgTime: '31m', earnings: '88,000', rating: 4.2 }
  ];

  return (
    <div className="p-10 space-y-10 bg-[#0B101B] min-h-screen text-slate-300">
      {/* Executive Header (အမှုဆောင်အရာရှိများအတွက် ခေါင်းစဉ်) */}
      <div className="flex justify-between items-center bg-[#05080F] p-10 rounded-[3rem] border border-white/5 shadow-2xl">
        <div className="flex items-center gap-6">
          <div className="p-4 bg-amber-500/10 rounded-2xl border border-amber-500/20">
            <Trophy className="h-8 w-8 text-amber-500" />
          </div>
          <div>
            <h1 className="text-4xl font-black text-white uppercase italic tracking-tighter">
              {lang === 'en' ? 'Rider Performance' : 'ယာဉ်မောင်း စွမ်းဆောင်ရည်'}
            </h1>
            <p className="text-amber-500 font-mono text-[10px] mt-1 uppercase tracking-widest">
              {lang === 'en' ? 'L5_ORCHESTRATION_SURVEILLANCE' : 'အဆင့်_၅_လုပ်ငန်း_စောင့်ကြည့်စနစ်'}
            </p>
          </div>
        </div>
        <div className="flex gap-4">
          <Button onClick={toggleLang} className="bg-white/5 border border-white/10 text-white h-12 px-8 rounded-xl">
             <Globe className="mr-2 h-4 w-4" /> {lang === 'en' ? "မြန်မာစာ" : "English"}
          </Button>
        </div>
      </div>

      {/* Global Performance KPIs */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
        {[
          { label: 'Avg Delivery Speed', val: '24.5 min', icon: Timer, color: 'text-sky-400' },
          { label: 'Success Velocity', val: '96.2%', icon: Zap, color: 'text-emerald-400' },
          { label: 'Total Payouts', val: '12.4M K', icon: Wallet, color: 'text-amber-400' }
        ].map((kpi, i) => (
          <Card key={i} className="bg-[#05080F] border-none ring-1 ring-white/5 rounded-[2.5rem] p-8">
            <kpi.icon className={`h-8 w-8 mb-4 ${kpi.color}`} />
            <p className="text-[10px] font-black text-slate-500 uppercase tracking-widest">{kpi.label}</p>
            <p className="text-3xl text-white font-black mt-2 tracking-tighter">{kpi.val}</p>
          </Card>
        ))}
      </div>

      {/* Rider Surveillance Matrix (ယာဉ်မောင်း စောင့်ကြည့်မှု ဇယား) */}
      <Card className="bg-[#05080F] border-none ring-1 ring-white/5 rounded-[3rem] overflow-hidden">
        <div className="p-8 border-b border-white/5 flex justify-between items-center">
          <div className="relative w-96">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-500" />
            <input className="w-full bg-[#0B101B] border border-white/10 rounded-full h-12 pl-12 pr-6 text-sm" placeholder={lang === 'en' ? "Search Rider ID or Name..." : "ယာဉ်မောင်း အိုင်ဒီ (သို့) အမည်ဖြင့် ရှာဖွေရန်..."} />
          </div>
          <Button variant="outline" className="h-12 border-white/10 text-slate-400 px-6 rounded-xl">
            <Filter className="mr-2 h-4 w-4" /> {lang === 'en' ? 'Filters' : 'စစ်ထုတ်ရန်'}
          </Button>
        </div>
        
        <div className="overflow-x-auto">
          <table className="w-full text-left">
            <thead className="bg-white/5 text-[10px] text-slate-500 font-mono uppercase tracking-widest">
              <tr>
                <th className="p-8">{lang === 'en' ? 'Rider Identity' : 'ယာဉ်မောင်း အချက်အလက်'}</th>
                <th className="p-8">{lang === 'en' ? 'Success Rate' : 'အောင်မြင်မှုနှုန်း'}</th>
                <th className="p-8">{lang === 'en' ? 'Avg Time' : 'ပျမ်းမျှကြာချိန်'}</th>
                <th className="p-8">{lang === 'en' ? 'Commission' : 'ကော်မရှင်'}</th>
                <th className="p-8 text-right">{lang === 'en' ? 'Actions' : 'လုပ်ဆောင်ချက်'}</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-white/5">
              {riderStats.map((r) => (
                <tr key={r.id} className="group hover:bg-white/5 transition-all">
                  <td className="p-8">
                    <p className="font-bold text-white text-lg">{r.name}</p>
                    <p className="text-[10px] text-slate-500 font-mono uppercase tracking-widest">{r.id}</p>
                  </td>
                  <td className="p-8">
                    <div className="flex items-center gap-3">
                      <div className="flex-1 h-1.5 bg-white/5 rounded-full w-24 overflow-hidden">
                        <div className="h-full bg-emerald-500" style={{ width: `${r.success}%` }}></div>
                      </div>
                      <span className="text-emerald-400 font-black text-xs">{r.success}%</span>
                    </div>
                  </td>
                  <td className="p-8 font-mono text-white font-bold">{r.avgTime}</td>
                  <td className="p-8 font-black text-amber-500">{r.earnings} MMK</td>
                  <td className="p-8 text-right">
                    <Button variant="ghost" className="h-10 px-4 text-sky-400 hover:bg-sky-500/10 font-black text-[10px] uppercase">
                      {lang === 'en' ? 'View Details' : 'အသေးစိတ်ကြည့်ရန်'} <ChevronRight className="ml-2 h-3 w-3" />
                    </Button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Card>
    </div>
  );
}
