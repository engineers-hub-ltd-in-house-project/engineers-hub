# Engineers Hub Platform

Engineers Hub株式会社が提供するエンジニア成長支援プラットフォーム「Tech Road/Library/Log」のモノレポジトリです。

## プロジェクト構造

```
engineers-hub/
├── services/               # 各サービス（フロントエンド＋バックエンド）
│   ├── tech-road/
│   │   ├── web/           # Tech Road Webアプリ (SvelteKit)
│   │   └── api/           # Tech Road API (Rust/Axum)
│   ├── tech-library/
│   │   ├── web/           # Tech Library Webアプリ
│   │   └── api/           # Tech Library API
│   └── tech-log/
│       ├── web/           # Tech Log Webアプリ
│       └── api/           # Tech Log API
├── packages/               # 共有パッケージ
│   ├── ui/                # 共通UIコンポーネント
│   ├── shared/            # 共通ユーティリティ
│   └── proto/             # gRPC定義ファイル（将来用）
├── infrastructure/         # インフラ構成
│   ├── docker/            # Docker関連ファイル
│   ├── terraform/         # AWS構成（Terraform）
│   └── k8s/               # Kubernetes設定
└── docs/                  # ドキュメント
    ├── requirements/      # 要件定義
    ├── planning/          # 開発計画
    ├── architecture/      # アーキテクチャ設計
    └── api/              # API仕様書
```

## 技術スタック

### フロントエンド
| カテゴリ | 技術 |
|---|---|
| Framework | SvelteKit |
| Build Tool | Vite |
| UI Library | Svelte |
| Styling | TailwindCSS (予定) |
| State Management | Svelte Stores |

### バックエンド
| カテゴリ | 技術 |
|---|---|
| 言語 | Rust |
| Web Framework | Axum |
| Database Access | sqlx |
| API | RESTful API + gRPC (サービス間通信) |
| Database | PostgreSQL |

### インフラストラクチャ
| カテゴリ | 技術 |
|---|---|
| Cloud | AWS |
| Container | Docker |
| Orchestration | ECS or EKS |
| CI/CD | GitHub Actions |

## 開発環境セットアップ

```bash
# 依存関係のインストール
make install

# 開発環境の起動
make dev

# テストの実行
make test
```

## サービス概要

### Tech Road
エンジニアのスキルレベル別・職種別のロードマップを提供し、個人の成長をサポートするサービス。

### Tech Library
学習コンテンツの管理・提供を行うサービス。記事、動画、チュートリアルなどを統合的に管理。

### Tech Log
エンジニアの学習履歴・開発経験を記録し、成長を可視化するサービス。