import React from "react";
import { useNavigate } from "react-router-dom";
import { ClipboardList, ArrowLeft, Construction } from "lucide-react";

export default function PlanningStub() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-[#0f0f0f] flex flex-col items-center justify-center p-6 text-center font-sans">
      <div className="relative mb-6">
        {/* Иконка планирования с эффектом пульсации */}
        <div className="w-24 h-24 bg-blue-600/10 rounded-3xl flex items-center justify-center border border-blue-500/20 animate-pulse">
          <ClipboardList size={48} className="text-blue-500" />
        </div>
        <div className="absolute -top-2 -right-2 bg-yellow-500 text-black text-[10px] font-black px-2 py-1 rounded-md uppercase">
          В разработке
        </div>
      </div>

      <h1 className="text-3xl font-black text-white uppercase tracking-tighter mb-4 italic">
        Раздел планирования
      </h1>
      
      <p className="text-gray-500 max-w-sm text-sm leading-relaxed mb-10 font-medium">
        Мы уже готовим инструменты для составления тренировочных планов. Совсем скоро этот раздел станет доступен!
      </p>

      {/* Кнопка возврата */}
      <button
        onClick={() => navigate("/daily")}
        className="flex items-center gap-3 px-8 py-4 bg-blue-600 hover:bg-blue-500 text-white rounded-2xl transition-all shadow-lg shadow-blue-600/20 active:scale-95 text-xs font-black uppercase tracking-widest"
      >
        <ArrowLeft size={18} strokeWidth={3} />
        Вернуться на главную
      </button>

      <div className="mt-12 flex items-center gap-2 text-gray-700">
        <Construction size={14} />
        <span className="text-[10px] font-bold uppercase tracking-[0.3em]">FASX DEV TEAM</span>
      </div>
    </div>
  );
}