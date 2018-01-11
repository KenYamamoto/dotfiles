colorscheme molokai

set number "行番号を表示する
set title "編集中のファイル名を表示
set showmatch "括弧入力時の対応する括弧を表示
syntax on "コードの色分け
set tabstop=4 "インデントをスペース4つ分に設定
set autoindent
set smartindent "オートインデント
set display=lastline "一行をちゃんと表示する
set pumheight=10 "補完メニューの高さ

"File
"ファイル変更中でも他のファイルを開けるようにする
set hidden
"ファイル内容が変更されると自動読み込みする
set autoread

"ターミナル接続を高速にする
set ttyfast
"ターミナルで256色表示を使う
set t_Co=256

set cursorline " カーソルラインをハイライト
set wildmenu " コマンドモードの補完
set history=5000 " 保存するコマンド履歴の数

"search
set incsearch    "インクリメンタルサーチを行う
set hlsearch    "検索結果をハイライトする
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る

" ESCキー2度押しでハイライトの切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

"ハイライト表示/非表示
nnoremap <ESC><ESC> :nohlsearch<CR>

"自動コメントアウト無効
autocmd FileType * setlocal formatoptions-=ro

"途中からコピー
nnoremap Y y$

if $TMUX != ""
  augroup titlesettings
  autocmd!
  autocmd BufEnter * call system("tmux rename-window " . "'[vim] " . expand("%:t") . "'")
  autocmd VimLeave * call system("tmux rename-window zsh")
  autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
  augroup END
endif

" set number
function Settingnumber()
		if &number
				setlocal nonumber
		else
				setlocal number
		endif
endfunction
nnoremap <silent> <C-@> :call Settingnumber()<CR>

" gtags
" 検索結果Windowを閉じる
nnoremap <C-q> <C-w><C-w><C-w>q
" Grep 準備
nnoremap <C-g> :Gtags -g
" このファイルの関数一覧
nnoremap <C-l> :Gtags -f %<CR>
" カーソル以下の定義元を探す
nnoremap <C-j> :Gtags <C-r><C-w><CR>
" カーソル以下の使用箇所を探す
nnoremap <C-k> :Gtags -r <C-r><C-w><CR>
" 次の検索結果
nnoremap <C-n> :cn<CR>
" 前の検索結果
nnoremap <C-p> :cp<CR>

" インサート／ノーマルどちらからでも呼び出せるようにキーマップ
nnoremap <silent> <C-x> :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
inoremap <silent> <C-x> <ESC>:<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <C-c> :<C-u>Unite buffer file_mru<CR>
inoremap <silent> <C-c> <ESC>:<C-u>Unite buffer file_mru<CR>

" grep検索のショートカット
nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

" paste setting
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif

" unite grepにjvgrepを使う
if executable('jvgrep')
    let g:unite_source_grep_command = 'jvgrep'
    let g:unite_source_grep_default_opts = '-r'
    let g:unite_source_grep_recursive_opt = '-R'
endif

hi SpecialKey ctermfg=darkgray
set list listchars=tab:>-

" dein
autocmd VimEnter * execute 'NERDTree'
let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &compatible
  set nocompatible
endif

if !isdirectory(s:dein_repo_dir)
  execute '!git clone git@github.com:Shougo/dein.vim.git' s:dein_repo_dir
endif

execute 'set runtimepath^=' . s:dein_repo_dir

call dein#begin(s:dein_dir)

call dein#add('Shougo/dein.vim')
call dein#add('scrooloose/nerdtree')
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/neocomplete.vim') " 補完
call dein#add('itchyny/lightline.vim') " 情報を見やすく
call dein#add('bronson/vim-trailing-whitespace') " 自動末尾空白除去
call dein#add('Shougo/neosnippet.vim') " スニペット
call dein#add('Shougo/neosnippet-snippets') " スニペット
call dein#add('Shougo/neomru.vim')
call dein#add('scrooloose/syntastic')
call dein#add('Yggdroot/indentLine')
call dein#end()

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on
