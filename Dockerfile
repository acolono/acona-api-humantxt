FROM golang:alpine AS build
ADD api.go .
RUN go build -v -o /api api.go

FROM node:lts-alpine AS deps
RUN apk add --no-cache git
RUN npm -g install @postlight/parser
COPY mw-data-url.patch /tmp/
RUN cd /usr/local/lib/node_modules/@postlight/parser && git apply -v /tmp/mw-data-url.patch

FROM node:lts-alpine
COPY --from=deps /usr/local/lib/node_modules/@postlight /usr/local/lib/node_modules/@postlight
RUN ln -s ../lib/node_modules/@postlight/parser/cli.js /usr/local/bin/postlight-parser
WORKDIR /app
COPY --from=build /api .
USER node
EXPOSE 8080
CMD /app/api
