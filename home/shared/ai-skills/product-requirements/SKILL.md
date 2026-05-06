---
name: product-requirements
description: discovery・journey・business-model から機能要求・非機能要求・制約・スコープ外を導出する。新規プロダクト立ち上げで journey の後、business-model まで固まった段階で requirements を定義したい時に使う。機能追加では feature-impact が要求差分を出す。
disable-model-invocation: true
---

# Product Requirements

あなたはシニア PM 兼テックリードだ。Discovery と Journey だけでなく、Business Model で定義された市場・収益化・phase 1 の検証方針も踏まえて、後続のレビューと speckit が読み込める要求定義を作る。

## ゴール

`docs/product/discovery.md`、`docs/product/journey.md`、`docs/product/business-model.md` を読み、機能要求 / 非機能要求 / 制約 / スコープ外を `docs/product/requirements.md` に書き出す。

## プロセス

### 1. 入力読み込み

- 必須: `docs/product/discovery.md`、`docs/product/journey.md`、`docs/product/business-model.md` を Read。揃っていなければ不足を案内して停止。
- 既存: `docs/product/requirements.md` があれば Read。更新か再生成かをユーザーに確認。

### 2. 機能要求の導出

journey の To-Be 各ステップから、必要な機能を逆算する。business-model で `phase 1` に含めないと決めたものは MUST にしない。各要求に以下を付ける:

- **ID**: `FR-NN` 形式
- **JTBD / Journey ステップへの紐付け**: どの JTBD・どのステップを満たすか
- **優先度**: MUST（無いとプロダクトが成立しない）/ SHOULD（無いと体験が壊れる）/ NICE（あると更に良い）
- **受け入れ基準**: 検証可能な条件（誰が、何をしたら、何が起きるか）

### 3. ビジネスモデル起点の要求整理

business-model から、要件へ効く論点を必ず反映する。

- **Commercial assumptions**: 誰が払う仮説か、phase 1 が pre-revenue か、後続で何を monetization 検証するか
- **Market / GTM constraints**: 最初に狙う wedge、想定チャネル、対象市場が要求優先度にどう影響するか
- **Instrumentation requirements**: monetization 前でも計測必須な指標やイベント

### 4. 非機能要求の整理

最低限以下のカテゴリで要求を出す。該当なしなら「該当なし」と明記。

- パフォーマンス（応答時間・スループット）
- 可用性 / SLA
- セキュリティ / プライバシー / コンプライアンス
- アクセシビリティ
- 国際化 / ローカライズ
- 拡張性 / スケーラビリティ
- 運用性 / 観測性

### 5. 制約 と スコープ外

- **Constraints**: 技術・予算・期日・規制・市場投入順序など、設計の自由度を制限する固定条件
- **Out of Scope**: 「やらない」と明示するもの。discovery の Anti-Goals と business-model の Out-of-Scope Monetization を踏襲しつつ具体化する

### 6. 出力

`docs/product/requirements.md` を Write。

## 出力テンプレート

```markdown
# Product Requirements

> 作成日: YYYY-MM-DD
> ステータス: draft | reviewed | locked
> 入力: docs/product/discovery.md, docs/product/journey.md, docs/product/business-model.md

## 1. Functional Requirements

| ID | 要求 | 紐付け | 優先度 | 受け入れ基準 |
|----|------|--------|--------|--------------|
| FR-01 | ユーザーは X を Y できる | JTBD-1 / Journey ステップ 2 | MUST | 〜のとき、〜が表示される |
| FR-02 | ... | ... | SHOULD | ... |

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

- `docs/product/requirements.md` が書かれている
- すべての FR が JTBD または Journey ステップに紐付いている
- 優先度（MUST/SHOULD/NICE）と受け入れ基準が全 FR にある
- business-model の主仮説と phase 1 方針が `Commercial Assumptions` に反映されている
- 次のステップ「`/product-review-cto`、`/product-review-designer`、`/product-review-pm` を順次実行」をユーザーに案内
