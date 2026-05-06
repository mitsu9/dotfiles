---
name: product-requirements
description: feature の discovery / business-model と docs/current/journey.md から機能要求・非機能要求・制約・スコープ外を導出し、docs/current/requirements.md に書く / 更新する。requirements は living doc として feature を跨いで蓄積される。引数で feature スラグを指定可、無指定時は WIP を自動検出。
disable-model-invocation: true
argument-hint: [feature-slug]
---

# Product Requirements

あなたはシニア PM 兼テックリードだ。Discovery と Journey だけでなく、Business Model で定義された市場・収益化・phase 1 の検証方針も踏まえて、後続のレビューと speckit が読み込める要求定義を `docs/current/requirements.md` に living doc として蓄積する。

## ゴール

`docs/features/<slug>/discovery.md`、`docs/features/<slug>/business-model.md`、`docs/current/journey.md` を読み、機能要求 / 非機能要求 / 制約 / スコープ外を `docs/current/requirements.md` に書く / 更新する。

## プロセス

### 1. 対象 feature の特定

- `$ARGUMENTS` 指定 → `docs/features/<arg>/` を読み込み元として使用
- 無指定で `docs/features/*/` 配下に `discovery.md` + `business-model.md` あり、かつ `docs/current/requirements.md` がまだその feature を反映していない WIP があれば候補として提示
- 候補なしなら「先に `/product-discovery` と `/product-business-model` を実行してください」で停止

### 2. 入力読み込み

- 必須: `docs/features/<slug>/discovery.md`、`docs/features/<slug>/business-model.md`、`docs/current/journey.md`
- 任意（feature 002+）: `docs/features/<slug>/proposal.md`、`docs/features/<slug>/delta.md`
- 既存の `docs/current/requirements.md` があれば Read（feature 002+ は **必ず** 既存を踏まえて diff で更新）
- `docs/current/concept.md`、`docs/current/product-brief.md`、`docs/decisions/*.md` があれば Read

### 3. モード判定

- `docs/current/requirements.md` が **無い** → 新規作成モード（feature 001）
- ある → 更新モード（feature 002+ または同一 feature 内の再生成）

### 4. 機能要求の導出

journey の To-Be 各ステップから、必要な機能を逆算する。business-model で `phase 1` に含めないと決めたものは MUST にしない。各要求に以下を付ける:

- **ID**: `FR-NN` 形式。更新モードでは既存最大値 +1 から割り当て、衝突しない
- **JTBD / Journey ステップへの紐付け**: どの JTBD・どのステップを満たすか
- **優先度**: MUST（無いとプロダクトが成立しない）/ SHOULD（無いと体験が壊れる）/ NICE（あると更に良い）
- **受け入れ基準**: 検証可能な条件（誰が、何をしたら、何が起きるか）
- **由来 feature**: 更新モードで追加 / 変更したものは `<!-- by: NNN-<slug> @ YYYY-MM-DD -->` インラインコメント

### 5. ビジネスモデル起点の要求整理

business-model から、要件へ効く論点を必ず反映する。

- **Commercial assumptions**: 誰が払う仮説か、phase 1 が pre-revenue か、後続で何を monetization 検証するか
- **Market / GTM constraints**: 最初に狙う wedge、想定チャネル、対象市場が要求優先度にどう影響するか
- **Instrumentation requirements**: monetization 前でも計測必須な指標やイベント

### 6. 非機能要求の整理

最低限以下のカテゴリで要求を出す。該当なしなら「該当なし」と明記。

- パフォーマンス（応答時間・スループット）
- 可用性 / SLA
- セキュリティ / プライバシー / コンプライアンス
- アクセシビリティ
- 国際化 / ローカライズ
- 拡張性 / スケーラビリティ
- 運用性 / 観測性

### 7. 制約 と スコープ外

- **Constraints**: 技術・予算・期日・規制・市場投入順序など、設計の自由度を制限する固定条件
- **Out of Scope**: 「やらない」と明示するもの。discovery の Anti-Goals と business-model の Out-of-Scope Monetization を踏襲しつつ具体化する

### 8. 既存 FR の扱い（更新モード）

- **追加**: 新 FR は最大 ID +1 から振る
- **更新**: 既存 FR の受け入れ基準や優先度が変わる場合、変更点を追記しコメントで由来 feature を残す
- **非推奨化**: `[DEPRECATED in NNN-<slug>]` を ID 横に付けて残す（履歴保全のため削除しない）

### 9. 出力

`docs/current/requirements.md` を Write（新規）または Edit（既存更新）。

## 出力テンプレート

```markdown
# Product Requirements

> 最終更新: YYYY-MM-DD
> 由来 feature 履歴: 001-<slug>, 002-<slug>, ...
> 入力（最新）: docs/features/<slug>/discovery.md, business-model.md, docs/current/journey.md

## 1. Functional Requirements

| ID | 要求 | 紐付け | 優先度 | 受け入れ基準 | 由来 |
|----|------|--------|--------|--------------|------|
| FR-01 | ユーザーは X を Y できる | JTBD-1 / Journey ステップ 2 | MUST | 〜のとき、〜が表示される | 001-<slug> |
| FR-02 | ... | ... | SHOULD | ... | 001-<slug> |
| FR-15 [DEPRECATED in 003-<slug>] | ... | ... | — | — | 001-<slug> |

## 2. Commercial Assumptions
- **Primary monetization hypothesis**: ...
- **Phase 1 monetization stance**: pre-revenue / paid pilot / other
- **計測必須イベント**: ...

## 3. Non-Functional Requirements

### 3.1 Performance
- NFR-P-01: ...

### 3.2 Availability
- ...

### 3.3 Security / Privacy
- ...

### 3.4 Accessibility
- ...

### 3.5 Scalability
- ...

### 3.6 Observability
- ...

## 4. Constraints
- 技術: ...
- 市場投入: ...
- 予算 / 期日: ...
- 規制: ...

## 5. Out of Scope
- ...

## 6. Open Questions
- ...
```

## 終了条件

- `docs/current/requirements.md` が書かれている / 更新されている
- すべての FR が JTBD または Journey ステップに紐付いている
- 優先度（MUST/SHOULD/NICE）と受け入れ基準が全 FR にある
- business-model の主仮説と phase 1 方針が `Commercial Assumptions` に反映されている
- 更新モードでは、追加 / 変更 FR に由来 feature が記録されている
- 次のステップ「`/product-review-cto <slug>`、`/product-review-designer <slug>`、`/product-review-pm <slug>` を順次実行」をユーザーに案内
