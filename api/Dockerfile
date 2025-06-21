
FROM node:22-alpine

RUN apk update && \
    apk upgrade && \
    apk add --no-cache dumb-init && \
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

USER nodejs

EXPOSE 8080

ENTRYPOINT ["dumb-init", "--"]
CMD [ "node", "app.js", "--host", "0.0.0.0" ]