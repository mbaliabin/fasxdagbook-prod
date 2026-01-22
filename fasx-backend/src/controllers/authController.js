import prisma from '../prisma/client.js';
import { hashPassword, comparePasswords } from '../utils/hash.js';
import jwt from 'jsonwebtoken';
import crypto from 'crypto';
import { sendEmail } from '../utils/sendEmail.js';

export async function login(req, res) {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email и пароль обязательны' });
  }

  try {
    const user = await prisma.user.findUnique({ where: { email } });

    if (!user) {
      return res.status(401).json({ error: 'Неверный email или пароль' });
    }

    if (!user.isVerified) {
      return res.status(403).json({ error: 'Пожалуйста, подтвердите ваш email перед входом' });
    }

    const isValid = await comparePasswords(password, user.password);
    if (!isValid) {
      return res.status(401).json({ error: 'Неверный email или пароль' });
    }

    const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET, {
      expiresIn: '7d',
    });

    res.json({ message: 'Успешный вход', token });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Ошибка сервера при входе' });
  }
}

export async function register(req, res) {
  const { email, name, password } = req.body;

  if (!email || !name || !password) {
    return res.status(400).json({ error: 'Все поля обязательны' });
  }

  try {
    const existingUser = await prisma.user.findUnique({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ error: 'Пользователь с таким email уже существует' });
    }

    const hashedPassword = await hashPassword(password);
    const verificationToken = crypto.randomBytes(32).toString('hex');

    await prisma.user.create({
      data: {
        email,
        name,
        password: hashedPassword,
        isVerified: false,
        verificationToken,
      },
    });

    const verifyUrl = `${process.env.FRONTEND_URL}/api/auth/verify-email?token=${verificationToken}`;

    try {
      await sendEmail({
        to: email,
        subject: 'Подтверждение регистрации FASX',
        html: `
          <div style="background-color: #0f0f0f; padding: 40px 20px; font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif; text-align: center; color: #ffffff;">
            <div style="max-width: 500px; margin: 0 auto; background-color: #131316; border-radius: 24px; padding: 40px; border: 1px solid #262626; box-shadow: 0 20px 40px rgba(0,0,0,0.4);">
              <div style="margin-bottom: 32px; text-align: center;">
                <img src="${process.env.FRONTEND_URL}/favicon.png" width="64" height="64" style="display: inline-block; border-radius: 16px;" alt="FASX" />
              </div>
              <h1 style="font-size: 28px; font-weight: 900; margin: 0 0 16px 0; color: #ffffff;">Добро пожаловать в <span style="color: #3b82f6;">FASX</span></h1>
              <p style="font-size: 16px; line-height: 1.6; color: #a1a1aa; margin-bottom: 32px;">Привет, ${name}! Подтверди свой email для активации аккаунта.</p>
              <a href="${verifyUrl}" style="display: inline-block; background-color: #2563eb; color: #ffffff; padding: 16px 32px; border-radius: 12px; text-decoration: none; font-weight: bold;">Подтвердить аккаунт</a>
            </div>
          </div>
        `
      });
      res.status(201).json({ message: 'Регистрация успешна! Проверьте почту.' });
    } catch (emailError) {
      console.error('Email sending error:', emailError);
      res.status(201).json({ message: 'Аккаунт создан, но не удалось отправить письмо.' });
    }
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ error: 'Ошибка сервера при регистрации' });
  }
}

export async function verifyEmail(req, res) {
  const { token } = req.query;
  if (!token) return res.status(400).send('Токен отсутствует.');

  try {
    const user = await prisma.user.findFirst({ where: { verificationToken: token } });
    if (!user) return res.status(400).send('Неверный или просроченный токен.');

    await prisma.user.update({
      where: { id: user.id },
      data: { isVerified: true, verificationToken: null }
    });

    res.redirect(`${process.env.FRONTEND_URL}/login?verified=true`);
  } catch (error) {
    console.error('Verification error:', error);
    res.status(500).send('Ошибка сервера.');
  }
}

// ДОБАВЛЕНО ТОЛЬКО ЭТО, ЧТОБЫ УБРАТЬ ОШИБКУ ИМПОРТА
export async function logout(req, res) {
  res.status(200).json({ message: 'Logout successful' });
}