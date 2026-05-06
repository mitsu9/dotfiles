# ai-skills

Claude Code / Codex 共通のグローバルスキル置き場。`home/shared/ai-skills/` は `~/.claude/skills/` と `~/.codex/skills/` の両方に symlink される。

## プロダクト開発ワークフロー

speckit に渡す前段（カスタマージャーニー / 要求定義）を多視点レビューで作り込むためのスキル群。各スキルが成果物を生成し、次のスキルがそれを読むパイプライン。**スキル自体はグローバルに 1 つだけ存在し、成果物は各プロダクトリポジトリの `docs/product/` 配下に書き出される。**

### 全体図

```
[初期立ち上げ]
  /product-discovery   → docs/product/discovery.md
  /product-journey     → docs/product/journey.md
  /product-requirements → docs/product/requirements.md
       │
       ├─ /product-review-cto       → docs/product/reviews/cto.md
       ├─ /product-review-designer  → docs/product/reviews/designer.md
       └─ /product-review-pm        → docs/product/reviews/pm.md
       │
  /product-refine      → docs/product/brief.md
       │
       ├─ （任意）/product-pitch → docs/product/pitch.md
       │
  /product-handoff     → docs/product/CONSTITUTION.md, speckit-input.md
       │
       ▼
  speckit  /speckit.constitution → /speckit.specify → /speckit.plan → /speckit.tasks → 実装

[機能追加（差分実装）]
  /feature-start <slug>   → docs/product/features/NNN-<slug>/proposal.md
  /feature-impact         → docs/product/features/NNN-<slug>/delta.md
       │
       ├─ /product-review-cto <slug>      → features/NNN-<slug>/reviews/cto.md
       ├─ /product-review-designer <slug> → features/NNN-<slug>/reviews/designer.md
       └─ /product-review-pm <slug>       → features/NNN-<slug>/reviews/pm.md
       │
  /product-refine <slug>  → features/NNN-<slug>/brief.md
       │
       ├─ （任意）/product-pitch <slug> → features/NNN-<slug>/pitch.md
       │
  /product-handoff <slug> → features/NNN-<slug>/speckit-input.md
       │
       ▼
  speckit /speckit.specify → /speckit.plan → /speckit.tasks → 実装
       │
       ▼
  /product-sync <slug>    → journey.md / requirements.md / decisions/ を更新
```

### 成果物の置き場（各プロダクトリポジトリ）

```
docs/product/
├── discovery.md              # プロダクトの存在理由（不変寄り）
├── journey.md                # ペルソナ + ジャーニー（feature 追加で更新）
├── requirements.md           # 機能 / 非機能要求（living document）
├── brief.md                  # 初期立ち上げ統合ブリーフ（1 回だけ）
├── pitch.md                  # 3 分ピッチ向けマークダウン（任意）
├── CONSTITUTION.md           # speckit 用憲法
├── speckit-input.md          # 初期立ち上げ用 /speckit.specify 入力
├── reviews/                  # 初期立ち上げ時のレビュー
│   ├── cto.md
│   ├── designer.md
│   └── pm.md
├── decisions/                # ADR 蓄積（YYYY-MM-DD-<slug>.md）
└── features/
    └── NNN-<slug>/           # 機能ごとの作業領域
        ├── proposal.md       # 機能の問題定義 / 対象ユーザー
        ├── delta.md          # 既存仕様への差分（影響分析の核）
        ├── reviews/{cto,designer,pm}.md
        ├── brief.md          # 機能のリファインドブリーフ
        ├── pitch.md          # 3 分ピッチ（任意、ステークホルダー向け）
        ├── speckit-input.md  # /speckit.specify 用ペースト文
        └── SHIPPED.md        # /product-sync 後に作成（実装完了マーク）
```

> speckit が生成する `specs/NNN-<feature>/spec.md` は **別ディレクトリ**。`docs/product/` は上流（プロダクト文脈）、`specs/` は下流（エンジニアリング仕様）。

### スキル一覧

| スキル | モード | 用途 |
|--------|--------|------|
| `product-discovery` | 初期 | 創業者視点で前提・問題・ターゲットユーザーを言語化 |
| `product-journey` | 初期 | ペルソナ・JTBD・As-Is/To-Be ジャーニー |
| `product-requirements` | 初期 | 機能 / 非機能要求の導出 |
| `feature-start` | 機能 | 既存 docs を読んで機能の骨子（proposal）を作成 |
| `feature-impact` | 機能 | 既存仕様への差分（delta）を構造化 |
| `product-review-cto` | 共通 | CTO 視点：実現性・アーキテクチャ・運用コスト |
| `product-review-designer` | 共通 | デザイナー視点：UX 完全性・情報設計・a11y |
| `product-review-pm` | 共通 | PM 視点：スコープ・優先度・指標 |
| `product-refine` | 共通 | 3 レビューの矛盾を解決した最終ブリーフ |
| `product-pitch` | 共通（任意） | brief.md から 3 分ピッチ用 `pitch.md` を生成（Airbnb 型 9 セクション） |
| `product-handoff` | 共通 | speckit に渡す `CONSTITUTION.md` / `speckit-input.md` を生成 |
| `product-sync` | 機能 | 機能リリース後、living docs と decisions/ を更新 |

### 共通スキルの引数

`product-review-*`、`product-refine`、`product-pitch`、`product-handoff` は引数で対象を切り替える:

- 引数なし → `docs/product/` 直下を対象（初期立ち上げ）
- 引数 `<feature-slug>` → `docs/product/features/<NNN-slug>/` を対象（機能追加）
- 引数なしでも feature WIP（`proposal.md` あり、最終成果物なし）が見つかれば候補として提示

### 設計原則

- **差分実装ファースト**: 機能追加は必ず既存仕様を Read してから差分を `delta.md` に明示する。レビューは差分のみを評価できる
- **多視点で発散させ、refine で収束**: CTO / Designer / PM は意図的に重複させて衝突を起こす。`product-refine` が矛盾を解決しないと先へ進めない
- **Living docs と immutable history の分離**: トップレベル docs は最新版、`features/NNN-<slug>/` は当時のスナップショットとして残す
- **speckit との責務分離**: 「what / why / 誰のため」までがこのスキル群、「どう作るか」は speckit 以降
