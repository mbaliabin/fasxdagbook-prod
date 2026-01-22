export const PlanningRow: React.FC<{ 
  label: string; 
  color?: string; 
  double?: boolean; 
  monthsCount: number;
  values: number[];
  onChange: (index: number, val: number) => void;
}> = ({ label, color, double, monthsCount, values, onChange }) => {
  
  // Динамическая сетка: подстраивается под количество месяцев в плане
  const gridStyle = {
    display: 'grid',
    gridTemplateColumns: double 
      ? `220px repeat(${monthsCount * 2}, 1fr) 120px` 
      : `220px repeat(${monthsCount}, 1fr) 100px`
  };

  // Считаем сумму строки (для обычных строк просто сумма, для двойных — сессии и часы отдельно)
  const rowTotal = useMemo(() => {
    if (!double) return values.reduce((a, b) => a + (b || 0), 0);
    const ses = values.filter((_, i) => i % 2 === 0).reduce((a, b) => a + (b || 0), 0);
    const hrs = values.filter((_, i) => i % 2 !== 0).reduce((a, b) => a + (b || 0), 0);
    return { ses, hrs };
  }, [values, double]);

  return (
    <div style={gridStyle} className="border-b border-gray-800/50 hover:bg-white/[0.02] transition-colors text-center items-center group/row">
      {/* Название категории */}
      <div className="sticky left-0 z-10 bg-[#111113] group-hover/row:bg-[#18181b] p-3 flex items-center gap-3 text-sm text-gray-300 text-left border-r border-gray-800/30 min-h-[44px] shadow-[4px_0_10px_rgba(0,0,0,0.3)]">
        {color && <div className="w-2 h-2 rounded-full shrink-0" style={{ backgroundColor: color }} />}
        <span className="truncate">{label}</span>
      </div>
      
      {/* Ячейки ввода */}
      {Array.from({ length: double ? monthsCount * 2 : monthsCount }).map((_, i) => (
        <input 
          key={i}
          type="number" 
          placeholder="-" 
          // Используем value вместо defaultValue для синхронизации с состоянием
          value={values[i] === 0 ? '' : values[i]} 
          className={`w-full h-full bg-transparent text-center outline-none transition-all appearance-none placeholder:text-gray-600 text-white p-3 border-r border-gray-800/30 focus:bg-white/5 focus:ring-1 focus:ring-blue-500/30 ${double ? 'text-[10px]' : 'text-sm'}`}
          onChange={(e) => {
            const val = e.target.value === '' ? 0 : parseFloat(e.target.value);
            onChange(i, val); // Передаем изменение в PlanningTable для сохранения
          }}
        />
      ))}

      {/* Итоговая ячейка */}
      <div className={`sticky right-0 z-10 bg-[#131316] group-hover/row:bg-[#1c1c20] text-[#3b82f6] font-bold flex items-center justify-center h-full shadow-[-4px_0_10px_rgba(0,0,0,0.3)] border-l border-gray-800 ${double ? 'text-[10px] grid grid-cols-2' : 'text-sm'}`}>
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