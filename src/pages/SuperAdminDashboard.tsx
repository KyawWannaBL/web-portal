import React, { useState } from 'react';
import { useOutletContext } from 'react-router-dom';
import Map, { Marker, NavigationControl } from 'react-map-gl';
import 'mapbox-gl/dist/mapbox-gl.css';
import { Card, CardContent } from '@/components/ui/card';
import { Landmark, Package, Users, Activity } from 'lucide-react';

export default function SuperAdminDashboard() {
  const { lang } = useOutletContext<{ lang: string }>();
  
  const MAPBOX_TOKEN = "pk.eyJ1IjoiYnJpdGl1bXZlbnR1cmVzIiwiYSI6ImNtbHVydDRwbTAwZjczZnMxbDgyODJxbHUifQ.HwgFGIQzepHOhImZLM4Knw";
  
  const [viewState, setViewState] = useState({
    longitude: 96.1951,
    latitude: 16.8661,
    zoom: 11
  });

  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-4xl font-black uppercase tracking-tighter text-white">
            {lang === 'EN' ? 'Executive Command' : 'အမှုဆောင် ကွပ်ကဲမှုစနစ်'}
          </h1>
          <p className="text-emerald-500 font-mono text-[10px] uppercase tracking-widest mt-2 flex items-center gap-2">
            <Activity className="h-3 w-3 animate-pulse" /> Live Production Telemetry Active
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
        <StatCard title={lang === 'EN' ? 'Gross Revenue' : 'စုစုပေါင်း ဝင်ငွေ'} value="0 MMK" icon={<Landmark/>} color="text-emerald-500" />
        <StatCard title={lang === 'EN' ? 'Active Shipments' : 'ပို့ဆောင်ဆဲ ပစ္စည်းများ'} value="0" icon={<Package/>} color="text-sky-500" />
        <StatCard title={lang === 'EN' ? 'Field Force' : 'ပို့ဆောင်ရေးသမားများ'} value="0" icon={<Users/>} color="text-amber-500" />
      </div>

      <Card className="rounded-[3rem] border-none bg-[#05080F]/80 backdrop-blur-xl ring-1 ring-white/5 overflow-hidden h-[500px] flex flex-col shadow-2xl">
        <div className="p-6 border-b border-white/5 flex justify-between items-center bg-[#05080F]">
          <h2 className="text-xl font-black text-white flex items-center gap-2">
            <span className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse"></span>
            {lang === 'EN' ? 'Live Courier Tracking' : 'တိုက်ရိုက် ခြေရာခံစနစ်'}
          </h2>
        </div>
        <div className="flex-1 relative">
          <Map
            {...viewState}
            onMove={evt => setViewState(evt.viewState)}
            mapStyle="mapbox://styles/mapbox/dark-v11"
            mapboxAccessToken={MAPBOX_TOKEN}
          >
            <NavigationControl position="top-right" />
            <Marker longitude={96.1951} latitude={16.8661} color="#10b981" />
          </Map>
        </div>
      </Card>
    </div>
  );
}

function StatCard({ title, value, icon, color }: any) {
  return (
    <Card className="bg-[#05080F]/80 backdrop-blur-xl border-white/5 rounded-[2rem] p-8 ring-1 ring-white/5 shadow-xl hover:ring-emerald-500/20 transition-all group">
      <div className="flex justify-between items-center">
        <div>
          <p className="text-[10px] font-black uppercase text-slate-500 tracking-widest mb-2 group-hover:text-slate-400 transition-colors">{title}</p>
          <p className="text-3xl font-black text-white tracking-tighter">{value}</p>
        </div>
        <div className={`${color} bg-white/5 p-4 rounded-2xl border border-white/5 shadow-inner`}>{icon}</div>
      </div>
    </Card>
  );
}
