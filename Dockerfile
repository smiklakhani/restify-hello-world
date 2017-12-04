# Docker file to test the hello-world example

#FROM mhart/alpine-node:8
FROM node:8-alpine
#FROM node:8

RUN npm install pm2 -g

WORKDIR /app
ADD . .

RUN npm install

EXPOSE 8080

CMD [ "pm2-docker", "index.js" ]
