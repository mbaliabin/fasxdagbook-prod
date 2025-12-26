# Этап 1: Сборка
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Этап 2: Раздача через Nginx
FROM nginx:stable-alpine
COPY --from=build /app/dist /usr/share/nginx/html

# ОБЯЗАТЕЛЬНО: Копируем ваш полный конфиг
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]