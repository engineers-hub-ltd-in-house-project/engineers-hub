# Engineers Hub システムアーキテクチャ設計書

## ドキュメント情報

| 項目 | 内容 |
|------|------|
| バージョン | 1.0.0 |
| 作成日 | 2025-06-22 |
| 承認者 | Engineers Hub 株式会社 |
| ステータス | ドラフト |

## 1. システム概要

Engineers Hubは、エンジニアの成長を支援する統合プラットフォームです。以下の3つの主要サービスで構成されています。

- Tech Road: スキルロードマップ管理サービス
- Tech Library: 学習コンテンツ管理サービス  
- Tech Log: 学習・開発履歴管理サービス

## 2. アーキテクチャ方針

### 基本方針
- マイクロサービスアーキテクチャの採用
- サービスごとの独立性を保ちつつ、統合的なユーザー体験を提供
- スケーラビリティとメンテナンス性を重視
- セキュリティファーストの設計

### 技術選定の理由

| 技術 | 選定理由 |
|------|----------|
| Rust/Axum | 高速性、メモリ安全性、型安全性 |
| SvelteKit | 高速なランタイム、優れた開発体験、SSR対応 |
| PostgreSQL | ACID準拠、JSON対応、拡張性 |
| Docker | 環境の一貫性、デプロイの簡易化 |
| AWS | 豊富なサービス、スケーラビリティ |

## 3. システム構成図

```
┌─────────────────────────────────────────────────────────────┐
│                        Engineers Hub                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐       │
│  │  Tech Road  │  │Tech Library │  │  Tech Log   │       │
│  │     Web     │  │     Web     │  │     Web     │       │
│  │ (SvelteKit) │  │ (SvelteKit) │  │ (SvelteKit) │       │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘       │
│         │                 │                 │               │
│         ▼                 ▼                 ▼               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐       │
│  │  Tech Road  │  │Tech Library │  │  Tech Log   │       │
│  │     API     │  │     API     │  │     API     │       │
│  │(Rust/Axum)  │  │(Rust/Axum)  │  │(Rust/Axum)  │       │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘       │
│         │                 │                 │               │
│         └─────────────────┼─────────────────┘               │
│                           ▼                                 │
│                    ┌─────────────┐                         │
│                    │ PostgreSQL  │                         │
│                    │   Database   │                         │
│                    └─────────────┘                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## 4. レイヤーアーキテクチャ

各サービスは以下のレイヤー構造を採用します。

### バックエンド（API）レイヤー構造

```
API Service
├── Presentation Layer (プレゼンテーション層)
│   ├── HTTP Handlers
│   ├── Request/Response DTOs
│   └── Middleware
├── Application Layer (アプリケーション層)
│   ├── Use Cases
│   ├── Application Services
│   └── DTOs
├── Domain Layer (ドメイン層)
│   ├── Entities
│   ├── Value Objects
│   ├── Domain Services
│   └── Repository Interfaces
└── Infrastructure Layer (インフラ層)
    ├── Repository Implementations
    ├── External Services
    └── Database Access
```

### フロントエンド（Web）レイヤー構造

```
Web Application
├── Routes (ルーティング層)
│   └── +page.svelte, +layout.svelte
├── Components (コンポーネント層)
│   ├── UI Components
│   └── Feature Components
├── Services (サービス層)
│   ├── API Clients
│   └── Business Logic
└── Stores (状態管理層)
    └── Svelte Stores
```

## 5. データベース設計

### スキーマ分離戦略
- 各サービスごとにスキーマを分離
- 共通データ（ユーザー情報など）はpublicスキーマに配置
- サービス間のデータ参照は最小限に抑える

### データモデル

```sql
-- Public Schema (共通)
public.users
public.auth_tokens

-- Service Schemas
tech_road.*
tech_library.*
tech_log.*
```

## 6. API設計

### RESTful API設計原則
- リソース指向のURL設計
- 適切なHTTPメソッドの使用
- 一貫したレスポンス形式
- バージョニング戦略（/api/v1/）

### エンドポイント例

```
GET    /api/v1/roadmaps              # ロードマップ一覧
GET    /api/v1/roadmaps/:id          # ロードマップ詳細
POST   /api/v1/roadmaps              # ロードマップ作成
PUT    /api/v1/roadmaps/:id          # ロードマップ更新
DELETE /api/v1/roadmaps/:id          # ロードマップ削除

GET    /api/v1/roadmaps/:id/progress # 進捗状況取得
PUT    /api/v1/roadmaps/:id/progress # 進捗状況更新
```

## 7. 認証・認可

### 認証方式
- JWT (JSON Web Token) を使用
- Access Token + Refresh Token方式
- セキュアなCookie管理

### 認可レベル

| レベル | 説明 |
|--------|------|
| Public | 認証不要 |
| User | 一般ユーザー |
| Admin | 管理者 |

## 8. サービス間通信

### Phase 1: REST API
- 初期フェーズではRESTful APIで実装
- サービス間の直接通信は最小限に
- 必要に応じてAPI Gatewayパターンを検討

### Phase 2: gRPC（将来）
- パフォーマンスが重要な内部通信にgRPCを追加
- Protocol Buffersによる型安全な通信
- 既存のREST APIと共存

## 9. 非機能要件

### パフォーマンス
- API レスポンスタイム: 200ms以下（95パーセンタイル）
- ページロード時間: 3秒以内
- 同時接続数: 1000ユーザー

### 可用性
- 稼働率: 99.5%以上
- 計画メンテナンス時間を除く

### セキュリティ
- HTTPS必須
- SQLインジェクション対策
- XSS対策
- CSRF対策
- 適切なCORS設定

### スケーラビリティ
- 水平スケーリング対応
- ステートレスな設計
- キャッシュ戦略の実装

## 10. 開発・運用環境

### 開発環境
- Docker Composeによるローカル環境
- ホットリロード対応
- テストデータの自動生成

### CI/CD
- GitHub Actions
- 自動テスト実行
- 自動デプロイ（ステージング/本番）

### 監視
- CloudWatchによるログ収集
- メトリクス監視
- アラート設定

## 11. 今後の拡張性

### 考慮事項
- モバイルアプリ対応（API設計で考慮済み）
- GraphQL APIの追加
- リアルタイム機能（WebSocket）
- 国際化対応
- マルチテナント対応