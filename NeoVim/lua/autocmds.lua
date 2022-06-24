-- Highlight on yank
vim.api.nvim_exec(
	[[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
	false
)

-- Specific options for different kinds of files
vim.api.nvim_exec(
	[[
  augroup FileTypeOptions
    autocmd!
    autocmd Filetype haskell set tabstop=2 shiftwidth=2
    autocmd Filetype lua set tabstop=2 shiftwidth=2
    autocmd Filetype go set tabstop=4 shiftwidth=4
    autocmd Filetype python set colorcolumn=88
  augroup end
]],
	false
)

-- Enable linters
vim.api.nvim_exec(
	[[
augroup LintAutogroup
  autocmd!
  autocmd BufWritePost <buffer> lua require('lint').try_lint()
augroup END
]],
	true
)

-- This leverages the formatter.nvim plug-in
vim.api.nvim_exec(
	[[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]],
	true
)
