FROM node:lts-alpine AS build-stage

WORKDIR /usr/src/app

# Install dependencies
COPY .npmrc ./
COPY package.json ./
COPY tsconfig.json ./
RUN npm install

# Build the application
COPY ./src ./src
RUN npm run build

FROM node:lts-alpine

WORKDIR /usr/src/app

ENV NODE_ENV=production

# Install dependencies
COPY .npmrc ./
COPY package.json ./
RUN npm install

# Copy the application from stage build
COPY --from=build-stage /usr/src/app/dist ./dist

# Copy the default configuration file
COPY config.json ./config.json

# Install ping
RUN apk update && apk add iputils 

# Expose default ports
EXPOSE 4028
EXPOSE 80
EXPOSE 443
EXPOSE 9000

CMD npm start



