FROM golang:1.14 as build

WORKDIR /go/src/app
COPY src/ .

RUN go get -d -v ./...
RUN go install -v ./...
RUN go build -o /go/bin/app

# Use a distroless image to save space
FROM gcr.io/distroless/base
COPY --from=build /go/bin/app /
EXPOSE 80
CMD ["/app"]
