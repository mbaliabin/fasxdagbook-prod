import React, { useEffect, useState } from "react";
import dayjs from "dayjs";
import isoWeek from "dayjs/plugin/isoWeek";
import "dayjs/locale/ru";
import { Plus, Loader2, BarChart3 } from "lucide-react";
import CalendarModalAdd from "./CalendarModalAdd";
import CalendarWorkoutDetails from "./CalendarWorkoutDetails";

dayjs.extend(isoWeek);
dayjs.locale("ru");

const weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"];

const getIntensityStyles = (e: any) => {
  const duration = e.duration || 1;
  const stressScore = ((e.zone1Min || 0) * 1 + (e.zone2Min || 0) * 1.5 + (e.zone3Min || 0) * 3 + (e.zone4Min || 0) * 6 + (e.zone5Min || 0) * 12) / duration;
  const baseText = "text-black font-semibold antialiased uppercase tracking-tight";

  if (stressScore >= 5.0) return `border-red-500 bg-red-500 ${baseText}`;
  if (stressScore >= 3.0) return `border-orange-400 bg-orange-400 ${baseText}`;
  if (stressScore >= 2.0) return `border-yellow-400 bg-yellow-400 ${baseText}`;
  if (stressScore >= 1.3) return `border-blue-400 bg-blue-400 ${baseText}`;
  return `border-gray-300 bg-gray-300 ${baseText}`;
};

