import { Outlet } from 'react-router-dom';
import { PublicNavbar } from '../components/navbar/PublicNavbar';
import { Footer } from '../components/Footer';

export function PublicLayout() {
  return (
    <div className="min-h-screen bg-[var(--bg)] text-[var(--text)] flex flex-col">
      <PublicNavbar />
      <main className="flex-1 animate-fade-in">
        <Outlet />
      </main>
      <Footer />
    </div>
  );
}
