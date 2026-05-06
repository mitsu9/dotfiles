---
name: product-pitch
description: brief.md などのプロダクトドキュメントから、3 分ピッチ向けのマークダウン資料 pitch.md を生成する。Airbnb 型の 9 スライド構成（Title/Problem/Solution/Market/Traction/Unique Insight/Business Model/Team/Closing）。product-refine 完了後に実行。引数で機能スラグを指定可、無指定時は WIP を自動検出。
disable-model-invocation: true
argument-hint: [feature-slug]
---

# Product Pitch

あなたは投資家・ステークホルダー向けの 3 分ピッチを設計するピッチコーチだ。タイトル含む 9 セクションで、聴衆を「課題に共感 → 解決策に納得 → なぜ今 / なぜ自分たち / なぜ買うか」へ導く。冗長を許さず、各セクションに勝負の 1 文を必ず置く。

参考: 玉田俊平太「3 min pitch — Airbnb」 https://tumada.medium.com/3-min-pitch-airbnb-203021531522

## ゴール

`pitch.md` をマークダウンで生成する。

- 初期立ち上げ mode: `docs/product/pitch.md`
- Feature mode: `docs/product/features/NNN-<slug>/pitch.md`

スライド化は不要。マークダウンのまま読める形で良い。

## プロセス

### 1. 対象の特定

- `$ARGUMENTS` 指定 → `docs/product/features/<arg>/` を対象（feature mode）
- 無指定で features 配下に `brief.md` あり `pitch.md` 無しの WIP があれば候補として提示
- それも無ければ `docs/product/` 直下を対象（初期立ち上げ mode）

### 2. 入力読み込み

`brief.md` が存在することを必須確認。無ければ「先に `/product-refine` を実行してください」で停止。

**初期立ち上げ mode**:
- `docs/product/brief.md`（必須）
- `docs/product/discovery.md`, `docs/product/journey.md`, `docs/product/requirements.md`
- `docs/product/CONSTITUTION.md`（あれば）

**Feature mode**:
- 対象 feature の `proposal.md`, `delta.md`, `brief.md`（必須）
- 親 `discovery.md`, `journey.md`, `requirements.md`
- `decisions/*.md`（あれば）

### 3. 不足情報のヒアリング

ピッチには brief.md に書かれていない情報が必要になることが多い。以下を Read 後に確認し、欠けていればユーザーに質問する（最大 5 問まで、まとめて聞く）:

- **Market size**: TAM/SAM/SOM の数字、または参照可能な近接市場のサイズ
- **Traction**: ユーザー数 / 売上 / 待機リスト / インタビュー件数 / LOI など、現時点の引き合いを示す数字や事実
- **Unique Insight**: 「この市場で他の人が見落としている真実」が discovery.md の "Why Now" に書かれているか確認、不足なら追加で聞く
- **Business Model**: 収益化方法（Conditions Carried Forward や discovery には書かれていないことが多い）
- **Team**: 創業者 / コアメンバーの背景（Why Us を補強する具体的な経歴・受賞・実績）

トラクションが本当に何も無い場合は「early-stage / pre-launch」として正直に書く。捏造しない。

### 4. 9 セクションの執筆

参考記事の構成順を維持する。各セクションに「勝負の 1 文（hook）」と補足 2-4 行を書く。冗長な背景説明は禁止。

#### 0. Title
- プロダクト名 + **6〜10 語の概要**（日本語の場合 20-30 字目安）
- Airbnb 例: "Book rooms with locals, rather than hotels"

#### 1. Problem
- 顧客が直面する課題を 1 文で。聴衆が「あー、それ確かに困る」と頷ける具体性
- 太字で強調。誰の、どんな状況での、何の不便かを明確に

#### 2. Solution
- 解決策と生じる価値を 1 文で
- ユーザーが得る 3 つの価値（Save X / Make Y / Get Z 形式が分かりやすい）
- スクリーンショットがあるならファイルパスを参照、無ければ言葉で UI を描写

#### 3. Market
- 市場規模を数字で。TAM/SAM/SOM か近接市場のサイズ
- 数字が無い場合は「成長率 / 利用頻度 / 隣接市場の取引量」など、市場の存在を示す代替指標を使う

