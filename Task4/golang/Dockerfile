# Build stage
FROM golang:alpine as builder
WORKDIR /app
COPY go.mod ./
COPY *.go ./
RUN go build -o /server

# Run stage
FROM alpine
COPY --from=builder /server /server
ENV DEVOPS=bakhtiyork
ENTRYPOINT ["/server"]