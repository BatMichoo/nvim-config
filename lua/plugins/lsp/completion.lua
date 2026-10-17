return {
  {
    'hrsh7th/cmp-nvim-lsp',
  },
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
    },
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'onsails/lspkind.nvim', -- The icon provider
      'xzbdmw/colorful-menu.nvim', -- The Treesitter colors
    },
    config = function()
      local lspkind = require 'lspkind'
      local colorful_menu = require 'colorful-menu'
      require('luasnip.loaders.from_vscode').lazy_load()

      local cmp = require 'cmp'

      cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        window = {
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-y>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'easy-dotnet' },
          { name = 'luasnip' }, -- For luasnip users.
          { name = 'vim-dadbod-completion' },
        }, {
          { name = 'buffer' },
        }),
        formatting = {
          fields = { 'icon', 'abbr', 'kind', 'menu' }, -- 'kind' is the icon, 'abbr' is the colored text
          format = lspkind.cmp_format {
            maxwidth = {
              menu = 50, -- leading text (labelDetails)
              abbr = 50, -- actual suggestion item
            },
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default
            before = function(entry, vim_item)
              -- 1. Get the Treesitter-colored text
              local highlights_info = colorful_menu.cmp_highlights(entry)

              -- 2. Merge them
              if highlights_info then
                vim_item.abbr = highlights_info.text
                vim_item.abbr_hl_group = highlights_info.highlights
              end

              return vim_item
            end,
          },
        },
      }
    end,
  },
}
