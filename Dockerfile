#Build stage
FROM golang:1.21.6-alpine3.19 AS builder
WORKDIR /app
COPY . .
RUN go build -o main main.go

#Run stage
FROM alpine:3.19
WORKDIR /app
COPY --from=builder /app/main .
COPY app.env /app/app.env
COPY start.sh /app/start.sh
COPY wait-for.sh /app/wait-for.sh
COPY db/migration ./db/migration

EXPOSE 3000
CMD ["/app/main"]
ENTRYPOINT ["/app/wait-for.sh", "postgres:5432", "--", "/app/start.sh"]