" My vimrc from years of hacking.
" It hsa many very weird hacks because I couldn't find the correct plugins to
" do stuff.
" For example, `;` is mapped to `la` so that Alt-L is equivalent to right
" arrow in insert mode,
" and `,` is mapped to `;` because I didn't know `;` would be so useful when I
" mapped `;` at first.
"
" For most settings, I forgot what they mean once I had them written.
" Only the muscle memory remains for using the consequence.
" IT JUST WORKS!

" Setting some decent VIM settings for programming
" This source file comes from git-for-windows build-extra repository (git-extra/vimrc)

ru! defaults.vim                " Use Enhanced Vim defaults
runtime macros/matchit.vim      " jump between <x> </x>
set mouse=                      " Reset the mouse setting from defaults
aug vimStartup | au! | aug END  " Revert last positioned jump, as it is defined below
let g:skip_defaults_vim = 1     " Do not source defaults.vim again (after loading this system vimrc)

set ai                          " set auto-indenting on for programming
set showmatch                   " automatically show matching brackets. works like it does in bbedit.
set vb                          " turn on the "visual bell" - which is much quieter than the "audio blink"
set laststatus=2                " make the last line where the status is two lines deep so you can see status always
set showmode                    " show the current mode
set clipboard=unnamed           " set clipboard to unnamed to access the system clipboard under windows
set wildmode=list:longest,longest:full   " Better command line completion
" set hlsearch

" Show EOL type and last modified timestamp, right after the filename
" Set the statusline
set statusline=%f               " filename relative to current $PWD
set statusline+=%h              " help file flag
set statusline+=%m              " modified flag
set statusline+=%r              " readonly flag
set statusline+=\ [%{&ff}]      " Fileformat [unix]/[dos] etc...
set statusline+=\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})  " last modified timestamp
set statusline+=%=              " Rest: right align
set statusline+=%l,%c%V         " Position in buffer: linenumber, column, virtual column
set statusline+=\ %P            " Position in buffer: Percentage

set autoread " auto reload external changes

" if &term =~ 'xterm-256color'    " mintty identifies itself as xterm-compatible
	" if &t_Co == 8
		" set t_Co = 256              " Use at least 256 colors
	" endif
	" " set termguicolors           " Uncomment to allow truecolors on mintty
" endif
set t_Co=16
"------------------------------------------------------------------------------
" Only do this part when compiled with support for autocommands.
if has("autocmd")
	" Set UTF-8 as the default encoding for commit messages
	autocmd BufReadPre COMMIT_EDITMSG,MERGE_MSG,git-rebase-todo setlocal fileencodings=utf-8

	" Remember the positions in files with some git-specific exceptions"
	autocmd BufReadPost *
				\ if line("'\"") > 0 && line("'\"") <= line("$")
				\           && &filetype !~# 'commit\|gitrebase'
				\           && expand("%") !~ "ADD_EDIT.patch"
				\           && expand("%") !~ "addp-hunk-edit.diff" |
				\   exe "normal g`\"" |
				\ endif

	autocmd BufNewFile,BufRead *.patch set filetype=diff

	autocmd Filetype diff
				\ highlight WhiteSpaceEOL ctermbg=red |
				\ match WhiteSpaceEOL /\(^+.*\)\@<=\s\+$/
endif " has("autocmd")

highlight ExtraWhitespace ctermbg=green guibg=green ctermfg=darkred guifg=darkred
match ExtraWhitespace /\s\+$/

syn match comment "\v(^\s*//.*\n)+" fold

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" System
Plugin 'VundleVim/Vundle.vim'
Plugin 'SOF3/signed-vimrc'

" Behaviour
Plugin '907th/vim-auto-save'
Plugin 'editorconfig/editorconfig-vim' " EditorConfig indents
Plugin 'tpope/vim-surround'
Plugin 'ycm-core/YouCompleteMe'

" Cosmetic
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'enricobacis/vim-airline-clock'
Plugin 'hugolgst/vimsence' " Discord Rich Presence
Plugin 'Yggdroot/indentLine' " indent guides

" Language support
Plugin 'cstrahan/vim-capnp' " CapnProto
Plugin 'elixir-editors/vim-elixir'
Plugin 'tikhomirov/vim-glsl' " GLSL
Plugin 'mustache/vim-mustache-handlebars' " Handlebars
Plugin 'udalov/kotlin-vim' " Kotlin
Plugin 'qnighy/lalrpop.vim' " lalrpop
Plugin 'drmingdrmer/vim-syntax-markdown' " Markdown
Plugin 'ron-rs/ron.vim' " RON
Plugin 'racer-rust/vim-racer' " Rust
Plugin 'lervag/vimtex' " Tex
Plugin 'cespare/vim-toml' " TOML
Plugin 'leafgarland/typescript-vim' " TypeScript
Plugin 'posva/vim-vue' " Vue

if filereadable($HOME . "/.vim-local-ext")
	source $HOME/.vim-local-ext
endif
call vundle#end()
filetype plugin indent on

set hidden
let g:racer_cmd = "~/.cargo/bin/racer"
let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1

let g:airline_powerline_fonts = v:true
let g:airline_theme='luna'
let g:airline#extensions#clock#format = '%H:%M:%S'
let g:airline#extensions#clock#updatetime = 1000

let g:indentLine_setConceal = 0

