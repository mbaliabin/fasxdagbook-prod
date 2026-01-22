import React, { useEffect, useState, useCallback } from 'react'
import {
  Timer, MapPin, Zap, Target, Plus, LogOut, ChevronLeft,
  ChevronRight, ChevronDown, Home, BarChart3,
  ClipboardList, CalendarDays, Activity, User, Brain, Moon,
  AlertTriangle, Thermometer, Send, Clock, Sun, Award,
  Settings, CheckCircle2, Mountain
} from 'lucide-react'
import { useNavigate, useLocation } from 'react-router-dom'
import dayjs from 'dayjs'
import 'dayjs/locale/ru'
import { getUserProfile } from "../api/getUserProfile"
import toast, { Toaster } from "react-hot-toast"

dayjs.locale("ru");

// --- ВСПОМОГАТЕЛЬНЫЕ КОМПОНЕНТЫ ---
const TenButtons = ({ value, onChange, Icon }: { value: number; onChange: (val: number) => void; Icon: any }) => (
  <div className="flex flex-wrap gap-2">
    {[...Array(10)].map((_, i) => {
      const active = i < value;
      return (
        <button
          key={i}
          type="button"
          onClick={() => onChange(i + 1)}
          className={`w-10 h-10 rounded-lg flex items-center justify-center transition-all border ${
            active
              ? "bg-blue-600 border-blue-500 shadow-[0_0_15px_rgba(37,99,235,0.3)] scale-105 z-10"
              : "bg-[#0a0a0b] border-white/[0.05] hover:border-white/20 text-gray-600"
          }`}
        >
          <Icon className={`w-4 h-4 ${active ? "text-white" : "text-gray-700"}`} />
        </button>
      );
    })}
  </div>
);

const CompactStatusButton = ({ id, label, Icon, isActive, onClick, activeColor }: any) => {
  return (
    <button
      type="button"
      onClick={onClick}
      className={`px-4 py-3 rounded-xl flex items-center space-x-3 transition-all border w-full ${
        isActive
          ? `${activeColor} border-transparent shadow-lg scale-[1.02]`
          : "bg-[#0a0a0b] border-white/[0.05] hover:border-white/10 text-gray-500 hover:text-gray-300"
      }`}
    >
      <div className={`p-1.5 rounded-lg ${isActive ? "bg-white/20" : "bg-white/[0.03]"}`}>
        <Icon className={`w-4 h-4 ${isActive ? "text-white" : "text-gray-500"}`} />
      </div>
      <span className={`text-[10px] font-black uppercase tracking-widest ${isActive ? "text-white" : ""}`}>{label}</span>
    </button>
  );
};

