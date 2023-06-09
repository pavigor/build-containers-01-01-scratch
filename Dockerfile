# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o /go/bin/app.bin cmd/main.go
RUN adduser -S -u 1001 appuser

FROM scratch

COPY --from=build /go/bin/app.bin /
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build --chown=1001 /go/src/app/upload /uploads

USER appuser

EXPOSE 9999

VOLUME /uploads

ENTRYPOINT ["/app.bin"]