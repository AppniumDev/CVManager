FROM node:18.7.0-alpine3.15 AS builder

# Create app directory
WORKDIR /app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./
# COPY prisma ./prisma/

# Install app dependencies
RUN npm install

COPY . .

RUN npm run build

# Set production ENV
ENV NODE_ENV production

FROM node:18.7.0-alpine3.15

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist

EXPOSE 4000

CMD [ "npm", "run", "start:prod" ]