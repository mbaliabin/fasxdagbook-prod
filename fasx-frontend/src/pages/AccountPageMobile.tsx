import React, { useState, useEffect, useCallback, useRef, Fragment } from "react";
import { useNavigate, useLocation } from "react-router-dom";
import Cropper from 'react-easy-crop';
import { Dialog, Transition } from "@headlessui/react";
import dayjs from "dayjs";
import "dayjs/locale/ru";
import {
  BarChart3, ClipboardList, CalendarDays, LogOut, User, Trophy, Heart, Edit3,
  Activity, Loader2, Check, Trash2, Timer, Pencil, ShieldCheck, Plus, Users
} from "lucide-react";

import EditAccountModal from "../components/AccountPage/EditAccountModalMobile";
import { getUserProfile } from "../api/getUserProfile";

dayjs.locale("ru");

const SectionLabel = ({ icon: Icon, title, color = "text-blue-500" }: any) => (
  <div className="flex items-center gap-2 px-1 mb-2.5">
    <Icon size={11} className={color} />
    <h2 className="text-[9px] font-black uppercase tracking-[0.2em] text-white/30">{title}</h2>
  </div>
);

// Функция сжатия полотна оригинала
const compressOriginal = (imageSrc: string): Promise<Blob> => {
  return new Promise((resolve, reject) => {
    const image = new Image();
    image.src = imageSrc;
    image.onload = () => {
      const canvas = document.createElement('canvas');
      const ctx = canvas.getContext('2d');
      if (!ctx) return reject();

      const maxSide = 1600;
      let width = image.width;
      let height = image.height;

      if (width > height) {
        if (width > maxSide) {
          height *= maxSide / width;
          width = maxSide;
        }
      } else {
        if (height > maxSide) {
          width *= maxSide / height;
          height = maxSide;
        }
      }

      canvas.width = width;
      canvas.height = height;
      ctx.drawImage(image, 0, 0, width, height);

      canvas.toBlob((blob) => {
        if (!blob) return reject();
        resolve(blob);
      }, 'image/jpeg', 0.85);
    };
    image.onerror = (e) => reject(e);
  });
};

