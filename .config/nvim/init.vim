call plug#begin('~/.config/nvim/plugged')
	Plug 'ap/vim-css-color'
	Plug 'scrooloose/nerdtree'
	Plug 'AlphaTechnolog/pywal.nvim'
	Plug 'nvim-lualine/lualine.nvim'
	Plug 'kyazdani42/nvim-web-devicons'
	Plug 'nvim-treesitter/nvim-treesitter'
	Plug 'nvim-orgmode/orgmode'
call plug#end()

colorscheme pywal
" set shell=kitty
set autoread
set hlsearch
set nu
set rnu
set ignorecase
set smartcase
set showmatch
syntax on
set mouse=a
set tabstop=5
set shiftwidth=5
set spelllang=en_US

" autocmd VimEnter * NERDTree
nnoremap q: :q
nnoremap <C-q> :q!
nnoremap <C-w> :w
nnoremap Y yy 
vnoremap <C-c> "+y 

" Lua line
lua << END
require('lualine').setup {
  options = {
	  icons_enabled = true,
	  theme = 'auto',
	  component_separators = { left = '', right = ''},
	  section_separators = { left = '', right = ''},
	  disabled_filetypes = { statusline = {}, winbar = {}, },
	  ignore_focus = {},
	  always_divide_middle = true,
	  globalstatus = false,
	  refresh = { statusline = 1000, tabline = 1000, winbar = 1000, }
  },

  sections = {
	  lualine_a = {'mode'},
	  lualine_b = {'branch', 'diff', 'diagnostics'},
	  lualine_c = {'filename'},
	  lualine_x = {'encoding', 'fileformat', 'filetype'},
	  lualine_y = {'progress'},
	  lualine_z = {'location'}
  },		

  inactive_sections = {
	  lualine_a = {},
	  lualine_b = {},
	  lualine_c = {'filename'},
	  lualine_x = {'location'},
	  lualine_y = {},
	  lualine_z = {}
  },

  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
require('lualine').setup()

-- init.lua

-- Load custom treesitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
-- If TS highlights are not enabled at all, or disabled via `disable` prop,
-- highlighting will fallback to default Vim syntax highlighting
	highlight = {
    		enable = true,
	    	-- Required for spellcheck, some LaTex highlights and
	    	-- code block highlights that do not have ts grammar
	    	additional_vim_regex_highlighting = {'org'},
	},
	ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup({
  org_agenda_files = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
  org_default_notes_file = '~/Dropbox/org/refile.org',
})

END
