FROM golang:alpine AS build
ADD api.go .
RUN go build -v -o /api api.go

FROM node:lts-alpine
RUN apk add --no-cache git
RUN npm -g install @postlight/parser
WORKDIR /app
COPY --from=build /api .
EXPOSE 8080
CMD /app/api