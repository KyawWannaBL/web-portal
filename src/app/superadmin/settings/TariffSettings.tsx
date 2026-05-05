import React, { useMemo, useState } from "react";
import { useLanguage } from "@/contexts/LanguageContext";
import {
  Save,
  Building,
  MapPin,
  PlaneTakeoff,
  Network,
  Plus,
  Trash2,
  DollarSign,
  Info,
} from "lucide-react";

const myanmarLocations: Record<string, string[]> = {
  "Yangon": ["Kamaryut","Bahan","Sanchaung","Hlaing","Mayangone","Insein","Mingaladon","North Okkalapa","South Okkalapa","Yankin","Thingangyun","Tamwe","South Dagon","North Dagon","East Dagon","Dagon Seikkan","Thaketa","Dawbon","Pazundaung","Botahtaung","Kyauktada","Pabedan","Latha","Lanmadaw","Ahlone","Kyeemyindaung","Hlaing Tharyar","Shwepyithar"],
  "Mandalay": ["Chanayethazan","Chanmyathazi","Maha Aungmye","Pyigyidagun","Amarapura","Patheingyi","Pyin Oo Lwin","Kyaukse","Meiktila","Myingyan","Nyaung-U","Mogok"],
  "Nay Pyi Taw": ["Zabuthiri","Dekkhinathiri","Ottarathiri","Pobbathiri","Zeyarthiri","Pyinmana","Lewe","Tatkon"],
  "Bago": ["Bago","Taungoo","Pyay","Thayarwady","Nyaunglebin","Shwegyin","Daik-U"],
  "Ayeyarwady": ["Pathein","Hinthada","Maubin","Myaungmya","Pyapon","Labutta","Bogale"],
  "Sagaing": ["Sagaing","Monywa","Shwebo","Kale","Katha","Tamu","Homalin"],
  "Magway": ["Magway","Pakokku","Thayet","Minbu","Gangaw","Chauk","Yenangyaung"],
  "Tanintharyi": ["Dawei","Myeik","Kawthaung","Bokpyin","Yebyu","Launglon"],
  "Kachin": ["Myitkyina","Bhamo","Mohnyin","Putao","Shwegu","Hpakant"],
  "Kayin": ["Hpa-An","Myawaddy","Kawkareik","Thandaunggyi","Hpapun"],
  "Mon": ["Mawlamyine","Thaton","Ye","Kyaikto","Chaungzon","Mudon"],
  "Rakhine": ["Sittwe","Kyaukpyu","Thandwe","Mrauk-U","Maungdaw"],
  "Shan (South)": ["Taunggyi","Kalaw","Nyaungshwe (Inle)","Hopong","Loilem","Nansang"],
  "Shan (North)": ["Lashio","Muse","Kyaukme","Hsipaw","Nawnghkio","Kutkai"],
  "Shan (East)": ["Kengtung","Tachileik","Mong Hsat","Mong Hpayak"],
};

type IntlRoute = { id: number; country: string; rate: number; minWeight: string; duration: string };

