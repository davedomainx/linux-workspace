set hidden
" set nobackup
" set nowritebackup
set cmdheight=3
set updatetime=250
set shortmess+=c
" Dec2019 signcolumn messes up tmux line-wrap copy-selection-and-cancel
" there should be a way to cleanly fix this but I haven't found it yet
" See also sign colour definitions at bottom of file 
set signcolumn=auto

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

call plug#begin('~/.config/nvim/plugged')

" Run these when installing a new plugin
":source %
":PluginInstall

Plug 'airblade/vim-gitgutter'
Plug 'pearofducks/ansible-vim'
" h: autopairs
Plug 'jiangmiao/auto-pairs'
" h: cs  || cs'[
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'editorconfig/editorconfig-vim' " For filetype management.
Plug 'elzr/vim-json' " For metadata.json
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Install fuzzy finder. Use whatever you prefer for file browsing
Plug 'junegunn/fzf.vim' " Fuzzy Finder vim plugin
" Dec2019 : commented yaml-vim out, ansible-vim should handle yml
" Plug 'mrk21/yaml-vim' " For hieradata
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}} " Language Server support
Plug 'rodjek/vim-puppet' " For Puppet syntax highlighting
Plug 'vim-ruby/vim-ruby' " For Facts, Ruby functions, and custom providers
" Supports mecurial + git.  git-gutter is git only (duh)
" Plug 'mhinz/vim-signify'
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'

call plug#end()

set completeopt+=preview

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()

" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

"imap <c-space> <Plug>(asyncomplete_force_refresh)

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0) " FZF settings
noremap <Leader>/ :FZF<CR> " Set FZF to <LEADER>/, which for me is `,/`

if executable('bash-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
        \ 'whitelist': ['sh'],
        \ })
endif

let g:signify_vcs_list = [ 'git', 'hg' ]

" lightline
set laststatus=2
set noshowmode
" colorschemes :h g:lightline.colorscheme
let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night_Eighties',
      \ }

" coc
" set statusline+=%{coc#status()}

iabbrev teh the
iabbrev eth the

" signcolumn goes here after colorscheme definitions
hi clear signcolumn
" allow to override other signs
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_sign_allow_clobber = 1
highlight GitGutterAdd    guifg=#009900 guibg=#2d2d2d ctermfg=2 ctermbg=0
highlight GitGutterChange guifg=#bbbb00 guibg=#2d2d2d ctermfg=3 ctermbg=0
highlight GitGutterDelete guifg=#ff2222 guibg=#2d2d2d ctermfg=1 ctermbg=0
