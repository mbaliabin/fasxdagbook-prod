import express from "express";
import prisma from "../prisma/client.js";
import { authenticateToken } from "../middleware/authMiddleware.js";

const router = express.Router();

// Вспомогательная функция для поиска диапазона дня
function getDayRange(dateStr) {
  const startOfDay = new Date(dateStr);
  startOfDay.setUTCHours(0, 0, 0, 0);

  const endOfDay = new Date(dateStr);
  endOfDay.setUTCHours(23, 59, 59, 999);

  return { startOfDay, endOfDay };
}

// 1. GET /api/daily-information/range — получить записи за диапазон дат (Добавлено)
router.get("/range", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const { start, end } = req.query;

    if (!userId) return res.status(401).json({ error: "Unauthorized" });
    if (!start || !end) return res.status(400).json({ error: "Missing start or end date" });

    const entries = await prisma.dailyInformation.findMany({
      where: {
        userId,
        date: {
          gte: new Date(start),
          lte: new Date(end),
        },
      },
      orderBy: { date: 'asc' }
    });

    res.json(entries);
  } catch (err) {
    console.error("Error fetching range information:", err);
    res.status(500).json({ error: err.message });
  }
});

// 2. POST /api/daily-information — создать или обновить запись состояния
router.post("/", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;

    if (!userId) {
      return res.status(401).json({ error: "Unauthorized: no userId in token" });
    }

    const { date, mainParam, physical, mental, sleepQuality, pulse, sleepDuration, comment } = req.body;

    if (!date) return res.status(400).json({ error: "Missing date" });

    const { startOfDay, endOfDay } = getDayRange(date);

    let entry = await prisma.dailyInformation.findFirst({
      where: {
        userId,
        date: { gte: startOfDay, lte: endOfDay },
      },
    });

    if (entry) {
      entry = await prisma.dailyInformation.update({
        where: { id: entry.id },
        data: {
          main_param: mainParam,
          physical,
          mental,
          sleep_quality: sleepQuality,
          pulse: pulse ? Number(pulse) : null,
          sleep_duration: sleepDuration,
          comment,
        },
      });
    } else {
      entry = await prisma.dailyInformation.create({
        data: {
          userId,
          date: new Date(date),
          main_param: mainParam,
          physical,
          mental,
          sleep_quality: sleepQuality,
          pulse: pulse ? Number(pulse) : null,
          sleep_duration: sleepDuration,
          comment,
        },
      });
    }

    res.json(entry);
  } catch (error) {
    console.error("Error saving daily information:", error);
    return res.status(500).json({ error: error.message });
  }
});

// 3. GET /api/daily-information?date=YYYY-MM-DD — получить запись состояния по одной дате
router.get("/", authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;
    const dateStr = req.query.date;

    if (!userId) return res.status(401).json({ error: "Unauthorized" });
    if (!dateStr) return res.status(400).json({ error: "Missing date" });

    const { startOfDay, endOfDay } = getDayRange(dateStr);

    const entry = await prisma.dailyInformation.findFirst({
      where: {
        userId,
        date: { gte: startOfDay, lte: endOfDay },
      },
    });

    if (!entry) return res.status(404).json({ error: "Not found" });

    res.json(entry);
  } catch (err) {
    console.error("Error fetching daily information:", err);
    return res.status(500).json({ error: err.message });
  }
});

export default router;
