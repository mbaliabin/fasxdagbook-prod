import React, { useEffect, useState, useCallback } from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { 
  BarChart3, CalendarDays, ClipboardList, Activity, 
  Plus, ChevronDown, FolderPlus, Check, Trash2, Home
} from 'lucide-react';
import { PlanningTable, PlanningRow } from '../components/Planning/PlanningTable';
import { getUserProfile } from "../api/getUserProfile";
import dayjs from 'dayjs';
import 'dayjs/locale/ru';

dayjs.locale('ru');

interface TrainingPlan {
  id: string;
  name: string;
  goal: string;
  startDate: string;
  endDate: string;
}

const PlanningPage = () => {
  const navigate = useNavigate();
  const location = useLocation();
  
  const [profile, setProfile] = useState<any>(null);
  const [plans, setPlans] = useState<TrainingPlan[]>([]); 
  const [currentPlan, setCurrentPlan] = useState<TrainingPlan | null>(null);
  const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);
  const [isPlanSelectorOpen, setIsPlanSelectorOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  const [newPlan, setNewPlan] = useState({ 
    name: '', 
    goal: '', 
    start: dayjs().format('YYYY-MM'), 
    end: dayjs().add(11, 'month').format('YYYY-MM') 
  });

  const fetchData = useCallback(async () => {
    const token = localStorage.getItem("token");
    const API_URL = import.meta.env.VITE_API_URL;

    try {
      // Параллельные запросы для скорости
      const [profileData, plansRes] = await Promise.all([
        getUserProfile(),
        fetch(`${API_URL}/api/planning`, {
          headers: { Authorization: `Bearer ${token}` }
        })
      ]);

      setProfile(profileData);

      if (plansRes.ok) {
        const fetchedPlans = await plansRes.json();
        const enrichedPlans = fetchedPlans.map((p: any) => ({
          ...p,
          startDate: p.startDate || dayjs().format('YYYY-MM-DD'),
          endDate: p.endDate || dayjs().add(11, 'month').format('YYYY-MM-DD'),
          goal: p.goal || ""
        }));
        
        setPlans(enrichedPlans);
        
        const lastActiveId = localStorage.getItem('active_plan_id');
        if (lastActiveId) {
          const active = enrichedPlans.find((p: any) => p.id === lastActiveId);
          if (active) setCurrentPlan(active);
          else if (enrichedPlans.length > 0) setCurrentPlan(enrichedPlans[0]);
        } else if (enrichedPlans.length > 0) {
          setCurrentPlan(enrichedPlans[0]);
          localStorage.setItem('active_plan_id', enrichedPlans[0].id);
        }
      }
    } catch (error) {
      console.error("Ошибка загрузки данных:", error);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const handleCreatePlan = async () => {
    if (!newPlan.name) return alert("Введите название плана");
    const token = localStorage.getItem("token");
    try {
      const payload = {
        name: newPlan.name,
        goal: newPlan.goal,
        startDate: dayjs(newPlan.start).startOf('month').toISOString(),
        endDate: dayjs(newPlan.end).endOf('month').toISOString()
      };
      const response = await fetch(`${import.meta.env.VITE_API_URL}/api/planning/create`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
        body: JSON.stringify(payload)
      });
      if (!response.ok) throw new Error("Ошибка создания");
      setIsCreateModalOpen(false);
      fetchData();
    } catch (error: any) { alert(error.message); }
  };

  const selectPlan = (plan: TrainingPlan) => {
    setCurrentPlan(plan);
    localStorage.setItem('active_plan_id', plan.id);
    setIsPlanSelectorOpen(false);
  };

  const deletePlan = async (e: React.MouseEvent, id: string) => {
    e.stopPropagation();
    if (!window.confirm("Удалить этот цикл планирования?")) return;
    const token = localStorage.getItem("token");
    try {
      const res = await fetch(`${import.meta.env.VITE_API_URL}/api/planning/${id}`, {
        method: 'DELETE',
        headers: { Authorization: `Bearer ${token}` }
      });
      if (res.ok) {
        const updated = plans.filter(p => p.id !== id);
        setPlans(updated);
        if (currentPlan?.id === id) {
          const next = updated.length > 0 ? updated[0] : null;
          setCurrentPlan(next);
          if (next) localStorage.setItem('active_plan_id', next.id);
          else localStorage.removeItem('active_plan_id');
        }
      }
    } catch (e) { console.error(e); }
  };

  const activeMonths = (() => {
    if (!currentPlan) return [];
    const start = dayjs(currentPlan.startDate).startOf('month');
    const end = dayjs(currentPlan.endDate).endOf('month');
    const diff = end.diff(start, 'month');
    return Array.from({ length: Math.min(diff, 36) + 1 }).map((_, i) => start.add(i, 'month').format('MMM YY'));
  })();

  const menuItems = [
    { label: "Главная", icon: Home, path: "/daily" },
    { label: "Тренировки", icon: BarChart3, path: "/profile" },
    { label: "Календарь", icon: CalendarDays, path: "/calendar" },
    { label: "Планирование", icon: ClipboardList, path: "/planning" },
    { label: "Статистика", icon: Activity, path: "/statistics" },
  ];

  if (isLoading) return (
    <div className="min-h-screen bg-[#0f0f0f] p-6 font-sans">
      <div className="max-w-[1600px] mx-auto space-y-6 px-4 animate-pulse">
        <div className="flex items-center space-x-5 mb-10 text-left">
          <div className="w-12 h-12 bg-white/5 rounded-full" />
          <div className="space-y-2">
            <div className="h-6 w-32 bg-white/5 rounded" />
            <div className="h-3 w-48 bg-white/5 rounded" />
          </div>
        </div>
        <div className="h-14 bg-[#131316] border border-white/[0.03] rounded-xl w-full" />
        <div className="h-64 bg-[#131316] border border-white/[0.03] rounded-xl w-full" />
      </div>
    </div>
  );

  return (
    <div className="min-h-screen bg-[#0f0f0f] text-gray-200 p-6 w-full font-sans selection:bg-blue-500/30">
      <div className="max-w-[1600px] mx-auto space-y-6 px-4">
        
        {/* HEADER */}
        <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-6 mb-4">
          <div className="flex items-center space-x-5 group cursor-pointer" onClick={() => navigate("/account")}>
             <div className="w-12 h-12 rounded-full overflow-hidden flex items-center justify-center bg-[#131316] border border-white/[0.05]">
              {profile?.avatarUrl ? <img src={profile.avatarUrl} className="w-full h-full object-cover" alt="avatar" /> : <div className="bg-blue-600 w-full h-full flex items-center justify-center font-bold text-white text-base">{profile?.name?.charAt(0) || "U"}</div>}
            </div>
            <div className="text-left">
              <h1 className="text-2xl font-black text-white tracking-tight leading-none mb-1 group-hover:text-blue-400 transition-colors">{profile?.name || "Пользователь"}</h1>
              <div className="flex items-center gap-2 text-gray-500">
                <Activity size={12} className="text-blue-500/50" />
                <p className="text-[10px] font-bold uppercase tracking-[0.2em]">Система планирования</p>
              </div>
            </div>
          </div>
        </div>

        {/* NAVIGATION */}
        <div className="flex justify-around bg-[#131316] border border-white/[0.03] py-2 px-4 rounded-xl shadow-2xl mb-8">
          {menuItems.map((item) => {
            const Icon = item.icon;
            const isActive = location.pathname === item.path;
            return (
              <button key={item.path} onClick={() => navigate(item.path)} className={`flex flex-col items-center gap-1 transition-all py-1 w-24 ${isActive ? "text-blue-500" : "text-gray-600 hover:text-gray-300"}`}>
                <Icon className={`w-5 h-5 ${isActive ? "stroke-[2.5px]" : "stroke-[2px]"}`}/>
                <span className={`text-[9px] font-black uppercase tracking-[0.2em]`}>{item.label}</span>
              </button>
            );
          })}
        </div>

        {!currentPlan ? (
          <div className="flex flex-col items-center justify-center py-32 bg-[#131316] rounded-2xl border border-dashed border-white/5 animate-in fade-in duration-500">
            <FolderPlus size={64} className="text-gray-800 mb-6" />
            <h2 className="text-xl font-bold text-white mb-2 text-center px-4 uppercase tracking-tighter">Нет активных планов</h2>
            <button onClick={() => setIsCreateModalOpen(true)} className="bg-blue-600 text-white px-10 py-4 rounded-xl font-black uppercase text-[10px] tracking-widest hover:bg-blue-500 transition-all mt-4 shadow-xl flex items-center gap-2 active:scale-95">
              <Plus size={16} strokeWidth={3}/> Создать первый план
            </button>
          </div>
        ) : (
          <div className="space-y-6 pb-20 animate-in fade-in slide-in-from-bottom-2 duration-700">
            {/* PLAN CARD */}
            <div className="bg-[#131316] border border-white/[0.03] rounded-xl shadow-2xl relative z-30">
              <div className="h-1 w-full bg-gradient-to-r from-blue-600 via-blue-400 to-transparent rounded-t-xl" />
              <div className="p-8 flex flex-col lg:flex-row gap-8 items-stretch">
                <div className="flex-1 flex flex-col justify-between border-r border-white/5 pr-8 text-left">
                  <div>
                    <div className="flex items-center gap-3 mb-2">
                      <span className="w-2 h-2 bg-blue-500 rounded-full animate-pulse" />
                      <span className="text-[10px] font-bold text-blue-500 uppercase tracking-[0.3em]">Текущий проект</span>
                    </div>
                    <h2 className="text-4xl font-black text-white uppercase tracking-tighter leading-none mb-4">{currentPlan.name}</h2>
                  </div>
                  <div className="flex items-center gap-6 mt-4">
                    <div className="flex flex-col">
                      <span className="text-[8px] text-gray-500 uppercase font-black tracking-widest mb-1">Период планирования</span>
                      <div className="flex items-center gap-2 text-gray-200 font-mono text-sm uppercase">
                        <CalendarDays size={14} className="text-gray-600" />
                        {dayjs(currentPlan.startDate).format('MMMM YYYY')} — {dayjs(currentPlan.endDate).format('MMMM YYYY')}
                      </div>
                    </div>
                  </div>
                </div>

                <div className="flex-[1.5] flex flex-col justify-center px-2 text-left">
                  <span className="text-[8px] text-gray-500 uppercase font-black tracking-widest mb-3">Стратегическая цель</span>
                  <div className="relative">
                    <div className="absolute left-0 top-0 bottom-0 w-[2px] bg-blue-600/30" />
                    <p className="pl-6 text-sm text-gray-400 leading-relaxed max-w-2xl font-medium italic">
                      {currentPlan.goal ? `«${currentPlan.goal}»` : "Цель не определена..."}
                    </p>
                  </div>
                </div>

                <div className="flex flex-col justify-between items-end gap-4 min-w-[200px]">
                  <div className="flex gap-2">
                    <div className="relative">
                      <button onClick={() => setIsPlanSelectorOpen(!isPlanSelectorOpen)} 
                        className={`bg-[#1a1a1d] border ${isPlanSelectorOpen ? 'border-blue-600' : 'border-white/10'} px-4 py-2.5 rounded-lg text-[9px] font-black uppercase tracking-widest text-gray-300 hover:bg-white/5 transition-all flex items-center gap-3 active:scale-95`}>
                        Планы: {plans.length} <ChevronDown size={12} className={`transition-transform duration-300 ${isPlanSelectorOpen ? 'rotate-180' : ''}`}/>
                      </button>
                      {isPlanSelectorOpen && (
                        <>
                          <div className="fixed inset-0 z-40" onClick={() => setIsPlanSelectorOpen(false)} />
                          <div className="absolute right-0 mt-2 w-72 bg-[#0f0f11] border border-white/[0.08] rounded-xl shadow-[0_20px_50px_rgba(0,0,0,0.7)] z-50 overflow-hidden animate-in fade-in zoom-in-95 duration-200 text-left">
                            <div className="p-2 max-h-[400px] overflow-y-auto">
                              <div className="px-3 py-2 text-[8px] font-black text-gray-500 uppercase tracking-widest border-b border-white/5 mb-1">Доступные циклы</div>
                              {plans.map((p) => (
                                <button key={p.id} onClick={() => selectPlan(p)} className={`w-full flex items-center justify-between p-3 rounded-lg text-left mb-1 transition-all ${currentPlan.id === p.id ? 'bg-blue-600 text-white' : 'hover:bg-white/5 text-gray-400'}`}>
                                  <div className="flex flex-col">
                                    <span className="text-[10px] font-bold uppercase tracking-tight">{p.name}</span>
                                    <span className="text-[8px] opacity-60 uppercase">{dayjs(p.startDate).format('MMM YY')} - {dayjs(p.endDate).format('MMM YY')}</span>
                                  </div>
                                  {currentPlan.id === p.id && <Check size={14} />}
                                </button>
                              ))}
                            </div>
                          </div>
                        </>
                      )}
                    </div>
                    <button onClick={() => setIsCreateModalOpen(true)} className="bg-blue-600 hover:bg-blue-500 text-white p-2.5 rounded-lg transition-all shadow-xl active:scale-95">
                      <Plus size={18} strokeWidth={3}/>
                    </button>
                  </div>
                  <button onClick={(e) => deletePlan(e, currentPlan.id)} className="group flex items-center gap-2 text-gray-700 hover:text-red-500 transition-colors p-2">
                    <Trash2 size={16} />
                  </button>
                </div>
              </div>
            </div>

            {/* ТАБЛИЦЫ */}
            <div className="space-y-10">
              <PlanningTable 
                title="Ключевые показатели" 
                customMonths={activeMonths} 
                planId={currentPlan.id}
                hideTotal={true}
              >
                <PlanningRow label="Тренировочные дни" /><PlanningRow label="Сессии" /><PlanningRow label="Часы" />
                <PlanningRow label="Дистанция (км)" /><PlanningRow label="Интенсивные занятия" /><PlanningRow label="Дни соревнований" />
                <PlanningRow label="Дистанция на лыжах" /><PlanningRow label="Дни катания на лыжах" /><PlanningRow label="Часы катания на лыжах" />
                <PlanningRow label="День на высоте" /><PlanningRow label="День отдыха" />
              </PlanningTable>

              <PlanningTable title="Зоны интенсивности (Сессии / Часы)" double customMonths={activeMonths} planId={currentPlan.id}>
                <PlanningRow label="Z1 - Восстановление" color="#4ade80" double />
                <PlanningRow label="Z2 - Базовая" color="#facc15" double />
                <PlanningRow label="Z3 - Темповая" color="#fb923c" double />
                <PlanningRow label="Z4 - Пороговая" color="#f87171" double />
                <PlanningRow label="Z5 - Максимальная" color="#a855f7" double />
              </PlanningTable>

              <PlanningTable title="Выносливость (Сессии / Часы)" double customMonths={activeMonths} planId={currentPlan.id}>
                <PlanningRow label="Бег" double /><PlanningRow label="Лыжи, св. стиль" double /><PlanningRow label="Лыжи, кл. стиль" double />
                <PlanningRow label="Лыжероллеры, св. стиль" double /><PlanningRow label="Лыжероллеры, кл. стиль" double />
                <PlanningRow label="Имитация" double /><PlanningRow label="Велосипед" double /><PlanningRow label="Плавание" double /><PlanningRow label="Другое" double />
              </PlanningTable>
              
              <PlanningTable title="Сила и стойкость (Сессии / Время)" double customMonths={activeMonths} planId={currentPlan.id}>
                <PlanningRow label="Сила - Общая" double /><PlanningRow label="Максимальная сила" double /><PlanningRow label="Кроссфит, серии" double /><PlanningRow label="Другое" double />
              </PlanningTable>

              <PlanningTable title="Подвижность и растяжка (Сессии / Время)" double customMonths={activeMonths} planId={currentPlan.id}>
                <PlanningRow label="Растяжка (Stretching)" double />
              </PlanningTable>
            </div>
          </div>
        )}
      </div>

      {/* MODAL */}
      {isCreateModalOpen && (
        <div className="fixed inset-0 z-[200] flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
          <div className="absolute inset-0" onClick={() => setIsCreateModalOpen(false)} />
          <div className="relative bg-[#131316] border border-white/10 w-full max-w-lg rounded-xl shadow-2xl overflow-hidden">
            <div className="p-8 border-b border-white/5 bg-black/20 text-left">
              <h3 className="text-xl font-black text-white uppercase tracking-tight">Новый цикл</h3>
            </div>
            <div className="p-8 space-y-6 text-left">
              <div>
                <label className="text-[9px] font-black text-gray-600 uppercase tracking-widest mb-2 block">Название</label>
                <input className="w-full bg-black/40 border border-white/5 rounded-lg p-4 text-white outline-none focus:border-blue-500/50 text-sm" value={newPlan.name} onChange={(e) => setNewPlan({...newPlan, name: e.target.value})} />
              </div>
              <div className="grid grid-cols-2 gap-6">
                <div><label className="text-[9px] font-black text-gray-600 uppercase tracking-widest block mb-2">Начало</label>
                <input type="month" className="w-full bg-black/40 border border-white/5 rounded-lg p-4 text-white font-mono text-sm [color-scheme:dark]" value={newPlan.start} onChange={(e) => setNewPlan({...newPlan, start: e.target.value})} /></div>
                <div><label className="text-[9px] font-black text-gray-600 uppercase tracking-widest block mb-2">Конец</label>
                <input type="month" className="w-full bg-black/40 border border-white/5 rounded-lg p-4 text-white font-mono text-sm [color-scheme:dark]" value={newPlan.end} onChange={(e) => setNewPlan({...newPlan, end: e.target.value})} /></div>
              </div>
              <div>
                <label className="text-[9px] font-black text-gray-600 uppercase tracking-widest mb-2 block">Цель</label>
                <textarea className="w-full bg-black/40 border border-white/5 rounded-lg p-4 text-white h-24 resize-none text-sm italic" value={newPlan.goal} onChange={(e) => setNewPlan({...newPlan, goal: e.target.value})} />
              </div>
            </div>
            <div className="p-6 bg-black/20 flex gap-4 border-t border-white/5">
              <button onClick={() => setIsCreateModalOpen(false)} className="flex-1 py-3 text-gray-500 font-bold uppercase text-[9px] tracking-widest hover:text-white transition-colors">Отмена</button>
              <button onClick={handleCreatePlan} className="flex-1 bg-blue-600 hover:bg-blue-500 py-3 rounded-lg text-white font-black uppercase text-[9px] tracking-widest shadow-lg active:scale-95 transition-all">Создать</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default PlanningPage;