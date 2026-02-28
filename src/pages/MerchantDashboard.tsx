import React, { useState, useEffect } from 'react';
import { supabase } from '@/lib/supabase';
import { useAuth } from '@/hooks/useAuth';
import { useLanguageContext } from '@/lib/LanguageContext';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Package, Truck, CheckCircle2, DollarSign } from 'lucide-react';

export default function MerchantDashboard() {
  const { user } = useAuth();
  const { t } = useLanguageContext();
  const [shipments, setShipments] = useState<any[]>([]);

  useEffect(() => {
    const fetchMerchantShipments = async () => {
      const { data } = await supabase
        .from('shipments')
        .select('*')
        .eq('merchant_id', user?.id)
        .order('created_at', { ascending: false });
      if (data) setShipments(data);
    };
    if (user) fetchMerchantShipments();
  }, [user]);

  return (
    <div className="p-8 space-y-8 bg-slate-50 min-h-screen">
      <h1 className="text-3xl font-bold">{t('Merchant Dashboard', 'ကုန်သည် ဒက်ရှ်ဘုတ်')}</h1>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card className="luxury-card">
          <CardContent className="pt-6">
            <div className="flex items-center gap-4">
              <Package className="h-8 w-8 text-primary" />
              <div>
                <p className="text-2xl font-bold">{shipments.length}</p>
                <p className="text-xs text-muted-foreground uppercase">{t('Total Orders', 'စုစုပေါင်း အော်ဒါ')}</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      <div className="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
        <table className="w-full text-left">
          <thead className="bg-slate-50 border-b">
            <tr>
              <th className="p-4 text-xs font-bold uppercase">{t('Tracking', 'ခြေရာခံရန်')}</th>
              <th className="p-4 text-xs font-bold uppercase">{t('Recipient', 'လက်ခံသူ')}</th>
              <th className="p-4 text-xs font-bold uppercase">{t('COD', 'ငွေကောက်ခံမှု')}</th>
            </tr>
          </thead>
          <tbody>
            {shipments.map((s) => (
              <tr key={s.id} className="border-b hover:bg-slate-50 transition-colors">
                <td className="p-4 font-mono text-primary font-bold">{s.tracking_no}</td>
                <td className="p-4">{s.receiver_name}</td>
                <td className="p-4 font-bold">{s.cod_amount?.toLocaleString()} K</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
