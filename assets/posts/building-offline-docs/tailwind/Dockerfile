FROM ubuntu

RUN apt update && apt upgrade -y
RUN apt install -y ca-certificates curl gnupg nodejs npm chromium

WORKDIR /app

COPY ./package.json /app/package.json
COPY ./package-lock.json /app/package-lock.json

RUN npm install
COPY . .
RUN npm run build

EXPOSE 8080
CMD ["npm", "run", "start", "--", "--port", "8080"]
