---
name: spec-review-plan-eng
description: Spec Kit の plan.md をエンジニア観点でレビューする。/spec-review-plan-eng として、実装前の architecture、data flow、contract、test coverage、performance、security/privacy、repo boundary、rollout/operations の抜けを検出したい時に使う。plan.md、spec.md、research/data-model/database/contracts/tasks などの Speckit artifacts を横断して、実装前に設計リスクと修正案を固める。
---

# Spec Plan Engineering Review

Spec Kit の `plan.md` を、実装開始前の engineering gate としてレビューする。gstack の plan engineering review の考え方を参考にし、スコープ圧縮、設計境界、テスト完全性、失敗モード、性能、運用、並列実装可能性を具体的に確認する。

## 原則

- レビューは非破壊で開始する。`plan.md` や関連 artifact は、ユーザーが明示的に「反映して」「修正して」と依頼した時だけ編集する。
- 問題は必ずファイルと行番号に結びつける。根拠が artifact に無い場合は「未記載」または「推測」と明示する。
- 重大度と確信度を分ける。高リスクだが未確認のものは、断定せず検証方法を書く。
- 完全な実装計画を好む。AI で数分増えるだけの shortcut は、後で事故るなら complete option を推奨する。
- 既存の Spec Kit artifact と隣接 repo の実態を優先する。外部ベストプラクティスは、必要な時だけ公式 docs や一次情報で確認する。

## 対象検出

1. ユーザーがファイルを指定した場合はその `plan.md` を対象にする。
2. 未指定なら、現在の branch 名に一致する `specs/<branch>/plan.md` を探す。
3. 見つからなければ、`specs/*/plan.md` のうち直近更新のものを候補にする。複数あり判断不能なら、候補を列挙してユーザーに確認する。
4. `AGENTS.md` や repo instruction が追加 context を指定している場合は従う。

## 入力読み込み

対象 feature directory から、存在するものだけ読む。

- 必須: `plan.md`, `spec.md`
- 強く推奨: `research.md`, `data-model.md`, `database.md`, `quickstart.md`, `tasks.md`
- Contract: `contracts/*.md`
- Checklists: `checklists/*.md`
- Product context: `docs/current/*.md`（特に `journey.md`、`requirements.md`、`product-brief.md`、`constitution.md`）、`docs/decisions/*.md`、`docs/features/<slug>/*.md` など plan が参照しているもの
- 実装 repo: plan が隣接 repo や package を参照する場合、該当 `README.md`, manifest, test config, source layout を確認する

## Step 0: Scope Challenge

レビュー本文に入る前に、次を短く結論づける。

1. 既存 artifact / code / flow で既に解けている部分は何か。
2. 目的達成に必要な最小変更は何か。
3. plan が 8 ファイル以上、2 つ以上の新 service/class、または新 infra を前提にする場合、過剰設計の疑いを明示する。
4. 新しい framework、runtime、DB 機能、外部 API、concurrency pattern を採用する場合、built-in や現在の推奨を確認する。情報が変わり得るものは公式 docs を優先して web 確認する。
5. distribution / rollout が必要な成果物なのに build、publish、deploy、rollback が未定義なら scope gap として扱う。
6. `NOT in scope` が明確か確認する。暗黙に落ちている作業は明示的な deferred work として提案する。

過剰設計またはスコープ不足が致命的なら、先に「縮小案 / 維持案 / 調査案」を提示し、ユーザー判断が必要な点として分ける。

## レビュー軸

各軸を必ず評価する。問題がなければ「No issues found」と書く。

### 1. Architecture

- system boundary、module boundary、repo boundary が実装可能な粒度か
- dependency direction が逆流していないか
- data flow が request/event/job/DB/API の順で追えるか
- failure scenario が plan に織り込まれているか
- ASCII diagram が必要な複雑さなのに無い箇所はないか

### 2. Contract and Data Model

- API/event/schema が client/server/tasks と一致しているか
- ID、join key、state transition、idempotency、retry、dedupe が定義されているか
- migration、backfill、seed data、retention、privacy deletion が必要なら計画されているか
- DB index、constraint、transaction boundary が性能/整合性要件に足りるか

### 3. Code Quality and Maintainability

- 実装順が Clean Architecture、DDD、layering など plan の設計方針と整合しているか
- 重複実装や parallel abstraction を作っていないか
- explicit で保守しやすい設計か。clever な暗黙ルールに依存していないか
- 12 ヶ月後に変更しにくい選択がないか

