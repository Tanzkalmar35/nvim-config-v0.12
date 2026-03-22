---@type vim.lsp.Config
return {
    cmd = { "texlab" },
    filetypes = { "tex", "bib" },
    root_markers = { ".git", "latexmkrc", ".latexmkrc", "texlab.json" },
    settings = {
        texlab = {
            build = {
                onSave = true, -- Let TexLab trigger build, but VimTeX is usually better for this
            },
            forwardSearch = {
                executable = "zathura",
                args = { "--remote-expr", "edit %1", "%2" },
            },
            chktex = {
                onOpenAndSave = true,
            },
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            bibtexFormatter = "texlab",
            latexFormatter = "latexindent",
            latexlint = {
                onChange = true,
            },
        },
    },
}
