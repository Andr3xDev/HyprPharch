---------------------------------------------------------------------------
--- find-and-replace feature for neovim, powered by ripgrep
---------------------------------------------------------------------------

return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  opts = {
    engine = "ripgrep",
    headerMaxWidth = 80,
  },
}
