---
name: product-sync
description: speckit が feature を実装し終わった後、その feature の product-brief / delta を docs/current/* の living docs（journey, requirements など）に折り返し、ADR を docs/decisions/ に追加する。引数は完了した feature のスラグ。
disable-model-invocation: true
argument-hint: <feature-slug>
---

# Product Sync

あなたはプロダクトドキュメントの保守責任者だ。実装が完了した feature を、`docs/current/` の living docs（journey.md / requirements.md ほか）に **正しく折り返す**。これをしないと次の feature が古い前提で始まってしまう。

## ゴール

完了 feature の `product-brief.md`（current 側）と `delta.md` / `discovery.md` を読み:
1. `docs/current/journey.md` を更新（ペルソナ追加、To-Be ジャーニーへのステップ追加）
2. `docs/current/requirements.md` を更新（FR 追加 / 更新 / 非推奨化、NFR 影響反映）
3. 必要なら `docs/current/concept.md`、`docs/current/constitution.md`、その他 `docs/current/*` を更新
4. `docs/decisions/<topic-slug>.md` を作成（この feature で確定した重要な判断）
5. feature ディレクトリの状態を「shipped」相当にマークする（`README.md` 末尾に shipped log を追記）

## プロセス

### 1. 引数チェック

- 引数 `$ARGUMENTS` が無ければ「対象 feature のスラグを指定してください（例: `/product-sync 003-team-invites` または `team-invites`）」で停止
- スラグは完全一致 / suffix 一致のどちらでも受け付け、`docs/features/` 配下から該当ディレクトリを特定

### 2. 入力読み込み

- 対象 `docs/features/NNN-<slug>/` 配下の全ファイル: `discovery.md`、`business-model.md`、`proposal.md`、`delta.md`、`pitch.md`、`speckit-input.md`、`reviews/{cto,designer,pm}.md`、`README.md`
- `docs/current/product-brief.md`（必須、特に `Upstream Updates` セクション）
- `docs/current/journey.md`、`docs/current/requirements.md`、`docs/current/constitution.md`、`docs/current/concept.md`（存在するもの）
- `docs/decisions/` を `ls`（既存 ADR の slug を把握、衝突回避）
- 関連する `specs/<slug>/` の存在確認（あれば実装結果と仕様の同期を確認）

### 3. journey.md の更新

`product-brief.md` の `Upstream Updates` と `delta.md` の Persona/JTBD/Journey Delta から、`docs/current/journey.md` に対する具体的な編集案を作る。Edit ツールで以下を反映:

- 新ペルソナの追加
- 既存ペルソナの Pain/Gain 更新
- 新 JTBD の追加 / 既存 JTBD の更新
- To-Be ジャーニーへのステップ挿入
- 新キーモーメントの追加

各編集には `<!-- updated-by: NNN-<slug> @ YYYY-MM-DD -->` 形式のインラインコメントを付け、由来を追跡可能にする。

### 4. requirements.md の更新

- `delta.md` の New FR、または initial launch なら `product-brief.md` の In-Scope FR をそのまま追加（FR ID は `requirements.md` の最大値 +1 から振り直す）
- Modified FR を反映
- Removed/Deprecated FR は削除せず `[DEPRECATED in NNN-<slug>]` を ID 横に付けて残す（履歴保全）
- Affected NFR の対応事項を該当 NFR に追記

ID リマップが発生した場合（feature 内で FR-99 と書いていたものが requirements.md では FR-23 になる等）、`docs/features/NNN-<slug>/README.md` に「ID リマップ表」を追加する。

### 5. concept.md / constitution.md / その他 current/ の更新

`Upstream Updates` に該当指示があれば反映。プロダクト固有の正本（`recommendation.md`、`integration-*.md`、`wireframes.md`、`design/README.md` 等）も Upstream Updates の指示に従って更新する。

### 6. ADR の作成

`reviews/{cto,designer,pm}.md` と `product-brief.md` の Resolved Conflicts から「**この feature で確定した、後の意思決定に影響する判断**」を抽出する。基準:

- 採用 / 不採用が明示的に決まったアーキテクチャ・データモデル・UX パターン
- 守るべき制約（Conditions Carried Forward）
- 矛盾の解決ロジック
- monetization / privacy / boundary に関わる決定

各判断につき 1 つの ADR ファイルを作成: `docs/decisions/<topic-slug>.md`

- slug は **トピック中心**（例: `profile-shared-phase1`、`event-naming-convention`）。日付プレフィクスは強制しない（front matter の `date:` で日付を残す）
- 既存 ADR と slug が衝突する場合は接頭辞 / 接尾辞で区別する
- 重要判断が無ければ「特になし」のメモとして 1 ファイル残すか、ADR は省略してよい
- `docs/decisions/README.md` の記録一覧にエントリを追加する

### 7. feature ディレクトリのマーク

`docs/features/NNN-<slug>/README.md` を Read（無ければ作成）し、末尾に shipped log を追記:

```markdown
## Shipped

> Sync 日: YYYY-MM-DD
> 反映先:
> - docs/current/journey.md: <更新したセクション>
> - docs/current/requirements.md: <追加 FR ID, 更新 FR ID>
> - docs/current/<その他>: ...
> - docs/decisions: <作成した ADR ファイル>
```

`SHIPPED.md` という別ファイルは作らない（README.md に集約）。

### 8. ユーザー確認

すべての編集を行う前に、計画している変更を **箇条書きでサマリー表示** してユーザーに確認を取る。承認されたら Edit を実行。reject されたら個別に詰める。

## ADR テンプレート

```markdown
# ADR: <短いタイトル>

> 日付: YYYY-MM-DD
> 由来: docs/features/NNN-<slug>
> ステータス: accepted | superseded by <other-slug>

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

- `docs/current/journey.md` / `docs/current/requirements.md` が更新されている（追跡コメント付き）
- 必要に応じ `docs/current/` のその他正本も更新されている
- 0 個以上の ADR が `docs/decisions/` に作成され、`docs/decisions/README.md` の一覧に追加されている
- `docs/features/NNN-<slug>/README.md` の末尾に Shipped セクションが追記されている
- ユーザーに「次の feature を始めるなら `/feature-start <slug>` でどうぞ」と案内
