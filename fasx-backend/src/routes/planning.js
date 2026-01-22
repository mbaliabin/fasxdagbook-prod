import { Router } from 'express';
import { PrismaClient } from '@prisma/client';
import { authenticateToken } from '../middleware/authMiddleware.js';

const router = Router();
const prisma = new PrismaClient();

// 1. ПОЛУЧЕНИЕ ВСЕХ ПЛАНОВ ПОЛЬЗОВАТЕЛЯ
router.get('/', authenticateToken, async (req, res) => {
  try {
    const userId = String(req.user.userId);
    const plans = await prisma.planning.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' }
    });
    res.json(plans);
  } catch (error) {
    console.error('Error fetching plans:', error);
    res.status(500).json({ error: error.message });
  }
});

// 2. СОЗДАНИЕ НОВОГО ПЛАНА
router.post('/create', authenticateToken, async (req, res) => {
  try {
    const { name, startDate, endDate, goal } = req.body;
    const userId = String(req.user.userId);

    if (!name) return res.status(400).json({ error: 'Название плана обязательно' });

    const newPlan = await prisma.planning.create({
      data: {
        name,
        userId,
        isActive: false,
        goal: goal || "",
        startDate: startDate ? new Date(startDate) : new Date('2026-01-01'),
        endDate: endDate ? new Date(endDate) : new Date('2026-12-31'),
      }
    });
    res.status(201).json(newPlan);
  } catch (error) {
    console.error('Error creating plan:', error);
    res.status(500).json({ error: 'Ошибка БД. Проверьте миграции (goal, startDate, endDate)' });
  }
});

// 3. СОХРАНЕНИЕ / ОБНОВЛЕНИЕ СТРОКИ
router.post('/save-row', authenticateToken, async (req, res) => {
  try {
    const { tableName, label, values, isDouble, planId } = req.body;
    const userId = String(req.user.userId);

    if (!planId || planId === 'undefined' || planId === 'null') {
      return res.status(400).json({ error: 'planId is missing' });
    }

    const result = await prisma.planningRow.upsert({
      where: {
        userId_tableName_label_planId: { 
          userId, 
          tableName: String(tableName), 
          label: String(label), 
          planId: String(planId) 
        }
      },
      update: { 
        values: values.map(v => Number(v)),
        isDouble: !!isDouble // Обновляем флаг на случай изменения типа таблицы
      },
      create: { 
        userId, 
        tableName: String(tableName), 
        label: String(label), 
        values: values.map(v => Number(v)), 
        planId: String(planId),
        isDouble: !!isDouble 
      }
    });
    res.json(result);
  } catch (error) {
    console.error('Error in save-row:', error);
    res.status(500).json({ error: 'Database error' });
  }
});

// 4. СОХРАНЕНИЕ ЗАМЕТКИ
router.post('/save-note', authenticateToken, async (req, res) => {
  try {
    const { tableName, month, text, planId } = req.body;
    const userId = String(req.user.userId);

    const result = await prisma.planningNote.upsert({
      where: {
        userId_tableName_month_planId: { userId, tableName, month, planId }
      },
      update: { text },
      create: { userId, tableName, month, text, planId }
    });
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 5. ПОЛУЧЕНИЕ ДАННЫХ (УНИВЕРСАЛЬНЫЙ - ДЛЯ ТАБЛИЦ И СВЕРКИ)
router.get('/data', authenticateToken, async (req, res) => {
  try {
    const { tableName, planId } = req.query;
    const userId = String(req.user.userId);

    if (!planId || planId === 'undefined') {
      return res.status(400).json({ error: 'planId is required' });
    }

    const plan = await prisma.planning.findUnique({
      where: { id: String(planId) }
    });

    if (!plan) return res.status(404).json({ error: 'План не найден' });

    // ЛОГИКА ФИЛЬТРАЦИИ:
    // Если tableName указан - фильтруем по нему (для конкретной таблицы)
    // Если tableName НЕ указан - отдаем ВСЕ строки плана (для страницы Сверки)
    const rowQuery = { userId, planId: String(planId) };
    if (tableName && tableName !== 'undefined') {
      rowQuery.tableName = String(tableName);
    }

    const [rows, notes] = await Promise.all([
      prisma.planningRow.findMany({ where: rowQuery }),
      prisma.planningNote.findMany({ where: rowQuery })
    ]);

    res.json({ 
      startDate: plan.startDate, 
      endDate: plan.endDate,
      name: plan.name,
      goal: plan.goal || "",
      rows: rows || [], 
      notes: notes || [] 
    });
  } catch (error) {
    console.error('Error fetching data:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// 6. ПЕРЕКЛЮЧЕНИЕ АКТИВНОГО ПЛАНА
router.patch('/:id/set-active', authenticateToken, async (req, res) => {
  try {
    const userId = String(req.user.userId);
    const planId = req.params.id;

    await prisma.$transaction([
      prisma.planning.updateMany({ where: { userId }, data: { isActive: false } }),
      prisma.planning.update({ where: { id: planId }, data: { isActive: true } })
    ]);

    res.json({ message: 'План активирован' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 7. УДАЛЕНИЕ ПЛАНА
router.delete('/:id', authenticateToken, async (req, res) => {
  try {
    const planId = req.params.id;
    const userId = String(req.user.userId);
    await prisma.planning.delete({ where: { id: planId, userId } });
    res.json({ message: 'План удален' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

export default router;