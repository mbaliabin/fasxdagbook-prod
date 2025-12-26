FROM node:20

WORKDIR /app

COPY package*.json ./
RUN npm install

# Копируем схему отдельно, чтобы сгенерировать клиент
COPY prisma ./prisma/
RUN npx prisma generate

COPY . .

EXPOSE 5000
CMD ["npm", "run", "dev"]