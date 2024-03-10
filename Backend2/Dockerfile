FROM node:20

WORKDIR /app

COPY . .

RUN npm install

RUN npx prisma generate 

#RUN npx prisma migrate dev --name init

EXPOSE 4000

CMD ["npm","run","dev"]