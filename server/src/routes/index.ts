import { Router } from 'express';
import authRoutes from './auth.routes.js';
import userRoutes from './user.routes.js';
import geminiRoutes from './gemini.routes.js';
import healthRoutes from './health.routes.js';
import financeRoutes from './finance.routes.js';

const router = Router();

// ─── API Routes ─────────────────────────────────────
router.use('/health', healthRoutes);
router.use('/auth', authRoutes);
router.use('/user', userRoutes);
router.use('/finance', financeRoutes);
router.use('/chat', geminiRoutes);

export default router;
