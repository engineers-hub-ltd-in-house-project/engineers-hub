# Engineers Hub ドメインモデル設計書

## ドキュメント情報

| 項目 | 内容 |
|------|------|
| バージョン | 1.0.0 |
| 作成日 | 2025-06-22 |
| 承認者 | Engineers Hub 株式会社 |
| ステータス | ドラフト |

## 1. ドメイン概要

Engineers Hubプラットフォームは、エンジニアの成長を支援するために以下の主要ドメインで構成されています。

## 2. 共通ドメインモデル

### User（ユーザー）

```rust
// エンティティ
struct User {
    id: UserId,
    email: Email,
    username: Username,
    full_name: Option<String>,
    avatar_url: Option<Url>,
    created_at: DateTime,
    updated_at: DateTime,
}

// 値オブジェクト
struct UserId(Uuid);
struct Email(String);  // バリデーション付き
struct Username(String); // 一意性保証
```

## 3. Tech Road ドメインモデル

### Roadmap（ロードマップ）

```rust
// エンティティ
struct Roadmap {
    id: RoadmapId,
    title: String,
    description: Option<String>,
    category: Category,
    level: SkillLevel,
    created_by: UserId,
    is_official: bool,
    nodes: Vec<RoadmapNode>,
    created_at: DateTime,
    updated_at: DateTime,
}

// 値オブジェクト
enum Category {
    Frontend,
    Backend,
    Mobile,
    DevOps,
    DataScience,
    Security,
    Other(String),
}

enum SkillLevel {
    Beginner,
    Intermediate,
    Advanced,
    Expert,
}
```

### RoadmapNode（ロードマップノード）

```rust
struct RoadmapNode {
    id: NodeId,
    roadmap_id: RoadmapId,
    title: String,
    description: Option<String>,
    position: Position,
    node_type: NodeType,
    prerequisites: Vec<NodeId>,
    resources: Vec<ResourceLink>,
}

struct Position {
    x: i32,
    y: i32,
}

enum NodeType {
    Skill,      // スキル習得
    Milestone,  // マイルストーン
    Optional,   // オプション
}
```

### UserProgress（ユーザー進捗）

```rust
struct UserProgress {
    id: ProgressId,
    user_id: UserId,
    roadmap_id: RoadmapId,
    node_progress: HashMap<NodeId, NodeProgress>,
    started_at: DateTime,
    last_updated: DateTime,
}

struct NodeProgress {
    node_id: NodeId,
    status: ProgressStatus,
    started_at: Option<DateTime>,
    completed_at: Option<DateTime>,
    notes: Option<String>,
}

enum ProgressStatus {
    NotStarted,
    InProgress,
    Completed,
    Skipped,
}
```

## 4. Tech Library ドメインモデル

### Content（コンテンツ）

```rust
struct Content {
    id: ContentId,
    title: String,
    description: Option<String>,
    content_type: ContentType,
    difficulty_level: DifficultyLevel,
    estimated_time: Duration, // 分単位
    url: Option<Url>,
    content_body: Option<String>,
    tags: Vec<Tag>,
    created_by: UserId,
    created_at: DateTime,
    updated_at: DateTime,
}

enum ContentType {
    Article,
    Video,
    Tutorial,
    Course,
    Book,
    Podcast,
}

enum DifficultyLevel {
    Beginner,
    Intermediate,
    Advanced,
}

struct Tag(String);
```

### ContentRating（コンテンツ評価）

```rust
struct ContentRating {
    id: RatingId,
    content_id: ContentId,
    user_id: UserId,
    rating: Rating,  // 1-5
    review: Option<String>,
    created_at: DateTime,
}

struct Rating(u8); // 1-5の範囲でバリデーション
```

### LearningPath（学習パス）

```rust
struct LearningPath {
    id: PathId,
    title: String,
    description: Option<String>,
    contents: Vec<ContentId>,
    estimated_total_time: Duration,
    created_by: UserId,
    tags: Vec<Tag>,
}
```

## 5. Tech Log ドメインモデル

### LearningLog（学習ログ）

```rust
struct LearningLog {
    id: LogId,
    user_id: UserId,
    title: String,
    description: Option<String>,
    learning_type: LearningType,
    duration: Duration,
    technologies: Vec<Technology>,
    understanding_level: UnderstandingLevel, // 1-5
    resources_used: Vec<ResourceLink>,
    created_at: DateTime,
}

enum LearningType {
    Study,      // 学習
    Practice,   // 実践
    Project,    // プロジェクト
    Review,     // 復習
}

struct Technology(String);
struct UnderstandingLevel(u8); // 1-5
```

### ProjectLog（プロジェクトログ）

