# Tech Road API

Tech Road サービスのバックエンドAPI（Rust/Axum）

## セットアップ

### 必要なツール

- Rust 1.75+
- PostgreSQL 15+
- sqlx-cli

### SQLx CLIのインストール

```bash
cargo install sqlx-cli --no-default-features --features postgres
```

### 環境変数の設定

```bash
cp .env.example .env
# .envファイルを編集して適切な値を設定
```

### データベースのセットアップ

```bash
# データベースの作成
sqlx database create

# マイグレーションの実行
sqlx migrate run
```

### 開発サーバーの起動

```bash
cargo run
```

または、ホットリロード付きで起動：

```bash
cargo watch -x run
```

## API エンドポイント

### ヘルスチェック

```
GET /api/v1/health
```

レスポンス例：
```json
{
  "success": true,
  "data": {
    "status": "healthy",
    "service": "tech-road-api",
    "version": "0.1.0"
  }
}
```

## テスト

```bash
cargo test
```

## ビルド

```bash
cargo build --release
```