let g:tex_flavor = 'latex'

let g:ycm_goto_buffer_command = 'new-tab'

set updatetime=500
autocmd CursorHold,CursorHoldI * update

set completeopt=longest,menuone

set nu ai sc sm ic smartcase smd ts=2 sw=2
set wim=list:longest,longest:full
set t_vb=
set fdm=indent foldlevel=1
inoremap " ""<left>
inoremap """ """"""<left><left><left>
inoremap \" \"
inoremap \\ \\
inoremap "" ""
" inoremap ' ''<left>
inoremap ` ``<left>
inoremap ( ()<left>
inoremap () ()
inoremap [ []<left>
inoremap [] []
inoremap { {}<left>
inoremap {} {}
inoremap {<CR> {}<left><CR><ESC>O
inoremap {;<CR> {<CR>};<ESC>O
inoremap {,<CR> {<CR>},<ESC>O
inoremap $$<SPACE> $$<SPACE><SPACE>$$<ESC>hhi

nnoremap ; la
nnoremap , ;
nnoremap f<CR> ;
nnoremap ' `

nnoremap c(( di(%r(``r)Pl%
nnoremap c([ di(%r[``r]Pl%
nnoremap c({ di(%r{``r}Pl%
nnoremap c[( di[%r(``r)Pl%
nnoremap c[[ di[%r[``r]Pl%
nnoremap c[{ di[%r{``r}Pl%
nnoremap c{( di{%r(``r)Pl%
nnoremap c{[ di{%r[``r]Pl%
nnoremap c{{ di{%r{``r}Pl%

nnoremap d() di(hPld2l
nnoremap d[] di[hPld2l
nnoremap d{} di{hPld2l

nnoremap c'" di'r"hr"p
nnoremap c"' di"r'hr'p
nnoremap c"` di"r`hr`p

vnoremap () c()<ESC>Pl%
vnoremap [] c[]<ESC>Pl%
vnoremap {} c{}<ESC>Pl%
vnoremap {<CR> c{<CR>}<ESC>P
vnoremap "" c""<ESC>P
vnoremap '' c''<ESC>P
vnoremap `` c``<ESC>P
vnoremap <> c<lt>><ESC>P

nnoremap Y :call system('xclip -i', @@)

nnoremap 'u mmgg/^use <CR>
nnoremap / mm/
nnoremap ? mm?
nnoremap * mm*
nnoremap # mm#
nnoremap : mm:
nnoremap gg mmgg
nnoremap g/ mmgg/
nnoremap G mmG
nnoremap Z :YcmCompleter GoTo

nnoremap <C-T> :tabedit 
inoremap <C-T> <ESC>:tabedit 
nnoremap g1 1gt
nnoremap g2 2gt
nnoremap g3 3gt
nnoremap g4 4gt
nnoremap g5 5gt
nnoremap g6 6gt
nnoremap g7 7gt
nnoremap g8 8gt
nnoremap g9 9gt

" Return to last position
au BufReadPost * if line("'\"") > 1 && line("'\"") <- line("$") | exe "normal! g'\"" | endif

" set filetype=xxx overrides the filetype
" setfiletype xxx provides default filetype
au BufRead,BufNewFile *.tex set filetype=tex
au BufRead,BufNewFile *.rviz set filetype=yaml
au BufRead,BufNewFile *.launch setfiletype xml
au BufRead,BufNewFile .eslintrc setfiletype json
au BufRead,BufNewFile *.rs set fdm=syntax foldlevel=0
au BufRead,BufNewFile *.py set foldlevel=0
au BufRead,BufNewFile *.xml inoremap </ </<C-X><C-O><ESC>mt==`tF<i
au BufRead,BufNewFile *.html inoremap </ </<C-X><C-O><ESC>mt==`tF<i
au BufRead,BufNewFile *.launch inoremap </ </<C-X><C-O><ESC>mt==`tF<i
au BufRead,BufNewFile *.tex nnoremap *$ :read /k/private/sofe/sys/templates/align.tex<CR>o
au BufRead,BufNewFile *.tex nnoremap ** :read /k/private/sofe/sys/templates/itemize.tex<CR>o
au BufRead,BufNewFile *.tex nnoremap *# :read /k/private/sofe/sys/templates/enumerate.tex<CR>o
au BufRead,BufNewFile *.Rmd nnoremap <C-K> :!Rscript -e "rmarkdown::render('%')"

command W :vertical resize 30
command Fmt :call Fmt_()

let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_browse_split = 2
let g:netrw_winsize = 20
augroup ProjectDrawer
	autocmd!
	"autocmd VimEnter * :vsp .
	"autocmd VimEnter * :vertical resize 30
	"autocmd VimEnter * :winc l
augroup END

function Fmt_()
	:!cargo fmt --all
	:bufdo e
endfunction

au BufRead,BufNewFile *.tex command -nargs=* Prtsc :call PrtscTex_(<f-args>)
function PrtscTex_(...)
	if a:0 > 0
		let file = system("bash -ic 'prtsc " . a:1 . "' 2>/dev/null")
	else
		let file = system("bash -ic 'prtsc " . "' 2>/dev/null")
	endif
	put ='\includegraphics{' . substitute(file, '\n\+$', '', '') . '}'
endfunction

cabbr <expr> %% expand('%:p:h')
