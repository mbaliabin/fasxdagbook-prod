import React from "react";
import { Hammer, ArrowLeft } from "lucide-react";
import { useNavigate } from "react-router-dom";

export default function InDevelopment({ title }: { title: string }) {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-[#0f0f0f] flex flex-col items-center justify-center p-6 text-center">
      <div className="relative mb-8">
        {/* Анимированная иконка молотка или каски */}
        <div className="w-24 h-24 bg-blue-600/10 rounded-3xl flex items-center justify-center border border-blue-500/20 animate-pulse">
          <Hammer size={48} className="text-blue-500" />
        </div>
        <div className="absolute -top-2 -right-2 bg-yellow-500 text-black text-[10px] font-black px-2 py-1 rounded-md uppercase tracking-tighter">
          Work in progress
        </div>
      </div>

      <h1 className="text-3xl font-black text-white uppercase tracking-tighter mb-4 italic">
        {title}
      </h1>
      
      <p className="text-gray-500 max-w-sm text-sm leading-relaxed mb-8 font-medium">
        Мы активно работаем над этим разделом. Скоро здесь появится крутая статистика и инструменты для анализа.
      </p>

      <button
        onClick={() => navigate(-1)} // Возврат на предыдущую страницу
        className="flex items-center gap-2 px-6 py-3 bg-[#1a1a1d] border border-white/5 hover:border-white/10 text-gray-300 hover:text-white rounded-xl transition-all text-sm font-bold uppercase tracking-widest"
      >
        <ArrowLeft size={16} /> Назад
      </button>
    </div>
  );
}