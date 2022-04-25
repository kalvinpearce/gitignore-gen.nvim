" Title:        gitignore-gen.nvim
" Description:  A plugin to generate a .gitignore from a list of templates.
" Maintainer:   Kalvin Pearce <https://github.com/kalvinpearce>

if exists("g:loaded_gitignoregen")
    finish
endif
let g:loaded_gitignoregen = 1

command! -nargs=0 GitignoreGenerate lua require("gitignore-gen").generate()
