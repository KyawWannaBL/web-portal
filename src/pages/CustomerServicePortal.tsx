import React, { useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Headset, Search, AlertCircle, FileText } from 'lucide-react';

export default function CustomerServicePortal() {
  const [search, setSearch] = useState('');
  return (
    <div className="p-10 space-y-8 bg-[#0B101B] min-h-screen text-slate-300">
      <div className="flex justify-between items-center bg-[#05080F] p-10 rounded-[3rem] border border-white/5 shadow-2xl">
        <div>
          <h1 className="text-4xl font-black uppercase text-white flex items-center gap-4"><Headset className="h-10 w-10 text-rose-400" /> CS Support Hub</h1>
          <p className="text-rose-400 font-mono text-xs mt-2 tracking-widest uppercase">L1_SUPPORT • DISPUTE & INQUIRY RESOLUTION</p>
        </div>
      </div>
      <Card className="rounded-[2.5rem] border-none bg-[#05080F] ring-1 ring-white/5">
        <CardHeader><CardTitle className="text-white flex items-center gap-2"><Search className="text-sky-400" /> Global AWB Tracking Inquiry</CardTitle></CardHeader>
        <CardContent className="space-y-6">
          <div className="flex gap-4">
            <Input placeholder="Enter Tracking AWB or Phone Number..." className="bg-white/5 border-white/10 text-white h-14 text-lg" />
            <Button className="h-14 px-8 bg-sky-600 hover:bg-sky-500 text-white font-black">Search Records</Button>
          </div>
          <div className="grid grid-cols-2 gap-4 mt-6">
            <div className="p-4 bg-rose-500/10 border border-rose-500/20 rounded-xl flex items-center gap-3 text-rose-400"><AlertCircle /> 12 Active "Suspect Address" Alerts</div>
            <div className="p-4 bg-emerald-500/10 border border-emerald-500/20 rounded-xl flex items-center gap-3 text-emerald-400"><FileText /> 5 ePOD Verification Requests</div>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
