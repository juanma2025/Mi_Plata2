import rateLimit from 'express-rate-limit';
import { env } from '../config/env.js';

/**
 * General rate limiter — applies to all routes.
 */
export const generalLimiter = rateLimit({
  windowMs: env.RATE_LIMIT_WINDOW_MS,
  max: env.RATE_LIMIT_MAX_REQUESTS,
  standardHeaders: 'draft-7',
  legacyHeaders: false,
  message: {
    success: false,
    error: 'Demasiadas solicitudes. Intenta de nuevo más tarde.',
  },
});

/**
 * Strict rate limiter — for login, register, and sensitive auth endpoints.
 * 10 attempts per 15 minutes.
 */
export const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 10,
  standardHeaders: 'draft-7',
  legacyHeaders: false,
  message: {
    success: false,
    error: 'Demasiados intentos de autenticación. Intenta de nuevo en 15 minutos.',
  },
  keyGenerator: (req) => {
    // Use X-Forwarded-For in production behind a proxy, otherwise IP
    return req.ip ?? req.socket.remoteAddress ?? 'unknown';
  },
});

/**
 * Gemini chatbot rate limiter — prevent abuse.
 * 30 messages per 15 minutes per user.
 */
export const chatLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 30,
  standardHeaders: 'draft-7',
  legacyHeaders: false,
  message: {
    success: false,
    error: 'Has alcanzado el límite de mensajes. Intenta de nuevo más tarde.',
  },
  keyGenerator: (req) => {
    return req.ip ?? req.socket.remoteAddress ?? 'unknown';
  },
});
