import React from 'react';

interface Props {
  title: string;
  children: React.ReactNode;
}

const PlanningTableWrapper: React.FC<Props> = ({ title, children }) => {
  const months = ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'];

  return (
    <div className="mb-10 bg-[#111113] border border-gray-800 rounded-xl overflow-hidden">
      <div className="p-4 border-b border-gray-800 bg-[#18181b]">
        <h3 className="text-blue-500 font-bold uppercase tracking-wider text-sm">{title}</h3>
      </div>
      <div className="overflow-x-auto">
        <div className="min-w-[1200px]">
          {/* Header */}
          <div className="grid grid-cols-[200px_repeat(12,1fr)_100px] bg-[#18181b] text-[10px] text-gray-500 uppercase font-medium border-b border-gray-800">
            <div className="p-3">Категория</div>
            {months.map(m => <div key={m} className="p-3 text-center border-l border-gray-800">{m}</div>)}
            <div className="p-3 text-center border-l border-gray-800 bg-blue-900/10 text-blue-400">Итого</div>
          </div>
          {children}
        </div>
      </div>
    </div>
  );
};