export default function AccountPageMobile() {
  const navigate = useNavigate();
  const location = useLocation();
  const fileInputRef = useRef<HTMLInputElement>(null);

  const [profile, setProfile] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [uploading, setUploading] = useState(false);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [showAvatarMenu, setShowAvatarMenu] = useState(false);

  const [imageForCrop, setImageForCrop] = useState<string | null>(null);
  const [crop, setCrop] = useState({ x: 0, y: 0 });
  const [zoom, setZoom] = useState(1);
  const [croppedAreaPixels, setCroppedAreaPixels] = useState<any>(null);

  const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000';

  const fetchProfile = useCallback(async () => {
    try {
      const data = await getUserProfile();
      setProfile(data);
    } catch (err) {
      if (err instanceof Error && err.message.includes("401")) {
        localStorage.removeItem("token");
        navigate('/login');
      }
    } finally {
      setLoading(false);
    }
  }, [navigate]);

  useEffect(() => { fetchProfile(); }, [fetchProfile]);

  const onFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files.length > 0) {
      const file = e.target.files[0];
      setImageForCrop(URL.createObjectURL(file));
      setShowAvatarMenu(false);
    }
  };

  const handleUploadCroppedImage = async () => {
    if (!imageForCrop || !croppedAreaPixels || uploading) return;
    setUploading(true);
    
    try {
      // 1. Получаем размеры исходника
      const img = new Image();
      img.src = imageForCrop;
      await new Promise((res) => (img.onload = res));

      // 2. Сжимаем оригинал
      const compressedBlob = await compressOriginal(imageForCrop);
      
      // 3. Получаем размеры сжатого фото для расчета коэффициента (scale)
      const compressedUrl = URL.createObjectURL(compressedBlob);
      const compressedImg = new Image();
      compressedImg.src = compressedUrl;
      await new Promise((res) => (compressedImg.onload = res));

      const scaleX = compressedImg.width / img.width;
      const scaleY = compressedImg.height / img.height;

      const formData = new FormData();
      formData.append("avatar", compressedBlob, "avatar.jpg");
      
      // Корректируем координаты под новый размер картинки
      formData.append("cropX", Math.round(croppedAreaPixels.x * scaleX).toString());
      formData.append("cropY", Math.round(croppedAreaPixels.y * scaleY).toString());
      formData.append("cropWidth", Math.round(croppedAreaPixels.width * scaleX).toString());
      formData.append("cropHeight", Math.round(croppedAreaPixels.height * scaleY).toString());

      const token = localStorage.getItem("token");
      const response = await fetch(`${BASE_URL}/api/user/upload-avatar`, {
        method: "POST",
        headers: { "Authorization": `Bearer ${token}` },
        body: formData
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || "Ошибка сервера при сохранении");
      }

      setProfile(data.user);
      URL.revokeObjectURL(imageForCrop);
      URL.revokeObjectURL(compressedUrl);
      setImageForCrop(null);
      
    } catch (err: any) {
      console.error("Upload error:", err);
      alert(err.message || "Не удалось загрузить фото");
    } finally {
      setUploading(false);
    }
  };

  const handleDeleteAvatar = async () => {
    setShowAvatarMenu(false);
    if (!window.confirm("Удалить фото профиля?")) return;
    try {
      setUploading(true);
      const token = localStorage.getItem("token");
      const response = await fetch(`${BASE_URL}/api/profile/delete-avatar`, {
        method: "DELETE",
        headers: { "Authorization": `Bearer ${token}` }
      });
      if (response.ok) {
        const data = await response.json();
        setProfile(data.user);
      }
    } catch (err) { console.error(err); } finally { setUploading(false); }
  };

  const hrZonesData = [
    { label: 'I1', range: profile?.profile?.hrZones?.I1 || '---', color: '#4ade80' },
    { label: 'I2', range: profile?.profile?.hrZones?.I2 || '---', color: '#22d3ee' },
    { label: 'I3', range: profile?.profile?.hrZones?.I3 || '---', color: '#facc15' },
    { label: 'I4', range: profile?.profile?.hrZones?.I4 || '---', color: '#fb923c' },
    { label: 'I5', range: profile?.profile?.hrZones?.I5 || '---', color: '#ef4444' },
  ];

  const menuItems = [
    { label: "Главная", icon: Timer, path: "/daily" },
    { label: "Тренировки", icon: BarChart3, path: "/profile" },
    { label: "Календарь", icon: CalendarDays, path: "/calendar" },
    { label: "Планы", icon: ClipboardList, path: "/planning" },
    { label: "Статы", icon: Activity, path: "/statistics" },
  ];

  if (loading && !profile) return (
    <div className="min-h-screen bg-[#0a0a0b] flex items-center justify-center text-blue-500">
      <Loader2 className="w-8 h-8 animate-spin" />
    </div>
  );

  return (
    <div className="min-h-screen bg-[#0a0a0b] text-gray-200 pb-32 font-sans overflow-x-hidden">
      
      {/* HEADER */}
      <div className="sticky top-0 z-40 bg-[#0a0a0b]/95 backdrop-blur-md border-b border-white/[0.03] px-4 py-3 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-9 h-9 rounded-full bg-blue-600 flex items-center justify-center overflow-hidden border border-white/10 shrink-0">
            {profile?.avatarUrl ? (
              <img src={profile.avatarUrl} className="w-full h-full object-cover" alt="avatar" />
            ) : (
              <span className="text-white text-[10px] font-black">{profile?.name?.charAt(0)}</span>
            )}
          </div>
          <div className="flex flex-col min-w-0">
            <span className="text-[12px] font-black tracking-tight text-white leading-none truncate">{profile?.name || "Атлет"}</span>
            <span className="text-[7px] font-bold text-blue-500 uppercase tracking-widest mt-1">Profile</span>
          </div>
        </div>
        <button onClick={() => { localStorage.removeItem("token"); navigate("/login"); }} className="p-2 text-gray-600 active:text-red-500 transition-colors">
          <LogOut size={16} />
        </button>
      </div>

      <div className="p-4 space-y-6">
        {/* ПРОФИЛЬ */}
        <section>
          <SectionLabel icon={User} title="Профиль спортсмена" />
          <div className="bg-[#131316] border border-white/[0.03] rounded-[32px] p-8 shadow-2xl relative flex flex-col items-center">
            <button onClick={() => setIsModalOpen(true)} className="absolute top-6 right-6 text-white/10 active:text-blue-500">
              <Edit3 size={18} />
            </button>
            <div className="relative mb-6 cursor-pointer" onClick={() => setShowAvatarMenu(true)}>
              <div className="w-32 h-32 rounded-[40px] overflow-hidden border-2 border-white/5 bg-[#1a1a1e] relative z-10 shadow-2xl">
                {profile?.avatarUrl ? (
                  <img src={profile.avatarUrl} className="w-full h-full object-cover" alt="avatar" />
                ) : (
                  <div className="w-full h-full flex items-center justify-center text-4xl font-black text-blue-500/10">{profile?.name?.charAt(0)}</div>
                )}
                {uploading && (
                  <div className="absolute inset-0 bg-black/60 flex items-center justify-center z-20">
                    <Loader2 className="w-6 h-6 text-blue-500 animate-spin" />
                  </div>
                )}
              </div>
            </div>
            <div className="text-center">
              <h2 className="text-xl font-black text-white mb-1">{profile?.name}</h2>
              <p className="text-[8px] font-bold text-blue-500/70 uppercase tracking-[0.3em]">{profile?.profile?.sportType || "Атлет"}</p>
            </div>
          </div>
        </section>

        {/* БИОГРАФИЯ */}
        <section>
          <SectionLabel icon={ClipboardList} title="Биография" />
          <div className="bg-[#131316] border border-white/[0.03] rounded-[24px] p-6">
             <p className="text-[11px] text-gray-400 leading-relaxed italic">{profile?.profile?.bio || "Биография не заполнена."}</p>
          </div>
        </section>

        {/* СПОРТИВНЫЙ СТАТУС */}
        <section>
          <SectionLabel icon={Trophy} title="Спортивный статус" />
          <div className="bg-[#131316] rounded-[28px] border border-white/[0.03] p-5 space-y-4">
            <div className="grid grid-cols-2 gap-3">
              <div className="bg-white/[0.02] p-4 rounded-2xl border border-white/[0.03]">
                <p className="text-gray-600 text-[8px] font-black uppercase mb-1">Клуб</p>
                <p className="text-white text-[10px] font-bold truncate">{profile?.profile?.club || "—"}</p>
              </div>
              <div className="bg-white/[0.02] p-4 rounded-2xl border border-white/[0.03]">
                <p className="text-gray-600 text-[8px] font-black uppercase mb-1">Пол</p>
                <p className="text-white text-[10px] font-bold">{profile?.profile?.gender || "—"}</p>
              </div>
            </div>
            <div className="bg-blue-500/5 p-4 rounded-2xl border border-blue-500/10 flex items-center gap-3">
              <div className="p-2 bg-blue-500/10 rounded-lg"><ShieldCheck size={16} className="text-blue-500" /></div>
              <div>
                <p className="text-gray-500 text-[8px] font-black uppercase">Ассоциация / Федерация</p>
                <p className="text-white text-[11px] font-bold">{profile?.profile?.association || "Личный зачет"}</p>
              </div>
            </div>
          </div>
        </section>

        {/* ПУЛЬСОВЫЕ ЗОНЫ */}
        <section>
          <SectionLabel icon={Heart} title="Пульсовые зоны" color="text-red-500" />
          <div className="bg-[#131316] border border-white/[0.03] rounded-[24px] p-5">
            <div className="flex justify-between items-center gap-1.5">
              {hrZonesData.map((z) => (
                <div key={z.label} className="flex flex-col items-center gap-1.5 flex-1">
                  <div className="w-full h-[3px] rounded-full" style={{ backgroundColor: z.color }} />
                  <span className="text-[10px] font-black text-white tabular-nums">{z.range}</span>
                  <span className="text-[7px] font-black text-gray-600 uppercase tracking-tighter">{z.label}</span>
                </div>
              ))}
            </div>
          </div>
        </section>

        {/* ТРЕНЕРЫ */}
        <section>
          <SectionLabel icon={Users} title="Тренерский штаб" />
          <div className="bg-white/[0.01] border border-dashed border-white/10 p-8 rounded-[24px] text-center">
            <p className="text-[9px] text-gray-500 italic mb-4 font-medium">Нет привязанных тренеров</p>
            <button className="inline-flex items-center gap-2 border border-blue-500/20 bg-blue-500/5 px-5 py-2.5 rounded-xl text-[9px] text-blue-400 font-black uppercase">
              <Plus size={12} /> Добавить
            </button>
          </div>
        </section>
      </div>

      {/* МЕНЮ ФОТО */}
      <Transition show={showAvatarMenu} as={Fragment}>
        <Dialog onClose={() => setShowAvatarMenu(false)} className="relative z-[100]">
          <div className="fixed inset-0 bg-black/80 backdrop-blur-sm" />
          <div className="fixed inset-0 flex items-end justify-center">
            <Dialog.Panel className="w-full bg-[#16161a] rounded-t-[32px] border-t border-white/10 pb-8">
              <div className="px-6 pt-8 space-y-3">
                <button type="button" onClick={() => fileInputRef.current?.click()} className="w-full flex items-center gap-4 p-4 rounded-2xl bg-white/[0.03] border border-white/5 active:scale-[0.98]">
                  <div className="w-10 h-10 rounded-xl bg-blue-500/10 flex items-center justify-center text-blue-500"><Pencil size={18} /></div>
                  <div className="text-left"><p className="text-[13px] font-bold text-white">Обновить фото</p></div>
                </button>
                {profile?.avatarUrl && (
                  <button type="button" onClick={handleDeleteAvatar} className="w-full flex items-center gap-4 p-4 rounded-2xl bg-red-500/5 border border-red-500/10 active:scale-[0.98]">
                    <div className="w-10 h-10 rounded-xl bg-red-500/10 flex items-center justify-center text-red-500"><Trash2 size={18} /></div>
                    <div className="text-left"><p className="text-[13px] font-bold text-red-400">Удалить</p></div>
                  </button>
                )}
              </div>
            </Dialog.Panel>
          </div>
        </Dialog>
      </Transition>

      <input type="file" ref={fileInputRef} onChange={onFileChange} className="hidden" accept="image/*" />

      {/* НИЖНЕЕ МЕНЮ */}
      <div className="fixed bottom-4 left-4 right-4 z-50">
        <div className="bg-[#131316]/95 backdrop-blur-md border border-white/10 p-1 rounded-xl flex justify-around">
          {menuItems.map((item) => {
            const Icon = item.icon;
            const isActive = location.pathname === item.path;
            return (
              <button key={item.path} onClick={() => navigate(item.path)} className={`flex-1 flex flex-col items-center gap-0.5 py-2 rounded-lg transition-all ${isActive ? "bg-blue-600/10 text-blue-500" : "text-gray-600"}`}>
                <Icon size={18} strokeWidth={isActive ? 2.5 : 2} />
                <span className="text-[7px] font-black uppercase tracking-tighter">{item.label}</span>
              </button>
            );
          })}
        </div>
      </div>

      {/* CROPPER */}
      {imageForCrop && (
        <div className="fixed inset-0 z-[150] bg-black/95 flex flex-col items-center justify-center p-4">
          <div className="relative w-full max-w-lg aspect-square bg-[#131316] rounded-3xl overflow-hidden border border-white/10 shadow-2xl">
            <Cropper image={imageForCrop} crop={crop} zoom={zoom} aspect={1} onCropChange={setCrop} onCropComplete={(a, p) => setCroppedAreaPixels(p)} onZoomChange={setZoom} />
          </div>
          <div className="mt-8 flex gap-4 w-full max-w-lg">
            <button onClick={() => setImageForCrop(null)} className="flex-1 bg-white/5 py-4 rounded-2xl text-[10px] font-black uppercase">Отмена</button>
            <button onClick={handleUploadCroppedImage} disabled={uploading} className="flex-1 bg-blue-600 py-4 rounded-2xl text-[10px] font-black uppercase flex items-center justify-center gap-2">
              {uploading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Check size={14} />}
              {uploading ? "Загрузка..." : "Сохранить"}
            </button>
          </div>
        </div>
      )}

      {isModalOpen && <EditAccountModal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} profile={profile} onUpdate={fetchProfile} />}
    </div>
  );
}