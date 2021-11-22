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
    autocmd Filetype python set colorcolumn=88
  augroup end
]],
	false
)

-- Show the inlay hints for rust files
vim.api.nvim_exec(
	[[
  augroup ShowInlayHints
    autocmd!
    autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ enabled={"ChainingHint","TypeHint"}, only_current_line = true }
  augroup end
]],
	false
)

-- Format Python files with Black, LSP doesn't support this yet.
vim.api.nvim_exec(
	[[
  augroup FormatWithBlack
    autocmd!
    autocmd BufWritePre *.py execute ':Black'
  augroup end
]],
	false
)

-- Run Go-autoimporter
vim.api.nvim_exec(
	[[
  augroup RunGoImport
    autocmd!
    autocmd BufWritePre *.go lua goimports(1000) 
  augroup end
]],
	false
)

vim.api.nvim_exec(
	[[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.rs,*.lua FormatWrite
augroup END
]],
	true
)

vim.api.nvim_exec(
	[[
augroup LintAutogroup
  autocmd!
  autocmd BufWritePost <buffer> lua require('lint').try_lint()
augroup END
]],
	true
)