export default function TrainingCalendar({ currentMonth, isMaximized }: any) {
  const [workouts, setWorkouts] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [modalAddOpen, setModalAddOpen] = useState(false);
  const [selectedDate, setSelectedDate] = useState<string | null>(null);
  const [viewWorkoutId, setViewWorkoutId] = useState<string | null>(null);
  const [viewModalOpen, setViewModalOpen] = useState(false);

  useEffect(() => {
    const fetchWorkouts = async () => {
      try {
        const token = localStorage.getItem("token");
        const res = await fetch(`${import.meta.env.VITE_API_URL}/api/workouts/user`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        const data = await res.json();
        setWorkouts(data || []);
      } catch (err) { console.error(err); } finally { setLoading(false); }
    };
    fetchWorkouts();
  }, [currentMonth]);

  const startOfMonth = currentMonth.startOf("month");
  const monthValue = currentMonth.month();
  const startCalendar = startOfMonth.startOf("isoWeek");
  const days = Array.from({ length: 42 }, (_, i) => startCalendar.add(i, "day"));

  const trainings: Record<string, any[]> = {};
  workouts.forEach(w => {
    if (!w) return;
    const key = dayjs(w.date).format("YYYY-MM-DD");
    if (!trainings[key]) trainings[key] = [];
    trainings[key].push(w);
  });

  const stats: Record<number, any> = {};
  workouts.forEach(w => {
    if (!w) return;
    const wNum = dayjs(w.date).isoWeek();
    if (!stats[wNum]) stats[wNum] = { distance: 0, totalDuration: 0 };
    stats[wNum].distance += w.distance ?? 0;
    stats[wNum].totalDuration += w.duration || 0;
  });

  const weeksInCalendar = Array.from(new Set(days.map(d => d.isoWeek()))).slice(0, 6);

  if (loading) return (
    <div className="h-96 flex flex-col items-center justify-center gap-4 bg-[#1c1c1f] rounded-[1.5rem] border border-white/[0.05]">
      <Loader2 className="animate-spin text-blue-500" size={40} />
      <span className="text-[10px] font-black uppercase tracking-widest text-gray-500">Загрузка...</span>
    </div>
  );

  return (
    <div className={`w-full bg-[#1c1c1f] flex flex-col border border-white/[0.05] shadow-2xl ${isMaximized ? "h-full rounded-2xl" : "rounded-[1.5rem] overflow-hidden"}`}>

      {/* "ЯДЕРНЫЙ" CSS ПРЯМО В КОМПОНЕНТЕ */}
      <style>{`
        .workout-scroll-area {
          scrollbar-width: none !important;
          -ms-overflow-style: none !important;
        }
        .workout-scroll-area::-webkit-scrollbar {
          display: none !important;
          width: 0 !important;
        }
        .day-cell-container:hover .workout-scroll-area {
          scrollbar-width: thin !important;
        }
        .day-cell-container:hover .workout-scroll-area::-webkit-scrollbar {
          display: block !important;
          width: 4px !important;
        }
        .day-cell-container:hover .workout-scroll-area::-webkit-scrollbar-thumb {
          background-color: rgba(255, 255, 255, 0.2) !important;
          border-radius: 10px !important;
        }
      `}</style>

      <div className="grid grid-cols-[100px_repeat(7,minmax(0,1fr))] bg-[#1c1c1f] flex-grow overflow-hidden" style={isMaximized ? { gridTemplateRows: 'auto repeat(6, 1fr)' } : {}}>
        <div className="py-3 text-center text-[9px] text-gray-600 font-black uppercase border-b border-r border-white/[0.05] bg-black/10">Аналитика</div>
        {weekdays.map(d => (
          <div key={d} className="py-3 text-center text-[9px] text-gray-400 font-black uppercase border-b border-r border-white/[0.05] bg-black/10">{d}</div>
        ))}

        {weeksInCalendar.map(weekNum => {
          const s = stats[weekNum] || { distance: 0, totalDuration: 0 };
          const weekDays = days.filter(d => d.isoWeek() === weekNum);

          return (
            <React.Fragment key={weekNum}>
              <div className={`border-r border-b border-white/[0.08] p-3 flex flex-col justify-center gap-2 ${isMaximized ? "bg-[#161619] h-full" : "bg-[#1e1e22] min-h-[140px]"}`}>
                <div className="flex items-center justify-between border-b border-white/[0.05] pb-1 mb-1 text-[9px] text-blue-500 font-black uppercase">
                  <span>Нед {weekNum}</span>
                  <BarChart3 size={10} />
                </div>
                <div className="space-y-2">
                  <div className="flex flex-col font-black text-white leading-none">
                    <span className={isMaximized ? "text-lg" : "text-base"}>
                      {s.distance > 0 ? s.distance.toFixed(1) : "0"}<span className="text-[8px] ml-0.5 text-gray-500 font-normal uppercase">км</span>
                    </span>
                  </div>
                  <div className="flex flex-col font-black text-blue-400 leading-none">
                    <span className={isMaximized ? "text-lg" : "text-base"}>
                      {Math.floor(s.totalDuration / 60)}<span className="text-[8px] font-normal text-gray-500 mx-0.5">ч</span>{s.totalDuration % 60}<span className="text-[8px] font-normal text-gray-500">м</span>
                    </span>
                  </div>
                </div>
              </div>

              {weekDays.map(d => {
                const dateStr = d.format("YYYY-MM-DD");
                const items = trainings[dateStr] || [];
                const isCurrentMonth = d.month() === monthValue;
                const isToday = d.isSame(dayjs(), 'day');

                return (
                  <div key={dateStr} className={`
                    day-cell-container group relative transition-all duration-300 border-r border-b border-white/[0.05] p-1.5 flex flex-col min-w-0
                    ${isMaximized ? "h-full overflow-hidden" : "min-h-[140px]"}
                    ${!isCurrentMonth ? "bg-black/20 opacity-30" : "bg-[#1c1c1f] hover:bg-white/[0.01]"}
                  `}>
                    <div className="flex justify-between items-center mb-1 text-[10px] font-black">
                      <span className={isToday ? "text-blue-500 bg-blue-500/10 px-1.5 py-0.5 rounded-md" : isCurrentMonth ? "text-gray-400" : "text-gray-700"}>
                        {d.date()}
                      </span>
                    </div>

                    <div className="flex-grow overflow-y-auto space-y-1.5 pr-0.5 h-0 min-h-0 min-w-0 workout-scroll-area">
                      {items.map(e => {
                        const styleClasses = getIntensityStyles(e);
                        return (
                          <button key={e.id} onClick={() => { setViewWorkoutId(e.id); setViewModalOpen(true); }}
                            className={`w-full flex flex-col p-2 rounded-lg border transition-all text-left relative overflow-hidden min-w-0 hover:brightness-110 active:scale-[0.98] ${styleClasses}`}>
                            <div className="flex items-center gap-1 w-full overflow-hidden text-[10px] leading-tight truncate">
                              {e.name || "Тренировка"}
                            </div>
                            <div className="text-[8px] text-black/60 font-bold flex items-center gap-1 uppercase tracking-tighter mt-1 truncate whitespace-nowrap">
                              {Math.floor(e.duration / 60)}ч {e.duration % 60}м {e.distance ? `• ${e.distance}км` : ""}
                            </div>
                          </button>
                        );
                      })}
                    </div>

                    <button onClick={() => { setSelectedDate(dateStr); setModalAddOpen(true); }}
                      className="absolute bottom-1.5 right-1.5 w-6 h-6 flex items-center justify-center rounded-md bg-[#2a2a2e] text-gray-400 opacity-0 group-hover:opacity-100 transition-all hover:bg-blue-600 hover:text-white border border-white/10 z-10 shadow-lg cursor-pointer">
                      <Plus size={12} strokeWidth={3} />
                    </button>
                  </div>
                );
              })}
            </React.Fragment>
          );
        })}
      </div>

      <CalendarModalAdd isOpen={modalAddOpen} onClose={() => setModalAddOpen(false)} onAddWorkout={(nw: any) => setWorkouts(p => [...p, nw])} initialDate={selectedDate} />
      {viewWorkoutId && <CalendarWorkoutDetails workoutId={viewWorkoutId} isOpen={viewModalOpen} onClose={() => setViewModalOpen(false)} onSave={(u: any) => u === null ? setWorkouts(p => p.filter(w => w?.id !== viewWorkoutId)) : setWorkouts(p => p.map(w => w?.id === u.id ? u : w))} />}
    </div>
  );
}