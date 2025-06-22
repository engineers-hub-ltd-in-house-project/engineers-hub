# Tech Road API 仕様書

## ドキュメント情報

| 項目 | 内容 |
|------|------|
| バージョン | 1.0.0 |
| 作成日 | 2025-06-22 |
| ベースURL | https://api.engineers-hub-eco-system.com/tech-road/v1 |

## 共通仕様

### リクエストヘッダー

| ヘッダー名 | 必須 | 説明 |
|------------|------|------|
| Authorization | Yes | Bearer {access_token} |
| Content-Type | Yes | application/json |

### レスポンス形式

成功時:
```json
{
  "success": true,
  "data": { ... }
}
```

エラー時:
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "エラーメッセージ",
    "details": { ... }
  }
}
```

### HTTPステータスコード

| コード | 説明 |
|--------|------|
| 200 | 成功 |
| 201 | 作成成功 |
| 400 | 不正なリクエスト |
| 401 | 認証エラー |
| 403 | 権限エラー |
| 404 | リソースが見つからない |
| 500 | サーバーエラー |

## 認証エンドポイント

### ユーザー登録

```
POST /auth/register
```

リクエスト:
```json
{
  "email": "user@example.com",
  "password": "securepassword",
  "username": "johndoe",
  "full_name": "John Doe"
}
```

レスポンス:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "email": "user@example.com",
      "username": "johndoe",
      "full_name": "John Doe"
    },
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIs..."
  }
}
```

### ログイン

```
POST /auth/login
```

リクエスト:
```json
{
  "email": "user@example.com",
  "password": "securepassword"
}
```

### トークンリフレッシュ

```
POST /auth/refresh
```

リクエスト:
```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIs..."
}
```

## ロードマップエンドポイント

### ロードマップ一覧取得

```
GET /roadmaps
```

クエリパラメータ:

| パラメータ | 型 | 説明 |
|------------|-----|------|
| category | string | カテゴリでフィルタ |
| level | string | レベルでフィルタ |
| is_official | boolean | 公式のみ表示 |
| page | number | ページ番号 |
| limit | number | 1ページあたりの件数 |

レスポンス:
```json
{
  "success": true,
  "data": {
    "roadmaps": [
      {
        "id": "550e8400-e29b-41d4-a716-446655440000",
        "title": "フロントエンド開発者ロードマップ",
        "description": "Webフロントエンド開発者になるための学習パス",
        "category": "frontend",
        "level": "beginner",
        "is_official": true,
        "created_by": {
          "id": "user-id",
          "username": "admin"
        },
        "node_count": 25,
        "estimated_duration": "6 months",
        "created_at": "2025-06-22T10:00:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 100,
      "pages": 5
    }
  }
}
```

### ロードマップ詳細取得

```
GET /roadmaps/{roadmap_id}
```

レスポンス:
```json
{
  "success": true,
  "data": {
    "roadmap": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "title": "フロントエンド開発者ロードマップ",
      "description": "Webフロントエンド開発者になるための学習パス",
      "category": "frontend",
      "level": "beginner",
      "is_official": true,
      "nodes": [
        {
          "id": "node-1",
          "title": "HTML基礎",
          "description": "HTMLの基本的なタグと構造を学ぶ",
          "position": { "x": 100, "y": 100 },
          "node_type": "skill",
          "prerequisites": [],
          "resources": [
            {
              "title": "MDN HTML Guide",
              "url": "https://developer.mozilla.org/ja/docs/Web/HTML",
              "type": "article"
            }
          ]
        }
      ],
      "created_at": "2025-06-22T10:00:00Z",
      "updated_at": "2025-06-22T10:00:00Z"
    }
  }
}
```

### ロードマップ作成

```
POST /roadmaps
```

リクエスト:
```json
{
  "title": "カスタムロードマップ",
  "description": "個人用の学習ロードマップ",
  "category": "backend",
  "level": "intermediate",
  "is_official": false,
  "nodes": [
    {
      "title": "Node.js基礎",
      "description": "Node.jsの基本を学ぶ",
      "position": { "x": 100, "y": 100 },
      "node_type": "skill"
    }
  ]
}
```

### ロードマップ更新

```
PUT /roadmaps/{roadmap_id}
```

### ロードマップ削除

```
DELETE /roadmaps/{roadmap_id}
```

## 進捗管理エンドポイント

### ユーザー進捗取得

```
GET /roadmaps/{roadmap_id}/progress
```

レスポンス:
```json
{
  "success": true,
  "data": {
    "progress": {
      "roadmap_id": "550e8400-e29b-41d4-a716-446655440000",
      "user_id": "user-id",
      "overall_progress": 45.5,
      "started_at": "2025-05-01T10:00:00Z",
      "last_updated": "2025-06-22T10:00:00Z",
      "node_progress": [
        {
          "node_id": "node-1",
          "status": "completed",
          "started_at": "2025-05-01T10:00:00Z",
          "completed_at": "2025-05-05T15:30:00Z",
          "notes": "HTMLの基礎を理解した"
        },
        {
          "node_id": "node-2",
          "status": "in_progress",
          "started_at": "2025-05-06T09:00:00Z",
          "completed_at": null,
          "notes": null
        }
      ]
    }
  }
}
```

### ノード進捗更新

```
PUT /roadmaps/{roadmap_id}/nodes/{node_id}/progress
```

リクエスト:
```json
{
  "status": "completed",
  "notes": "CSSフレックスボックスをマスターした"
}
```

### 進捗リセット

```
DELETE /roadmaps/{roadmap_id}/progress
```

## ユーザープロファイルエンドポイント

### プロファイル取得

```
GET /users/me
```

レスポンス:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "email": "user@example.com",
      "username": "johndoe",
      "full_name": "John Doe",
      "avatar_url": "https://example.com/avatar.jpg",
      "current_level": "intermediate",
      "target_position": "フルスタックエンジニア",
      "available_hours_per_week": 10,
      "created_at": "2025-01-01T00:00:00Z"
    }
  }
}
```

### プロファイル更新

```
PUT /users/me
```

リクエスト:
```json
{
  "full_name": "John Doe Updated",
  "current_level": "advanced",
  "target_position": "テックリード",
  "available_hours_per_week": 15
}
```

## 統計エンドポイント

### ユーザー統計取得

```
GET /users/me/stats
```

レスポンス:
```json
{
  "success": true,
  "data": {
    "stats": {
      "total_roadmaps": 5,
      "completed_roadmaps": 2,
      "in_progress_roadmaps": 3,
      "total_nodes_completed": 45,
      "learning_streak": 15,
      "total_learning_hours": 120,
      "strongest_category": "frontend",
      "recent_achievements": [
        {
          "type": "roadmap_completed",
          "title": "React開発者ロードマップ完了",
          "achieved_at": "2025-06-20T10:00:00Z"
        }
      ]
    }
  }
}
```

## エラーコード一覧

| コード | 説明 |
|--------|------|
| AUTH_INVALID_CREDENTIALS | 認証情報が無効 |
| AUTH_TOKEN_EXPIRED | トークンの有効期限切れ |
| VALIDATION_ERROR | バリデーションエラー |
| RESOURCE_NOT_FOUND | リソースが見つからない |
| PERMISSION_DENIED | 権限がない |
| DUPLICATE_ENTRY | 重複エントリ |
| INTERNAL_SERVER_ERROR | サーバー内部エラー |