FROM node:22-alpine3.23 AS builder
WORKDIR /app 
COPY package.json .
RUN npm install
COPY *.js .

FROM node:22-alpine3.23 
WORKDIR /app
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
ENV MONGO_URL="mongodb://mongodb:27017/users" \
    REDIS_URL="redis://redis:6379" \
    MONGO=true
COPY --from=builder /app ./
USER roboshop
CMD ["node","server.js"]
