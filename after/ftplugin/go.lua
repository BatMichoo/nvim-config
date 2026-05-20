local keymap = vim.keymap

keymap.set('n', '<leader>ee', 'oif err != nil {<CR>}<Esc>Oreturn err<Esc>', { desc = 'Go error return' })

keymap.set('n', '<leader>ea', 'oassert.NoError(err, "")<Esc>F";a', { desc = 'Go assert error' })

keymap.set('n', '<leader>ef', 'oif err != nil {<CR>}<Esc>Olog.Fatalf("error: %s\\n", err.Error())<Esc>jj', { desc = 'Go error fatal log' })

keymap.set('n', '<leader>el', 'oif err != nil {<CR>}<Esc>O.logger.Error("error", "error", err)<Esc>F.;i', { desc = 'Go error log' })
