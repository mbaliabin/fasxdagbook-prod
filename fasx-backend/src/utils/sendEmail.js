import nodemailer from 'nodemailer';

export const sendEmail = async (options) => {
  const transporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: parseInt(process.env.SMTP_PORT),
    secure: process.env.SMTP_PORT == 465, 
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
    // КРИТИЧЕСКИ ВАЖНО:
    connectionTimeout: 3000, // 3 секунды на попытку соединения
    greetingTimeout: 3000,   // 3 секунды на приветствие сервера
  });

  return await transporter.sendMail({
    from: `"FASX Dagbook" <${process.env.EMAIL_USER}>`,
    to: options.to,
    subject: options.subject,
    html: options.html,
  });
};