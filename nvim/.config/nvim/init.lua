-- ~/.config/nvim/init.lua

-- builtin package manager: only need server definitions
vim.pack.add({
  { src = 'https://github.com/neovim/nvim-lspconfig' },
})

vim.g.mapleader = ' '

-- small defaults that pull their weight
vim.o.number = true
vim.o.signcolumn = 'yes'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.completeopt = 'menuone,noselect,popup'

-- per-language indent
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    vim.bo.expandtab = false
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

-- LSP niceties: completion + format key
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({
        async = true,
        filter = function(c)
          return c:supports_method('textDocument/formatting')
        end,
      })
    end, { buffer = ev.buf, desc = 'Format buffer' })

    vim.keymap.set('i', '<C-Space>', function()
      vim.lsp.completion.get()
    end, { buffer = ev.buf, desc = 'LSP completion' })
  end,
})

-- keep diagnostics available but not inline-noisy
vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
})

-- Python: Ruff for lint/format, ty for typing + language features
vim.lsp.config('ruff', {})
vim.lsp.config('ty', {})

-- Go
vim.lsp.config('gopls', {})

vim.lsp.enable('ruff')
vim.lsp.enable('ty')
vim.lsp.enable('gopls')