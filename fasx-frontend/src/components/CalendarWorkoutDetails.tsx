import React, { useEffect, useState, useMemo } from "react";
import { Dialog } from "@headlessui/react";
import { X, Check, Calendar, MessageSquare, Edit2, Trash2 } from "lucide-react";
import toast from "react-hot-toast";

interface Workout {
  id: string;
  name: string;
  date: string;
  duration: number;
  type: string;
  comment?: string;
  effort?: number;
  feeling?: number;
  distance?: number | null;
  zone1Min?: number;
  zone2Min?: number;
  zone3Min?: number;
  zone4Min?: number;
  zone5Min?: number;
}

interface Props {
  workoutId: string | null;
  isOpen: boolean;
  onClose: () => void;
  onSave?: (updatedWorkout: Workout | null) => void;
}

export default function CalendarWorkoutDetails({ workoutId, isOpen, onClose, onSave }: Props) {
  const [loading, setLoading] = useState(false);
  const [localMode, setLocalMode] = useState<"view" | "edit">("view");

  const [name, setName] = useState("");
  const [date, setDate] = useState("");
  const [comment, setComment] = useState("");
  const [effort, setEffort] = useState<number | null>(null);
  const [feeling, setFeeling] = useState<number | null>(null);
  const [type, setType] = useState("");
  const [zones, setZones] = useState(["0", "0", "0", "0", "0"]);
  const [distance, setDistance] = useState<number | "">("");

  // Цвета: Серый, Синий, Желтый, Оранжевый, Красный
  const zoneColors = ["bg-gray-400", "bg-blue-400", "bg-yellow-400", "bg-orange-400", "bg-red-500"];
  const zoneLabels = ["I1", "I2", "I3", "I4", "I5"];

  useEffect(() => {
    if (isOpen) setLocalMode("view");
  }, [isOpen]);

  useEffect(() => {
    if (!workoutId || !isOpen) return;

    const fetchWorkout = async () => {
      setLoading(true);
      try {
        const token = localStorage.getItem("token");
        const res = await fetch(`${import.meta.env.VITE_API_URL}/api/workouts/${workoutId}`, {
          headers: { Authorization: "Bearer " + token },
        });
        const data = await res.json();
        setName(data.name || "");
        setDate(data.date.slice(0, 10));
        setComment(data.comment || "");
        setEffort(data.effort ?? null);
        setFeeling(data.feeling ?? null);
        setType(data.type);
        setZones([
          (data.zone1Min ?? 0).toString(),
          (data.zone2Min ?? 0).toString(),
          (data.zone3Min ?? 0).toString(),
          (data.zone4Min ?? 0).toString(),
          (data.zone5Min ?? 0).toString(),
        ]);
        setDistance(data.distance ?? "");
      } catch (e) {
        toast.error("Ошибка загрузки");
      } finally {
        setLoading(false);
      }
    };
    fetchWorkout();
  }, [workoutId, isOpen]);

  // СТРОГИЙ РАСЧЕТ ОБЩЕГО ВРЕМЕНИ
  const totalMin = useMemo(() => {
    return zones.reduce((sum, val) => sum + (Math.floor(Number(val)) || 0), 0);
  }, [zones]);

  const pace = useMemo(() => {
    if (distance && totalMin && Number(distance) > 0) {
      const totalSec = totalMin * 60;
      const secPerKm = totalSec / Number(distance);
      const min = Math.floor(secPerKm / 60);
      const sec = Math.floor(secPerKm % 60);
      return `${min}:${sec < 10 ? '0' : ''}${sec} /км`;
    }
    return null;
  }, [distance, totalMin]);

  const formattedFullDate = useMemo(() => {
    if (!date) return "";
    const d = new Date(date);
    const options: Intl.DateTimeFormatOptions = { weekday: 'long', day: '2-digit', month: '2-digit' };
    const localeDate = new Intl.DateTimeFormat('ru-RU', options).format(d);
    return localeDate.charAt(0).toUpperCase() + localeDate.slice(1);
  }, [date]);

  const handleSave = async () => {
    const loadingToast = toast.loading("Сохранение...");
    const intensityZones = {
      zone1Min: Math.floor(Number(zones[0])) || 0,
      zone2Min: Math.floor(Number(zones[1])) || 0,
      zone3Min: Math.floor(Number(zones[2])) || 0,
      zone4Min: Math.floor(Number(zones[3])) || 0,
      zone5Min: Math.floor(Number(zones[4])) || 0,
    };

    try {
      const token = localStorage.getItem("token");
      const res = await fetch(`${import.meta.env.VITE_API_URL}/api/workouts/${workoutId}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json", Authorization: `Bearer ${token}` },
        body: JSON.stringify({ name, date, comment, effort, feeling, type, duration: totalMin, distance: Number(distance) || null, intensityZones }),
      });

      if (res.ok) {
        const updated = await res.json();
        toast.success("Обновлено", { id: loadingToast });
        onSave?.(updated);
        setLocalMode("view");
      }
    } catch {
      toast.error("Ошибка сети", { id: loadingToast });
    }
  };

  const handleDelete = async () => {
    if (!window.confirm("Удалить тренировку?")) return;
    try {
      const res = await fetch(`${import.meta.env.VITE_API_URL}/api/workouts/${workoutId}`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
      });
      if (res.ok) {
        toast.success("Удалено");
        onSave?.(null);
        onClose();
      }
    } catch { toast.error("Ошибка удаления"); }
  };

  return (
    <Dialog open={isOpen} onClose={onClose} className="fixed inset-0 z-[1001] flex items-center justify-center p-4">
      <div className="fixed inset-0 bg-black/85 backdrop-blur-md" aria-hidden="true" />

      <Dialog.Panel className="relative bg-[#1a1a1d] max-h-[92vh] overflow-y-auto rounded-3xl w-[95%] max-w-2xl z-[1002] text-white shadow-2xl border border-gray-800 scrollbar-hide">

        <div className="sticky top-0 bg-[#1a1a1d]/90 backdrop-blur-md z-10 px-8 py-6 border-b border-gray-800 flex justify-between items-center">
          <div>
            {localMode === "view" ? (
              <div className="space-y-0.5">
                <div className="text-blue-500 text-2xl font-black tracking-tight">{formattedFullDate}</div>
                <Dialog.Title className="text-gray-400 font-medium italic">{name || "Без названия"}</Dialog.Title>
              </div>
            ) : (
              <div className="space-y-0.5">
                <div className="flex items-center gap-2 text-blue-500 mb-0.5">
                  <Calendar size={12} />
                  <span className="text-[10px] font-bold uppercase tracking-widest">{date}</span>
                </div>
                <Dialog.Title className="text-xl font-black tracking-tight">Редактирование</Dialog.Title>
              </div>
            )}
          </div>
          <div className="flex items-center gap-2">
            {localMode === "view" && !loading && (
              <button onClick={() => setLocalMode("edit")} className="p-2 hover:bg-gray-800 rounded-full transition-colors text-blue-500">
                <Edit2 size={22} />
              </button>
            )}
            <button onClick={onClose} className="p-2 hover:bg-gray-800 rounded-full transition-colors text-gray-400"><X size={24} /></button>
          </div>
        </div>

        <div className="p-8">
          {loading ? (
            <div className="h-64 flex items-center justify-center text-gray-500 animate-pulse font-medium">Загрузка данных...</div>
          ) : localMode === "view" ? (
            <div className="space-y-10">
              <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                <div className="bg-[#2a2a2d] p-5 rounded-2xl border border-gray-800">
                  <span className="text-gray-500 text-[10px] font-bold uppercase block mb-2">Дистанция</span>
                  <div className="flex items-baseline gap-1">
                    <span className="text-3xl font-black text-white">{distance || "0"}</span>
                    <span className="text-gray-400 font-bold text-sm">км</span>
                  </div>
                </div>
                <div className="bg-[#2a2a2d] p-5 rounded-2xl border border-gray-800">
                  <span className="text-gray-500 text-[10px] font-bold uppercase block mb-2">Время</span>
                  <div className="flex items-baseline gap-1">
                    <span className="text-3xl font-black text-white">{Math.floor(totalMin/60)}ч {totalMin%60}м</span>
                  </div>
                </div>
                {pace && (
                  <div className="bg-blue-600/10 p-5 rounded-2xl border border-blue-500/20">
                    <span className="text-blue-500 text-[10px] font-bold uppercase block mb-2">Средний темп</span>
                    <span className="text-2xl font-black text-blue-400">{pace}</span>
                  </div>
                )}
              </div>

              {/* ГАРАНТИРОВАННОЕ ИСПРАВЛЕНИЕ ПОЛОСКИ */}
              <div className="space-y-4">
                <h4 className="text-[10px] font-bold text-gray-500 uppercase tracking-widest px-1">Интенсивность</h4>
                <div className="flex h-10 w-full rounded-xl overflow-hidden bg-gray-900 shadow-inner border border-white/5">
                  {zones.map((val, i) => {
                    const mins = Math.floor(Number(val)) || 0;
                    if (mins <= 0) return null; // Если 0, элемент ВООБЩЕ не рендерится

                    const width = totalMin > 0 ? (mins / totalMin) * 100 : 0;
                    if (width <= 0) return null; // Дополнительная проверка на ширину

                    return (
                      <div
                        key={`bar-${i}`}
                        style={{ width: `${width}%` }}
                        className={`${zoneColors[i]} h-full transition-all flex items-center justify-center text-[9px] font-black text-black/40 border-r border-black/5 last:border-r-0`}
                      >
                        {width > 12 ? zoneLabels[i] : ""}
                      </div>
                    );
                  })}
                </div>

                <div className="grid grid-cols-5 gap-2 px-1">
                  {zones.map((val, i) => {
                    const isZero = (Math.floor(Number(val)) || 0) <= 0;
                    return (
                      <div key={`info-${i}`} className="text-center">
                        <div className={`w-1.5 h-1.5 rounded-full ${zoneColors[i]} mx-auto mb-1 ${isZero ? 'opacity-10' : 'opacity-100'}`}></div>
                        <div className={`text-[10px] font-bold ${isZero ? 'text-gray-700' : 'text-gray-300'}`}>
                          {Math.floor(Number(val)) || 0}м
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>

              <div className="grid grid-cols-2 gap-8 py-6 border-y border-gray-800">
                <div className="flex items-center gap-4">
                   <div className="w-12 h-12 rounded-full border-2 border-green-500 flex items-center justify-center text-lg font-black text-green-500">{feeling || '-'}</div>
                   <span className="text-[10px] font-bold text-gray-500 uppercase">Самочувствие</span>
                </div>
                <div className="flex items-center gap-4">
                   <div className="w-12 h-12 rounded-full border-2 border-blue-500 flex items-center justify-center text-lg font-black text-blue-500">{effort || '-'}</div>
                   <span className="text-[10px] font-bold text-gray-500 uppercase">Нагрузка</span>
                </div>
              </div>

              {comment && (
                <div className="bg-[#2a2a2d]/50 p-6 rounded-2xl border border-gray-800 border-dashed">
                  <div className="flex items-center gap-2 text-gray-500 mb-3"><MessageSquare size={14}/> <span className="text-[10px] font-bold uppercase">Комментарий</span></div>
                  <p className="text-gray-300 italic leading-relaxed text-sm">"{comment}"</p>
                </div>
              )}
            </div>
          ) : (
            <div className="space-y-6">
              <div className="grid grid-cols-2 gap-6">
                <div className="space-y-1">
                  <label className="text-[10px] font-bold text-gray-500 uppercase">Название</label>
                  <input type="text" value={name} onChange={(e) => setName(e.target.value)} className="w-full h-11 px-4 rounded-xl bg-[#2a2a2d] border border-gray-700 text-sm outline-none focus:border-blue-500" />
                </div>
                <div className="space-y-1">
                  <label className="text-[10px] font-bold text-gray-500 uppercase">Дата</label>
                  <input type="date" value={date} onChange={(e) => setDate(e.target.value)} className="w-full h-11 px-4 rounded-xl bg-[#2a2a2d] border border-gray-700 text-sm outline-none focus:border-blue-500 color-scheme-dark" />
                </div>
              </div>

              <div className="space-y-1">
                <label className="text-[10px] font-bold text-blue-500 uppercase">Дистанция (км)</label>
                <input type="number" step={0.1} value={distance} onChange={(e) => setDistance(e.target.value)} className="w-full h-11 px-4 rounded-xl bg-[#2a2a2d] border border-blue-900/30 text-lg font-black outline-none focus:border-blue-500 no-spinner" />
              </div>

              <div className="space-y-6">
                <div className="space-y-2">
                  <label className="text-[10px] font-bold text-gray-500 uppercase flex justify-between">Самочувствие <span className="text-green-500">{feeling}</span></label>
                  <div className="flex gap-1">
                    {[...Array(10)].map((_, i) => (
                      <button type="button" key={i} onClick={() => setFeeling(i + 1)} className={`flex-1 h-8 rounded-lg text-xs font-bold transition-all ${feeling === i + 1 ? "bg-green-600 text-white" : "bg-[#2a2a2d] text-gray-500 hover:bg-[#323235]"}`}>{i + 1}</button>
                    ))}
                  </div>
                </div>
                <div className="space-y-2">
                  <label className="text-[10px] font-bold text-gray-500 uppercase flex justify-between">Нагрузка <span className="text-blue-500">{effort}</span></label>
                  <div className="flex gap-1">
                    {[...Array(10)].map((_, i) => (
                      <button type="button" key={i} onClick={() => setEffort(i + 1)} className={`flex-1 h-8 rounded-lg text-xs font-bold transition-all ${effort === i + 1 ? "bg-blue-600 text-white" : "bg-[#2a2a2d] text-gray-500 hover:bg-[#323235]"}`}>{i + 1}</button>
                    ))}
                  </div>
                </div>
              </div>

              <div className="space-y-3">
                <label className="text-[10px] font-bold text-gray-500 uppercase">Зоны (минуты)</label>
                <div className="grid grid-cols-5 gap-1 rounded-xl overflow-hidden border border-gray-800">
                  {zones.map((val, idx) => (
                    <div key={idx} className="flex flex-col">
                      <div className={`${zoneColors[idx]} py-1 text-center text-[9px] font-black text-black/50 uppercase`}>{zoneLabels[idx]}</div>
                      <input type="number" value={val} onChange={(e) => { const u = [...zones]; u[idx] = e.target.value; setZones(u); }} className="bg-[#2a2a2d] text-white text-center py-2.5 text-sm outline-none border-t border-gray-800 no-spinner" />
                    </div>
                  ))}
                </div>
              </div>

              <textarea rows={3} value={comment} onChange={(e) => setComment(e.target.value)} className="w-full p-4 rounded-xl bg-[#2a2a2d] border border-gray-700 text-sm outline-none focus:border-blue-500 transition-all resize-none" placeholder="Заметки..." />
            </div>
          )}

          <div className="flex flex-col sm:flex-row justify-between items-center gap-4 mt-10 pt-6 border-t border-gray-800">
             <div className="w-full sm:w-auto">
               {localMode === "edit" && (
                 <button onClick={handleDelete} className="w-full flex items-center justify-center gap-2 px-6 py-3 bg-red-500/10 text-red-500 hover:bg-red-500 hover:text-white rounded-xl transition-all text-[10px] font-black uppercase border border-red-500/20">
                   <Trash2 size={16} /> Удалить
                 </button>
               )}
             </div>
             <div className="flex gap-3 w-full sm:w-auto">
               <button onClick={onClose} className="flex-1 sm:flex-none px-6 py-3 bg-[#2a2a2d] text-gray-400 rounded-xl hover:bg-[#323235] font-bold text-xs uppercase tracking-widest">Закрыть</button>
               {localMode === "edit" && (
                 <button onClick={handleSave} className="flex-1 sm:flex-none bg-blue-600 hover:bg-blue-500 px-10 py-3 rounded-xl font-bold text-xs uppercase tracking-widest flex items-center justify-center gap-2 transition-all shadow-lg shadow-blue-600/20">
                   <Check size={16}/> Сохранить
                 </button>
               )}
             </div>
          </div>
        </div>
      </Dialog.Panel>
      <style>{`.no-spinner::-webkit-outer-spin-button, .no-spinner::-webkit-inner-spin-button { -webkit-appearance: none; margin: 0; } .scrollbar-hide::-webkit-scrollbar { display: none; }`}</style>
    </Dialog>
  );
}