#### 4. Traction
- ユーザー数 / 売上 / 成長率 / インタビュー件数 / 待機リスト / LOI
- 何も無い場合は「pre-launch」と正直に書き、代わりに「<digital traction>: customer interview N 件、強い反応 X%」など、検証してきた事実を並べる

#### 5. Unique Insight
- 「他の人が見落としている真実」「Why Now」への答え
- 1 文の主張 + その根拠 1-2 個
- discovery.md の Why Now / Why Us を再構成

#### 6. Business Model
- 収益化方法を一言で（例: 「取引額の 10%」「月額 $X / 席」「広告」）
- 単価 × 想定ユーザー数の概算があれば添える

#### 7. Team（Why You）
- 創業者 / コアメンバーの背景
- 「この問題を解く unfair advantage」を裏付ける具体（経歴、受賞、過去の実績、ドメイン知識）

#### 8. Closing
- 聴衆に求める **具体的な次のアクション**（投資額、紹介、パイロット顧客、採用候補など）
- そのアクションを取った場合の 12 ヶ月後のコミット（数字付き）

### 5. 出力

対象パスに `pitch.md` を Write。

## 出力テンプレート

```markdown
# Pitch: <プロダクト名 / 機能名>

> 作成日: YYYY-MM-DD
> 想定発表時間: 3 min
> 対象聴衆: <投資家 | 経営層 | パイロット顧客 | 採用候補者 | その他>
> 入力: （Read したファイル一覧）

---

## 0. Title
**<プロダクト名>** — <6〜10 語のキャッチコピー>

---

## 1. Problem
**<1 文で問題を太字で>**

- 誰の問題か: ...
- どんな状況で起きるか: ...
- 既存の代替手段の限界: ...

---

## 2. Solution
**<1 文で解決策を太字で>**

ユーザーが得る価値:
- 💰 **<価値 1>**: ...
- ⚡ **<価値 2>**: ...
- 🤝 **<価値 3>**: ...

（UI のキー画面: <参照パス or 言葉で描写>）

---

## 3. Market

| 指標 | 数字 | 出典 |
|------|------|------|
| TAM | ... | ... |
| SAM | ... | ... |
| SOM | ... | ... |

近接市場の動き: ...

---

## 4. Traction

- <数字 1>: ...
- <数字 2>: ...
- <顧客の声を 1 件、引用形式で>

> "<顧客が言った印象的な一言>" — <顧客の属性>

（pre-launch の場合）
- インタビュー実施: N 件
- 強い反応（"今すぐ使いたい" 以上）: X / N
- 待機リスト: M 件

---

## 5. Unique Insight
**<他の人が見落としている真実を 1 文で>**

なぜ今か:
- ...

なぜ自分たちか:
- ...

---

## 6. Business Model
**<収益モデルを一言で>**

- 単価: ...
- 想定 N 人 / 月 → 月次収益 X
- ユニットエコノミクス（任意）: CAC <数字>, LTV <数字>

---

## 7. Team

| メンバー | 役割 | Why this person |
|---------|------|----------------|
| ... | Founder / CEO | <unfair advantage の具体> |
| ... | ... | ... |

アドバイザー / 出資者（あれば）:
- ...

---

## 8. Closing

**ask: <聴衆に求める具体的な次のアクション>**

このアクションが揃えば、12 ヶ月で達成すること:
- <数字付きのコミット 1>
- <数字付きのコミット 2>
- <数字付きのコミット 3>

---

## Open Questions（聴衆から想定される質問）
- Q: ... / A: ...
- Q: ... / A: ...
```

## 終了条件

- `pitch.md` が書かれている
- 各セクションに「勝負の 1 文」が太字で配置されている
- Title が 6-10 語（日本語なら 20-30 字目安）
- Traction セクションが空欄でない（数字が無い場合は pre-launch と明示し代替指標を入れる）
- Closing に具体的な ask と 12 ヶ月のコミットがある
- ユーザーに「ピッチ後の改訂は brief.md / discovery.md 側を更新してから再実行を推奨」と案内
