.PHONY: help install dev test build clean docker-up docker-down

# デフォルトターゲット
help:
	@echo "Available commands:"
	@echo "  make install       - Install all dependencies"
	@echo "  make dev          - Start development environment"
	@echo "  make test         - Run all tests"
	@echo "  make build        - Build all services"
	@echo "  make clean        - Clean build artifacts"
	@echo "  make docker-up    - Start Docker containers"
	@echo "  make docker-down  - Stop Docker containers"

# 依存関係のインストール
install:
	@echo "Installing dependencies..."
	cd apps/web && pnpm install
	cd services/tech-road-api && cargo build
	cd services/tech-library-api && cargo build
	cd services/tech-log-api && cargo build

# 開発環境の起動
dev:
	@echo "Starting development environment..."
	docker-compose -f infrastructure/docker/docker-compose.dev.yml up -d
	@echo "Development environment is running"

# テストの実行
test:
	@echo "Running tests..."
	cd apps/web && pnpm test
	cd services/tech-road-api && cargo test
	cd services/tech-library-api && cargo test
	cd services/tech-log-api && cargo test

# ビルド
build:
	@echo "Building all services..."
	cd apps/web && pnpm build
	cd services/tech-road-api && cargo build --release
	cd services/tech-library-api && cargo build --release
	cd services/tech-log-api && cargo build --release

# クリーンアップ
clean:
	@echo "Cleaning build artifacts..."
	rm -rf apps/web/build apps/web/.svelte-kit
	cd services/tech-road-api && cargo clean
	cd services/tech-library-api && cargo clean
	cd services/tech-log-api && cargo clean

# Docker環境の起動
docker-up:
	docker-compose -f infrastructure/docker/docker-compose.dev.yml up -d

# Docker環境の停止
docker-down:
	docker-compose -f infrastructure/docker/docker-compose.dev.yml down