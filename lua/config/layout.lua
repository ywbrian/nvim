-- Auto-setup function to create the layout on startup
local function setup_layout()
  -- Small delay to ensure plugins are loaded
  vim.defer_fn(function()
    -- Open NvimTree
    vim.cmd('NvimTreeOpen')
    
    -- Move to the main editor window
    vim.cmd('wincmd l')
    
    -- Open terminal at bottom
    vim.cmd('botright split')
    vim.cmd('resize 15')
    vim.cmd('terminal')
    
    -- Return focus to the main editor window after a brief moment
    vim.defer_fn(function()
      vim.cmd('wincmd k')
    end, 100)
  end, 50)
end

-- Auto-command to set up layout when Neovim starts
vim.api.nvim_create_autocmd("VimEnter", {
  callback = setup_layout
})
