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
" ファイル名表示
set statusline=%F
" 変更チェック表示
set statusline+=%m
" これ以降は右寄せ表示
set statusline+=%=
" ステータスラインにbranchを表示
set statusline+=%{fugitive#statusline()}
" 空白2つ挿入
set statusline+=\ \ 
" カーソル行の表示
set statusline+=%1l/%L

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

" use dein.vim
if &compatible
  set nocompatible
endif
let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#add('haya14busa/incsearch.vim')
  call dein#add('kien/ctrlp.vim')
  call dein#add('elixir-lang/vim-elixir')
  call dein#add('soramugi/auto-ctags.vim')
  call dein#end()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

" Key map for haya14busa/incsearch.vim
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

"" setting got ctrlp
" キャッシュディレクトリ
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
" キャッシュをクリアしない
let g:ctrlp_clear_cache_on_exit = 0
" 遅延再描画
let g:ctrlp_lazy_update = 1
" CtrlPのウィンドウ最大高さ
let g:ctrlp_max_height = 20
" ルートパスと認識させるためのファイル
let g:ctrlp_root_markers = ['Gemfile', 'pom.xml', 'build.xml']

"" setting for auto-ctags
" 保存時に自動でtagを更新
let g:auto_ctags = 1
" git管理されていれば/.git/tagsにtagsファイルを作成
let g:auto_ctags_directory_list = ['.git']
" ctags実行時のオプション
let g:auto_ctags_tags_args = '--tag-relative --recurse --sort=yes'
" /.git/tagsを読み込ませる
:set tags+=.git/tags
" 複数候補あるときは一覧を表示
nnoremap <C-]> g<C-]>

" move window
nnoremap sl <C-w>l
nnoremap sh <C-w>h
