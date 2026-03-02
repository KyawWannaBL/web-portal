import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useLanguage } from '@/contexts/LanguageContext';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { 
  ShieldCheck, Zap, Landmark, Headphones, 
  Target, Truck, Warehouse, Globe, 
  Activity, Lock, ArrowRight, LayoutGrid, BarChart3 
} from 'lucide-react';

export default function SuperAdminDashboard() {
  const { lang, toggleLang } = useLanguage();
  const navigate = useNavigate();

  const departments = [
    { id: 'FIN', nameEn: 'Finance & Vault', nameMy: 'ဘဏ္ဍာရေးနှင့် လုံခြုံရေးဗဟို', route: '/finance/core', icon: Landmark, color: 'text-emerald-500', status: 'SECURE' },
    { id: 'OPS', nameEn: 'Fleet & Dispatch', nameMy: 'ယာဉ်တန်းနှင့် ပို့ဆောင်ရေး', route: '/admin/live-map', icon: Truck, color: 'text-sky-500', status: 'LIVE' },
    { id: 'MKT', nameEn: 'Marketing Intel', nameMy: 'စျေးကွက်ဆိုင်ရာ အချက်အလက်', route: '/marketing/portal', icon: Target, color: 'text-indigo-500', status: 'ACTIVE' },
    { id: 'SUP', nameEn: 'Customer Support', nameMy: 'သုံးစွဲသူ အကူအညီပေးရေး', route: '/support/hub', icon: Headphones, color: 'text-rose-500', status: 'STABLE' },
    { id: 'WH', nameEn: 'Warehouse L2', nameMy: 'ဂိုဒေါင်စီမံခန့်ခွဲမှု', route: '/warehouse/dashboard', icon: Warehouse, color: 'text-amber-500', status: 'SORTING' },
    { id: 'BRN', nameEn: 'Office Office Branch Network', nameMy: 'ရုံးခွဲများ ကွန်ရက်', route: '/branch/portal', icon: LayoutGrid, BarChart3, color: 'text-purple-500', status: 'SYNCED' }
  ];

  return (
    <div className="p-10 space-y-10 bg-[#0B101B] min-h-screen text-slate-300">
      <div className="flex justify-between items-center bg-[#05080F] p-10 rounded-[3.5rem] border border-white/5 shadow-2xl">
        <div className="flex items-center gap-6">
          <div className="p-5 bg-emerald-500/10 rounded-3xl border border-emerald-500/20 animate-pulse">
            <ShieldCheck className="h-10 w-10 text-emerald-500" />
          </div>
          <div>
            <h1 className="text-5xl font-black text-white uppercase italic tracking-tighter">Sovereign Master Core</h1>
            <p className="text-emerald-500 font-mono text-xs mt-1 uppercase tracking-widest italic">L5_APP_OWNER_OVERSIGHT</p>
          </div>
        </div>
        <Button onClick={toggleLang} className="bg-white/5 border border-white/10 text-white h-14 px-10 rounded-2xl shadow-xl">
           <Globe className="mr-2 h-5 w-5" /> {lang === 'en' ? "MYANMAR" : "ENGLISH"}
        </Button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        {departments.map((dept) => (
          <Card key={dept.id} onClick={() => navigate(dept.route)} className="bg-[#05080F] border-none ring-1 ring-white/5 p-10 rounded-[3rem] cursor-pointer group hover:ring-emerald-500/40 transition-all">
             <div className="flex justify-between items-start mb-8">
                <div className={`p-5 rounded-2xl bg-white/5 group-hover:bg-emerald-500/10 transition-colors`}>
                   <dept.icon className={`h-8 w-8 ${dept.color}`} />
                </div>
                <span className="text-[10px] font-black px-4 py-1.5 rounded-full border border-white/10 text-slate-500 group-hover:text-emerald-500 group-hover:border-emerald-500/20 transition-all font-mono">
                   {dept.status}
                </span>
             </div>
             <div>
                <h3 className="text-2xl font-black text-white italic uppercase tracking-tight">
                   {lang === 'en' ? dept.nameEn : dept.nameMy}
                </h3>
                <div className="mt-6 flex items-center gap-2 text-[10px] font-black text-slate-600 uppercase tracking-[0.2em] group-hover:text-emerald-500 transition-colors">
                   Enter Portal <ArrowRight size={14} className="group-hover:translate-x-2 transition-transform"/>
                </div>
             </div>
          </Card>
        ))}
      </div>
    </div>
  );
}
