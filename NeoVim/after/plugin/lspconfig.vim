" LSP configuration
lua << EOF
    require'lspconfig'.rust_analyzer.setup{}
    require'lspconfig'.gopls.setup{}
    require'lspconfig'.hls.setup{}
EOF
