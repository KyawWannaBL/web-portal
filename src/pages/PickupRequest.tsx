import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { supabase } from "@/lib/supabase";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent } from "@/components/ui/card";

export default function PickupRequest() {
  const { t } = useTranslation();
  const [pieces, setPieces] = useState("1");
  const [type, setType] = useState("box");
  const [condition, setCondition] = useState("OK");
  const [codAmount, setCodAmount] = useState("");

  return (
    <Card className="max-w-md mx-auto mt-10">
      <CardContent className="p-6 space-y-5">
        <h1 className="text-xl font-semibold">Create Pickup Request</h1>
        <div className="space-y-3">
          <Input value={pieces} onChange={(e) => setPieces(e.target.value)} placeholder="Pieces" />
          <Input value={type} onChange={(e) => setType(e.target.value)} placeholder="Type (e.g. Bag, Box)" />
          <Input value={condition} onChange={(e) => setCondition(e.target.value)} placeholder="Condition" />
          <Input value={codAmount} onChange={(e) => setCodAmount(e.target.value)} placeholder="COD Amount" />
        </div>
        <Button className="w-full bg-emerald-600 text-white font-bold h-12">Submit Request</Button>
      </CardContent>
    </Card>
  );
}
