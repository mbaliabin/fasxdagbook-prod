FROM node:20
WORKDIR /app
COPY package*.json ./
RUN npm install
# Генерируем клиент ДО копирования всего остального кода
COPY prisma ./prisma/
RUN npx prisma generate
COPY . .
EXPOSE 5000
CMD ["npm", "run", "dev"]