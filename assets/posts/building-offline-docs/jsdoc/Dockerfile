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
RUN ls -al /app/_site


###################################
# Building final image
###################################
FROM nginx:1-alpine3.20

RUN mkdir -p /usr/share/nginx/html
COPY --from=build /app/_site /usr/share/nginx/html
RUN ls -al /usr/share/nginx/html

#RUN echo "include /etc/nginx/config.d/*.conf;" >> /etc/nginx/nginx.conf
COPY nginx-jsdoc.conf /etc/nginx/nginx.conf

EXPOSE 80/tcp

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

# vi: ft=dockerfile
