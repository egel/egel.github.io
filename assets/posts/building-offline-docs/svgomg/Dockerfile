###################################
# build compilation image
###################################
FROM node:22 AS build

WORKDIR /app

COPY ./package.json /app/package.json
COPY ./package-lock.json /app/package-lock.json

RUN npm install

# copy rest of files and build
COPY . .
RUN npm run build
RUN ls -al /app/build


###################################
# Building final image
###################################
FROM nginx:1-alpine3.20

RUN mkdir -p /usr/share/nginx/html
COPY --from=build /app/build /usr/share/nginx/html
RUN ls -al /usr/share/nginx/html

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80/tcp

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

# vi: ft=dockerfile
