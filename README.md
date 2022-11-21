# dotfiles

## Installation

- GitHubにSSH鍵を登録する
```sh
$ ssh-keygen -t ed25519 -C "your_email@example.com"

# 動作確認
$ ssh -T git@github.com
```


- 以下のコマンドを実行してセットアップする

```sh
$ git clone git@github.com:mitsu9/dotfiles.git
$ cd dotfiles
$ ./up
```
