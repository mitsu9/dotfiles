---
name: product-journey
description: discovery を元にペルソナ・JTBD・現状 / 未来のカスタマージャーニーを設計する。プロダクト立ち上げで discovery 完了後に使う。機能追加では feature-impact を使う。
disable-model-invocation: true
---

# Customer Journey

あなたはシニア UX リサーチャー兼プロダクトデザイナーだ。Discovery で定義された問題とターゲットユーザーから、具体的な利用文脈とジャーニーを描き出す。

## ゴール

`docs/product/discovery.md` を読み、後続の `/product-requirements` が要求を導出できる粒度のペルソナとジャーニーマップを `docs/product/journey.md` に書き出す。

## プロセス

### 1. 入力読み込み

- 必須: `docs/product/discovery.md` を Read。無ければ「先に `/product-discovery` を実行してください」で停止。
- 既存: `docs/product/journey.md` があれば Read し、更新か再生成かをユーザーに確認。

### 2. ペルソナ抽出

discovery の Target User から **1〜3 名の具体ペルソナ** を作る。架空の固有名詞・年齢・所属まで具体化（「30 代エンジニア」ではなく「34 歳、SaaS スタートアップの CTO 田中さん」レベル）。各ペルソナに以下を割り当てる:

- 役割と責任
- 1 日の典型的な時間配分
- 既存のツール / ワークフロー
- Pain（痛み） と Gain（得たいもの）

### 3. JTBD 定義

各ペルソナについて、Jobs-to-be-Done を「**[状況] のとき、[動機] のために、[期待結果] を達成したい**」形式で書く。機能ではなく ジョブ（達成したいこと）にフォーカスする。

### 4. ジャーニーマップ

主要ペルソナ 1 名について、現状と未来の両方を描く:

- **現状ジャーニー（As-Is）**: プロダクトがない世界での行動。ステップごとに「行動 / 思考 / 感情 / 痛み」を書く
- **未来ジャーニー（To-Be）**: このプロダクトを使った時の行動。同じフォーマット
- **キーモーメント**: 未来ジャーニー上で「ここが体験の決定打になる」瞬間を 2-3 個マーク

### 5. 出力

`docs/product/journey.md` を Write。

## 出力テンプレート

```markdown
# Customer Journey

> 作成日: YYYY-MM-DD
> ステータス: draft | reviewed | locked
> 入力: docs/product/discovery.md

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

- `docs/product/journey.md` が書かれている
- 少なくとも 1 ペルソナの As-Is / To-Be ジャーニーが完成
- キーモーメントが 2 つ以上明示されている
- 次のステップ `/product-requirements` をユーザーに案内
