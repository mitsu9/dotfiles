################
## キーバインド ##
################
bindkey -e

##################
## 文字コード関係 ##
##################
# 文字コードの設定
export LANG=ja_JP.UTF-8
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

###########
## 色関係 ##
###########
# 色の使用できるようにする
autoload -U colors; colors
# PROMPT変数内で変数参照する
setopt prompt_subst
# プロンプト表示
PROMPT='%F{red} %F{yellow}%* %F{green}%n@%m %F{reset_color}at %F{cyan}%~%F{reset_color}'
PROMPT=$PROMPT' ${vcs_info_msg_0_} %F{cyan}%F{reset_color}
>>> '
SPROMPT='%F{red}??? もしかして %r のこと? [No/Yes/Abort/Edit]: %F{reset_color}'
# vcs_infoロード
autoload -Uz vcs_info
# vcsの表示
zstyle ':vcs_info:*' formats "on %F{magenta}%b %c %u %f" #通常
zstyle ':vcs_info:*' actionformats "on %F{magenta}%b%F{white}|%F{red}%a " #rebase 途中,merge コンフリクト等 formats 外の表示
zstyle ':vcs_info:git:*' check-for-changes true #formats 設定項目で %c,%u が使用可
zstyle ':vcs_info:git:*' stagedstr "%F{green}✚" #commit されていないファイルがある
zstyle ':vcs_info:git:*' unstagedstr "%F{blue}✹" #add されていないファイルがある
# プロンプト表示直前にvcs_info呼び出し
precmd() { vcs_info }

# ls時の色
export CLICOLOR=true

#############
## 補完関係 ##
#############
# 補完候補を一覧で表示
setopt auto_list
# 補完キー連打で候補順に自動で補完
setopt auto_menu
# コマンドで可能なオプションの補完
autoload -U compinit
compinit
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#############
## 履歴関連 ##
############
# 履歴を保存するファイル
HISTFILE=~/.zsh_history
# メモリに保存する履歴の件数
HISTSIZE=1000000
# ファイルに保存する履歴の件数
SAVEHIST=1000000
# 直前と重複するコマンドを無視
setopt hist_ignore_dups
# 履歴と重複するコマンドを保存しない
setopt hist_save_no_dups
# zsh間で履歴を共有
setopt share_history

###########
## その他 ##
###########
# ディレクトリ名のみで移動
setopt auto_cd
# cd時に自動でpushd
setopt auto_pushd
# 間違えてコマンド入力した時に修正してくれる
setopt correct
# ビープを鳴らさなk
setopt nobeep
# iTerm2のタブ名を変更する
function title {
    echo -ne "\033]0;"$*"\007"
}

###########
## alias ##
###########
alias .="pwd"
alias ..=".."
alias ...="../.."
alias ts="tig status"
alias c="clear"
alias gc="git commit -m"
alias gps="git push"
alias ssh=~/bin/ssh-background
alias be="bundle exec"
alias h="history -30"
alias g="git"

#############
## history ##
#############
function peco-history-selection() {
  BUFFER="$(history -nr 1 | awk '!a[$0]++' | peco --query "$LBUFFER" | sed 's/\\n/\n/')"
  CURSOR=$#BUFFER
  zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

#############
## パス設定 ##
############
# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath
# activatorのパス
export PATH=~/shinomilab_sdn/util/activator-dist-1.3.10/bin:$PATH
# for brew
export PATH=/usr/local/sbin:$PATH
# gopath
export GOPATH=$HOME/.go
# nodenev
export PATH=$HOME/.nodenv/bin:$PATH
eval "$(nodenv init -)"
# for wantaedly intern
export PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH
# nodebrew 
export PATH=$HOME/.nodebrew/current/bin:$PATH
# rbenv
export PATH=${HOME}/.rbenv/bin:${PATH}
eval "$(rbenv init -)"

###########
## ctags ##
###########
alias ctags="`brew --prefix`/bin/ctags"

###################
## local setting ##
###################
# githubにあげたくない設定を読み込む
source ~/.zshrc_local
