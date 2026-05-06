---
name: product-refine
description: 3 視点（CTO/Designer/PM）のレビューを統合し、矛盾を解決した上で docs/current/product-brief.md を更新する。docs/current/journey.md, requirements.md への反映指示も同時に書く。引数で feature スラグを指定可、無指定時は WIP を自動検出。
disable-model-invocation: true
argument-hint: [feature-slug]
---

# Product Refine

あなたは 3 視点のレビューを束ねるシニアプロダクトリードだ。CTO・Designer・PM が出した評価を読み、矛盾を解決し、各 GO-WITH-CONDITIONS の条件を満たす形で **`docs/current/product-brief.md` を更新する**。最終的に speckit に渡せる living な統合ブリーフを作る。

`docs/current/product-brief.md` は **プロダクトの最新統合像** であり、feature を跨いで蓄積される。

## ゴール

`docs/current/product-brief.md` を新規作成または更新する。並行して `docs/current/journey.md`、`docs/current/requirements.md` への反映指示を `Upstream Updates` に明記する（実反映は `/product-sync` 段階）。

## プロセス

### 1. 対象の特定

- `$ARGUMENTS` 指定 → `docs/features/<arg>/` を対象
- 無指定で `docs/features/*/` 配下に `reviews/{cto,designer,pm}.md` 揃いで、`docs/current/product-brief.md` がまだその feature を反映していない WIP があれば候補として提示し確認
- 候補なしなら「先にレビューを完了してください」で停止

### 2. 入力読み込み（必須）

3 つのレビュー（cto/designer/pm）が揃っていることを確認。1 つでも欠けていれば「先にレビューを完了してください」で停止。

- 必須: 対象 feature の `reviews/cto.md`、`reviews/designer.md`、`reviews/pm.md`
- 必須: 対象 feature の `discovery.md`、`business-model.md`（あれば）、`proposal.md`（あれば）、`delta.md`（あれば）
- 必須: `docs/current/journey.md`、`docs/current/requirements.md`
- 任意: `docs/current/product-brief.md`（既存の場合は **必ず** Read。更新前提）
- 任意: `docs/current/concept.md`、`docs/current/constitution.md`、`docs/decisions/*.md`、過去 feature の `reviews/*.md`

### 3. モード判定

- `docs/current/product-brief.md` が **無い** → 新規作成モード（feature 001）
- ある → 更新モード（既存 brief に今回の feature の意思決定を統合）

### 4. 矛盾の解決

3 レビュー間で意見が割れている論点を **すべて** 列挙する。各論点に:
- 各 reviewer の主張
- どちらを採るか（または折衷案）
- その判断の理由
- もし不採用にした reviewer の懸念をどう緩和するか

判断に迷う論点はユーザーに聞く（最大 3 問）。「両論併記で先送り」は許さない。

### 5. 条件の取り込み

各レビューの「GO-WITH-CONDITIONS の条件」をすべて列挙し、ブリーフに組み込む。組み込めない条件はその理由を明示。

### 6. 統合ブリーフの執筆 / 更新

speckit の `/speckit.specify` に渡せる完結した文書として書く。更新モードでは、既存セクションは保ちつつ、今回の feature が変える箇所をマージする（追跡コメント `<!-- updated-by: NNN-<slug> @ YYYY-MM-DD -->` を必ず付ける）。

### 7. Upstream Updates の記述

レビューを反映する過程で、`docs/current/journey.md`、`docs/current/requirements.md`、必要なら `docs/current/concept.md` を更新すべき箇所が出る。これを `product-brief.md` 末尾の「Upstream Updates」セクションに具体的な変更指示として書く。実反映は `/product-sync` がコミットする。

### 8. 出力

`docs/current/product-brief.md` を Write（新規）または Edit（更新）。

## 出力テンプレート

```markdown
# Product Brief

> 最終更新: YYYY-MM-DD
> ステータス: refined（speckit 引き渡し可）
> 由来 feature 履歴: 001-<slug>, 002-<slug>, ...
> 直近の入力: docs/features/<slug>/{discovery,business-model,reviews/*}.md

## Executive Summary
（このプロダクトを 3 文で。問題、解決策、成功指標）

## 1. Problem & Target User
（discovery を統合した最新版）

## 2. Solution Overview
（journey の To-Be をベースにした最新の体験像）

## 3. In-Scope Functional Requirements
| ID | 要求 | 優先度 | 受け入れ基準 | 由来 |
|----|------|--------|-------------|------|
| FR-01 | ... | MUST | ... | 001-<slug> |

## 4. Non-Functional Requirements
（Performance / Availability / Security / Accessibility / Scalability / Observability）

## 5. Out of Scope（明示）
- ...

## 6. Resolved Conflicts（feature 別、最新分のみ）
### 002-<slug>
| 論点 | CTO | Designer | PM | 決定 | 理由 |
|------|-----|----------|----|----|------|
| ... | ... | ... | ... | ... | ... |

## 7. Conditions Carried Forward
レビューで提示された GO-WITH-CONDITIONS のうち、speckit 以降で必ず守るべきもの。
- [ ] CTO 由来（NNN-<slug>）: ...
- [ ] Designer 由来（NNN-<slug>）: ...
- [ ] PM 由来（NNN-<slug>）: ...

## 8. Success Metrics
| 指標 | 種別 | 目標 | 計測方法 | 由来 |
|------|------|------|---------|------|

## 9. Open Questions
（refine しても残った論点。speckit に渡す前にユーザーが判断するもの）

## 10. Upstream Updates（既存 living docs への反映指示）
このブリーフを生かすために、`docs/current/` 配下をどう更新すべきか。実反映は `/product-sync` で。
- `docs/current/journey.md`: ペルソナ X に「招待ゲスト」を追加 / Persona Y の Pain 更新
- `docs/current/requirements.md`: FR-NN を追加 / FR-05 の受け入れ基準を更新 / FR-12 を [DEPRECATED in NNN-<slug>]
- `docs/current/concept.md`: （必要なら）
- `docs/decisions/<topic-slug>.md`: 新規 ADR 候補（タイトル / 要旨）
```

## 終了条件

- `docs/current/product-brief.md` が書かれている / 更新されている
- 3 レビュー間の矛盾がすべて Resolved Conflicts に記載されている
- Conditions Carried Forward が漏れなくチェックリスト化されている
- Upstream Updates が具体的に書かれている
- 次のステップ `/product-pitch <slug>`（任意）または `/product-handoff <slug>` をユーザーに案内
