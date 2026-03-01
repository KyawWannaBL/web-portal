import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { supabase } from '@/lib/supabase';
import { Card } from '@/components/ui/card';
import { Warehouse, Package, ArrowDownToLine, ArrowUpRight, QrCode, RefreshCcw } from 'lucide-react';
import { Button } from '@/components/ui/button';

export default function ShipmentControl() {
  const navigate = useNavigate();
  const [metrics, setMetrics] = useState({
    totalInventory: 0,
    receivedToday: 0,
    dispatchedToday: 0
  });
  const [isLoading, setIsLoading] = useState(true);

  // Live Database Connection Hook
  useEffect(() => {
    fetchLiveMetrics();
  }, []);

  async function fetchLiveMetrics() {
    setIsLoading(true);
    try {
      // Querying the 'orders' table. Update this table name if your schema differs.
      const { count: inventoryCount } = await supabase
        .from('orders')
        .select('*', { count: 'exact', head: true })
        .eq('status', 'at_hub');

      const { count: receivedCount } = await supabase
        .from('orders')
        .select('*', { count: 'exact', head: true })
        .gte('created_at', new Date().toISOString().split('T')[0]);

      const { count: dispatchedCount } = await supabase
        .from('orders')
        .select('*', { count: 'exact', head: true })
        .eq('status', 'in_transit');

      setMetrics({
        totalInventory: inventoryCount || 0,
        receivedToday: receivedCount || 0,
        dispatchedToday: dispatchedCount || 0
      });
    } catch (error) {
      console.error("Database connection error:", error);
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <div className="p-10 space-y-8 bg-[#0B101B] min-h-screen text-slate-300">
      <div className="flex justify-between items-center bg-[#05080F] p-10 rounded-[3rem] border border-white/5 shadow-2xl">
        <div>
          <h1 className="text-4xl font-black text-white uppercase tracking-tighter flex items-center gap-4">
            <Warehouse className="h-10 w-10 text-amber-500" /> Warehouse Hub
          </h1>
          <p className="text-amber-500 font-mono text-xs mt-2 uppercase tracking-widest flex items-center gap-2">
            L4_OPERATIONS • <span className="text-emerald-400 flex items-center gap-1"><span className="h-2 w-2 rounded-full bg-emerald-400 animate-pulse"></span> DB CONNECTED</span>
          </p>
        </div>
        <div className="flex gap-4">
          <Button onClick={fetchLiveMetrics} variant="outline" className="border-white/10 text-slate-400 hover:text-white h-12 px-4 rounded-xl">
            <RefreshCcw className={`h-5 w-5 ${isLoading ? 'animate-spin text-amber-500' : ''}`} />
          </Button>
          <Button onClick={() => navigate('/admin/warehouse-drop')} className="bg-amber-600 hover:bg-amber-500 text-white font-black h-12 px-6 rounded-xl shadow-lg shadow-amber-900/20">
            <QrCode className="mr-2 h-5 w-5" /> Inbound Handover Scan
          </Button>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card className="bg-[#05080F] p-8 rounded-[2.5rem] border-white/5 ring-1 ring-white/5 relative overflow-hidden">
          <Package className="text-amber-500 mb-4 h-8 w-8" />
          <p className="text-slate-500 font-bold uppercase text-[10px] tracking-widest">Live Inventory (At Hub)</p>
          <p className="text-4xl text-white font-black mt-2">
            {isLoading ? '...' : metrics.totalInventory}
          </p>
        </Card>
        
        <Card className="bg-[#05080F] p-8 rounded-[2.5rem] border-white/5 ring-1 ring-white/5 relative overflow-hidden">
          <ArrowDownToLine className="text-emerald-500 mb-4 h-8 w-8" />
          <p className="text-slate-500 font-bold uppercase text-[10px] tracking-widest">Received Today</p>
          <p className="text-4xl text-white font-black mt-2">
            {isLoading ? '...' : metrics.receivedToday}
          </p>
        </Card>
        
        <Card className="bg-[#05080F] p-8 rounded-[2.5rem] border-white/5 ring-1 ring-white/5 relative overflow-hidden">
          <ArrowUpRight className="text-sky-500 mb-4 h-8 w-8" />
          <p className="text-slate-500 font-bold uppercase text-[10px] tracking-widest">Dispatched (In Transit)</p>
          <p className="text-4xl text-white font-black mt-2">
            {isLoading ? '...' : metrics.dispatchedToday}
          </p>
        </Card>
      </div>
    </div>
  );
}
