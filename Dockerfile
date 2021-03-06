FROM node:8-alpine

LABEL maintainer="Tom Bartindale <tom.bartindale@ncl.ac.uk>"

RUN mkdir -p /usr/src/app && npm i -g grunt-cli nodemon --silent

WORKDIR /usr/src/app

COPY package.json /usr/src/app/

RUN apk add --no-cache --update --repository http://dl-3.alpinelinux.org/alpine/edge/testing \
	git python gcc g++ make && \
	npm install --production --silent && \
	apk del git gcc g++ make python && \
	rm -rf /var/cache/apk/*

COPY . /usr/src/app

EXPOSE 1337

RUN grunt buildProd && mkdir -p /usr/src/app/upload/ && rm -R /usr/src/app/assets/music/ && rm /usr/src/app/Gruntfile.js && rm -R /usr/src/app/tasks

VOLUME ["/usr/src/app/www","/usr/src/app/data","/usr/src/app/assets"]

CMD [ "npm", "start" ]