export default function TariffSettings() {
  const { lang } = useLanguage();
  const t = (en: string, my: string) => (lang === "en" ? en : my);

  const [tab, setTab] = useState<"local" | "intl" | "network">("local");

  const [selectedState, setSelectedState] = useState("");
  const [selectedTownship, setSelectedTownship] = useState("");

  const [intlRoutes, setIntlRoutes] = useState<IntlRoute[]>([
    { id: 1, country: "United States (USA)", rate: 18.5, minWeight: "1.0 Kg", duration: "7-10 Days" },
    { id: 2, country: "Singapore", rate: 4.5, minWeight: "0.5 Kg", duration: "2-3 Days" },
    { id: 3, country: "Thailand (BKK)", rate: 3.0, minWeight: "0.5 Kg", duration: "1-2 Days" },
    { id: 4, country: "United Kingdom (UK)", rate: 15.0, minWeight: "1.0 Kg", duration: "5-7 Days" },
  ]);

  const addRoute = () => {
    setIntlRoutes((p) => [...p, { id: Date.now(), country: "", rate: 0, minWeight: "1.0 Kg", duration: "" }]);
  };

  const deleteRoute = (id: number) => setIntlRoutes((p) => p.filter((r) => r.id !== id));

  const handleSave = () => {
    // production-ready: replace with API call + toast
    alert(t("All Settings Saved Successfully!", "ပြောင်းလဲမှုအားလုံးကို အောင်မြင်စွာ သိမ်းဆည်းပြီးပါပြီ။"));
  };

  const regions = useMemo(() => Object.keys(myanmarLocations).sort(), []);

  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-2xl font-black text-white tracking-wide uppercase">
            {t("Settings & Configuration", "စနစ် သတ်မှတ်ချက်များနှင့် ပြင်ဆင်မှုများ")}
          </h2>
          <p className="text-slate-400 text-sm mt-1">
            {t(
              "Manage system pricing, international routes, and logistics network hubs.",
              "စနစ်၏ ဈေးနှုန်းများ၊ နိုင်ငံတကာ လမ်းကြောင်းများနှင့် ထောက်ပံ့ပို့ဆောင်ရေး ဟပ်များကို စီမံပါ။"
            )}
          </p>
        </div>

        <button
          onClick={handleSave}
          className="flex items-center justify-center gap-2 px-6 py-3 bg-emerald-600 hover:bg-emerald-500 text-white font-black rounded-2xl transition-all shadow-lg shadow-emerald-500/20"
        >
          <Save size={18} />
          {t("Save All Changes", "ပြောင်းလဲမှုအားလုံး သိမ်းဆည်းရန်")}
        </button>
      </div>

      {/* Tabs */}
      <div className="flex gap-2 p-1 bg-[#111622] rounded-2xl border border-white/5 overflow-x-auto">
        <TabBtn active={tab === "local"} onClick={() => setTab("local")} icon={<MapPin size={16} />} label={t("Local Pricing", "ပြည်တွင်း ဈေးနှုန်းများ")} />
        <TabBtn active={tab === "intl"} onClick={() => setTab("intl")} icon={<PlaneTakeoff size={16} />} label={t("International Air Cargo", "နိုင်ငံတကာ လေကြောင်းပို့ဆောင်ရေး")} />
        <TabBtn active={tab === "network"} onClick={() => setTab("network")} icon={<Network size={16} />} label={t("Network Expansion", "ကွန်ရက် တိုးချဲ့ခြင်း")} />
      </div>

      {/* LOCAL */}
      {tab === "local" && (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <PricingCard
            accent="blue"
            title={t("Yangon Region", "ရန်ကုန်တိုင်းဒေသကြီး")}
            zones={[
              { name: "Zone 1: Downtown", desc: "Latha, Lanmadaw, Pabedan, Kyauktada, Botahtaung, Pazundaung", price: 2000 },
              { name: "Zone 2: Inner City", desc: "Bahan, Sanchaung, Kamaryut, Hlaing, Ahlone, Kyeemyindaung", price: 2500 },
              { name: "Zone 3: New Towns", desc: "North/South/East Dagon, North/South Okkalapa, Thaketa", price: 3000 },
            ]}
            t={t}
          />
          <PricingCard
            accent="emerald"
            title={t("Mandalay Region", "မန္တလေးတိုင်းဒေသကြီး")}
            zones={[
              { name: "Downtown Grid", desc: "Chanayethazan, Chanmyathazi, Maha Aungmye", price: 2500 },
              { name: "Industrial Zone", desc: "Pyigyidagun, Industrial Park Areas", price: 3000 },
            ]}
            t={t}
          />
          <PricingCard
            accent="amber"
            title={t("Nay Pyi Taw", "နေပြည်တော်")}
            zones={[
              { name: "Ministry Zone", desc: "Zabuthiri (Govt Offices)", price: 3000 },
              { name: "Residential & Hotel", desc: "Dekkhinathiri, Ottarathiri", price: 3500 },
            ]}
            t={t}
          />
        </div>
      )}

      {/* INTERNATIONAL */}
      {tab === "intl" && (
        <div className="bg-[#111622] border-t-4 border-t-rose-500 border border-white/5 rounded-3xl p-6 shadow-2xl">
          <div className="flex flex-col sm:flex-row justify-between items-center border-b border-white/10 pb-4 mb-6 gap-4">
            <div className="flex items-center gap-3">
              <PlaneTakeoff className="text-rose-400" />
              <h3 className="font-black text-white text-lg">
                {t("International Air Cargo Rates", "နိုင်ငံတကာ လေကြောင်း ပို့ဆောင်ခနှုန်းထားများ")}
              </h3>
            </div>
            <button
              onClick={addRoute}
              className="flex items-center gap-2 px-4 py-2 bg-white/5 hover:bg-white/10 border border-white/10 rounded-2xl text-sm font-black text-white transition-all"
            >
              <Plus size={16} className="text-emerald-300" /> {t("Add Route", "လမ်းကြောင်း အသစ်ထည့်ရန်")}
            </button>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm border-collapse">
              <thead>
                <tr className="border-b border-white/10 text-slate-400">
                  <th className="p-4 font-bold">{t("Country / Destination", "နိုင်ငံ / ခရီးစဉ်")}</th>
                  <th className="p-4 font-bold">{t("Rate (USD/Kg)", "နှုန်းထား (USD/Kg)")}</th>
                  <th className="p-4 font-bold">{t("Min Weight", "အနည်းဆုံး အလေးချိန်")}</th>
                  <th className="p-4 font-bold">{t("Est. Duration", "ခန့်မှန်း ကြာချိန်")}</th>
                  <th className="p-4 font-bold text-center">{t("Action", "လုပ်ဆောင်ချက်")}</th>
                </tr>
              </thead>
              <tbody>
                {intlRoutes.map((route) => (
                  <tr key={route.id} className="border-b border-white/5 hover:bg-white/[0.02]">
                    <td className="p-2">
                      <input
                        type="text"
                        defaultValue={route.country}
                        placeholder={t("Country Name", "နိုင်ငံအမည်")}
                        className="w-full bg-[#05080F] border border-white/10 rounded-xl px-3 py-2 text-white outline-none focus:border-rose-500"
                      />
                    </td>
                    <td className="p-2">
                      <div className="relative">
                        <span className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">
                          <DollarSign size={14} />
                        </span>
                        <input
                          type="number"
                          defaultValue={route.rate}
                          className="w-full bg-[#05080F] border border-white/10 rounded-xl pl-8 pr-3 py-2 text-white outline-none focus:border-rose-500"
                        />
                      </div>
                    </td>
                    <td className="p-2">
                      <input
                        type="text"
                        defaultValue={route.minWeight}
                        className="w-full bg-[#05080F] border border-white/10 rounded-xl px-3 py-2 text-white outline-none focus:border-rose-500"
                      />
                    </td>
                    <td className="p-2">
                      <input
                        type="text"
                        defaultValue={route.duration}
                        placeholder="e.g. 5-7 Days"
                        className="w-full bg-[#05080F] border border-white/10 rounded-xl px-3 py-2 text-white outline-none focus:border-rose-500"
                      />
                    </td>
                    <td className="p-2 text-center">
                      <button
                        onClick={() => deleteRoute(route.id)}
                        className="p-2 text-rose-400 hover:bg-rose-500/10 rounded-xl transition-colors"
                      >
                        <Trash2 size={18} />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>

            <p className="mt-4 text-xs text-slate-500">
              {t(
                "Production-ready: replace alert/save with API calls. Table structure matches typical backend DTOs.",
                "Production-ready: alert/save ကို API ချိတ်ဆက်မှုဖြင့် အစားထိုးပါ။ Table ဖွဲ့စည်းပုံသည် backend DTO များနှင့် ကိုက်ညီပါသည်။"
              )}
            </p>
          </div>
        </div>
      )}

      {/* NETWORK */}
      {tab === "network" && (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 bg-[#111622] border-t-4 border-t-emerald-500 border border-white/5 rounded-3xl p-6 shadow-2xl">
            <div className="flex items-center gap-3 border-b border-white/10 pb-4 mb-6">
              <Network className="text-emerald-400" />
              <h3 className="font-black text-white text-lg">
                {t("Add New Substation / Hub", "ဆပ်စတေရှင် / ဟပ် အသစ်ထည့်ရန်")}
              </h3>
            </div>

            <form
              onSubmit={(e) => {
                e.preventDefault();
                alert(t("New Hub Added Successfully!", "ဟပ် အသစ်ကို အောင်မြင်စွာ ထည့်သွင်းပြီးပါပြီ။"));
              }}
              className="space-y-6"
            >
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-2">
                  <label className="text-xs font-black text-slate-400 uppercase tracking-wider">
                    {t("State / Region", "ပြည်နယ် / တိုင်းဒေသကြီး")}
                  </label>
                  <select
                    className="w-full h-12 bg-[#05080F] border border-white/10 rounded-2xl px-4 text-white outline-none focus:border-emerald-500"
                    value={selectedState}
                    onChange={(e) => {
                      setSelectedState(e.target.value);
                      setSelectedTownship("");
                    }}
                    required
                  >
                    <option value="" disabled>
                      {t("Select Region...", "တိုင်းဒေသကြီး ရွေးပါ...")}
                    </option>
                    {regions.map((r) => (
                      <option key={r} value={r}>
                        {r}
                      </option>
                    ))}
                  </select>
                </div>

                <div className="space-y-2">
                  <label className="text-xs font-black text-slate-400 uppercase tracking-wider">
                    {t("Township", "မြို့နယ်")}
                  </label>
                  <select
                    className="w-full h-12 bg-[#05080F] border border-white/10 rounded-2xl px-4 text-white outline-none focus:border-emerald-500 disabled:opacity-50"
                    value={selectedTownship}
                    onChange={(e) => setSelectedTownship(e.target.value)}
                    disabled={!selectedState}
                    required
                  >
                    <option value="" disabled>
                      {selectedState ? t("Select Township...", "မြို့နယ် ရွေးပါ...") : t("Select State First", "ပြည်နယ်/တိုင်း အရင်ရွေးပါ")}
                    </option>
                    {selectedState &&
                      myanmarLocations[selectedState]?.slice().sort().map((tsp) => (
                        <option key={tsp} value={tsp}>
                          {tsp}
                        </option>
                      ))}
                  </select>
                </div>
              </div>

              <div className="space-y-2">
                <label className="text-xs font-black text-slate-400 uppercase tracking-wider">
                  {t("Hub Name (Internal ID)", "ဟပ် အမည် (အတွင်းသုံး ID)")}
                </label>
                <input
                  type="text"
                  required
                  placeholder="e.g. Lashio-North-Hub-01"
                  className="w-full h-12 bg-[#05080F] border border-white/10 rounded-2xl px-4 text-white outline-none focus:border-emerald-500"
                />
              </div>

              <div className="space-y-2">
                <label className="text-xs font-black text-slate-400 uppercase tracking-wider">
                  {t("Full Address", "အပြည့်အစုံ လိပ်စာ")}
                </label>
                <textarea
                  required
                  rows={3}
                  placeholder={t("Street address, Quarter, etc.", "လမ်း၊ ရပ်ကွက် စသည်...")}
                  className="w-full bg-[#05080F] border border-white/10 rounded-2xl p-4 text-white outline-none focus:border-emerald-500 resize-none"
                />
              </div>

              <div className="pt-2 flex justify-end">
                <button
                  type="submit"
                  className="px-8 py-3 bg-emerald-600 hover:bg-emerald-500 text-white font-black rounded-2xl transition-all shadow-lg shadow-emerald-500/20"
                >
                  {t("Create Hub", "ဟပ် ဖန်တီးရန်")}
                </button>
              </div>
            </form>
          </div>

          <div className="bg-blue-500/10 border border-blue-500/20 rounded-3xl p-6 h-fit">
            <div className="flex items-center gap-2 mb-3">
              <Info className="text-blue-300" />
              <h4 className="font-black text-blue-200">{t("Database Info", "ဒေတာဘေ့စ် အချက်အလက်")}</h4>
            </div>
            <p className="text-sm text-blue-200/70 leading-relaxed">
              {t(
                "State/Township list is pre-loaded (MIMU-style) to ensure delivery routing accuracy.",
                "ပြည်နယ်နှင့် မြို့နယ် စာရင်းကို (MIMU စံနှုန်းစိတ်ကူး) ဖြင့် ကြိုတင် ထည့်သွင်းထားပြီး လမ်းကြောင်း မှန်ကန်စေရန် လုပ်ဆောင်ထားပါသည်။"
              )}
            </p>
          </div>
        </div>
      )}
    </div>
  );
}

function TabBtn({ active, onClick, icon, label }: { active: boolean; onClick: () => void; icon: React.ReactNode; label: string }) {
  return (
    <button
      onClick={onClick}
      className={`flex items-center gap-2 px-6 py-3 rounded-xl text-sm font-black transition-all whitespace-nowrap ${
        active ? "bg-emerald-500/10 text-emerald-300 border border-emerald-500/20" : "text-slate-400 hover:text-white hover:bg-white/5 border border-transparent"
      }`}
    >
      {icon} {label}
    </button>
  );
}

function PricingCard({
  accent,
  title,
  zones,
  t,
}: {
  accent: "blue" | "emerald" | "amber";
  title: string;
  zones: Array<{ name: string; desc: string; price: number }>;
  t: (en: string, my: string) => string;
}) {
  const accentClass =
    accent === "blue"
      ? "border-t-blue-500"
      : accent === "emerald"
      ? "border-t-emerald-500"
      : "border-t-amber-500";

  const iconColor =
    accent === "blue" ? "text-blue-400" : accent === "emerald" ? "text-emerald-400" : "text-amber-400";

  return (
    <div className={`bg-[#111622] border-t-4 ${accentClass} border border-white/5 rounded-3xl p-6 shadow-2xl`}>
      <div className="flex items-center gap-3 border-b border-white/10 pb-4 mb-6">
        <Building className={iconColor} />
        <h3 className="font-black text-white text-lg">{title}</h3>
      </div>

      <div className="space-y-4">
        {zones.map((z, idx) => (
          <div key={idx} className="bg-[#05080F] p-4 rounded-2xl border border-white/5 hover:border-white/15 transition-all">
            <input
              type="text"
              defaultValue={z.name}
              className="font-black text-slate-200 bg-transparent border-b border-dashed border-white/20 focus:border-solid focus:border-emerald-500 outline-none w-full mb-2 pb-1"
            />
            <textarea
              defaultValue={z.desc}
              rows={2}
              className="text-xs text-slate-400 w-full bg-transparent border border-transparent focus:border-white/10 rounded outline-none resize-none mb-3"
            />
            <div className="flex items-center bg-white/5 rounded-xl border border-white/10 overflow-hidden">
              <span className="px-3 py-2 bg-white/10 text-xs font-black text-slate-300">{t("Price", "ဈေးနှုန်း")}</span>
              <input
                type="number"
                defaultValue={z.price}
                className="flex-1 bg-transparent px-3 py-2 text-emerald-300 font-mono outline-none"
              />
              <span className="px-3 py-2 text-xs font-black text-slate-500">MMK</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
