import React, { useState, useEffect } from 'react';
import { supabase } from '@/lib/supabase';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { ShieldCheck, Eye, History, Search, Loader2 } from 'lucide-react';

export default function AccountControl() {
  const [auditLogs, setAuditLogs] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  // 1. Fetch Live Audit Logs from Database
  const fetchLogs = async () => {
    setIsLoading(true);
    const { data, error } = await supabase
      .from('audit_logs')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(20);
    
    if (!error && data) setAuditLogs(data);
    setIsLoading(false);
  };

  useEffect(() => { fetchLogs(); }, []);

  // 2. Omni-Viewer Shadow Logic
  const handleShadowAccess = (rolePath: string, roleName: string) => {
    const confirmView = window.confirm(`ENTER SHADOW MODE: Accessing ${roleName} dashboard. All data will be READ-ONLY. Continue?`);
    if (confirmView) {
      // Opens the dashboard with a readonly flag in the URL
      window.open(`${rolePath}?mode=readonly`, '_blank');
    }
  };

  return (
    <div className="p-10 space-y-8 bg-[#0B101B] min-h-screen text-slate-300">
      <div className="flex justify-between items-end bg-[#05080F] p-10 rounded-[3rem] border border-white/5 shadow-2xl">
        <div>
          <h1 className="text-4xl font-black uppercase tracking-tighter text-white flex items-center gap-4">
            <ShieldCheck className="h-10 w-10 text-emerald-500" />
            Security & Oversight Hub
          </h1>
          <p className="text-emerald-500 font-mono text-xs mt-2 tracking-widest uppercase">L5_OWNER_AUDIT_TRAIL_ENABLED</p>
        </div>
        <Button onClick={fetchLogs} variant="outline" className="border-white/10 text-white h-12 rounded-xl">
          <History className="mr-2 h-4 w-4" /> Refresh Audit Trail
        </Button>
      </div>

      <div className="grid grid-cols-12 gap-8">
        {/* OMNI-VIEWER: ACCESS OTHER ROLES */}
        <Card className="col-span-4 rounded-[3rem] border-none bg-[#05080F] ring-1 ring-white/5 shadow-2xl">
          <CardHeader className="bg-white/5 p-8 border-b border-white/5">
            <CardTitle className="text-xl font-black text-white flex items-center gap-3">
              <Eye className="text-emerald-500" /> Omni-Role Mirroring
            </CardTitle>
          </CardHeader>
          <CardContent className="p-8 space-y-3">
             <ShadowBtn label="Finance Manager Panel" path="/admin/omni-finance" onAccess={handleShadowAccess} />
             <ShadowBtn label="Logistics Operations" path="/ways" onAccess={handleShadowAccess} />
             <ShadowBtn label="Merchant Dashboard" path="/merchant/dashboard" onAccess={handleShadowAccess} />
             <ShadowBtn label="System Settings" path="/admin/settings" onAccess={handleShadowAccess} />
             <p className="text-[10px] text-slate-500 font-mono mt-4 text-center uppercase tracking-widest opacity-50">
                Read-only mode enforced for mirrored sessions
             </p>
          </CardContent>
        </Card>

        {/* LIVE AUDIT LOG TABLE */}
        <Card className="col-span-8 rounded-[3rem] border-none bg-[#05080F] ring-1 ring-white/5 overflow-hidden shadow-2xl">
          <CardHeader className="bg-white/5 p-8 border-b border-white/5">
            <CardTitle className="text-xl font-black text-white flex items-center gap-3">
              <History className="text-gold-500" /> Administrative Audit Log
            </CardTitle>
          </CardHeader>
          <CardContent className="p-0">
            <div className="overflow-x-auto min-h-[300px]">
              <table className="w-full text-left whitespace-nowrap">
                <thead className="bg-white/5 text-slate-500 uppercase font-black text-[10px] tracking-widest">
                  <tr>
                    <th className="px-8 py-6">Timestamp</th>
                    <th className="px-8 py-6">Administrator</th>
                    <th className="px-8 py-6">Action Performed</th>
                    <th className="px-8 py-6">Target Identity</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-white/5">
                  {isLoading ? (
                    <tr><td colSpan={4} className="p-20 text-center"><Loader2 className="animate-spin mx-auto text-emerald-500" /></td></tr>
                  ) : auditLogs.length === 0 ? (
                    <tr><td colSpan={4} className="p-20 text-center text-slate-600 font-bold uppercase tracking-widest">No Security Actions Recorded</td></tr>
                  ) : (
                    auditLogs.map((log) => (
                      <tr key={log.id} className="hover:bg-white/5 transition-colors">
                        <td className="px-8 py-4 font-mono text-xs text-slate-500">{new Date(log.created_at).toLocaleString()}</td>
                        <td className="px-8 py-4 font-bold text-emerald-500">{log.admin_email}</td>
                        <td className="px-8 py-4"><span className="bg-white/5 px-3 py-1 rounded-md border border-white/5 text-[10px] font-black uppercase text-white">{log.action_type}</span></td>
                        <td className="px-8 py-4 font-mono text-xs text-slate-400">{log.target_email}</td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

function ShadowBtn({ label, path, onAccess }: any) {
  return (
    <button 
      onClick={() => onAccess(path, label)}
      className="w-full flex justify-between items-center p-5 bg-[#0B101B] border border-white/5 rounded-2xl hover:border-emerald-500/50 transition-all group"
    >
      <span className="font-bold text-slate-400 group-hover:text-white">{label}</span>
      <Eye className="h-4 w-4 text-slate-600 group-hover:text-emerald-500" />
    </button>
  );
}
