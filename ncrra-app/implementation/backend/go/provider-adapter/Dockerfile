# Agreement-gated NCRRA provider adapter. Runtime receives no live provider credential by default.
FROM golang:1.27-alpine AS build
WORKDIR /src
COPY go.mod ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags='-s -w' -o /out/provider-adapter ./cmd/provider-adapter

FROM alpine:3.20
COPY --from=build /out/provider-adapter /provider-adapter
USER 65534:65534
EXPOSE 8080
ENTRYPOINT ["/provider-adapter"]