### 4. Tests

全 codepath と user flow をテスト対象として扱う。単に「unit test を書く」だけなら不足。

- unit / integration / contract / e2e / accessibility / analytics / migration の責務分担
- success path、empty state、permission denied、timeout、stale data、invalid input、retry、concurrent action
- iOS / server / cross-repo contract の同期方法
- LLM/prompt がある場合は eval が定義されているか

必ず ASCII の coverage diagram を出す。

```text
CODE PATHS / ARTIFACTS                 USER FLOWS / FAILURE STATES
[GAP] contracts/home-feed              [GAP][E2E] cold start home
  |-- validation: missing               |-- no friends -> fallback reason
  |-- auth/session: covered?            |-- Apple Music denied
  |-- DB read model: missing index      |-- slow network retry

COVERAGE: 4/11 paths planned (36%)
GAPS: 7 total, 2 contract, 2 integration, 2 e2e, 1 analytics
```

### 5. Performance and Scalability

- latency target と実装手段が一致しているか
- N+1 query、large payload、cold start、cache invalidation、batch/job 設計
- DB index / query path / pagination / fan-out / rate limit
- mobile constraints: offline, low network, foreground/background, handoff latency

### 6. Security, Privacy, Operations

- authn/authz、secret/token handling、least privilege、PII minimization
- logging / metrics / alerting / dashboard / runbook / rollback
- feature flag、staged rollout、kill switch、migration safety
- external dependency outage 時の user-visible behavior

## Finding Format

Findings first。重大度順に並べる。

```text
[P1] (confidence: 8/10) specs/001-x/plan.md:42 - Home feed latency target is stated, but no read-model/indexing plan exists.
Impact: Users may wait on synchronous recommendation generation, violating the 2s first-home target.
Recommendation: Add an offline candidate generation + indexed delivery read model task before iOS integration.
Options: A) Add read-model/index tasks now (recommended) / B) Keep plan as-is and accept performance risk / C) Timebox a query design spike.
```

Severity guide:

- `P0`: plan would cause unsafe release, data loss, security breach, or impossible implementation.
- `P1`: likely implementation blocker or major user/business risk.
- `P2`: should fix before implementation, but not release-stopping.
- `P3`: polish, clarity, or follow-up.

Confidence guide:

- `9-10`: verified by specific artifact/code.
- `7-8`: strong pattern match with concrete artifact support.
- `5-6`: plausible but needs validation.
- `3-4`: appendix only unless severity is P0/P1.

## Required Output

Return a concise review with these sections:

````markdown
# Engineering Plan Review

対象: <plan path>
入力: <read files>

## Verdict
GO | GO-WITH-CONDITIONS | NO-GO
理由: ...

## Step 0 Scope Challenge
- What already exists: ...
- Minimum viable implementation: ...
- Scope risks: ...
- NOT in scope clarity: ...

## Findings
1. [P1] (confidence: 8/10) path:line - ...

## Test Coverage Diagram
```text
...
```

## Scores
| Axis | Score | Notes |
|------|-------|-------|
| Architecture | 0-10 | ... |
| Contract/Data | 0-10 | ... |
| Maintainability | 0-10 | ... |
| Tests | 0-10 | ... |
| Performance | 0-10 | ... |
| Security/Privacy/Ops | 0-10 | ... |

## Failure Modes
| Flow | Failure | Covered? | User impact |
|------|---------|----------|-------------|

## Recommended Plan Changes
- ...

## Deferred TODO Candidates
- What: ...
  Why: ...
  Depends on: ...

## Parallelization
Sequential implementation, no parallelization opportunity.
````

If there are independent workstreams, replace the final line with lanes:

```text
Lane A: contracts + server ports -> server contract tests
Lane B: iOS shell + MusicKit authorization
Merge gate: shared API fixtures
Then: cross-repo integration + metrics verification
Conflict flags: contracts/ touched by both lanes
```

## Editing Follow-up

If the user asks to apply fixes:

1. Edit the smallest set of Spec Kit artifacts needed to resolve accepted findings.
2. Keep production code out of docs-only repos.
3. Update `plan.md` and dependent artifacts consistently. If a contract changes, update tasks and quickstart references too.
4. Run repo-appropriate validation such as `rg` consistency checks, markdown checks, tests, or contract fixture checks.
5. Summarize exactly which findings were resolved and which remain.
