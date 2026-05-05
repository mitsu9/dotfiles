# dotfiles

macOSの個人開発環境を Ansible でプロビジョニングする dotfiles リポジトリ。

## ディレクトリ構造

- `home/` — ホームディレクトリへ symlink / copy される全コンテンツ。ツール名で1階層切る（例: `home/zsh/zshrc`）
- `home/shared/` — 複数ツールから参照される共有リソース（例: `home/shared/ai-skills` が `~/.claude/skills` と `~/.codex/skills` の両方にリンクされる）
- `provisioning/` — Ansible playbook 一式
- `up` — ブートストラップエントリポイント

## エントリポイント

- `./up` — Homebrew 未導入なら入れて、`ansible` を入れ、`provisioning/run.sh` を実行する
- `provisioning/run.sh` — `provisioning/playbook.yml` を `--ask-become-pass` 付きで `ansible-playbook` 実行する
- 変数は `provisioning/group_vars/all.yml` を Ansible が自動でロードする

## 設定の追加・変更フロー

ほぼ全ての設定は **`provisioning/group_vars/all.yml` を編集してから `./up`** で反映される。

- パッケージ追加（CLI / GUI）: `homebrew.packages` / `homebrew.applications`
- 言語ランタイム: `asdf.plugins` と `asdf.global_settings`
- npm / go / uv のグローバルツール: 各 `*.packages`
- VSCode 拡張: `vscode.extensions`
- ghq で clone する repo: `github.repositories`

## シンボリックリンク

`group_vars/all.yml` の `links:` / `copy:` で配置を定義する。`link` 役割（`provisioning/roles/link/tasks/main.yml`）が処理する。

- `links:` — symlink リスト。`{ src: home/<path>, dest: <home からの相対パス> }`
- `copy:` — symlink ではなくコピー（`zshrc_local.sample` → `~/.zshrc_local` のような初期値配布用途）

新しい dotfile を足すときは、ファイルを `home/<tool>/` 配下に置いてから `links:` か `copy:` に登録する。
