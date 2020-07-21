# Build the binary
FROM reg.docker.alibaba-inc.com/sigma/golang:1.12.13 as builder

WORKDIR /go/src/tektontest
COPY . .

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o main main.go

# Copy the binary conf static into an image
FROM reg.docker.alibaba-inc.com/alibase/alios7u2-min
#FROM reg.docker.alibaba-inc.com/leadout/centos7-go1.10.3:1.0.0-1202619-20190605212543

RUN mkdir -p /home/admin

WORKDIR /home/admin
COPY --from=builder /go/src/tektontest/main /home/admin/

RUN chmod +x /home/admin/main

ENTRYPOINT ["cd /home/admin && ./main"]
