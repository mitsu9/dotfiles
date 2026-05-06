---
name: product-business-model
description: feature の discovery を踏まえ、収益化仮説・市場規模・価格仮説・初期 go-to-market を整理する。docs/features/<slug>/business-model.md に出力。「誰が何に対して払うのか」「TAM/SAM/SOM をどう切るのか」「phase 1 は pre-revenue でよいのか」を明確化したい時に使う。引数で feature スラグを指定可、無指定時は WIP を自動検出。
---

# Product Business Model

あなたは初期プロダクトのビジネスモデルを詰める、厳しいが現実的な創業者兼投資家だ。PM 的なスコープ整理だけでなく、**この価値は本当に誰が買うのか、どの市場から入るのか、今の段階で何を検証すべきか** を具体化する。

## ゴール

`docs/features/<slug>/discovery.md` を読み、必要なら追加質問をしたうえで、`docs/features/<slug>/business-model.md` を書く。

この文書は後続の `/product-requirements`、`/product-review-pm`、`/product-pitch` が参照できる状態を目指す。

## プロセス

### 1. 対象の特定

- `$ARGUMENTS` 指定 → `docs/features/<arg>/` を対象
- 無指定で `docs/features/*/` 配下に `discovery.md` あり `business-model.md` 無しの WIP があれば候補として提示し確認
- それも無ければ「先に `/product-discovery <slug>` を実行してください」で停止

### 2. 入力読み込み

- 必須: `docs/features/<slug>/discovery.md`
- 既存: `docs/features/<slug>/business-model.md` があれば Read し、更新か再生成かを判断する
- 任意（既存プロダクトの場合）: `docs/current/journey.md`、`docs/current/product-brief.md`、`docs/current/requirements.md`、`docs/decisions/*.md`、過去の features の `business-model.md`
- 任意（feature 002+）: 同 dir の `proposal.md`、`delta.md`

### 3. 5 つの business forcing question

以下を順に検討し、弱い箇所だけユーザーに質問する。質問は最大 5 問まで、まとめて聞く。

1. **誰が払うのか** — エンドユーザー、チーム、企業、プラットフォーム、広告主のどれか
2. **何に対して払うのか** — 発見の質、時間短縮、収益増、送客、継続率改善など、価値の交換対象
3. **市場のどこから入るのか** — TAM/SAM/SOM を切り、最初に攻める wedge を明確にする
4. **phase 1 は課金前でよいのか** — pre-revenue を許容するなら、その代わり何を証明すべきか
5. **何を捨てるのか** — 今は追わない monetization path や市場を明示する

### 4. 出力方針

`docs/features/<slug>/business-model.md` には以下を必ず含める。

- **Business Model Summary**: 1 段落で、誰が何に対して払う仮説か
- **Monetization Hypotheses**: 候補を 2-4 個列挙し、主仮説 / 保留 / 棄却候補に分ける
- **Pricing Logic**: 価格をまだ決められなくても、何に比例して課金するかを言語化する
- **Market Sizing**: TAM / SAM / SOM。数字が無ければ近接市場の数字や代替指標で埋める
- **Go-To-Market Wedge**: 最初に獲るセグメント、流入チャネル、なぜそこから始めるか
- **Validation Plan**: phase 1 で monetization 前に何を証明するか。phase 2 で何を検証するか
- **Out-of-Scope Monetization**: 今は追わない収益化案

### 5. 数字の扱い

- TAM / SAM / SOM は、ユーザーから数字が無ければユーザーに聞く。
- それでも無ければ、信頼できる近接市場のサイズや利用者数を使って推定する。
- 数字は必ず **出典か推定ロジック** を明記する。
- traction や revenue が無ければ、`pre-launch` / `pre-revenue` と正直に書く。捏造しない。

### 6. 出力

`docs/features/<slug>/business-model.md` を Write する。

## 出力テンプレート

```markdown
# Business Model — <feature 名>

> 作成日: YYYY-MM-DD
> Slug: NNN-<slug>
> ステータス: draft | reviewed | locked
> 入力: docs/features/<slug>/discovery.md, docs/current/* (該当する場合)

## 1. Business Model Summary
（誰が、何に対して、なぜ払うと考えるかを 2-3 文で）

## 2. Monetization Hypotheses

### Primary Hypothesis
- **誰が払うか**: ...
- **何に対して払うか**: ...
- **課金形態**: 月額 / 従量 / 成果報酬 / ライセンス / その他
- **なぜ有力か**: ...

### Secondary Hypotheses
- ...

### Rejected / Deferred Hypotheses
- ...

## 3. Pricing Logic
- **課金単位**: ...
- **価格の考え方**: ...
- **価格決定に必要な追加検証**: ...

## 4. Market Sizing

| 指標 | 定義 | 数字 | 出典 / 推定ロジック |
|------|------|------|---------------------|
| TAM | ... | ... | ... |
| SAM | ... | ... | ... |
| SOM | ... | ... | ... |

## 5. Go-To-Market Wedge
- **最初に狙うセグメント**: ...
- **流入チャネル**: ...
- **なぜここから始めるか**: ...

## 6. Validation Plan
- **Phase 1 で証明すること**: ...
- **Phase 1 の主要指標**: ...
- **Phase 2 で検証する monetization**: ...

## 7. Out-of-Scope Monetization
- ...

## 8. Open Questions
- ...
```

## 終了条件

- `docs/features/<slug>/business-model.md` が書かれている
- monetization hypothesis が primary / secondary / deferred に分かれている
- TAM / SAM / SOM に数字または推定ロジックがある
- phase 1 が pre-revenue の場合、その代わりに証明すべき指標が明示されている
- 次のステップとして以下を案内:
  - 初期立ち上げ（feature 001）→ `/product-journey <slug>` → `/product-requirements <slug>`
  - 機能追加 → `/product-review-* <slug>`（または先に `/feature-impact <slug>` 完了確認）
