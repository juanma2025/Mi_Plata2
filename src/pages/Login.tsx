import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Button } from '../components/ui/Button';
import { Input } from '../components/ui/Input';
import { useAuthStore } from '../store/useAuthStore';
import { toast } from 'sonner';

export function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const login = useAuthStore(state => state.login);
  const navigate = useNavigate();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!email || !password) {
      toast.error('Por favor, completa todos los campos.');
      return;
    }
    
    setIsLoading(true);
    // Simulate API call
    setTimeout(() => {
      setIsLoading(false);
      login({ name: 'Juan Manuel', email: email, initials: 'JM' });
      toast.success('Bienvenido de nuevo');
      navigate('/app');
    }, 1000);
  };

  return (
    <div>
      <h2 className="text-3xl font-bold mb-2">Iniciar sesión</h2>
      <p className="text-[var(--muted)] mb-8">Ingresa tus credenciales para acceder a tu cuenta.</p>

      <form onSubmit={handleSubmit} className="flex flex-col gap-5">
        <Input 
          label="Correo electrónico" 
          type="email" 
          placeholder="juan@email.com" 
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <div className="flex flex-col gap-1.5">
          <Input 
            label="Contraseña" 
            type="password" 
            placeholder="••••••••" 
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <div className="flex justify-between items-center px-1">
            <label className="flex items-center gap-2 text-sm text-[var(--muted)] cursor-pointer">
              <input type="checkbox" className="accent-[var(--green)]" />
              Recordarme
            </label>
            <button type="button" className="text-sm font-medium text-[var(--green)] hover:underline">
              ¿Olvidaste tu contraseña?
            </button>
          </div>
        </div>
        
        <Button type="submit" className="w-full mt-2" isLoading={isLoading}>
          Entrar a mi cuenta
        </Button>
      </form>

      <p className="mt-8 text-center text-sm text-[var(--muted)]">
        ¿No tienes una cuenta? <Link to="/register" className="text-[var(--green)] font-medium hover:underline">Regístrate gratis</Link>
      </p>
    </div>
  );
}
