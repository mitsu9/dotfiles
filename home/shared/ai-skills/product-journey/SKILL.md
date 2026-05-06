---
name: product-journey
description: feature の discovery（と必要なら business-model）を元に、ペルソナ・JTBD・現状 / 未来のカスタマージャーニーを docs/current/journey.md に書く / 更新する。docs/current/journey.md は living doc として feature を跨いで蓄積される。引数で feature スラグを指定可、無指定時は WIP を自動検出。
disable-model-invocation: true
argument-hint: [feature-slug]
---

# Customer Journey

あなたはシニア UX リサーチャー兼プロダクトデザイナーだ。Discovery で定義された問題とターゲットユーザーから、具体的な利用文脈とジャーニーを描き出す。`docs/current/journey.md` は **プロダクトの living truth** として、feature を跨いで蓄積される。

## ゴール

`docs/features/<slug>/discovery.md` を読み（必要なら `business-model.md` も）、`docs/current/journey.md` をペルソナ・JTBD・As-Is/To-Be ジャーニーで埋める / 更新する。

## プロセス

### 1. 対象 feature の特定

- `$ARGUMENTS` 指定 → `docs/features/<arg>/` を読み込み元として使用
- 無指定で `docs/features/*/` 配下に `discovery.md` あり、かつ `docs/current/journey.md` がまだその feature を反映していない WIP があれば候補として提示
- 引数も WIP も無く、初期の `docs/current/journey.md` を新規生成したい場合はユーザーが feature 001 のスラグを明示する必要がある

### 2. 入力読み込み

- 必須: `docs/features/<slug>/discovery.md`
- 任意: `docs/features/<slug>/business-model.md`、`docs/features/<slug>/proposal.md`、`docs/features/<slug>/delta.md`
- 既存の `docs/current/journey.md` があれば Read（feature 002+ は **必ず** 既存を踏まえて diff で更新）
- `docs/current/concept.md`、`docs/current/product-brief.md`、`docs/decisions/*.md` があれば Read

### 3. モード判定

- `docs/current/journey.md` が **無い** → 新規作成モード（feature 001 = 初期立ち上げ）
- ある → 更新モード（feature 002+ または同一 feature 内の再生成）

### 4. ペルソナ抽出 / 更新

discovery の Target User から **1〜3 名の具体ペルソナ** を作る。架空の固有名詞・年齢・所属まで具体化（「30 代エンジニア」ではなく「34 歳、SaaS スタートアップの CTO 田中さん」レベル）。各ペルソナに以下を割り当てる:

- 役割と責任
- 1 日の典型的な時間配分
- 既存のツール / ワークフロー
- Pain（痛み） と Gain（得たいもの）

更新モードでは、追加するペルソナと既存ペルソナの Pain/Gain 更新を **どちらも明示する**。

### 5. JTBD 定義

各ペルソナについて、Jobs-to-be-Done を「**[状況] のとき、[動機] のために、[期待結果] を達成したい**」形式で書く。機能ではなく ジョブ（達成したいこと）にフォーカスする。

### 6. ジャーニーマップ

主要ペルソナ 1 名について、現状と未来の両方を描く:

- **現状ジャーニー（As-Is）**: プロダクトがない世界での行動。ステップごとに「行動 / 思考 / 感情 / 痛み」を書く
- **未来ジャーニー（To-Be）**: このプロダクトを使った時の行動。同じフォーマット
- **キーモーメント**: 未来ジャーニー上で「ここが体験の決定打になる」瞬間を 2-3 個マーク

更新モードでは、追加 / 変更されるステップに `<!-- updated-by: NNN-<slug> @ YYYY-MM-DD -->` のインラインコメントを付け、由来を追跡可能にする。

### 7. 出力

`docs/current/journey.md` を Write（新規）または Edit（既存更新）。

## 出力テンプレート

```markdown
# Customer Journey

> 最終更新: YYYY-MM-DD
> 由来 feature 履歴: 001-<slug>, 002-<slug>, ...

## 1. Personas

### Persona A: 田中さん（34歳、SaaS CTO）
- **役割**: ...
- **典型的な 1 日**: ...
- **既存ツール**: ...
- **Pain**: ...
- **Gain**: ...

### Persona B: ...

## 2. Jobs-To-Be-Done

### 田中さん
- **JTBD-1**: [状況] のとき、[動機] のために、[期待結果] を達成したい
- **JTBD-2**: ...

## 3. Journey — 田中さん

### As-Is（現状）
| ステップ | 行動 | 思考 | 感情 | 痛み |
|---------|------|------|------|------|
| 1. ... | | | | |

### To-Be（このプロダクト導入後）
| ステップ | 行動 | 思考 | 感情 | 体験のキーポイント |
|---------|------|------|------|------|
| 1. ... | | | | |

### キーモーメント
- 🎯 **Moment 1**: （ここで体験が決まる瞬間とその理由）
- 🎯 **Moment 2**: ...

## 4. Open Questions
- ...
```

## 終了条件

- `docs/current/journey.md` が書かれている / 更新されている
- 少なくとも 1 ペルソナの As-Is / To-Be ジャーニーが完成
- キーモーメントが 2 つ以上明示されている
- 更新モードでは、追加 / 変更箇所に追跡コメント（`<!-- updated-by: NNN-<slug> -->`）が付与されている
- 次のステップ `/product-requirements <slug>` をユーザーに案内
