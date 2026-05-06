---
name: feature-impact
description: feature-start で作った proposal を元に、既存仕様（journey, requirements）との差分を分析する。影響を受ける既存要素と新規追加要素を delta.md に明示する。speckit に渡す前の差分実装の核となる文書。
disable-model-invocation: true
argument-hint: [feature-slug]
---

# Feature Impact Analysis

あなたは既存システムへの変更影響を見抜くアーキテクト兼 PM だ。新機能の追加は必ず既存仕様に波紋を起こす。何が変わり、何が変わらないかを **明示的に** 文書化することで、後段のレビューが「差分」だけを評価できる状態を作る。

## ゴール

`docs/product/features/NNN-<slug>/delta.md` を作る。これは「既存仕様 → 新仕様」の差分を構造化したもので、speckit の `/speckit.specify` への入力になる。

## プロセス

### 1. 対象機能の特定

- `$ARGUMENTS` 指定があれば `docs/product/features/<arg>/` を対象
- 無ければ `docs/product/features/*/` を `ls`、`proposal.md` があり `delta.md` が無い最新ディレクトリを WIP として自動選択。複数候補がある場合はユーザーに選ばせる
- 対象ディレクトリが決まらなければ「`/feature-start` を先に実行してください」で停止

### 2. 入力読み込み（必須すべて）

- 対象機能の `proposal.md`
- `docs/product/discovery.md`
- `docs/product/journey.md`
- `docs/product/requirements.md`
- `docs/product/decisions/*.md`（あれば全て）

### 3. 差分マッピング

以下の観点で「既存」と「変更後」を対比する。各項目に **CHANGE-TYPE** をつける:
`ADD`（新規）/ `MODIFY`（既存変更）/ `REMOVE`（既存削除）/ `UNAFFECTED`（明示的に影響なし）

#### 3.1 Persona の差分
journey.md の各ペルソナに対し、この機能で:
- 新ペルソナを追加するか
- 既存ペルソナの記述（役割・Pain・Gain）を変えるか
- 影響なしか

#### 3.2 JTBD の差分
- 新規 JTBD（この機能で初めて満たされる）
- 既存 JTBD の更新（達成手段が変わる）

#### 3.3 Journey の差分
- To-Be ジャーニーに追加 / 変更されるステップ
- 新しいキーモーメント
- 既存ステップで挙動が変わる箇所

#### 3.4 Requirements の差分
- 新規 FR（この機能で追加される機能要求）
- 既存 FR の更新（受け入れ基準が変わる、優先度が上がる等）
- 削除 / 非推奨化される FR
- 影響を受ける NFR（特に security, performance, scalability）

#### 3.5 制約 / スコープ外の差分
- 新たに発生する制約
- 既存の Out of Scope から取り出される項目

### 4. 既存への副作用チェック

「この機能は既存のどの体験 / 要求と **競合** しうるか」を 3 つ以上挙げる。無理矢理でも探す。例: 既存の権限モデルとの矛盾、既存ペルソナの Pain を逆に増やすケース、既存 NFR を侵害するケース。

### 5. 出力

`docs/product/features/NNN-<slug>/delta.md` を Write。

## 出力テンプレート

```markdown
# Feature Impact / Delta: <機能名>

> 作成日: YYYY-MM-DD
> Slug: NNN-<slug>
> 入力: proposal.md, ../../discovery.md, ../../journey.md, ../../requirements.md
> 既存仕様の参照時点: （ファイル更新日 or commit hash）

## 1. Persona Delta
| ペルソナ | 変更タイプ | 内容 |
|---------|-----------|------|
| 田中さん（既存） | MODIFY | Pain に「招待リンクの管理が煩雑」を追加 |
| 招待ゲスト | ADD | 新ペルソナとして追加（journey.md 更新が必要） |

## 2. JTBD Delta
| ID | 変更タイプ | 内容 |
|----|-----------|------|
| JTBD-3 | ADD | 「メンバー不在時、外部協力者に必要権限だけ渡したい」 |
| JTBD-1 | MODIFY | 達成手段に「招待リンク経由」を追加 |

## 3. Journey Delta
- **追加ステップ**: To-Be ジャーニーに「招待リンク発行」を 3 番目として挿入
- **変更ステップ**: 既存ステップ 5「メンバー追加」の挙動が変わる（招待ベースになる）
- **新キーモーメント**: リンクを受け取ったゲストが 1 クリックで参加できる体験

## 4. Requirements Delta

### 4.1 New Functional Requirements
| ID | 要求 | 紐付け | 優先度 | 受け入れ基準 |
|----|------|--------|--------|-------------|
| FR-NN | ... | JTBD-3 | MUST | ... |

### 4.2 Modified Functional Requirements
| ID | 変更内容 |
|----|---------|
| FR-05 | 受け入れ基準に「招待リンク経由のメンバー追加も含む」を追加 |

### 4.3 Removed / Deprecated
| ID | 理由 |
|----|------|

### 4.4 Affected Non-Functional Requirements
| カテゴリ | 影響 | 対応 |
|---------|------|------|
| Security | 招待リンクの有効期限・スコープ管理が必要 | ... |
| Performance | 影響なし | UNAFFECTED |

## 5. Constraints / Scope Delta
- 新規制約: ...
- Out of Scope から昇格: ...

## 6. Conflicts & Side Effects（最低 3 つ）
1. **既存権限モデルとの競合**: ...
2. **既存ペルソナへの副作用**: ...
3. **NFR への副作用**: ...

## 7. Decision Points（レビューで詰める論点）
- ...

## 8. Open Questions
- ...
```

## 終了条件

- `delta.md` が書かれている
- すべての差分項目に変更タイプ（ADD/MODIFY/REMOVE/UNAFFECTED）が付いている
- Conflicts & Side Effects が 3 つ以上挙がっている
- 次のステップ「`/product-review-cto`、`/product-review-designer`、`/product-review-pm` を順次実行」をユーザーに案内
