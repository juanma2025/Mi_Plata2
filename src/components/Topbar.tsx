import { Search, Bell } from 'lucide-react';
import { useAuthStore } from '../store/useAuthStore';
import { useLocation } from 'react-router-dom';

const getPageInfo = (pathname: string) => {
  switch (pathname) {
    case '/app': return { title: 'Buenos días, Juan', eyebrow: 'MIÉRCOLES, 30 DE SEPTIEMBRE' };
    case '/app/movimientos': return { title: 'Movimientos', eyebrow: 'HISTORIAL' };
    case '/app/presupuesto': return { title: 'Presupuesto', eyebrow: 'CONTROL MENSUAL' };
    case '/app/metas': return { title: 'Mis metas', eyebrow: 'AHORRO' };
    case '/app/estadisticas': return { title: 'Estadísticas', eyebrow: 'ANÁLISIS' };
    case '/app/plata-ia': return { title: '✦ PLATA IA', eyebrow: 'ASISTENTE FINANCIERO' };
    case '/app/perfil': return { title: 'Mi perfil', eyebrow: 'CONFIGURACIÓN' };
    default: return { title: 'MiPlata', eyebrow: 'BIENVENIDO' };
  }
};

export function Topbar() {
  const { user } = useAuthStore();
  const location = useLocation();
  const { title, eyebrow } = getPageInfo(location.pathname);

  return (
    <header className="flex flex-col md:flex-row justify-between md:items-center mb-7 gap-5">
      <div>
        <div className="text-[var(--muted)] text-[13px] mb-[5px] uppercase tracking-wider font-semibold">
          {eyebrow}
        </div>
        <h1 className="text-2xl md:text-[30px] font-bold tracking-tight">{title}</h1>
      </div>
      <div className="flex items-center gap-3">
        <button className="btn-icon hidden md:flex">
          <Search size={20} className="transition-transform group-hover:scale-110" />
        </button>
        <button className="btn-icon hidden md:flex">
          <Bell size={20} className="transition-transform group-hover:scale-110" />
        </button>
        <button className="w-[42px] h-[42px] rounded-xl grid place-items-center font-bold bg-[var(--green)] text-[#0b120e] transition-all hover:scale-105 active:scale-95 shadow-[0_0_10px_rgba(101,211,145,0.2)]">
          {user?.initials}
        </button>
      </div>
    </header>
  );
}
