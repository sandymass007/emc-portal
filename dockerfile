# Dockerfile for EMC Portal
FROM node:18-alpine
WORKDIR /usr/src/app

# copy package files first to leverage caching
COPY app/package*.json ./
RUN npm install --production

# copy app sources
COPY app/ ./

EXPOSE 3000
CMD ["npm", "start"]
