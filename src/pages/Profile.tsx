import { Card, CardHeader, CardTitle } from '../components/ui/Card';
import { useAuthStore } from '../store/useAuthStore';
import { Button } from '../components/ui/Button';

export function Profile() {
  const { user, logout, theme, setTheme } = useAuthStore();

  return (
    <div className="animate-in fade-in duration-500">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Card>
          <CardHeader>
            <CardTitle>Perfil</CardTitle>
            <button className="btn-secondary text-sm">Editar</button>
          </CardHeader>
          <div className="flex items-center gap-4">
            <div className="w-16 h-16 rounded-xl bg-[var(--green)] text-[#0b120e] grid place-items-center font-bold text-xl">
              {user?.initials}
            </div>
            <div>
              <h2 className="text-xl font-bold">{user?.name}</h2>
              <p className="text-sm text-[var(--muted)] mt-1">{user?.email}</p>
            </div>
          </div>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Preferencias</CardTitle>
          </CardHeader>
          <div className="flex flex-col">
            <div className="flex justify-between items-center py-3.5 border-b border-[var(--border)]">
              <span className="text-sm">Tema visual</span>
              <div className="flex gap-2 bg-[var(--panel2)] p-1 rounded-lg">
                <button 
                  onClick={() => setTheme('light')} 
                  className={`px-3 py-1 text-xs rounded-md font-medium transition-colors ${theme === 'light' ? 'bg-[var(--bg)] shadow-sm' : 'text-[var(--muted)] hover:text-[var(--text)]'}`}
                >Claro</button>
                <button 
                  onClick={() => setTheme('dark')} 
                  className={`px-3 py-1 text-xs rounded-md font-medium transition-colors ${theme === 'dark' ? 'bg-[var(--bg)] shadow-sm' : 'text-[var(--muted)] hover:text-[var(--text)]'}`}
                >Oscuro</button>
                <button 
                  onClick={() => setTheme('system')} 
                  className={`px-3 py-1 text-xs rounded-md font-medium transition-colors ${theme === 'system' ? 'bg-[var(--bg)] shadow-sm' : 'text-[var(--muted)] hover:text-[var(--text)]'}`}
                >Auto</button>
              </div>
            </div>
          </div>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Datos y privacidad</CardTitle>
          </CardHeader>
          <div className="flex flex-col">
            <div className="flex justify-between items-center py-3.5 border-b border-[var(--border)]">
              <span className="text-sm">Exportar datos</span>
              <button className="btn-secondary text-xs py-1.5">JSON</button>
            </div>
            <div className="flex justify-between items-center py-3.5 border-b border-[var(--border)]">
              <span className="text-sm">Conversaciones de PLATA IA</span>
              <button className="btn-secondary text-xs py-1.5">Gestionar</button>
            </div>
            <div className="flex justify-between items-center py-3.5 border-b border-[var(--border)]">
              <span className="text-sm">Cerrar sesión</span>
              <Button variant="secondary" onClick={logout} className="py-1.5 px-4 text-xs h-8">Cerrar sesión</Button>
            </div>
            <div className="flex justify-between items-center pt-3.5">
              <span className="text-sm">Eliminar cuenta</span>
              <button className="bg-[var(--red)]/10 text-[var(--red)] border border-[var(--red)]/20 rounded-xl px-4 py-1.5 transition-colors text-xs hover:bg-[var(--red)]/20">Eliminar</button>
            </div>
          </div>
        </Card>
      </div>
    </div>
  );
}
