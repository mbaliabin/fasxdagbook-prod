interface ModalProps {
    isOpen: boolean;
    month: string;
    onClose: () => void;
    onSave: (text: string) => void;
  }
  
  const CommentModal: React.FC<ModalProps> = ({ isOpen, month, onClose, onSave }) => {
    const [text, setText] = React.useState('');
  
    if (!isOpen) return null;
  
    return (
      <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm p-4">
        <div className="bg-[#111113] border border-gray-800 w-full max-w-md rounded-2xl shadow-2xl overflow-hidden">
          <div className="p-6 border-b border-gray-800 flex justify-between items-center bg-[#18181b]">
            <h3 className="text-white font-bold tracking-tight">Комментарий: {month}</h3>
            <button onClick={onClose} className="text-gray-500 hover:text-white transition">✕</button>
          </div>
          <div className="p-6">
            <textarea
              autoFocus
              className="w-full h-32 bg-[#09090b] border border-gray-800 rounded-xl p-4 text-gray-200 focus:ring-2 focus:ring-blue-600 outline-none transition-all resize-none"
              placeholder="Опишите цели или важные события месяца..."
              value={text}
              onChange={(e) => setText(e.target.value)}
            />
          </div>
          <div className="p-6 bg-[#18181b] flex gap-3">
            <button 
              onClick={onClose}
              className="flex-1 px-4 py-2 rounded-lg border border-gray-800 text-gray-400 hover:bg-white/5 transition"
            >
              Отмена
            </button>
            <button 
              onClick={() => { onSave(text); onClose(); }}
              className="flex-1 px-4 py-2 rounded-lg bg-blue-600 hover:bg-blue-700 text-white font-semibold transition"
            >
              Сохранить
            </button>
          </div>
        </div>
      </div>
    );
  };