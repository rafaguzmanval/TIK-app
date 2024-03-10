FROM node:20

WORKDIR /app

COPY . .

RUN npm install

RUN npx prisma generate 

EXPOSE 4000

CMD ["npm","run","dev"]