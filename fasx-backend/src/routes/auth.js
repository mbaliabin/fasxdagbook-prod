import express from 'express';
import { register, login, logout, verifyEmail } from '../controllers/authController.js'; // Добавили logout
import { getMe } from '../controllers/userController.js';
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = express.Router();

router.post('/register', register);
router.post('/login', login);
router.post('/logout', logout); // Новый маршрут для выхода (удаления куки)
router.get('/verify-email', verifyEmail);
router.get('/me', authenticateToken, getMe);

export default router;