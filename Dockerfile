# Stage 1: Build the Go application
FROM golang:1.22-alpine AS builder

# 필요한 패키지 설치
RUN apk add --no-cache git

# 작업 디렉토리 설정
WORKDIR /app

# GitHub에서 특정 태그의 소스 코드 내려받기
ARG GIT_TAG=main
RUN git clone --branch $GIT_TAG https://github.com/San9H0/mediamtx.git .

# Go 애플리케이션 빌드
RUN go generate ./... && go mod tidy && go build -o mediamtx

# Stage 2: Create a lightweight image for running the application
FROM alpine:latest

# 필요한 패키지 설치 (여기서는 Bash만 예로 설치합니다)
RUN apk add --no-cache bash

# 작업 디렉토리 설정
WORKDIR /app

# 빌드한 애플리케이션을 복사
COPY --from=builder /app/mediamtx /app/mediamtx
COPY --from=builder /app/mediamtx.yml /app/mediamtx.yml

# 애플리케이션 실행
CMD ["./mediamtx"]