-- lua/plugins/formatting.lua (or inside your lazy.setup call)
return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                python = { "ruff_format" },
            },
            -- Run formatter on save
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })
    end,
}
