import React from 'react';
import { Card, CardContent } from '@/components/ui/card';

export default function MerchantPortal() {
  return (
    <div className="p-10 bg-[#0B101B] min-h-screen text-white">
      <h1 className="text-3xl font-black mb-6">Merchant Financial Center</h1>
      <Card className="bg-[#05080F] border-white/5 p-6 rounded-[2rem]">
        <CardContent>
          <p className="text-slate-500">COD Withdrawal and statements will appear here.</p>
        </CardContent>
      </Card>
    </div>
  );
}
