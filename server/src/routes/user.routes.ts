import { Router } from 'express';
import * as userController from '../controllers/user.controller.js';
import { validate } from '../middlewares/validate.middleware.js';
import { requireAuth, requireMfa } from '../middlewares/auth.middleware.js';
import { updateProfileSchema, onboardingSchema } from '../schemas/user.schemas.js';

const router = Router();

// All user routes require authentication
router.use(requireAuth);

// ─── Profile Routes ─────────────────────────────────
router.get('/profile', userController.getProfile);
router.patch('/profile', validate(updateProfileSchema), userController.updateProfile);
router.post('/onboarding', validate(onboardingSchema), userController.saveOnboarding);

// ─── Destructive: requires MFA if enabled ───────────
router.delete('/account', requireMfa, userController.deleteAccount);

export default router;