export default function DailyParameters() {
  const navigate = useNavigate();
  const location = useLocation();
  const API_URL = import.meta.env.VITE_API_URL;

  const [profile, setProfile] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [selectedDate, setSelectedDate] = useState(dayjs());
  const [mainParam, setMainParam] = useState<string[]>([]);
  const [physical, setPhysical] = useState(0);
  const [mental, setMental] = useState(0);
  const [sleepQuality, setSleepQuality] = useState(0);
  const [pulse, setPulse] = useState<string>("");
  const [sleepDuration, setSleepDuration] = useState<string>("");
  const [comment, setComment] = useState<string>("");

  const fetchData = useCallback(async () => {
    try {
      const profileData = await getUserProfile();
      setProfile(profileData);

      const token = localStorage.getItem("token");
      const dateStr = selectedDate.format("YYYY-MM-DD");
      const res = await fetch(`${API_URL}/api/daily-information?date=${dateStr}`, {
        headers: { Authorization: `Bearer ${token}` }
      });

      if (res.ok) {
        const data = await res.json();
        setMainParam(data.main_param ? data.main_param.split(',') : []);
        setPhysical(Number(data.physical) || 0);
        setMental(Number(data.mental) || 0);
        setSleepQuality(Number(data.sleep_quality) || 0);
        setPulse(data.pulse != null ? String(data.pulse) : "");
        setSleepDuration(data.sleep_duration || "");
        setComment(data.comment || "");
      } else {
        setMainParam([]); setPhysical(0); setMental(0); setSleepQuality(0); setPulse(""); setSleepDuration(""); setComment("");
      }
    } catch (err) { console.error(err); }
    finally { setLoading(false); }
  }, [selectedDate, API_URL]);

  useEffect(() => { fetchData(); }, [fetchData]);

  const handleSave = async () => {
    const loadingToast = toast.loading("Сохранение данных...", {
        style: { background: '#131316', color: '#fff', border: '1px solid rgba(255,255,255,0.1)' }
    });
    try {
      const token = localStorage.getItem("token");
      const res = await fetch(`${API_URL}/api/daily-information`, {
        method: "POST",
        headers: { "Content-Type": "application/json", Authorization: `Bearer ${token}` },
        body: JSON.stringify({
          date: selectedDate.format("YYYY-MM-DD"),
          mainParam: mainParam.join(','),
          physical, mental, sleepQuality,
          pulse: pulse ? Number(pulse) : null,
          sleepDuration: sleepDuration || null,
          comment: comment || null,
        }),
      });
      if (res.ok) toast.success("Данные успешно сохранены ✅", { id: loadingToast });
      else toast.error("Ошибка при сохранении ❌", { id: loadingToast });
    } catch (err) { toast.error("Сбой сети ❌", { id: loadingToast }); }
  };

  const toggleStatus = (id: string) => {
    setMainParam(prev => prev.includes(id) ? prev.filter(i => i !== id) : [...prev, id]);
  };

  const menuItems = [
    { label: "Главная", icon: Timer, path: "/daily" },
    { label: "Тренировки", icon: BarChart3, path: "/profile" },
    { label: "Календарь", icon: CalendarDays, path: "/calendar" },
    { label: "Планирование", icon: ClipboardList, path: "/planning" },
    { label: "Статистика", icon: Activity, path: "/statistics" },
  ];

  const readinessScore = Math.round(((physical + mental + sleepQuality) / 30) * 100);

  if (loading && !profile) return (
    <div className="min-h-screen bg-[#0f0f0f] flex items-center justify-center text-white font-sans">
      <div className="w-12 h-12 border-4 border-blue-600 border-t-transparent rounded-full animate-spin"></div>
    </div>
  );

  return (
    <div className="min-h-screen bg-[#0f0f0f] text-gray-200 p-6 w-full font-sans selection:bg-blue-500/30">
      <Toaster position="bottom-right" />
      <div className="max-w-[1600px] mx-auto space-y-6 px-4 pb-12">

        {/* HEADER */}
        <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-6 mb-4 animate-in fade-in slide-in-from-top-4 duration-500">
          <div className="flex items-center space-x-5 group cursor-pointer" onClick={() => navigate("/account")}>
            <div className="w-12 h-12 rounded-full overflow-hidden flex items-center justify-center bg-[#131316] transition-transform group-hover:scale-105 border border-white/[0.05]">
              {profile?.avatarUrl ? (
                <img src={profile.avatarUrl} className="w-full h-full object-cover" alt="avatar" />
              ) : (
                <div className="w-full h-full flex items-center justify-center bg-blue-600 font-bold text-white text-lg">
                  {profile?.name?.charAt(0) || "U"}
                </div>
              )}
            </div>
            <div>
              <h1 className="text-2xl font-black text-white tracking-tight leading-none mb-1 group-hover:text-blue-400 transition-colors">
                {profile?.name || "Пользователь"}
              </h1>
              <div className="flex items-center gap-2 text-gray-500 group-hover:text-gray-300">
                <Activity size={12} className="text-blue-500/50" />
                <p className="text-[10px] font-bold uppercase tracking-[0.2em]">
                  Daily Parameters
                </p>
              </div>
            </div>
          </div>

          <div className="flex items-center space-x-2 flex-wrap">
            <div className="flex items-center bg-[#131316] border border-white/[0.05] rounded-xl p-1 shadow-xl">
              <button onClick={() => setSelectedDate(selectedDate.subtract(1, "day"))} className="p-2 hover:text-blue-500 transition-colors"><ChevronLeft size={18}/></button>
              <div className="px-4 text-center">
                <span className="text-[10px] font-black uppercase text-white tracking-widest">{selectedDate.format("D MMM YYYY")}</span>
              </div>
              <button onClick={() => setSelectedDate(selectedDate.add(1, "day"))} className="p-2 hover:text-blue-500 transition-colors"><ChevronRight size={18}/></button>
            </div>
            <button onClick={() => { localStorage.removeItem("token"); navigate("/login"); }} className="bg-[#1a1a1d] border border-gray-800 hover:border-red-500/50 hover:text-red-400 text-gray-400 text-[10px] font-black uppercase tracking-widest px-5 py-2.5 rounded-xl flex items-center transition-all">
              <LogOut className="w-4 h-4 mr-2"/> Выйти
            </button>
          </div>
        </div>

        {/* NAVIGATION */}
        <div className="flex justify-around bg-[#131316] border border-white/[0.03] py-2 px-4 rounded-xl shadow-2xl">
          {menuItems.map((item) => {
            const Icon = item.icon;
            const isActive = location.pathname === item.path;
            return (
              <button key={item.path} onClick={() => navigate(item.path)}
                className={`flex flex-col items-center gap-1 transition-all py-1 w-24 ${isActive ? "text-blue-500" : "text-gray-600 hover:text-gray-300"}`}>
                <Icon className={`w-5 h-5 ${isActive ? "stroke-[2.5px]" : "stroke-[2px]"}`}/>
                <span className={`text-[9px] font-black uppercase tracking-[0.2em]`}>{item.label}</span>
              </button>
            );
          })}
        </div>

        {/* MAIN CONTENT */}
        <div className="grid lg:grid-cols-4 gap-6 min-h-[600px]">
          {/* СТАТУСЫ */}
          <div className="lg:col-span-1 h-full">
            <div className="bg-[#131316] border border-white/[0.03] p-6 rounded-xl shadow-xl h-full flex flex-col">
              <div className="flex items-center gap-2 mb-4 text-gray-400">
                <AlertTriangle size={14} className="text-blue-500" />
                <h2 className="text-[10px] font-black uppercase tracking-widest">Основной статус</h2>
              </div>

              <div className="flex flex-col gap-2">
                <CompactStatusButton id="skadet" label="Травма" Icon={AlertTriangle} isActive={mainParam.includes("skadet")} onClick={() => toggleStatus("skadet")} activeColor="bg-red-600" />
                <CompactStatusButton id="syk" label="Болезнь" Icon={Thermometer} isActive={mainParam.includes("syk")} onClick={() => toggleStatus("syk")} activeColor="bg-orange-600" />
                <CompactStatusButton id="hoyde" label="На высоте" Icon={Mountain} isActive={mainParam.includes("hoyde")} onClick={() => toggleStatus("hoyde")} activeColor="bg-cyan-600" />
                <CompactStatusButton id="paReise" label="В пути" Icon={Send} isActive={mainParam.includes("paReise")} onClick={() => toggleStatus("paReise")} activeColor="bg-blue-600" />
                <CompactStatusButton id="hoydedogn" label="Часовой пояс" Icon={Clock} isActive={mainParam.includes("hoydedogn")} onClick={() => toggleStatus("hoydedogn")} activeColor="bg-purple-600" />
                <CompactStatusButton id="fridag" label="Выходной" Icon={Sun} isActive={mainParam.includes("fridag")} onClick={() => toggleStatus("fridag")} activeColor="bg-green-600" />
                <CompactStatusButton id="konkurranse" label="Соревнование" Icon={Award} isActive={mainParam.includes("konkurranse")} onClick={() => toggleStatus("konkurranse")} activeColor="bg-yellow-600" />
              </div>

              <div className="flex-grow flex flex-col justify-center space-y-4 py-8">
                <div className="bg-black/40 border border-white/[0.05] p-5 rounded-xl text-center">
                  <p className="text-[9px] font-black text-gray-600 uppercase tracking-widest mb-2">Индекс готовности</p>
                  <div className="text-3xl font-black text-blue-500 tracking-tighter">{readinessScore > 0 ? readinessScore + '%' : '--'}</div>
                  <div className="h-1.5 w-full bg-white/[0.05] rounded-full overflow-hidden mt-4">
                    <div className="h-full bg-blue-600 transition-all duration-1000" style={{ width: `${readinessScore}%` }} />
                  </div>
                </div>

                <div className="bg-blue-600/5 border border-blue-500/10 p-4 rounded-xl min-h-[80px] flex flex-col justify-center">
                  <div className="flex items-center gap-2 mb-2 text-blue-500">
                    <Activity size={12} />
                    <span className="text-[10px] font-bold uppercase tracking-widest">Совет дня</span>
                  </div>
                  <p className="text-[11px] text-gray-400 leading-relaxed italic text-center md:text-left">
                    {mainParam.includes('syk') ? "Полное восстановление — твой главный приоритет." :
                     physical > 7 ? "Организм готов к интенсивным нагрузкам." :
                     "Хороший день для восстановительного кросса."}
                  </p>
                </div>
              </div>
              <div className="pt-4 border-t border-white/[0.05]">
                <p className="text-[9px] text-gray-500 leading-relaxed uppercase font-bold tracking-tighter text-center">
                  Выбор статуса помогает точнее анализировать форму
                </p>
              </div>
            </div>
          </div>

          {/* ПАРАМЕТРЫ */}
          <div className="lg:col-span-3 h-full">
            <div className="bg-[#131316] border border-white/[0.03] p-8 rounded-xl shadow-xl h-full flex flex-col space-y-10">
              <div className="flex items-center gap-2 text-blue-500">
                <Settings size={16} />
                <h2 className="text-[10px] font-black uppercase tracking-widest">Параметры готовности</h2>
              </div>

              <div className="grid gap-10 flex-grow">
                <section className="space-y-4">
                  <label className="text-[10px] font-black text-gray-500 uppercase tracking-[0.2em] flex items-center gap-2">
                    <User size={14} className="text-blue-500" /> Физическая готовность
                  </label>
                  <TenButtons value={physical} onChange={setPhysical} Icon={User} />
                </section>

                <section className="space-y-4">
                  <label className="text-[10px] font-black text-gray-500 uppercase tracking-[0.2em] flex items-center gap-2">
                    <Brain size={14} className="text-blue-500" /> Ментальная готовность
                  </label>
                  <TenButtons value={mental} onChange={setMental} Icon={Brain} />
                </section>

                <section className="space-y-4">
                  <label className="text-[10px] font-black text-gray-500 uppercase tracking-[0.2em] flex items-center gap-2">
                    <Moon size={14} className="text-blue-500" /> Качество сна
                  </label>
                  <TenButtons value={sleepQuality} onChange={setSleepQuality} Icon={Moon} />
                </section>

                <div className="grid md:grid-cols-2 gap-8">
                  <section className="space-y-4">
                    <label className="text-[10px] font-black text-gray-500 uppercase tracking-[0.2em] flex items-center gap-2">
                      <Timer size={14} className="text-blue-500" /> Пульс (уд/мин)
                    </label>
                    <input type="number" value={pulse} onChange={(e) => setPulse(e.target.value)} placeholder="60" className="w-full bg-black/40 border border-white/[0.05] p-4 rounded-xl focus:border-blue-500 outline-none transition-all text-white font-bold" />
                  </section>
                  <section className="space-y-4">
                    <label className="text-[10px] font-black text-gray-500 uppercase tracking-[0.2em] flex items-center gap-2">
                      <Clock size={14} className="text-blue-500" /> Длительность сна
                    </label>
                    <input type="text" value={sleepDuration} onChange={(e) => setSleepDuration(e.target.value)} placeholder="07:30" className="w-full bg-black/40 border border-white/[0.05] p-4 rounded-xl focus:border-blue-500 outline-none transition-all text-white font-bold" />
                  </section>
                </div>

                <section className="space-y-4">
                  <label className="text-[10px] font-black text-gray-500 uppercase tracking-[0.2em]">Заметки к дню</label>
                  <textarea value={comment} onChange={(e) => setComment(e.target.value)} placeholder="Как прошло восстановление?..." className="w-full bg-black/40 border border-white/[0.05] p-4 h-32 rounded-xl focus:border-blue-500 outline-none transition-all text-white resize-none" />
                </section>
              </div>

              <div className="pt-6">
                <button onClick={handleSave} className="w-full bg-blue-600 hover:bg-blue-500 text-white font-black text-[11px] uppercase tracking-[0.3em] py-5 rounded-xl flex items-center justify-center gap-3 transition-all active:scale-[0.98]">
                  <CheckCircle2 size={18} /> Сохранить параметры
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* НИЖНЯЯ НАДПИСЬ */}
        <div className="mt-10 flex flex-col items-center justify-center py-6 border-t border-white/[0.03]">
          <div className="flex items-center gap-2 text-gray-600 mb-2">
             <Activity size={12} className="opacity-50" />
             <span className="text-[9px] font-black uppercase tracking-[0.3em] opacity-50">Monitoring & Recovery System</span>
          </div>
          <p className="text-[10px] text-gray-700 font-bold uppercase tracking-widest">Данные обновляются в реальном времени на основе ваших показателей</p>
        </div>

      </div>
    </div>
  );
}