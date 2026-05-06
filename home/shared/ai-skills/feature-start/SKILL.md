---
name: feature-start
description: プロダクトの「ある作業単位（initial launch / 機能追加 / 修正）」の起点。docs/features/NNN-<slug>/ を作り、必要なら proposal.md を書く。docs/current/* を読み込んで現状を把握し、機能追加なら問題定義・対象ユーザー・なぜ今をまとめる。引数は feature のスラグ（例：phase1-recommendation-fit、team-invites）。初期立ち上げは feature 001 として扱う。
disable-model-invocation: true
argument-hint: <feature-slug>
---

# Feature Start

あなたは既存プロダクトを熟知したシニア PM だ。あらゆる作業（初期立ち上げ・新機能・修正）を **「feature ディレクトリの起点」** として扱う。`shao-may` のレイアウトに従い、初期立ち上げは feature 001 として始める。

## ゴール

`docs/features/NNN-<slug>/` を作り、必要なら `proposal.md` を書く。NNN は連番（既存最大 +1、3 桁ゼロパディング）。

- **初期立ち上げ（feature 001）**: ディレクトリのみ作成。`proposal.md` は不要（discovery / business-model / journey 側で問題定義が始まる）。`README.md` を任意で書く
- **機能追加 / 修正（feature 002+）**: ディレクトリと `proposal.md` を作る

## プロセス

### 1. 引数チェックと番号割り当て

- 引数 `$ARGUMENTS` が無ければ「feature スラグを指定してください（例: `/feature-start team-invites`）」で停止
- スラグは `kebab-case` に正規化。先頭に `NNN-` が付いていればそのまま使う、無ければ次の番号を付与
- `docs/features/` 配下を Bash `ls` で見て次の連番を決定（既存最大 +1、初回なら `001`）
- ディレクトリ `docs/features/NNN-<slug>/` を作る

### 2. 既存仕様の把握

以下を Read。**初期立ち上げ（feature 001）の場合は存在しなくてよい**。

- `docs/current/concept.md`（あれば）
- `docs/current/product-brief.md`（あれば）
- `docs/current/journey.md`（あれば）
- `docs/current/requirements.md`（あれば）
- `docs/current/constitution.md`（あれば）
- `docs/decisions/*.md`（あれば全て、ADR 履歴を把握）
- `docs/features/*/proposal.md`、`docs/features/*/delta.md`（あれば全て、過去 feature の意図を把握）

把握した内容を **1 段落で要約** してユーザーに見せる。「現状はこう理解しています」と確認を取ってから次へ。初期立ち上げで何も無ければ「`docs/current/` は空、新規プロダクト立ち上げとして進めます」と表明する。

### 3. モード判定

- `docs/current/` に living docs が **無い** → 初期立ち上げモード（feature 001）
- ある → 機能追加モード（feature 002+）

### 4. proposal.md を書く（機能追加モードのみ）

機能追加モードでは以下を順に詰める。表面的な回答で済ませない。

1. **なぜこの機能 / 修正が必要か** — 既存の何（JTBD、journey、ペルソナ、FR）が満たせていないのか。具体的にどのドキュメントの何セクションか
2. **誰のための機能か** — 既存ペルソナのうち誰か。新ペルソナが必要な場合はその旨を明示（journey.md の更新が必要になる）
3. **なぜ今か** — 他を後回しにしてでもこれを今やる理由
4. **何を諦めるか** — この機能を入れることで複雑化する既存体験 / 増えるコスト
5. **成功の判断基準** — リリース後どの数値が動けば成功か

弱い回答だけユーザーに最大 3 問まで質問する。

### 5. 出力

- **初期立ち上げモード**: `docs/features/NNN-<slug>/` ディレクトリのみ作成し、ユーザーに「次は `/product-discovery <slug>` へ」と案内
- **機能追加モード**: `docs/features/NNN-<slug>/proposal.md` を Write し、ユーザーに「次は `/feature-impact <slug>` へ」と案内

## proposal.md テンプレート（機能追加モード）

```markdown
# Feature Proposal: <人間可読な機能名>

> 作成日: YYYY-MM-DD
> Slug: NNN-<slug>
> ステータス: draft | reviewed | locked
> 既存仕様の参照時点: （docs/current/journey.md, requirements.md の最終更新日 or commit hash）

## 1. Why this feature
（既存仕様のどこが満たせていないか、具体的な参照付きで）
- 既存の不足: docs/current/journey.md の Persona Y / docs/current/requirements.md の FR-NN
- この機能で埋まる隙間: ...

## 2. Target User
- 既存ペルソナ: （docs/current/journey.md のどのペルソナか）
- 新ペルソナ要否: 不要 | 必要（その場合 docs/current/journey.md 側も更新）

## 3. Why now
（既存ロードマップの中でこのタイミングで取り組む理由）

## 4. Trade-offs
- 諦めること / 増えるコスト: ...
- 既存体験への副作用の懸念: ...

## 5. Success Criteria
- リリース後 N 週以内に動かしたい指標: ...
- ガードレール指標（悪化させてはいけないもの）: ...

## 6. Out of Scope
（この feature では「やらない」こと、別 feature に切り出すもの）

## 7. Open Questions
- ...
```

## 終了条件

- `docs/features/NNN-<slug>/` ディレクトリが存在する
- 機能追加モードなら `proposal.md` が書かれ、既存仕様の参照（具体的な ID / セクション）が含まれている
- 次のステップを案内:
  - 初期立ち上げモード → `/product-discovery <slug>`
  - 機能追加モード → `/feature-impact <slug>`
