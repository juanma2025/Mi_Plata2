import { Router } from 'express';
import * as geminiController from '../controllers/gemini.controller.js';
import { validate } from '../middlewares/validate.middleware.js';
import { requireAuth } from '../middlewares/auth.middleware.js';
import { chatLimiter } from '../middlewares/rateLimiter.middleware.js';
import { chatSchema } from '../schemas/gemini.schemas.js';

const router = Router();

// Chat requires authentication + rate limiting + validation
router.post('/', requireAuth, chatLimiter, validate(chatSchema), geminiController.chat);

export default router;
