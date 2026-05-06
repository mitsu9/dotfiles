---
name: product-handoff
description: refine 済みの brief を speckit に引き渡す。初回は CONSTITUTION.md を生成、毎回 /speckit.specify 用のペースト文を speckit-input.md に出力。引数で機能スラグを指定可、無指定時は WIP を自動検出。
disable-model-invocation: true
argument-hint: [feature-slug]
---

# Speckit Handoff

あなたはプロダクトブリーフを speckit が消化できる形に整える役だ。speckit は `/speckit.constitution` → `/speckit.specify` → `/speckit.plan` → `/speckit.tasks` の順に進むので、入力として **constitution（一度だけ）** と **specify 用テキスト（毎回）** を用意する。

## ゴール

1. （初回のみ）`docs/product/CONSTITUTION.md` を生成
2. `speckit-input.md` を生成（初期立ち上げ時は `docs/product/speckit-input.md`、feature 時は `docs/product/features/NNN-<slug>/speckit-input.md`）
3. ユーザーに speckit のコマンド実行手順を提示

## プロセス

### 1. 対象の特定

- `$ARGUMENTS` 指定 → `docs/product/features/<arg>/`（feature mode）
- 無指定で features 配下に `brief.md` あり `speckit-input.md` 無しの WIP があれば候補として提示
- それも無ければ `docs/product/` 直下を対象（初期立ち上げ mode）

### 2. 入力読み込み

- 対象の `brief.md` を Read（無ければ「先に `/product-refine` を実行してください」で停止）
- 親 `discovery.md`, `journey.md`, `requirements.md` も Read
- `docs/product/CONSTITUTION.md` の存在確認

### 3. CONSTITUTION.md の生成（初回のみ、または明示更新時）

`docs/product/CONSTITUTION.md` が無ければ作る。speckit の `/speckit.constitution` にそのまま渡せる、プロダクトの「変えてはいけない原則」を書く。`brief.md` の Conditions Carried Forward と `discovery.md` の Anti-Goals を中心に、以下を含める:

- **Product Principles**: このプロダクトが何を最優先するか（ユーザー価値 > 開発速度、など）
- **Quality Bars**: Must-meet な NFR のしきい値（パフォーマンス、可用性、a11y）
- **Boundaries**: やらないこと、避ける技術的選択
- **Decision-making rules**: 迷ったときの優先順位

既に存在する場合は Read して内容を確認。今回の `brief.md` で更新が必要なら、ユーザーに差分を提示して上書き確認。

### 4. speckit-input.md の生成

`/speckit.specify` にペーストする「機能仕様の自然言語記述」を作る。speckit の `/speckit.specify` は **「what と why に集中、tech stack には触れない」** が原則。

含めるもの:
- 解決する問題（1 段落）
- 対象ユーザー（具体的に）
- 主要なユーザーストーリー（journey の To-Be / delta から）
- 機能要求リスト（brief.md の In-Scope FR から、優先度付き）
- 受け入れ基準（FR ごと）
- スコープ外（Out of Scope を明記）
- 成功指標
- 守るべき制約（Conditions Carried Forward の関連分のみ）

含めないもの:
- 技術スタック、アーキテクチャ、実装詳細（`/speckit.plan` のフェーズに任せる）
- 内部レビューの議論経緯（brief.md に残っているのでここでは除外）

### 5. 引き渡し手順の提示

実行を終えたら、ユーザーに以下を提示:

**初回（CONSTITUTION.md を作った場合）**:
```
1. `cat docs/product/CONSTITUTION.md | pbcopy`
2. speckit セッションで `/speckit.constitution` を実行、ペースト
3. `cat docs/product/speckit-input.md | pbcopy`
4. `/speckit.specify` を実行、ペースト
5. `/speckit.clarify` → `/speckit.plan` → `/speckit.tasks` → 実装
```

**Feature mode**:
```
1. `cat docs/product/features/NNN-<slug>/speckit-input.md | pbcopy`
2. speckit セッションで `/speckit.specify` を実行、ペースト
   （CONSTITUTION.md は変更不要のはず。変更がある場合は brief.md の Upstream Updates に記載）
3. `/speckit.clarify` → `/speckit.plan` → `/speckit.tasks` → 実装
4. 実装完了後、`/product-sync NNN-<slug>` で top-level docs を更新
```

### 6. 出力

- `docs/product/CONSTITUTION.md`（必要時）
- 対象パスの `speckit-input.md`

## CONSTITUTION.md テンプレート

```markdown
# Product Constitution

> 作成日: YYYY-MM-DD
> ステータス: locked
> 出典: docs/product/discovery.md, docs/product/brief.md

## Product Principles
1. ...
2. ...

## Quality Bars
- Performance: ...
- Availability: ...
- Security / Privacy: ...
- Accessibility: ...

## Boundaries（やらないこと）
- ...

## Decision-making Rules
迷ったときの優先順位:
1. ユーザー価値 > 開発速度 > 技術的純度
2. ...
```

## speckit-input.md テンプレート

```markdown
# Speckit Specify Input — <機能名 or プロダクト名>

> このファイルの内容を `/speckit.specify` にそのままペーストする。
> tech stack には触れず、what と why に集中している。

## Problem
（1 段落で問題を記述）

## Target Users
- <具体的なペルソナ>: ...

## User Stories
- As a ..., I want ..., so that ...

## Functional Requirements
1. **[MUST]** ユーザーは X を Y できる
   - 受け入れ基準: ...
2. **[SHOULD]** ...

## Non-Functional Requirements
- Performance: ...
- Security: ...

## Out of Scope
- ...

## Success Criteria
- ...

## Constraints
（Conditions Carried Forward のうち、speckit 段階で守らせる必要があるもの）
- ...
```

## 終了条件

- `speckit-input.md` が書かれている
- 初回なら `CONSTITUTION.md` も書かれている
- ユーザーに pbcopy → speckit ペースト手順が提示されている
- Feature mode の場合、実装完了後の `/product-sync` を案内
