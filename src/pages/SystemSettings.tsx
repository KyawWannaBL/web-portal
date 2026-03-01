import React, { useState } from 'react';
import { supabase } from '@/lib/supabase';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Globe, Save, Loader2, FileSpreadsheet, Download, Upload, CheckCircle2 } from 'lucide-react';

const NATIONWIDE_LOCATIONS: Record<string, string[]> = {
  "Yangon": ["Kamaryut", "Bahan", "Sanchaung", "Hlaing", "Insein", "Latha", "Mayangone", "Tamwe", "South Okkalapa", "North Okkalapa", "Mingaladon", "Thaketa", "Dawbon", "Pazundaung", "Botataung"],
  "Mandalay": ["Chanayethazan", "Chanmyathazi", "Maha Aungmye", "Pyigyidagun", "Pyin Oo Lwin", "Amarapura", "Patheingyi", "Singu", "Thabeikkyin"],
  "Nay Pyi Taw": ["Zabuthiri", "Dekkhinathiri", "Ottarathiri", "Pobbathiri", "Pyinmana", "Lewe", "Tatkon"],
  "Shan (South)": ["Taunggyi", "Kalaw", "Nyaungshwe", "Hopong", "Hiseng", "Pinlaung", "Pekon"],
  "Shan (North)": ["Lashio", "Hseni", "Kutkai", "Namtu", "Hsipaw", "Kyaukme", "Nawnghkio"],
  "Shan (East)": ["Kengtung", "Mongla", "Mongyang", "Mongpawk"],
  "Ayeyarwady": ["Pathein", "Hinthada", "Myaungmya", "Maubin", "Pyapon", "Labutta", "Bogale"],
  "Bago": ["Bago", "Pyay", "Taungoo", "Tharyarwady", "Nyaunglebin", "Kawa"],
  "Magway": ["Magway", "Pakokku", "Minbu", "Thayet", "Gangaw", "Chauk"],
  "Sagaing": ["Sagaing", "Monywa", "Shwebo", "Katha", "Kale", "Tammu", "Hkamti"],
  "Mon": ["Mawlamyine", "Thaton", "Mudon", "Ye", "Kyaikto", "Chaungzon"],
  "Kayin": ["Hpa-An", "Myawaddy", "Kawkareik", "Hpapun", "Thandaunggyi"],
  "Kachin": ["Myitkyina", "Bhamo", "Putao", "Mogaung", "Mohnyin", "Waingmaw"],
  "Rakhine": ["Sittwe", "Thandwe", "Mrauk-U", "Kyaukpyu", "Maungdaw", "Ann"],
  "Kayah": ["Loikaw", "Demoso", "Hpruso", "Bawlake"],
  "Chin": ["Hakha", "Falam", "Mindat", "Kanpetlet", "Matupi", "Tedim"]
};

