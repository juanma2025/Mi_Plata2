import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { env } from './config/env.js';
import { corsOptions } from './config/cors.js';
import { generalLimiter } from './middlewares/rateLimiter.middleware.js';
import { errorHandler, notFoundHandler } from './middlewares/errorHandler.middleware.js';
import routes from './routes/index.js';
import { logger } from './utils/logger.js';

const app = express();

// ─── Security Headers ───────────────────────────────
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", 'data:', 'https:'],
      connectSrc: ["'self'"],
    },
  },
  crossOriginEmbedderPolicy: false,
}));

// ─── CORS ───────────────────────────────────────────
app.use(cors(corsOptions));

// ─── Body Parsing ───────────────────────────────────
app.use(express.json({ limit: '10kb' }));  // Prevent large payload attacks
app.use(express.urlencoded({ extended: false, limit: '10kb' }));

// ─── General Rate Limiting ──────────────────────────
app.use(generalLimiter);

// ─── Trust Proxy (for rate limiting behind reverse proxy) ──
if (env.NODE_ENV === 'production') {
  app.set('trust proxy', 1);
}

// ─── API Routes ─────────────────────────────────────
app.use('/api/v1', routes);

// ─── 404 Handler ────────────────────────────────────
app.use(notFoundHandler);

// ─── Global Error Handler ───────────────────────────
app.use(errorHandler);

// ─── Start Server ───────────────────────────────────
app.listen(env.PORT, () => {
  logger.info(`🚀 MiPlata Server running`, {
    port: env.PORT,
    environment: env.NODE_ENV,
    cors: env.CORS_ORIGIN,
  });
  logger.info('📡 API available at: /api/v1');
  logger.info('Endpoints:');
  logger.info('  POST   /api/v1/auth/register');
  logger.info('  POST   /api/v1/auth/login');
  logger.info('  POST   /api/v1/auth/logout');
  logger.info('  POST   /api/v1/auth/forgot-password');
  logger.info('  POST   /api/v1/auth/reset-password');
  logger.info('  POST   /api/v1/auth/refresh');
  logger.info('  POST   /api/v1/auth/mfa/enroll');
  logger.info('  POST   /api/v1/auth/mfa/challenge');
  logger.info('  POST   /api/v1/auth/mfa/verify');
  logger.info('  POST   /api/v1/auth/mfa/unenroll');
  logger.info('  GET    /api/v1/auth/mfa/factors');
  logger.info('  GET    /api/v1/auth/mfa/assurance-level');
  logger.info('  GET    /api/v1/user/profile');
  logger.info('  PATCH  /api/v1/user/profile');
  logger.info('  DELETE /api/v1/user/account');
  logger.info('  POST   /api/v1/chat');
  logger.info('  GET    /api/v1/health');
});

export default app;
