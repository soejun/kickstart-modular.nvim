-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Disable New Line Comment',
  callback = function()
    vim.opt.formatoptions:remove { 'c', 'r', 'o' }
  end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  desc = 'Enable spell checking for text-related files',
  callback = function()
    vim.opt.spell = true
    vim.opt.spelllang = 'en'
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Exit empty buffer with q',
  pattern = '*',
  callback = function()
    if vim.api.nvim_buf_get_name(0) == '' and vim.bo.modified == false and vim.bo.buftype == '' then
      local buffer_map = vim.api.nvim_buf_set_keymap
      buffer_map(0, 'n', 'q', '<cmd>qa<CR>', { desc = 'Quit' })
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Close certain windows with q',
  pattern = {
    'checkhealth',
    'dap-float',
    'fugitive',
    -- "help",
    -- "man",
    'notify',
    'null-ls-info',
    'qf',
    'PlenaryTestPopup',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Go to last location when opening a buffer',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
