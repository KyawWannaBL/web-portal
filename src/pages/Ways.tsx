import React, { useState, useEffect } from 'react';
import { supabase } from '@/lib/supabase';
import { useLanguageContext } from '@/lib/LanguageContext';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Card, CardContent } from '@/components/ui/card';
import { Package, Truck, AlertTriangle, RotateCcw, ArrowUpDown } from 'lucide-react';

export default function Ways() {
  const { t } = useLanguageContext();
  const [data, setData] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);

  const fetchWays = async (status: string) => {
    setLoading(true);
    const { data: shipments } = await supabase
      .from('shipments')
      .select('*')
      .eq('status', status);
    setData(shipments || []);
    setLoading(false);
  };

  useEffect(() => { fetchWays('pickup'); }, []);

  return (
    <div className="p-6 space-y-6 bg-slate-50 min-h-screen">
      <h1 className="text-3xl font-bold text-navy-900">{t('Ways Tracking', 'ပို့ဆောင်မှု ခြေရာခံခြင်း')}</h1>
      
      <Tabs defaultValue="pickup" onValueChange={fetchWays} className="w-full">
        <TabsList className="grid w-full grid-cols-5 bg-navy-900/5 p-1">
          <TabsTrigger value="pickup" className="gap-2"><Package className="h-4 w-4" /> {t('Pickup', 'ပစ္စည်းယူ')}</TabsTrigger>
          <TabsTrigger value="deliver" className="gap-2"><Truck className="h-4 w-4" /> {t('Deliver', 'ပို့ဆောင်')}</TabsTrigger>
          <TabsTrigger value="failed" className="gap-2"><AlertTriangle className="h-4 w-4" /> {t('Failed', 'မအောင်မြင်')}</TabsTrigger>
          <TabsTrigger value="returned" className="gap-2"><RotateCcw className="h-4 w-4" /> {t('Return', 'ပြန်ပေး')}</TabsTrigger>
          <TabsTrigger value="transit" className="gap-2"><ArrowUpDown className="h-4 w-4" /> {t('Transit', 'လမ်းခရီး')}</TabsTrigger>
        </TabsList>

        <TabsContent value={data[0]?.status || 'pickup'}>
          <div className="grid gap-4 mt-6">
            {loading ? <p className="text-center py-10">Loading...</p> : 
             data.map((item) => (
              <Card key={item.id} className="luxury-card hover:border-primary/50 transition-all">
                <CardContent className="p-4 flex justify-between items-center">
                  <div>
                    <p className="font-mono text-primary font-bold">{item.tracking_no}</p>
                    <p className="text-sm text-slate-600">{item.receiver_name} | {item.receiver_phone}</p>
                  </div>
                  <div className="text-right">
                    <p className="font-bold text-navy-900">{item.cod_amount?.toLocaleString()} K</p>
                    <p className="text-xs text-slate-400">{new Date(item.created_at).toLocaleDateString()}</p>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </TabsContent>
      </Tabs>
    </div>
  );
}
