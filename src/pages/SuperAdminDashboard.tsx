import React from 'react';
import { useNavigate } from 'react-router-dom';
import { useLanguage } from '@/contexts/LanguageContext';
import { formatCurrency, formatDate } from '@/lib/constants';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { 
  LayoutDashboard, Wallet, Truck, ShieldCheck, 
  Activity, Globe, Search, ArrowUpRight, Package,
  Users, MapPin, Settings
} from 'lucide-react';

export default function SuperAdminDashboard() {
  const navigate = useNavigate();
  const { toggleLang, lang } = useLanguage();

  const metrics = [
    { label: lang === 'en' ? 'Total Revenue' : 'စုစုပေါင်းဝင်ငွေ', val: '45.2M K', growth: '+12%', icon: Wallet, color: 'text-emerald-500' },
    { label: lang === 'en' ? 'Active Roles' : 'ခွင့်ပြုထားသည့်ရာထူးများ', val: '33', growth: 'Full Hierarchy', icon: Users, color: 'text-sky-500' },
    { label: lang === 'en' ? 'System Health' : 'စနစ်အခြေအနေ', val: '99.9%', growth: 'Stable', icon: Settings, color: 'text-emerald-400' },
    { label: lang === 'en' ? 'Pending KYC' : 'အတည်ပြုရန်စောင့်ဆိုင်းဆဲ', val: '128', growth: 'High Priority', icon: ShieldCheck, color: 'text-rose-500' }
  ];

  return (
    <div className="p-10 space-y-10 bg-[#0B101B] min-h-screen text-slate-300">
      <div className="flex justify-between items-center bg-[#05080F] p-8 rounded-[2.5rem] border border-white/5 shadow-2xl">
        <div className="flex items-center gap-6">
          <div className="p-4 bg-emerald-500/10 rounded-2xl border border-emerald-500/20">
            <LayoutDashboard className="h-8 w-8 text-emerald-500" />
          </div>
          <div>
            <h1 className="text-3xl font-black text-white uppercase italic tracking-tighter">Executive Dashboard</h1>
            <p className="text-emerald-500 font-mono text-[10px] mt-1 uppercase tracking-widest italic">Britium_Express_Network • {formatDate(new Date())}</p>
          </div>
        </div>
        
        <div className="flex items-center gap-4">
          <div className="relative group">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-500" />
            <input className="bg-[#0B101B] border border-white/10 rounded-full h-12 pl-12 pr-6 text-sm w-64 focus:w-80 transition-all focus:border-emerald-500 outline-none" placeholder="Global Search..." />
          </div>
          <Button onClick={toggleLang} className="bg-white/5 hover:bg-white/10 border border-white/10 text-white font-bold h-12 px-6 rounded-xl">
            <Globe className="mr-2 h-4 w-4" /> {lang === 'en' ? "မြန်မာစာ" : "English"}
          </Button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        {metrics.map((m, i) => (
          <Card key={i} className="bg-[#05080F] border-none ring-1 ring-white/5 rounded-3xl p-6 hover:ring-emerald-500/30 transition-all">
            <div className="flex justify-between items-start">
              <div>
                <p className="text-slate-500 font-bold text-[10px] uppercase tracking-widest">{m.label}</p>
                <p className="text-3xl text-white font-black mt-2 tracking-tighter">{m.val}</p>
                <span className={`text-[10px] font-bold mt-1 block ${m.color === 'text-rose-500' ? 'text-rose-500' : 'text-emerald-500'}`}>{m.growth}</span>
              </div>
              <div className={`p-3 rounded-xl bg-white/5`}>
                <m.icon className={`h-6 w-6 ${m.color}`} />
              </div>
            </div>
          </Card>
        ))}
      </div>

      <Card className="bg-[#05080F] border-none ring-1 ring-white/5 rounded-[3.5rem] p-12 relative overflow-hidden group">
        <div className="absolute inset-0 bg-gradient-to-br from-emerald-500/5 to-transparent opacity-50"></div>
        <div className="relative z-10 flex flex-col items-center justify-center space-y-6 py-20">
           <div className="w-20 h-20 bg-emerald-500/20 rounded-full flex items-center justify-center animate-pulse">
              <Activity className="text-emerald-500 h-10 w-10" />
           </div>
           <div className="text-center">
              <h2 className="text-5xl font-black text-white uppercase tracking-tighter mb-2 italic">Britium Express <span className="text-emerald-500">Network</span></h2>
              <p className="text-emerald-500 font-mono text-xs uppercase tracking-[0.5em]">Live Logistics Overview</p>
           </div>
           <Button onClick={() => navigate('/admin/fleet')} className="bg-emerald-600 hover:bg-emerald-500 text-white font-black h-14 px-10 rounded-2xl shadow-xl shadow-emerald-900/20">
              {lang === 'en' ? 'Launch Live Tracking' : 'တိုက်ရိုက်စောင့်ကြည့်မှု ဖွင့်ရန်'}
           </Button>
        </div>
      </Card>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-8 pt-4">
        <Card className="bg-[#05080F] border-none ring-1 ring-white/5 rounded-[3rem] p-10 flex justify-between items-center group cursor-pointer hover:ring-sky-500/50 transition-all" onClick={() => navigate('/admin/approvals')}>
           <div className="flex items-center gap-6">
              <div className="p-4 bg-sky-500/10 rounded-2xl group-hover:bg-sky-500/20 transition-all">
                <ShieldCheck className="h-8 w-8 text-sky-500" />
              </div>
              <div>
                <h3 className="text-xl font-bold text-white uppercase italic">{lang === 'en' ? 'Global Control Center' : 'ထိန်းချုပ်မှုဗဟို'}</h3>
                <p className="text-slate-500 text-xs font-mono uppercase tracking-widest">Surveillance & IAM</p>
              </div>
           </div>
           <ArrowUpRight className="text-slate-700 group-hover:text-sky-500 transition-all" />
        </Card>

        <Card className="bg-[#05080F] border-none ring-1 ring-white/5 rounded-[3rem] p-10 flex justify-between items-center group cursor-pointer hover:ring-amber-500/50 transition-all" onClick={() => navigate('/admin/tariffs')}>
           <div className="flex items-center gap-6">
              <div className="p-4 bg-amber-500/10 rounded-2xl group-hover:bg-amber-500/20 transition-all">
                <MapPin className="h-8 w-8 text-amber-500" />
              </div>
              <div>
                <h3 className="text-xl font-bold text-white uppercase italic">{lang === 'en' ? 'System Tariffs' : 'ဝန်ဆောင်ခနှုန်းထားများ'}</h3>
                <p className="text-slate-500 text-xs font-mono uppercase tracking-widest">Regional Zone Pricing</p>
              </div>
           </div>
           <ArrowUpRight className="text-slate-700 group-hover:text-amber-500 transition-all" />
        </Card>
      </div>
    </div>
  );
}
