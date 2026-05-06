---
name: product-sync
description: speckit が機能を実装し終わった後、その feature の brief / delta を top-level の living docs（journey, requirements）に折り返し、ADR を decisions/ に追加する。引数は完了した feature のスラグ。
disable-model-invocation: true
argument-hint: <feature-slug>
---

# Product Sync

あなたはプロダクトドキュメントの保守責任者だ。実装が完了した feature を、トップレベルの living docs（journey.md / requirements.md）に **正しく折り返す**。これをしないと次の feature が古い前提で始まってしまう。

## ゴール

完了 feature の `brief.md` と `delta.md` を読み:
1. `docs/product/journey.md` を更新（ペルソナ追加、To-Be ジャーニーへのステップ追加）
2. `docs/product/requirements.md` を更新（FR 追加 / 更新 / 非推奨化、NFR 影響反映）
3. `docs/product/decisions/YYYY-MM-DD-<slug>.md` を作成（この feature で確定した重要な判断）
4. feature ディレクトリのステータスを `shipped` にマーク

## プロセス

### 1. 引数チェック

- 引数 `$ARGUMENTS` が無ければ「対象 feature のスラグを指定してください（例: `/product-sync 003-team-invites` または `team-invites`）」で停止
- スラグは完全一致 / suffix 一致のどちらでも受け付け、`docs/product/features/` 配下から該当ディレクトリを特定

### 2. 入力読み込み

- 対象 `features/NNN-<slug>/brief.md`（必須）
- 対象 `features/NNN-<slug>/delta.md`（必須）
- 対象 `features/NNN-<slug>/proposal.md`
- 対象 `features/NNN-<slug>/reviews/{cto,designer,pm}.md`（ADR 抽出のため）
- top-level `docs/product/{discovery,journey,requirements}.md`
- `docs/product/decisions/` を `ls`（既存 ADR の番号を把握）

### 3. journey.md の更新

`brief.md` の Upstream Updates と `delta.md` の Persona/JTBD/Journey Delta から、journey.md に対する具体的な編集案を作る。Edit ツールで以下を反映:

- 新ペルソナの追加
- 既存ペルソナの Pain/Gain 更新
- 新 JTBD の追加 / 既存 JTBD の更新
- To-Be ジャーニーへのステップ挿入
- 新キーモーメントの追加

各編集には `<!-- added-by: NNN-<slug> @ YYYY-MM-DD -->` 形式のインラインコメントを付け、由来を追跡可能にする。

### 4. requirements.md の更新

- `delta.md` の New FR をそのまま追加（FR ID は requirements.md の最大値 +1 から振り直す）
- Modified FR を反映
- Removed/Deprecated FR は削除せず `[DEPRECATED in NNN-<slug>]` を ID 横に付けて残す（履歴保全）
- Affected NFR の対応事項を該当 NFR に追記

ID リマップが発生した場合（feature 内で FR-99 と書いていたものが requirements.md では FR-23 になる等）、`brief.md` 末尾に「ID リマップ表」を追加する。

### 5. ADR の作成

`reviews/{cto,designer,pm}.md` と `brief.md` の Resolved Conflicts から「**この feature で確定した、後の意思決定に影響する判断**」を抽出する。基準:

- 採用 / 不採用が明示的に決まったアーキテクチャ・データモデル・UX パターン
- 守るべき制約（Conditions Carried Forward）
- 矛盾の解決ロジック

各判断につき 1 つの ADR ファイルを作成: `docs/product/decisions/YYYY-MM-DD-<short-slug>.md`

### 6. feature ディレクトリのマーク

`features/NNN-<slug>/proposal.md` の冒頭ステータスを `shipped` に Edit する。`features/NNN-<slug>/SHIPPED.md` を Write し、以下を残す:

```markdown
# Shipped

> Sync 日: YYYY-MM-DD
> 反映先:
> - journey.md: <更新したセクション>
> - requirements.md: <追加 FR ID, 更新 FR ID>
> - decisions: <作成した ADR ファイル>
```

### 7. ユーザー確認

すべての編集を行う前に、計画している変更を **箇条書きでサマリー表示** してユーザーに確認を取る。承認されたら Edit を実行。reject されたら個別に詰める。

## ADR テンプレート

```markdown
# ADR: <短いタイトル>

> 日付: YYYY-MM-DD
> 由来: features/NNN-<slug>
> ステータス: accepted

## Context
（この判断が必要になった背景。どの feature で、どんな選択肢があったか）

## Decision
（採用したこと。具体的に）

## Rationale
（なぜそれを選んだか。CTO/Designer/PM のどの観点が決め手だったか）

## Consequences
- 良い影響: ...
- 悪い影響 / トレードオフ: ...
- 制約として残るもの: ...

## Alternatives considered
- 不採用案 1: ... / 不採用理由: ...
```

## 終了条件

- journey.md / requirements.md が更新されている（追跡コメント付き）
- 1 つ以上の ADR が `decisions/` に作成されている（重要判断が無ければ「特になし」のメモを ADR として残す）
- feature ディレクトリに `SHIPPED.md` が書かれ、proposal.md のステータスが `shipped` になっている
- ユーザーに「次の feature を始めるなら `/feature-start <slug>` でどうぞ」と案内