export default function SystemSettings() {
  const [isSaving, setIsSaving] = useState(false);
  const [selectedRegion, setSelectedRegion] = useState("Yangon");
  const [rates, setRates] = useState<Record<string, number>>({});
  
  const MAPBOX_TOKEN = "pk.eyJ1IjoiYnJpdGl1bXZlbnR1cmVzIiwiYSI6ImNtbHVydDRwbTAwZjczZnMxbDgyODJxbHUifQ.HwgFGIQzepHOhImZLM4Knw";

  const handleExport = () => {
    const header = "Region,Township,Rate_MMK\n";
    const rows = Object.entries(NATIONWIDE_LOCATIONS).flatMap(([region, townships]) => 
      townships.map(t => `${region},${t},0`)
    ).join("\n");
    const blob = new Blob([header + rows], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `Britium_Tariff_Template.csv`;
    a.click();
  };

  const handleImport = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    setIsSaving(true);
    const reader = new FileReader();
    reader.onload = async (e) => {
      const text = e.target?.result as string;
      const lines = text.split('\n').slice(1); // Skip header
      const updates = lines
        .filter(line => line.trim())
        .map(line => {
          const [region, township, rate] = line.split(',');
          return { region_name: region.trim(), zone_label: township.trim(), base_rate: Number(rate.trim()) };
        });

      const { error } = await supabase.from('domestic_tariffs').upsert(updates, { onConflict: 'region_name,zone_label' });
      if (error) alert("Import Error: " + error.message);
      else alert(`Bulk Sync Complete: ${updates.length} townships updated.`);
      setIsSaving(false);
    };
    reader.readAsText(file);
  };

  const handleSave = async () => {
    setIsSaving(true);
    const updates = Object.entries(rates).map(([township, rate]) => ({
      region_name: selectedRegion, zone_label: township, base_rate: rate
    }));
    const { error } = await supabase.from('domestic_tariffs').upsert(updates, { onConflict: 'region_name,zone_label' });
    if (error) alert(error.message);
    else alert(`${selectedRegion} tariffs updated.`);
    setIsSaving(false);
  };

  return (
    <div className="p-10 space-y-8 bg-[#0B101B] min-h-screen text-slate-300">
      <div className="flex justify-between items-center bg-[#05080F] p-10 rounded-[3rem] border border-white/5 shadow-2xl">
        <div>
          <h1 className="text-4xl font-black uppercase tracking-tighter text-white">Tariff Production Control</h1>
          <p className="text-emerald-500 font-mono text-[10px] uppercase tracking-widest mt-2">MAPBOX_ID: {MAPBOX_TOKEN.substring(0, 12)}...</p>
        </div>
        <div className="flex gap-4">
          <Button onClick={handleExport} variant="outline" className="border-white/10 text-white h-14 px-6 rounded-2xl font-black">
            <Download className="mr-2 h-5 w-5" /> Export Template
          </Button>
          <div className="relative">
            <input type="file" accept=".csv" onChange={handleImport} className="absolute inset-0 opacity-0 cursor-pointer" />
            <Button variant="outline" className="border-emerald-500/30 text-emerald-500 h-14 px-6 rounded-2xl font-black bg-emerald-500/5">
              <Upload className="mr-2 h-5 w-5" /> Import CSV
            </Button>
          </div>
          <Button onClick={handleSave} disabled={isSaving} className="bg-emerald-600 hover:bg-emerald-500 text-white font-black h-14 px-10 rounded-2xl shadow-lg shadow-emerald-900/20">
            {isSaving ? <Loader2 className="animate-spin" /> : <><Save className="mr-2 h-5 w-5" /> Save Region</>}
          </Button>
        </div>
      </div>

      <div className="grid grid-cols-12 gap-8">
        <Card className="col-span-3 rounded-[3rem] border-none bg-[#05080F] ring-1 ring-white/5 max-h-[70vh] overflow-y-auto scrollbar-hide">
          <CardHeader className="p-8 border-b border-white/5"><CardTitle className="text-white font-black text-xl flex items-center gap-3"><Globe className="text-emerald-500" /> States & Regions</CardTitle></CardHeader>
          <CardContent className="p-6 space-y-1">
            {Object.keys(NATIONWIDE_LOCATIONS).map((reg) => (
              <button key={reg} onClick={() => setSelectedRegion(reg)} className={`w-full text-left p-4 rounded-xl font-bold transition-all text-sm ${selectedRegion === reg ? 'bg-emerald-500/20 text-emerald-400' : 'hover:bg-white/5 text-slate-500'}`}>
                {reg}
              </button>
            ))}
          </CardContent>
        </Card>

        <Card className="col-span-9 rounded-[3rem] border-none bg-[#05080F] ring-1 ring-white/5">
          <CardHeader className="p-8 border-b border-white/5 flex justify-between flex-row items-center">
            <CardTitle className="text-white font-black text-xl italic">{selectedRegion} Pricing Grid</CardTitle>
            <div className="flex items-center gap-2 text-[10px] font-black text-slate-500 uppercase tracking-widest">
               <CheckCircle2 className="h-3 w-3 text-emerald-500" /> Ready for Production
            </div>
          </CardHeader>
          <CardContent className="p-8 grid grid-cols-3 gap-4 overflow-y-auto max-h-[60vh] scrollbar-hide">
            {NATIONWIDE_LOCATIONS[selectedRegion].map((township) => (
              <div key={township} className="bg-[#0B101B] p-5 rounded-2xl border border-white/5 hover:border-emerald-500/30 transition-all group">
                <label className="text-[10px] font-black text-slate-500 uppercase mb-2 block group-hover:text-emerald-400">{township}</label>
                <div className="flex items-center bg-white/5 rounded-xl px-4 py-3 border border-transparent focus-within:border-emerald-500/50">
                  <input type="number" placeholder="0" className="bg-transparent text-white font-black w-full outline-none text-lg" onChange={(e) => setRates({...rates, [township]: Number(e.target.value)})} />
                  <span className="text-xs font-black text-slate-700 ml-2">MMK</span>
                </div>
              </div>
            ))}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
