FROM node:22
RUN npm i --global pnpm@9.15.4

WORKDIR /app
COPY . .

# the docs require some packages from root repo therefore
# first we need to install root packages then go do docs directory
RUN cd /app
RUN pnpm install
RUN ls -al

# change dir to docs and build documentation
WORKDIR /app/docs
RUN ls -al
RUN pwd
RUN pnpm install
RUN pnpm build:clean

EXPOSE 8080
CMD ["pnpm", "run", "start", "-p", "8080"]
