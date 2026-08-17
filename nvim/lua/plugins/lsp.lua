-- ~/.config/nvim/lua/plugins/lsp.lua

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp", -- If you use nvim-cmp
  },
  config = function()
    -- This is for nvim-cmp. If you don't use it, you can remove this line.
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- Setup mason so it can manage external tools
    require("mason").setup()

    -- NEW: The updated way to configure mason-lspconfig
    require("mason-lspconfig").setup({
      -- A list of servers to automatically install if they're not already installed
      ensure_installed = { "pyright", "lua_ls", "ruff" },

      -- The handlers are now inside a 'handlers' key
      handlers = {
        -- This is the default handler for servers that don't have a specific setup
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,

        -- Example of a custom handler for pyright
        ["pyright"] = function()
          require("lspconfig").pyright.setup({
            capabilities = capabilities,
            settings = {
              python = {
                -- Make sure pyright uses the python from your virtualenv
                pythonPath = vim.fn.exepath("python3") or vim.fn.exepath("python"),
              },
            },
          })
        end,
      },
    })
  end,
}
