FROM node:alpine as build

ARG HUGO_VERSION=0.103.1

# Get Hugo
RUN apk add gcompat
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz /hugo.tar.gz
RUN tar -zxvf hugo.tar.gz
RUN /hugo version

# Install Node Modules
WORKDIR /site
COPY /src/package*.json ./
RUN npm i

# Build Hugo
COPY /src /site
RUN /hugo --minify

#Copy static files to Nginx
FROM nginx:alpine
COPY --from=build /site/public /usr/share/nginx/html
WORKDIR /usr/share/nginx/html