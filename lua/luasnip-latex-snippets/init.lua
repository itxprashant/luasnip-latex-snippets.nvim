local utils = require("luasnip-latex-snippets.util.utils")
-- local no_backslash = utils.no_backslash
local ls = require("luasnip")

local M = {}

local default_opts = { use_treesitter = true }

M.setup = function(opts)
  opts = vim.tbl_deep_extend("force", default_opts, opts or {})

  local augroup = vim.api.nvim_create_augroup("luasnip-latex-snippets", {})
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    group = augroup,
    once = true,
    callback = function()
      local is_math = utils.with_opts(utils.is_math, opts.use_treesitter)
      local not_math = utils.with_opts(utils.not_math, opts.use_treesitter)
      M.setup_tex(is_math, not_math)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", { pattern = "markdown",   group = augroup, once = true,
    callback = function()
      M.setup_markdown()
    end,
  })
end

local _autosnippets = function(is_math, not_math)
  local autosnippets = {}

  for _, s in ipairs({ "math_rA_no_backslash", "math_iA", "math_wrA", "chemistry_iA" })
  do
    vim.list_extend(autosnippets, require(("luasnip-latex-snippets.%s"):format(s)).retrieve(is_math))
  end

  for _, s in ipairs({ "wA", "bwA", })
  do
    vim.list_extend(autosnippets, require(("luasnip-latex-snippets.%s"):format(s)).retrieve(not_math))
  end

  return autosnippets
end

M.setup_tex = function(is_math, not_math)

  ls.add_snippets("tex", _autosnippets(is_math, not_math), { type = "autosnippets", default_priority = 0, })

  for _, str in ipairs({ "math_i", "chemistry_i", "text_i"}) do
    ls.add_snippets("tex", require(("luasnip-latex-snippets.%s"):format(str)).retrieve(is_math), { default_priority = 0 })
  end

end

M.setup_markdown = function()
  local is_math = utils.with_opts(utils.is_math, true)
  local not_math = utils.with_opts(utils.not_math, true)

  local autosnippets = _autosnippets(is_math, not_math)
  local trigger_of_snip = function(s)
    return s.trigger
  end

  local to_filter = {}
  for _, str in ipairs({ "wA", "bwA", }) do
    local t = require(("luasnip-latex-snippets.%s"):format(str)).retrieve(not_math)
    vim.list_extend(to_filter, vim.tbl_map(trigger_of_snip, t))
  end

  local filtered = vim.tbl_filter(function(s)
    return not vim.tbl_contains(to_filter, s.trigger)
  end, autosnippets)

  vim.list_extend(filtered, require("luasnip-latex-snippets/wA_md").retrieve(not_math))


  ls.add_snippets("markdown", filtered, { type = "autosnippets", default_priority = 0, })

  for _, str in ipairs({ "math_i", "chemistry_i", }) do
    ls.add_snippets("markdown", require(("luasnip-latex-snippets.%s"):format(str)).retrieve(is_math), { default_priority = 0 })
  end

end

return M
