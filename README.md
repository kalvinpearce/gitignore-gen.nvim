# gitignore-gen.nvim

A simple neovim plugin to generate `.gitignore` using
[gitignore.io](https://gitignore.io/) templates.

## Getting Started

### Required dependencies

- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) is
  required.

### Installation

Using [vim-plug](https://github.com/junegunn/vim-plug)

```viml
Plug 'nvim-lua/plenary.nvim'
Plug 'kalvinpearce/gitignore-gen.nvim'
```

Using [dein](https://github.com/Shougo/dein.vim)

```viml
call dein#add('nvim-lua/plenary.nvim')
call dein#add('kalvinpearce/gitignore-gen.nvim')
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'kalvinpearce/gitignore-gen.nvim',
  requires = { {'nvim-lua/plenary.nvim'} }
}
```

## Usage

Running `:GitignoreGenerate` will bring up a series of dialogs to guide you
through generating a `.gitignore`

```viml
# vim
nnoremap <leader>gG <cmd>GitignoreGenerate<cr>
```

```lua
-- lua
vim.keymap.set('n', '<leader>gG', require('gitignore-gen').generate)
```

## Documentation

See `:help gitignore-gen.nvim`

## Special Mentions

This plugin is largely inspired by and based on
[piotrpalarz/vscode-gitignore-generator](https://github.com/piotrpalarz/vscode-gitignore-generator).
Piotrpalarz wrote an amazing plugin that I used to use all the time in vscode.
I missed it so much I decided to learn how to make a plugin for neovim just to
recreate its functionality.
