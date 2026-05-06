# ai-skills

Claude Code / Codex 共通のグローバルスキル置き場。`home/shared/ai-skills/` は `~/.claude/skills/` と `~/.codex/skills/` の両方に symlink される。

## プロダクト開発ワークフロー

speckit に渡す前段（カスタマージャーニー / 要求定義）を多視点レビューで作り込むためのスキル群。各スキルが成果物を生成し、次のスキルがそれを読むパイプライン。**スキル自体はグローバルに 1 つだけ存在し、成果物は各プロダクトリポジトリの `docs/` 配下に書き出される。**

レイアウトは `shao-may` 型に統一する。具体的には:

- `docs/current/` を **正本（living docs）** として扱う
- `docs/features/<NNN-slug>/` は **そのときの初期インプットと履歴スナップショット**
- `docs/decisions/` は **長く残す ADR**
- 初期立ち上げも feature 001 として扱う（スキルの動作は常に feature scope）

### 全体図

```
[初期立ち上げ = feature 001]
  /feature-start <slug>          → docs/features/001-<slug>/proposal.md（新規プロダクトなら "proposal" 不要、空でも可）
  /product-discovery <slug>      → docs/features/001-<slug>/discovery.md
  /product-journey <slug>        → docs/current/journey.md（新規作成）
  /product-business-model <slug> → docs/features/001-<slug>/business-model.md
  /product-requirements <slug>   → docs/current/requirements.md（新規作成）
       │
       ├─ /product-review-cto <slug>      → docs/features/001-<slug>/reviews/cto.md
       ├─ /product-review-designer <slug> → docs/features/001-<slug>/reviews/designer.md
       └─ /product-review-pm <slug>       → docs/features/001-<slug>/reviews/pm.md
       │
  /product-refine <slug>         → docs/current/product-brief.md（journey/requirements への Upstream Updates も提案）
       │
       ├─ （任意）/product-pitch <slug>   → docs/features/001-<slug>/pitch.md
       │
  /product-handoff <slug>        → docs/features/001-<slug>/speckit-input.md, docs/current/constitution.md
       │
       ▼
  speckit  /speckit.constitution → /speckit.specify → /speckit.plan → /speckit.tasks → 実装
       │
       ▼
  /product-sync <slug>           → docs/current/* 反映, docs/decisions/<slug>.md 追加

[機能追加（差分実装）]
  /feature-start <slug>          → docs/features/NNN-<slug>/proposal.md
  /feature-impact <slug>         → docs/features/NNN-<slug>/delta.md
       │
       ├─ （任意）/product-business-model <slug> → docs/features/NNN-<slug>/business-model.md（収益化に影響する変更のみ）
       │
       ├─ /product-review-cto <slug>      → docs/features/NNN-<slug>/reviews/cto.md
       ├─ /product-review-designer <slug> → docs/features/NNN-<slug>/reviews/designer.md
       └─ /product-review-pm <slug>       → docs/features/NNN-<slug>/reviews/pm.md
       │
  /product-refine <slug>         → docs/current/product-brief.md 更新（journey/requirements への反映指示込み）
       │
       ├─ （任意）/product-pitch <slug>   → docs/features/NNN-<slug>/pitch.md
       │
  /product-handoff <slug>        → docs/features/NNN-<slug>/speckit-input.md
       │
       ▼
  speckit /speckit.specify → /speckit.plan → /speckit.tasks → 実装
       │
       ▼
  /product-sync <slug>           → docs/current/journey.md, docs/current/requirements.md, docs/decisions/<slug>.md を更新
```

### 成果物の置き場（各プロダクトリポジトリ）

