"" 表示
" 文字コード
set encoding=utf-8
" インデント
set autoindent
" 行番号の表示
set number
" 編集中の行をハイライト
set cursorline
" 対応する括弧をハイライト
set showmatch
set matchtime=1
" インクリメンタルサーチを有効にする
set incsearch
" 編集中のファイルでも保存せず他のファイルを表示する
set hidden
" タブを空白文字に置き換える
set expandtab

"" ステータス行
" ステータス行を常に表示
set laststatus=2
" ステータスラインにbranchを表示
set statusline+=%{fugitive#statusline()}

"" バックアップ
" backupファイルを作成しない
set nobackup
" swapファイルを作成しない
set noswapfile

" NeoBundle
" パスの設定
if has('vim_starting')
  set nocompatible
  set runtimepath+=/Users/mitsunobu/.vim/bundle/neobundle.vim/
endif
" プラグインのインストール
call neobundle#begin(expand('/Users/mitsunobu/.vim/bundle'))
NeoBundle 'tpope/vim-fugitive' " git
call neobundle#end()
" Required
filetype plugin indent on
NeoBundleCheck

"" カラースキーマ
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'chriskempson/vim-tomorrow-theme'
syntax on
set background=dark
if !has("gui_running")
  colorscheme Tomorrow-Night
else
endif

" auto reload .vimrc
augroup source-vimrc
  autocmd!
  autocmd BufWritePost *vimrc source $MYVIMRC | set foldmethod=marker
  autocmd BufWritePost *gvimrc if has('gui_running') source $MYGVIMRC
augroup END
