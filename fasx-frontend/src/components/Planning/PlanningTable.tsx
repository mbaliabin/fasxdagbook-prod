import React, { useState, useMemo, useEffect, useCallback, useRef } from 'react';

// --- КОМПОНЕНТ МОДАЛЬНОГО ОКНА ---
const CommentModal: React.FC<{ 
  isOpen: boolean; 
  month: string; 
  onClose: () => void; 
  onSave: (text: string) => void;
  currentText: string;
}> = ({ isOpen, month, onClose, onSave, currentText }) => {
  const [text, setText] = useState(currentText);
  const [isEditing, setIsEditing] = useState(false);

  useEffect(() => { 
    if (isOpen) {
      setText(currentText);
      setIsEditing(!currentText);
    }
  }, [currentText, isOpen]);

  if (!isOpen) return null;

  const formatFullDate = (m: string) => {
    const year = m.includes('25') ? '2025' : '2026';
    const monthName = m.split(' ')[0];
    const fullMonths: Record<string, string> = {
      'Янв': 'Январь', 'Фев': 'Февраль', 'Мар': 'Март', 'Апр': 'Апрель',
      'Май': 'Май', 'Июн': 'Июнь', 'Июл': 'Июль', 'Авг': 'Август',
      'Сен': 'Сентябрь', 'Окт': 'Октябрь', 'Ноя': 'Ноябрь', 'Дек': 'Декабрь'
    };
    return `${fullMonths[monthName] || monthName} ${year} года`;
  };

  return (
    <div className="fixed inset-0 z-[210] flex items-center justify-center bg-black/40 backdrop-blur-sm p-4 text-left animate-in fade-in duration-300">
      <div className="absolute inset-0" onClick={onClose} />
      <div className="relative bg-[#111113]/95 border border-gray-800 w-full max-w-md rounded-2xl shadow-[0_20px_50px_rgba(0,0,0,0.5)] overflow-hidden">
        <div className="p-6 border-b border-gray-800 flex justify-between items-center bg-[#18181b]/50">
          <div>
            <h3 className="text-white font-bold text-lg">Заметка</h3>
            <p className="text-blue-500 text-xs font-medium uppercase tracking-widest mt-0.5">{formatFullDate(month)}</p>
          </div>
          <button onClick={onClose} className="text-gray-500 hover:text-white transition-colors p-2 hover:bg-white/5 rounded-full">✕</button>
        </div>
        <div className="p-6 min-h-[160px]">
          {isEditing ? (
            <textarea 
              autoFocus 
              className="w-full h-40 bg-[#09090b] border border-blue-600/50 rounded-xl p-4 text-white focus:ring-2 focus:ring-blue-600 outline-none resize-none transition-all shadow-inner" 
              placeholder="Введите ваши планы..." 
              value={text} 
              onChange={(e) => setText(e.target.value)} 
            />
          ) : (
            <div className="relative group">
              <div className="text-gray-300 text-sm leading-relaxed whitespace-pre-wrap italic bg-white/[0.03] p-5 rounded-xl border border-gray-800/50 shadow-inner">
                {currentText || "Заметка пуста..."}
              </div>
              <button 
                onClick={() => setIsEditing(true)}
                className="absolute top-3 right-3 p-2 bg-gray-800/80 hover:bg-blue-600 text-white rounded-lg transition-all shadow-lg flex items-center gap-2 group/btn backdrop-blur-md"
              >
                <span className="text-[10px] font-bold hidden group-hover/btn:block pl-1">РЕДАКТИРОВАТЬ</span>
                <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                  <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
                </svg>
              </button>
            </div>
          )}
        </div>
        <div className="p-4 bg-[#18181b]/50 flex gap-3 border-t border-gray-800">
          <button onClick={onClose} className="flex-1 px-4 py-2.5 rounded-lg border border-gray-800 text-gray-400 hover:bg-white/5 transition font-medium">
            {isEditing && currentText ? 'Отмена' : 'Закрыть'}
          </button>
          {isEditing && (
            <button 
              onClick={() => { onSave(text); setIsEditing(false); }} 
              className="flex-1 px-4 py-2.5 rounded-lg bg-blue-600 hover:bg-blue-700 text-white font-bold shadow-lg shadow-blue-500/20 transition-all active:scale-95"
            >
              Сохранить
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

// --- КОМПОНЕНТ СТРОКИ ТАБЛИЦЫ ---
export const PlanningRow: React.FC<{ 
  label: string; 
  color?: string; 
  double?: boolean; 
  monthsCount?: number;
  values?: number[];
  onChange?: (index: number, val: number) => void;
  hideTotal?: boolean;
}> = ({ label, color, double, monthsCount = 1, values = [], onChange }) => {
  const colMinWidth = double ? 'minmax(45px, 1fr)' : 'minmax(70px, 1fr)';
  const gridStyle = {
    display: 'grid',
    gridTemplateColumns: `220px repeat(${double ? monthsCount * 2 : monthsCount}, ${colMinWidth}) 100px`
  };

  const rowTotal = useMemo(() => {
    if (!double) return values.reduce((a, b) => a + (b || 0), 0);
    const ses = values.filter((_, i) => i % 2 === 0).reduce((a, b) => a + (b || 0), 0);
    const hrs = values.filter((_, i) => i % 2 !== 0).reduce((a, b) => a + (b || 0), 0);
    return { ses, hrs };
  }, [values, double]);

  return (
    <div style={gridStyle} className="border-b border-gray-800/50 hover:bg-white/[0.02] transition-colors text-center items-center group/row">
      <div className="sticky left-0 z-10 bg-[#111113] group-hover/row:bg-[#18181b] p-3 flex items-center gap-3 text-sm text-gray-300 text-left border-r border-gray-800/80 min-h-[44px] shadow-[4px_0_10px_rgba(0,0,0,0.5)]">
        {color && <div className="w-2 h-2 rounded-full shrink-0" style={{ backgroundColor: color }} />}
        <span className="truncate">{label}</span>
      </div>
      
      {Array.from({ length: double ? monthsCount * 2 : monthsCount }).map((_, i) => (
        <input 
          key={i}
          type="number" 
          placeholder="-" 
          className={`w-full h-full bg-transparent text-center outline-none transition-all appearance-none placeholder:text-gray-700 text-white p-2 border-r border-gray-800/30 focus:bg-blue-500/10 ${double ? 'text-[10px]' : 'text-sm'}`}
          value={values[i] === 0 ? '' : values[i] || ''}
          onChange={(e) => {
            const val = e.target.value === '' ? 0 : parseFloat(e.target.value);
            if (onChange) onChange(i, val);
          }}
        />
      ))}

      <div className={`sticky right-0 z-10 bg-[#131316] group-hover/row:bg-[#1c1c20] text-[#3b82f6] font-bold flex items-center justify-center h-full shadow-[-4px_0_10px_rgba(0,0,0,0.5)] border-l border-gray-800 ${double ? 'text-[9px] grid grid-cols-2' : 'text-sm'}`}>
        {double && typeof rowTotal === 'object' ? (
          <>
            <div className="flex items-center justify-center border-r border-blue-500/10 h-full">{rowTotal.ses || '-'}</div>
            <div className="flex items-center justify-center">{rowTotal.hrs || '-'}</div>
          </>
        ) : (
          <span>{(rowTotal as number) || '-'}</span>
        )}
      </div>
    </div>
  );
};

// --- ОСНОВНОЙ КОМПОНЕНТ ТАБЛИЦЫ ---
export const PlanningTable: React.FC<{ 
  title: string; 
  children: React.ReactNode; 
  double?: boolean; 
  customMonths?: string[];
  planId?: string; 
  hideTotal?: boolean;
}> = ({ title, children, double, customMonths, planId, hideTotal = false }) => {
  const months = useMemo(() => customMonths || ['Янв'], [customMonths]);
  const monthsCount = months.length;
  
  const [data, setData] = useState<Record<string, number[]>>({});
  const [notes, setNotes] = useState<Record<string, string>>({});
  const [selectedMonth, setSelectedMonth] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  
  const saveTimers = useRef<Record<string, any>>({});

  const loadData = useCallback(async () => {
    if (!planId) { setData({}); setNotes({}); return; }
    const token = localStorage.getItem("token");
    if (!token) return;

    try {
      setLoading(true);
      const res = await fetch(`${import.meta.env.VITE_API_URL}/api/planning/data?tableName=${encodeURIComponent(title)}&planId=${planId}`, {
        headers: { Authorization: `Bearer ${token}` }
      });
      if (!res.ok) throw new Error('Load failed');
      const result = await res.json();
      const formattedData: Record<string, number[]> = {};
      (result.rows || []).forEach((r: any) => { formattedData[r.label] = r.values; });
      const formattedNotes: Record<string, string> = {};
      (result.notes || []).forEach((n: any) => { formattedNotes[n.month] = n.text; });
      setData(formattedData);
      setNotes(formattedNotes);
    } catch (e) { console.error(e); } finally { setLoading(false); }
  }, [title, planId]);

  useEffect(() => { loadData(); }, [loadData]);

  const saveRow = async (label: string, values: number[]) => {
    const token = localStorage.getItem("token");
    if (!token || !planId) return;
    if (saveTimers.current[label]) clearTimeout(saveTimers.current[label]);
    saveTimers.current[label] = setTimeout(async () => {
      try {
        await fetch(`${import.meta.env.VITE_API_URL}/api/planning/save-row`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
          body: JSON.stringify({ tableName: title, label, values, isDouble: double, planId })
        });
      } catch (e) { console.error(e); }
    }, 500);
  };

  const handleSaveNote = async (text: string) => {
    if (!selectedMonth || !planId) return;
    const token = localStorage.getItem("token");
    try {
      await fetch(`${import.meta.env.VITE_API_URL}/api/planning/save-note`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
        body: JSON.stringify({ tableName: title, month: selectedMonth, text, planId })
      });
      setNotes(prev => ({ ...prev, [selectedMonth]: text }));
    } catch (e) { console.error(e); }
  };

  const handleValueChange = (label: string, index: number, val: number) => {
    setData(prev => {
      const currentValues = prev[label] || new Array(double ? monthsCount * 2 : monthsCount).fill(0);
      const newValues = [...currentValues];
      newValues[index] = val;
      saveRow(label, newValues);
      return { ...prev, [label]: newValues };
    });
  };

  const colTotals = useMemo(() => {
    if (hideTotal) return [];
    const length = double ? monthsCount * 2 : monthsCount;
    const totals = new Array(length).fill(0);
    Object.values(data).forEach(row => {
      row.forEach((val, i) => { if (i < length) totals[i] += (val || 0); });
    });
    return totals;
  }, [data, monthsCount, double, hideTotal]);

  const monthMinWidth = double ? 'minmax(90px, 1fr)' : 'minmax(70px, 1fr)';
  const gridLayout = `220px repeat(${monthsCount}, ${monthMinWidth}) 100px`;

  return (
    <div className={`mb-10 bg-[#111113] border border-gray-800 rounded-xl overflow-hidden shadow-2xl transition-opacity ${loading ? 'opacity-70' : 'opacity-100'}`}>
      <CommentModal 
        isOpen={!!selectedMonth} 
        month={selectedMonth || ''} 
        currentText={selectedMonth ? notes[selectedMonth] || '' : ''}
        onClose={() => setSelectedMonth(null)} 
        onSave={handleSaveNote} 
      />
      
      <div className="p-4 border-b border-gray-800 bg-[#18181b] flex justify-between items-center">
        <div className="flex items-center gap-3">
          <h3 className="text-[#3b82f6] font-bold uppercase tracking-wider text-[10px]">{title}</h3>
          {loading && <div className="w-3 h-3 border-2 border-blue-500 border-t-transparent rounded-full animate-spin" />}
        </div>
        <span className="text-[9px] text-gray-500 uppercase italic">Автосохранение</span>
      </div>
      
      <div className="overflow-x-auto scrollbar-thin scrollbar-thumb-blue-600/20 scrollbar-track-transparent">
        <div style={{ minWidth: 'fit-content' }}>
          
          <div style={{ display: 'grid', gridTemplateColumns: gridLayout }} className="bg-[#18181b] text-[10px] text-gray-500 uppercase font-bold border-b border-gray-800 italic">
            <div className="sticky left-0 z-20 bg-[#18181b] p-3 border-r border-gray-800/80 shadow-[4px_0_10px_rgba(0,0,0,0.5)]">Категория</div>
            {months.map(m => (
              <div key={m} className={`border-r border-gray-800 flex flex-col items-stretch ${m.includes('26') ? 'bg-blue-500/5' : ''}`}>
                <div className={`p-2 text-center text-gray-300 font-black ${double ? 'border-b border-gray-800' : ''}`}>{m}</div>
                {double && (
                  <div className="grid grid-cols-2 text-[7px] text-gray-600 font-bold uppercase">
                    <div className="p-1 text-center border-r border-gray-800/50">СЕССИИ</div>
                    <div className="p-1 text-center">ЧАСЫ</div>
                  </div>
                )}
              </div>
            ))}
            <div className="sticky right-0 z-20 bg-[#1e1e21] text-[#3b82f6] border-l border-gray-800 flex items-center justify-center shadow-[-4px_0_10px_rgba(0,0,0,0.5)] uppercase">Итого</div>
          </div>

          {title === "Ключевые показатели" && (
            <div style={{ display: 'grid', gridTemplateColumns: gridLayout }} className="border-b border-gray-800/50 bg-white/[0.01]">
              <div className="sticky left-0 z-10 bg-[#111113] p-3 text-[10px] text-gray-500 uppercase font-bold border-r border-gray-800/80 shadow-[4px_0_10px_rgba(0,0,0,0.3)]">Заметки</div>
              {months.map(m => (
                <div key={m} className={`border-r border-gray-800 flex items-center justify-center py-2 ${m.includes('26') ? 'bg-blue-500/5' : ''}`}>
                  <button 
                    onClick={() => setSelectedMonth(m)} 
                    className={`text-[9px] font-bold uppercase transition-all px-2 py-1 rounded ${notes[m] ? 'text-[#3b82f6] border border-[#3b82f6]/30 bg-[#3b82f6]/5' : 'text-gray-700 hover:text-blue-400'}`}
                  >
                    {notes[m] ? 'Смотреть' : 'Добавить +'}
                  </button>
                </div>
              ))}
              <div className="sticky right-0 z-10 bg-[#111113] border-l border-gray-800 shadow-[-4px_0_10px_rgba(0,0,0,0.3)]"></div>
            </div>
          )}

          {React.Children.map(children, (child) => {
            if (React.isValidElement(child)) {
              const label = (child.props as any).label;
              return React.cloneElement(child as React.ReactElement<any>, { 
                monthsCount,
                values: data[label] || new Array(double ? monthsCount * 2 : monthsCount).fill(0),
                onChange: (idx: number, val: number) => handleValueChange(label, idx, val)
              });
            }
            return child;
          })}

          {!hideTotal && (
            <div style={{ display: 'grid', gridTemplateColumns: `220px repeat(${double ? monthsCount * 2 : monthsCount}, ${double ? 'minmax(45px, 1fr)' : 'minmax(70px, 1fr)'}) 100px` }} className="bg-[#18181b]/80 border-t border-gray-700 font-bold">
              <div className="sticky left-0 z-20 bg-[#18181b] p-3 text-[10px] text-gray-400 uppercase border-r border-gray-800/80 italic shadow-[4px_0_10px_rgba(0,0,0,0.5)] text-left">Общее</div>
              {colTotals.map((total, i) => (
                <div key={i} className="p-3 text-center border-r border-gray-800 text-[11px] text-white opacity-80">{total || '-'}</div>
              ))}
              <div className={`sticky right-0 z-20 bg-[#1e1e21] text-[#3b82f6] border-l border-gray-800 flex items-center justify-center shadow-[-4px_0_10px_rgba(0,0,0,0.5)] ${double ? 'text-[9px]' : 'text-sm'}`}>
                {double ? (
                  <div className="grid grid-cols-2 w-full h-full">
                     <div className="flex items-center justify-center border-r border-blue-500/10">
                       {colTotals.filter((_, idx) => idx % 2 === 0).reduce((a, b) => a + b, 0) || '-'}
                     </div>
                     <div className="flex items-center justify-center">
                       {colTotals.filter((_, idx) => idx % 2 !== 0).reduce((a, b) => a + b, 0) || '-'}
                     </div>
                  </div>
                ) : (
                  colTotals.reduce((a,b) => a+b, 0) || '-'
                )}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};