" Include the system settings
:if filereadable( "/etc/vimrc" )
   source /etc/vimrc
:endif

" Include Arista-specific settings
:if filereadable( $VIM . "/vimfiles/arista.vim" )
   source $VIM/vimfiles/arista.vim
:endif

"set autochdir

" Put your own customizations below

let mapleader=";"
set pastetoggle=<F5>
set ic
"inoremap ( (<Space>
"inoremap ) <Space>)
"inoremap [ [<Space>
"inoremap ] <Space>]
"highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
"match OverLength /\%>85v.\+/

" akhil commented
" set statusline=%<%f\ %h%m%r\ %1*%{CTagInStatusLine()}%*%=%-14.(%l,%c%V%)\ %P

" akhil commented
":function ToggleWrap()
": if (&wrap == 1)
":   match OverLength /\%>85v.\+/
": else
":   match no OverLength
": endif
":endfunction

"map <F9> :call ToggleWrap()<CR>
"map! <F9> ^[:call ToggleWrap()<CR>
"" vim plug section
   " Specify a directory for plugins
   " - For Neovim: ~/.local/share/nvim/plugged
   " - Avoid using standard Vim directory names like 'plugin'
   call plug#begin('~/.vim/plugged')

      " Think of sensible.vim as one step above 'nocompatible' mode
      " Plug 'tpope/vim-sensible'
      " Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
      " Plug 'junegunn/vim-easy-align'
      " https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2
      Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
      Plug 'junegunn/fzf.vim'
      " Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
      " Plug 'skywind3000/asyncrun.vim'
      " Plug 'vim-scripts/ZoomWin'
      " Plug 'tpope/vim-dispatch'
      " Plug 'dhruvasagar/vim-zoom'

   " Initialize plugin system
   call plug#end()

" FZF Plugin related: https://github.com/junegunn/fzf.vim
   " FZF Global commands
   " This is the default extra key bindings
   let g:fzf_action = {
     \ 'ctrl-t': 'tab split',
     \ 'ctrl-x': 'split',
     \ 'ctrl-v': 'vsplit' }

   " Default fzf layout
   " - down / up / left / right
   let g:fzf_layout = { 'down': '~40%' }

   " In Neovim, you can set up fzf window using a Vim command
   "let g:fzf_layout = { 'window': 'enew' }
   "let g:fzf_layout = { 'window': '-tabnew' }
   "let g:fzf_layout = { 'window': '10split enew' }

   " Customize fzf colors to match your color scheme
   let g:fzf_colors =
   \ { 'fg':      ['fg', 'Normal'],
     \ 'bg':      ['bg', 'Normal'],
     \ 'hl':      ['fg', 'Comment'],
     \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
     \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
     \ 'hl+':     ['fg', 'Statement'],
     \ 'info':    ['fg', 'PreProc'],
     \ 'border':  ['fg', 'Ignore'],
     \ 'prompt':  ['fg', 'Conditional'],
     \ 'pointer': ['fg', 'Exception'],
     \ 'marker':  ['fg', 'Keyword'],
     \ 'spinner': ['fg', 'Label'],
     \ 'header':  ['fg', 'Comment'] }

   " Enable per-command history.
   " CTRL-N and CTRL-P will be automatically bound to next-history and
   " previous-history instead of down and up. If you don't like the change,
   " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
   let g:fzf_history_dir = '~/.local/share/fzf-history'

   " Command for git grep
   " - fzf#vim#grep(command, with_column, [options], [fullscreen])
   command! -bang -nargs=* GGrep
     \ call fzf#vim#grep(
     \   'git grep --line-number '.shellescape(<q-args>), 0,
     \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

   " Override Colors command. You can safely do this in your .vimrc as fzf.vim
   " will not override existing commands.
   command! -bang Colors
     \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'}, <bang>0)

   " Augmenting Ag command using fzf#vim#with_preview function
   "   * fzf#vim#with_preview([[options], preview window, [toggle keys...]])
   "     * For syntax-highlighting, Ruby and any of the following tools are required:
   "       - Highlight: http://www.andre-simon.de/doku/highlight/en/highlight.php
   "       - CodeRay: http://coderay.rubychan.de/
   "       - Rouge: https://github.com/jneen/rouge
   "
   "   :Ag  - Start fzf with hidden preview window that can be enabled with "?" key
   "   :Ag! - Start fzf in fullscreen and display the preview window above
   command! -bang -nargs=* Ag
     \ call fzf#vim#ag(<q-args>,
     \                 <bang>0 ? fzf#vim#with_preview('up:60%')
     \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
     \                 <bang>0)


   " --column: Show column number
   " --line-number: Show line number
   " --no-heading: Do not show file headings in results
   " --fixed-strings: Search term as a literal string
   " --ignore-case: Case insensitive search
   " --no-ignore: Do not respect .gitignore, etc...
   " --hidden: Search hidden files and folders
   " --follow: Follow symlinks
   " --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
   " --color: Search color options
   " Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
   command! -bang -nargs=* Find
     \ call fzf#vim#grep(
     \   'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color=always '.shellescape(<q-args>), 1,
     \   <bang>0 ? fzf#vim#with_preview('up:60%')
     \           : fzf#vim#with_preview('right:50%:hidden', '?'),
     \   <bang>0)

   command! -bang -nargs=* Rg
   \ call fzf#vim#grep(
   \   'rg --vimgrep --type-add "ar:*.{tac,tin,py,ar,am,cpp,h}" --type-add "tac:*.tac" --type-add "tin:*.tin" --no-ignore --glob "!pycscope*" --glob "!newpycscope*" --glob "!cscope*" --color=always '.<q-args>, 1,
   \   <bang>0 ? fzf#vim#with_preview('up:60%')
   \           : fzf#vim#with_preview('right:50%:hidden', '?'),
   \   <bang>0)

   " Likewise, Files command with preview window
   command! -bang -nargs=? -complete=dir Files
     \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

   " Alias for fzf
   nnoremap <silent> <leader><space> :Files<CR>
   nnoremap <silent> <Leader>b :Buffers<cr>
   nnoremap <Leader>r :Rg -i 

" easy align
   " Start interactive EasyAlign in visual mode (e.g. vipga)
   xmap ga <Plug>(EasyAlign)

   " Start interactive EasyAlign for a motion/text object (e.g. gaip)
   nmap ga <Plug>(EasyAlign)


