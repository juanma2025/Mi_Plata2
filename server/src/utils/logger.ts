import { env } from '../config/env.js';

type LogLevel = 'info' | 'warn' | 'error' | 'debug';

/**
 * Simple structured logger that sanitizes sensitive data.
 * In production, this could be replaced with Winston, Pino, etc.
 */
class Logger {
  private isDev = env.NODE_ENV === 'development';

  private format(level: LogLevel, message: string, meta?: Record<string, unknown>): string {
    const timestamp = new Date().toISOString();
    const metaStr = meta ? ` ${JSON.stringify(this.sanitize(meta))}` : '';
    return `[${timestamp}] [${level.toUpperCase()}] ${message}${metaStr}`;
  }

  /**
   * Strips sensitive fields from log metadata to prevent accidental leaks.
   */
  private sanitize(obj: Record<string, unknown>): Record<string, unknown> {
    const sensitiveKeys = [
      'password', 'token', 'access_token', 'refresh_token',
      'authorization', 'cookie', 'secret', 'api_key', 'apikey',
      'supabase_service_role_key', 'gemini_api_key',
    ];

    const sanitized: Record<string, unknown> = {};
    for (const [key, value] of Object.entries(obj)) {
      if (sensitiveKeys.includes(key.toLowerCase())) {
        sanitized[key] = '[REDACTED]';
      } else if (typeof value === 'object' && value !== null && !Array.isArray(value)) {
        sanitized[key] = this.sanitize(value as Record<string, unknown>);
      } else {
        sanitized[key] = value;
      }
    }
    return sanitized;
  }

  info(message: string, meta?: Record<string, unknown>) {
    console.log(this.format('info', message, meta));
  }

  warn(message: string, meta?: Record<string, unknown>) {
    console.warn(this.format('warn', message, meta));
  }

  error(message: string, meta?: Record<string, unknown>) {
    console.error(this.format('error', message, meta));
  }

  debug(message: string, meta?: Record<string, unknown>) {
    if (this.isDev) {
      console.debug(this.format('debug', message, meta));
    }
  }
}

export const logger = new Logger();
