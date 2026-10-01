import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Button } from '../components/ui/Button';
import { Input } from '../components/ui/Input';
import { useAuthStore } from '../store/useAuthStore';
import { toast } from 'sonner';

export function Register() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const login = useAuthStore(state => state.login);
  const navigate = useNavigate();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name || !email || !password) {
      toast.error('Por favor, completa todos los campos.');
      return;
    }
    
    setIsLoading(true);
    // Simulate API call
    setTimeout(() => {
      setIsLoading(false);
      login({ name, email, initials: name.substring(0, 2).toUpperCase() });
      toast.success('Cuenta creada exitosamente');
      navigate('/app');
    }, 1500);
  };

  return (
    <div>
      <h2 className="text-3xl font-bold mb-2">Crear cuenta</h2>
      <p className="text-[var(--muted)] mb-8">Únete a MiPlata y toma el control de tus finanzas.</p>

      <form onSubmit={handleSubmit} className="flex flex-col gap-5">
        <Input 
          label="Nombre completo" 
          placeholder="Juan Manuel" 
          value={name}
          onChange={(e) => setName(e.target.value)}
        />
        <Input 
          label="Correo electrónico" 
          type="email" 
          placeholder="juan@email.com" 
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <Input 
          label="Contraseña" 
          type="password" 
          placeholder="••••••••" 
          value={password}
          onChange={(e) => setPassword(e.target.value)}
        />
        
        <Button type="submit" className="w-full mt-4" isLoading={isLoading}>
          Crear cuenta
        </Button>
      </form>

      <p className="mt-8 text-center text-sm text-[var(--muted)]">
        ¿Ya tienes una cuenta? <Link to="/login" className="text-[var(--green)] font-medium hover:underline">Inicia sesión</Link>
      </p>
    </div>
  );
}