```rust
struct ProjectLog {
    id: ProjectLogId,
    user_id: UserId,
    project_name: String,
    description: Option<String>,
    technologies: Vec<Technology>,
    role: Option<String>,
    team_size: Option<u32>,
    duration: ProjectDuration,
    achievements: Vec<String>,
    challenges: Vec<String>,
    solutions: Vec<String>,
    repository_url: Option<Url>,
    demo_url: Option<Url>,
    created_at: DateTime,
    updated_at: DateTime,
}

struct ProjectDuration {
    start_date: Date,
    end_date: Option<Date>,
}
```

### SkillSnapshot（スキルスナップショット）

```rust
struct SkillSnapshot {
    id: SnapshotId,
    user_id: UserId,
    skills: HashMap<Technology, SkillLevel>,
    generated_at: DateTime,
    total_learning_hours: Duration,
    projects_completed: u32,
}
```

## 6. ドメインサービス

### ProgressCalculator（進捗計算サービス）

```rust
trait ProgressCalculator {
    fn calculate_roadmap_progress(&self, user_progress: &UserProgress) -> f32;
    fn calculate_estimated_completion(&self, user_progress: &UserProgress) -> Option<DateTime>;
    fn suggest_next_nodes(&self, user_progress: &UserProgress) -> Vec<NodeId>;
}
```

### ContentRecommender（コンテンツ推薦サービス）

```rust
trait ContentRecommender {
    fn recommend_for_node(&self, node: &RoadmapNode) -> Vec<Content>;
    fn recommend_for_user(&self, user_id: UserId) -> Vec<Content>;
    fn find_similar_contents(&self, content_id: ContentId) -> Vec<Content>;
}
```

### SkillAnalyzer（スキル分析サービス）

```rust
trait SkillAnalyzer {
    fn analyze_skill_gaps(&self, current: &SkillSnapshot, target: &Roadmap) -> SkillGapReport;
    fn generate_skill_snapshot(&self, user_logs: &[LearningLog]) -> SkillSnapshot;
    fn calculate_skill_growth(&self, snapshots: &[SkillSnapshot]) -> GrowthReport;
}
```

## 7. リポジトリインターフェース

### UserRepository

```rust
trait UserRepository {
    async fn find_by_id(&self, id: UserId) -> Result<Option<User>>;
    async fn find_by_email(&self, email: &Email) -> Result<Option<User>>;
    async fn save(&self, user: &User) -> Result<()>;
    async fn delete(&self, id: UserId) -> Result<()>;
}
```

### RoadmapRepository

```rust
trait RoadmapRepository {
    async fn find_by_id(&self, id: RoadmapId) -> Result<Option<Roadmap>>;
    async fn find_by_category(&self, category: Category) -> Result<Vec<Roadmap>>;
    async fn find_official(&self) -> Result<Vec<Roadmap>>;
    async fn save(&self, roadmap: &Roadmap) -> Result<()>;
}
```

## 8. ドメインイベント

### イベント定義

```rust
enum DomainEvent {
    // User Events
    UserRegistered { user_id: UserId, email: Email },
    UserProfileUpdated { user_id: UserId },
    
    // Roadmap Events
    RoadmapCreated { roadmap_id: RoadmapId, created_by: UserId },
    NodeCompleted { user_id: UserId, node_id: NodeId, roadmap_id: RoadmapId },
    RoadmapCompleted { user_id: UserId, roadmap_id: RoadmapId },
    
    // Content Events
    ContentCreated { content_id: ContentId, created_by: UserId },
    ContentRated { content_id: ContentId, user_id: UserId, rating: Rating },
    
    // Learning Events
    LearningLogCreated { log_id: LogId, user_id: UserId },
    ProjectCompleted { project_id: ProjectLogId, user_id: UserId },
    SkillLevelAchieved { user_id: UserId, skill: Technology, level: SkillLevel },
}
```

## 9. ビジネスルール

### ロードマップ関連
- 公式ロードマップは管理者のみ作成可能
- ノードの削除は依存関係を考慮
- 進捗は前提ノードの完了が必要

### コンテンツ関連
- 評価は1ユーザー1コンテンツにつき1回のみ
- コンテンツの削除は作成者または管理者のみ
- タグは最大10個まで

### 学習ログ関連
- 学習時間は24時間を超えない
- プロジェクト期間は開始日より終了日が後
- スキルレベルは段階的に上昇

## 10. 集約境界

### Tech Road 集約
- Roadmap（集約ルート）
  - RoadmapNode
- UserProgress（集約ルート）
  - NodeProgress

### Tech Library 集約
- Content（集約ルート）
- ContentRating（独立）
- LearningPath（集約ルート）

### Tech Log 集約
- LearningLog（集約ルート）
- ProjectLog（集約ルート）
- SkillSnapshot（集約ルート）