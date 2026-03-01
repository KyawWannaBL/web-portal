import React, { useState } from 'react';
import { useLanguage } from '@/contexts/LanguageContext';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Truck, Fuel, FileText, Activity, Gauge, Globe } from 'lucide-react';

export default function FleetCommand() {
  const { t, toggleLang } = useLanguage();
  const [activeTab, setActiveTab] = useState<'telemetry' | 'routing'>('telemetry');

  return (
    <div className="p-10 space-y-8 bg-[#0B101B] min-h-screen text-slate-300">
      <div className="flex justify-between items-center bg-[#05080F] p-10 rounded-[3rem] border border-white/5">
        <div>
          <h1 className="text-4xl font-black text-white uppercase flex items-center gap-4">
            <Truck className="h-10 w-10 text-indigo-500" /> {t('linehaulFleet')}
          </h1>
          <p className="text-indigo-500 font-mono text-xs mt-2 uppercase">{t('fleetTelemetry')}</p>
        </div>
        <div className="flex gap-4">
          <Button onClick={toggleLang} className="bg-emerald-600 text-white font-bold rounded-xl h-12 px-6">
            <Globe className="mr-2 h-4 w-4" /> {t('switchLang')}
          </Button>
          <Button onClick={() => setActiveTab('telemetry')} className={`h-12 px-6 rounded-xl font-bold ${activeTab === 'telemetry' ? 'bg-indigo-600 text-white' : 'bg-white/5 text-slate-400'}`}>{t('activeFleet')}</Button>
        </div>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <Card className="bg-[#05080F] p-6 rounded-[2rem] border-white/5 ring-1 ring-white/5">
          <Activity className="text-emerald-500 mb-3 h-6 w-6" />
          <p className="text-slate-500 font-bold uppercase text-[10px]">{t('activeTrucks')}</p>
          <p className="text-3xl text-white font-black">12 / 15</p>
        </Card>
        <Card className="bg-[#05080F] p-6 rounded-[2rem] border-white/5 ring-1 ring-white/5">
          <Fuel className="text-amber-500 mb-3 h-6 w-6" />
          <p className="text-slate-500 font-bold uppercase text-[10px]">{t('fuelBurn')}</p>
          <p className="text-3xl text-white font-black">1,420 L</p>
        </Card>
      </div>
    </div>
  );
}
