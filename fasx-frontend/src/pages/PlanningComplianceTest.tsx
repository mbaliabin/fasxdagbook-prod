import React, { useEffect, useState, useCallback, useMemo } from 'react';
import dayjs from 'dayjs';
import isBetween from 'dayjs/plugin/isBetween';
import { 
  Zap, RefreshCw, ChevronDown, Flame, Timer, 
  LayoutGrid, User, Route, Dumbbell, Clock
} from 'lucide-react';

dayjs.extend(isBetween);

export default function PlanComplianceFinal() {
  const [allPlans, setAllPlans] = useState<any[]>([]);
  const [workouts, setWorkouts] = useState<any[]>([]);
  const [planRows, setPlanRows] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedPlan, setSelectedPlan] = useState<any>(null);

  const API_URL = import.meta.env.VITE_API_URL;
  const token = localStorage.getItem("token");

  const fetchPlans = useCallback(async () => {
    try {
      const res = await fetch(`${API_URL}/api/planning`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      if (res.ok) {
        const data = await res.json();
        setAllPlans(data || []);
        const activeId = localStorage.getItem('active_plan_id');
        const initial = data.find((p: any) => p.id === activeId) || data[0];
        if (initial) setSelectedPlan(initial);
      }
    } catch (e) { console.error(e); }
  }, [API_URL, token]);

  const loadPlanData = useCallback(async (planId: string) => {
    setLoading(true);
    try {
      const [wRes, pRes] = await Promise.all([
        fetch(`${API_URL}/api/workouts/user`, { headers: { Authorization: `Bearer ${token}` } }),
        fetch(`${API_URL}/api/planning/data?planId=${planId}`, { headers: { Authorization: `Bearer ${token}` } })
      ]);
      if (wRes?.ok) setWorkouts(await wRes.json());
      if (pRes?.ok) {
        const pData = await pRes.json();
        setPlanRows(pData?.rows || []);
      }
    } catch (e) { console.error(e); } finally { setLoading(false); }
  }, [API_URL, token]);

  useEffect(() => { fetchPlans(); }, [fetchPlans]);
  useEffect(() => { if (selectedPlan?.id) loadPlanData(selectedPlan.id); }, [selectedPlan, loadPlanData]);

  const stats = useMemo(() => {
    if (!selectedPlan || !Array.isArray(planRows) || planRows.length === 0) return null;
    
    const start = dayjs(selectedPlan.startDate).startOf('day');
    const end = dayjs(selectedPlan.endDate).endOf('day');
    const filteredWorkouts = workouts.filter(w => w && w.date && dayjs(w.date).isBetween(start, end, null, '[]'));

    const fact = {
      "Часы": filteredWorkouts.reduce((sum, w) => sum + (Number(w?.duration) || 0), 0) / 60,
      "Сессии": filteredWorkouts.length,
      "Интенсивные": filteredWorkouts.filter(w => {
        const dur = Number(w?.duration) || 1;
        const score = ((Number(w?.zone1Min)||0)*1 + (Number(w?.zone2Min)||0)*1.5 + (Number(w?.zone3Min)||0)*3 + (Number(w?.zone4Min)||0)*6 + (Number(w?.zone5Min)||0)*12) / dur;
        return score >= 2.0;
      }).length,
      "Дистанция": filteredWorkouts.reduce((sum, w) => sum + (Number(w?.distance) || 0), 0),
      "Сила Сессии": filteredWorkouts.filter(w => w?.type === 'StrengthTraining').length,
      "Сила Часы": filteredWorkouts.filter(w => w?.type === 'StrengthTraining').reduce((sum, w) => sum + (Number(w?.duration) || 0), 0) / 60,
    };

    const getPlanValue = (label: string, isHours: boolean = false) => {
      const row = planRows.find(r => r?.label?.toLowerCase().includes(label.toLowerCase()));
      if (!row || !row.values) return 0;
      let total = 0;
      let curr = start.clone();
      while (curr.isBefore(end) || curr.isSame(end, 'month')) {
        const mIdx = curr.month();
        const valIdx = row.isDouble ? (isHours ? mIdx * 2 + 1 : mIdx * 2) : mIdx;
        total += Number(row.values[valIdx]) || 0;
        curr = curr.add(1, 'month');
      }
      return total;
    };

    const planValues = {
      "Часы": getPlanValue("Часы", true),
      "Сессии": getPlanValue("Сессии", false),
      "Интенсивные": getPlanValue("Интенсивные", false),
      "Дистанция": getPlanValue("Дистанция", false),
      "Сила Сессии": getPlanValue("Сила", false),
      "Сила Часы": getPlanValue("Сила", true),
    };

    const progress = planValues["Часы"] > 0 ? Math.round((fact["Часы"] / planValues["Часы"]) * 100) : 0;
    return { fact, plan: planValues, progress, start, end };
  }, [workouts, planRows, selectedPlan]);

  const cards = [
    { title: "Volume & Intensity", items: [
      { label: "Общее время", key: "Часы", unit: "ч", icon: <Timer size={14}/> },
      { label: "Общий путь", key: "Дистанция", unit: "км", icon: <Route size={14}/> },
      { label: "Всего сессий", key: "Сессии", unit: "зан", icon: <Flame size={14}/> },
      { label: "Интенсивные", key: "Интенсивные", unit: "зан", icon: <Zap size={14}/> }
    ]},
    { title: "Strength Work", items: [
      { label: "Сила (Сессии)", key: "Сила Сессии", unit: "зан", icon: <Dumbbell size={14}/> },
      { label: "Сила (Часы)", key: "Сила Часы", unit: "ч", icon: <Clock size={14}/> },
    ]}
  ];

  if (loading && !selectedPlan) return <div className="min-h-screen bg-[#070708] flex items-center justify-center text-blue-500 font-black italic uppercase tracking-widest">Loading_System...</div>;

  return (
    <div className="min-h-screen bg-[#070708] text-gray-200 p-4 md:p-8 font-sans">
      <div className="max-w-4xl mx-auto space-y-8">
        
        <header className="flex flex-col md:flex-row justify-between items-start md:items-end gap-6">
          <div className="space-y-1">
            <h1 className="text-4xl font-black italic tracking-tighter uppercase">Metrics <span className="text-blue-600">Core</span></h1>
            <p className="text-[10px] text-gray-500 font-black uppercase tracking-[0.3em]">Plan: {selectedPlan?.name || "No active plan"}</p>
          </div>
          <div className="relative w-full md:w-72">
             <div className="relative bg-[#111114] border border-white/10 rounded-xl flex items-center">
                <div className="pl-4 text-blue-600"><LayoutGrid size={18}/></div>
                <select 
                  value={selectedPlan?.id || ''} 
                  onChange={(e) => setSelectedPlan(allPlans.find(p => p.id === e.target.value))}
                  className="bg-transparent text-[11px] font-black uppercase text-white outline-none px-4 py-4 w-full cursor-pointer appearance-none"
                >
                  {allPlans.map(p => <option key={p.id} value={p.id} className="bg-[#0a0a0a]">{p.name}</option>)}
                </select>
             </div>
          </div>
        </header>

        {stats && (
          <>
            <section className="bg-[#111114] border border-white/5 rounded-xl p-10 flex flex-col md:flex-row items-center justify-between gap-12 relative overflow-hidden group">
                <div className="absolute top-0 right-0 p-8 opacity-[0.05] pointer-events-none group-hover:opacity-[0.08] transition-opacity">
                    <User size={320} className="text-white" strokeWidth={1} />
                </div>
                
                <div className="relative z-10">
                    <span className="text-blue-500 text-[10px] font-black uppercase tracking-[0.4em] mb-4 block italic">Compliance_Index</span>
                    <div className="text-[9.5rem] font-black leading-none tracking-tighter text-white italic">
                        {stats.progress}<span className="text-4xl text-blue-600 font-black not-italic">%</span>
                    </div>
                </div>

                <div className="w-full md:w-[45%] space-y-6 relative z-10">
                    <div className="space-y-3">
                        <div className="flex justify-between text-[10px] font-black uppercase text-gray-500">
                            <span>{stats.start.format('DD.MM.YY')} — {stats.end.format('DD.MM.YY')}</span>
                            <span className="text-white">{stats.progress}%</span>
                        </div>
                        <div className="h-3 w-full bg-white/5 rounded-full p-0.5 border border-white/5 overflow-hidden">
                            <div className="h-full bg-gradient-to-r from-blue-700 to-blue-400 rounded-full transition-all duration-1000" style={{ width: `${Math.min(stats.progress, 100)}%` }} />
                        </div>
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                        <div className="bg-white/5 p-5 rounded-lg border border-white/5">
                            <p className="text-[9px] font-black text-gray-500 uppercase tracking-widest mb-1">Total Distance</p>
                            <p className="text-2xl font-black italic">{stats.fact["Дистанция"].toFixed(1)} <span className="text-xs text-blue-600">KM</span></p>
                        </div>
                        <div className="bg-white/5 p-5 rounded-lg border border-white/5">
                            <p className="text-[9px] font-black text-gray-500 uppercase tracking-widest mb-1">Total Sessions</p>
                            <p className="text-2xl font-black italic">{stats.fact["Сессии"]} <span className="text-xs text-blue-600">SESS</span></p>
                        </div>
                    </div>
                </div>
            </section>

            <div className="grid md:grid-cols-2 gap-6">
              {cards.map((section) => (
                <div key={section.title} className="bg-[#111114] border border-white/5 rounded-xl flex flex-col overflow-hidden">
                  <div className="p-6 border-b border-white/5 bg-white/[0.01]">
                    <h3 className="text-[11px] font-black uppercase tracking-[0.2em] text-white/80">{section.title}</h3>
                  </div>
                  <div className="p-5 space-y-3">
                    {section.items.map((item) => {
                      const fVal = (stats.fact as any)[item.key] || 0;
                      const pVal = (stats.plan as any)[item.key] || 0;
                      const per = pVal > 0 ? Math.round((fVal / pVal) * 100) : 0;
                      return (
                        <div key={item.key} className="bg-white/[0.02] border border-white/5 rounded-lg p-5 hover:border-white/20 transition-all group">
                          <div className="flex justify-between items-start mb-4">
                            <div className="flex items-center gap-2 text-gray-500 group-hover:text-blue-500 transition-colors">
                              {item.icon}
                              <span className="text-[10px] font-black uppercase tracking-tighter">{item.label}</span>
                            </div>
                            {pVal > 0 && (
                              <span className={`text-[10px] font-black px-2 py-0.5 rounded-md ${per >= 100 ? 'bg-emerald-500/20 text-emerald-500' : 'bg-white/5 text-gray-500'}`}>
                                {per}%
                              </span>
                            )}
                          </div>
                          <div className="flex items-baseline justify-between">
                            <span className="text-3xl font-black italic text-white tracking-tighter">
                                {typeof fVal === 'number' ? fVal.toFixed(1).replace('.0', '') : fVal}
                            </span>
                            <span className="text-[10px] font-bold text-gray-600 uppercase tracking-widest">
                                {pVal > 0 ? `/ ${pVal} ${item.unit}` : item.unit}
                            </span>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              ))}
            </div>
          </>
        )}

        <footer className="flex justify-center pb-10">
          <button 
            onClick={() => selectedPlan && loadPlanData(selectedPlan.id)} 
            className="flex items-center gap-3 px-12 py-5 bg-white text-black text-[11px] font-black uppercase tracking-[0.3em] rounded-xl hover:bg-blue-600 hover:text-white transition-all shadow-xl active:scale-95"
          >
            <RefreshCw size={14} /> Sync Metrics
          </button>
        </footer>
      </div>
    </div>
  );
}