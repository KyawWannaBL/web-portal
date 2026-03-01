import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/lib/supabase';
import { useLanguage } from '@/contexts/LanguageContext';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { LayoutDashboard, Headset, Calculator, TrendingUp, Warehouse, MapPin, Store, Truck, Users, UserPlus, Globe } from 'lucide-react';

export default function UserControlCenter() {
  const navigate = useNavigate();
  const { t, toggleLang } = useLanguage();
  const [users, setUsers] = useState<any[]>([]);

  useEffect(() => { fetchUsers(); }, []);
  async function fetchUsers() {
    const { data } = await supabase.from('admin_users').select('*');
    if (data) setUsers(data);
  }

  const depts = [
    { title: t('customerService' as any) || "Customer Service", role: "customer_service", path: "/admin/cs", icon: Headset, color: "text-rose-400", bg: "bg-rose-500/10" },
    { title: t('finance' as any) || "Finance", role: "accountant", path: "/admin/finance-ops", icon: Calculator, color: "text-emerald-400", bg: "bg-emerald-500/10" },
    { title: t('warehouseOps' as any) || "Warehouse", role: "warehouse", path: "/admin/shipments", icon: Warehouse, color: "text-amber-400", bg: "bg-amber-500/10" },
    { title: t('branchMgmt' as any) || "Branch Management", role: "manager", path: "/admin/branch", icon: MapPin, color: "text-cyan-400", bg: "bg-cyan-500/10" }
  ];

  return (
    <div className="p-10 space-y-8 bg-[#0B101B] min-h-screen text-slate-300">
      <div className="flex justify-between items-center bg-[#05080F] p-10 rounded-[3rem] border border-white/5 shadow-2xl">
        <div>
          <h1 className="text-4xl font-black text-white uppercase flex items-center gap-4">
            <LayoutDashboard className="h-10 w-10 text-sky-500" /> {t('controlCenter')}
          </h1>
          <p className="text-sky-500 font-mono text-xs mt-2 uppercase">{t('deptOversight')}</p>
        </div>
        <div className="flex gap-4">
          <Button onClick={toggleLang} className="bg-emerald-600 text-white font-bold rounded-xl px-6 h-12">
            <Globe className="mr-2 h-4 w-4" /> {t('switchLang')}
          </Button>
          <Button className="bg-sky-600 text-white font-black h-12 px-6 rounded-xl">
             <UserPlus className="mr-2 h-5 w-5" /> {t('provisionAccount')}
          </Button>
        </div>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {depts.map((dept, i) => (
          <Card key={i} className="bg-[#05080F] border-none ring-1 ring-white/5 rounded-[2rem] overflow-hidden">
            <CardContent className="p-6 space-y-6">
              <div className={`p-3 w-fit rounded-xl ${dept.bg}`}><dept.icon className={`h-6 w-6 ${dept.color}`} /></div>
              <h3 className="text-white font-bold text-lg">{dept.title}</h3>
            </CardContent>
            <div className="grid grid-cols-2 border-t border-white/5 bg-[#0B101B]/50">
              <button className="p-4 text-xs font-bold text-slate-400 hover:text-white border-r border-white/5">{t('manageStaff')}</button>
              <button onClick={() => navigate(dept.path)} className={`p-4 text-xs font-black ${dept.color}`}>{t('launchPortal')}</button>
            </div>
          </Card>
        ))}
      </div>
    </div>
  );
}
