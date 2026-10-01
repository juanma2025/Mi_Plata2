import { NavLink } from 'react-router-dom';
import { cn } from '../utils/cn';
import { Home, ArrowDownUp, PieChart, Target, BarChart2, MessageSquare, User } from 'lucide-react';

const navItems = [
  { path: '/app', label: 'Inicio', icon: Home },
  { path: '/app/movimientos', label: 'Movimientos', icon: ArrowDownUp },
  { path: '/app/presupuesto', label: 'Presupuesto', icon: PieChart },
  { path: '/app/metas', label: 'Metas', icon: Target },
  { path: '/app/estadisticas', label: 'Estadísticas', icon: BarChart2 },
  { path: '/app/plata-ia', label: 'PLATA IA', icon: MessageSquare },
  { path: '/app/perfil', label: 'Perfil', icon: User },
];

export function Sidebar() {
  return (
    <>
      {/* Desktop Sidebar */}
      <aside className="hidden md:block w-[250px] bg-[var(--panel)] border-r border-[var(--border)] p-[26px_16px] fixed inset-y-0 left-0 z-20">
        <div className="text-2xl font-extrabold tracking-tight px-3.5 pb-[30px]">
          Mi<span className="text-[var(--green)]">Plata</span>
        </div>
        <nav className="grid gap-[7px]">
          {navItems.map((item) => (
            <NavLink
              key={item.path}
              to={item.path}
              className={({ isActive }) => cn(
                "text-[var(--muted)] text-left px-3.5 py-[13px] rounded-xl flex gap-3 items-center transition-all duration-200 relative group overflow-hidden",
                isActive ? "bg-[var(--panel2)] text-[var(--text)] font-semibold shadow-[inset_3px_0_var(--green)]" : "hover:bg-[var(--panel2)] hover:text-[var(--text)] hover:translate-x-1"
              )}
            >
              <item.icon size={18} className={cn("transition-transform duration-200", "group-hover:scale-110")} />
              <span>{item.label}</span>
            </NavLink>
          ))}
        </nav>
      </aside>

      {/* Mobile Navigation */}
      <nav className="md:hidden fixed bottom-0 left-0 right-0 h-[68px] bg-[var(--panel)] border-t border-[var(--border)] z-30 flex justify-around">
        {navItems.filter(i => ['/app', '/app/movimientos', '/app/estadisticas', '/app/metas', '/app/perfil'].includes(i.path)).map((item) => (
          <NavLink
            key={item.path}
            to={item.path}
            className={({ isActive }) => cn(
              "text-[var(--muted)] text-[10px] flex flex-col items-center justify-center gap-1 p-2 w-full transition-all duration-200",
              isActive ? "text-[var(--green)] -translate-y-1" : "hover:text-[var(--text)] active:scale-95"
            )}
          >
            <item.icon size={20} className={cn("transition-transform duration-200")} />
            <span className="font-medium">{item.label === 'Estadísticas' ? 'Stats' : item.label}</span>
          </NavLink>
        ))}
      </nav>
    </>
  );
}