```
docs/
├── current/                     # 正本（living docs）
│   ├── concept.md               # プロダクトの存在理由（不変寄り）
│   ├── product-brief.md         # 統合ブリーフ（feature ごとに refine が更新）
│   ├── journey.md               # ペルソナ + ジャーニー（feature 追加で更新）
│   ├── requirements.md          # 機能 / 非機能要求（living document）
│   ├── constitution.md          # speckit 用憲法（小文字）
│   └── （プロダクト固有の正本: recommendation.md, integration-*.md, wireframes.md, design/, implementation-spec.md など）
│
├── decisions/                   # ADR（長く残す意思決定ログ）
│   ├── README.md
│   └── <slug>.md                # 日付プレフィクス無し、トピック中心の slug
│
└── features/
    └── NNN-<slug>/              # 機能ごとの初期インプットと履歴。slug は specs/<slug>/ と一致させる
        ├── README.md            # この feature のメタ情報（任意）
        ├── proposal.md          # 機能の問題定義 / 対象ユーザー（feature 002+ で必要）
        ├── delta.md             # 既存仕様への差分（影響分析の核）
        ├── discovery.md         # 初期 problem / target user / premise
        ├── business-model.md    # 初期 monetization / market sizing / validation plan
        ├── pitch.md             # 3 分ピッチ（任意、ステークホルダー向け）
        ├── reviews/{cto,designer,pm}.md
        └── speckit-input.md     # /speckit.specify 用ペースト文
```

> speckit が生成する `specs/NNN-<slug>/spec.md` は **別ディレクトリ**。`docs/features/<slug>/` は上流（プロダクト文脈）、`specs/<slug>/` は下流（エンジニアリング仕様）。slug は同一にする。

### スキル一覧

| スキル | 用途 |
|--------|------|
| `feature-start` | 機能スラグでディレクトリを切り、proposal.md を作成（feature 001 = 初期立ち上げにも使う） |
| `feature-impact` | 既存仕様への差分（delta.md）を構造化（feature 002+） |
| `product-discovery` | 創業者視点で前提・問題・ターゲットユーザーを言語化（feature/<slug>/discovery.md） |
| `product-journey` | ペルソナ・JTBD・As-Is/To-Be ジャーニーを current/journey.md に書く / 更新する |
| `product-business-model` | 収益化仮説・市場規模・価格仮説・初期 GTM を feature/<slug>/business-model.md に整理 |
| `product-requirements` | 機能 / 非機能要求を current/requirements.md に書く / 更新する |
| `product-review-cto` | CTO 視点：実現性・アーキテクチャ・運用コスト |
| `product-review-designer` | デザイナー視点：UX 完全性・情報設計・a11y |
| `product-review-pm` | PM 視点：スコープ・優先度・指標 |
| `product-refine` | 3 レビューの矛盾を解決し、current/product-brief.md を更新 + journey/requirements への反映指示 |
| `product-pitch` | brief から 3 分ピッチ用 `pitch.md` を生成（Airbnb 型 9 セクション、任意） |
| `product-handoff` | speckit に渡す `speckit-input.md` / 初回のみ `current/constitution.md` を生成 |
| `product-sync` | feature リリース後、current/* と decisions/<slug>.md を更新 |

### 共通ルール

- すべてのプロダクト系スキルは **第 1 引数に feature slug（例: `001-phase1-recommendation-fit`）** を取る。slug は `docs/features/<slug>/` および `specs/<slug>/` と一致させる
- 引数省略時は `docs/features/*/` 配下から WIP（必要な前段ファイルあり、自身の出力ファイル無し）を自動検出して提示
- 初期立ち上げも feature 001 として feature-start で開始する（独立した「初期モード」は持たない）

### 設計原則

- **差分実装ファースト**: 機能追加は必ず既存 `docs/current/*` を Read してから差分を `delta.md` に明示する。レビューは差分のみを評価できる
- **多視点で発散させ、refine で収束**: CTO / Designer / PM は意図的に重複させて衝突を起こす。`product-refine` が矛盾を解決しないと先へ進めない
- **Living docs と immutable history の分離**: `docs/current/` は最新版、`docs/features/NNN-<slug>/` は当時のスナップショットとして残す
- **speckit との責務分離**: 「what / why / 誰のため」までがこのスキル群、「どう作るか」は speckit 以降
- **ADR の slug 中心命名**: `docs/decisions/<topic-slug>.md`。日付プレフィクスは強制しない（front matter または本文内に日付を残す）
