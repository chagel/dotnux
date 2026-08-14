-- Re-apply the generated theme inside an already-running nvim.
--
-- scripts/theme evaluates this in every nvim socket after a switch, so the
-- editor follows without a restart. Not generated -- it reads whatever
-- themes/nvim.lua currently holds.
local spec = dofile(vim.fn.expand("~/Dotfiles/themes/nvim.lua"))
local opts = spec and spec[1] and spec[1].opts

if opts then
  local ok, aether = pcall(require, "aether")
  if ok then
    aether.setup(opts)
    vim.cmd.colorscheme("aether")
  end
end
