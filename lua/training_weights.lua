local M = {}
-- check config against default values for everything

-- let s:lasttime = 0
-- let s:lastkey = ''
-- let s:lastcount = 0

--
--
-- :lua Pr(vim.api.nvim_eval([[hasmapto("<leader>p", "<Cmd>lua require('config.telescope').find_files() <CR>")]]))
function M.retrieve_mapping(key, mode)
  vim.api.nvim_eval("maparg('" .. key .. "', '" .. mode .. "')")
end

-- local function has_map_to()
--   vim.api.nvim_eval("hasmapto(" .. "<Cmd>lua require('config.telescope').find_files() <CR>")]])
-- end

-- fun! s:RetrieveMapping(key, mode)
--     let mapping = maparg(a:key, a:mode, 0, 1)
--
--     if !has_key(mapping, "rhs") || mapping["rhs"] == ""
--         return "'" . a:key . "'"
--     endif
--     " If mapping is an expression, don't quote
--     if mapping["expr"]
--         return mapping["rhs"]
--     endif
--     return "'" . mapping["rhs"] . "'"
-- endf

local loaded_keys = {}
M.on = function()
  for mode, key in pairs(M.config.keys) do
    vim.api.nvim_set_keymap(
      mode,
      key,
      "v:lua.require'training_weights'.do_rhs()",
      { noremap = true, silent = true, expr = true }
    )
    Pr(mode)
    Pr(key)
    -- local i = "w"
    -- local foo = "inoremap <buffer> <silent> <expr> i TryKey('w') ? "
    --   .. s:RetrieveMapping(i, "i")
    --   .. " : TooSoon('w','i')"
  end
end

-- fun! HardTimeOn()
-- 	call s:check_defined("b:hardtime_on", 0)
--     " Prevents from mapping keys recursively
--     if b:hardtime_on == 0
--         let b:hardtime_on = 1
--         for i in g:list_of_normal_keys
--             let ii = substitute(i, "<", "<lt>", "")
--             exec "nnoremap <buffer> <silent> <expr> " . i . " TryKey('" . i . "') ? " . s:RetrieveMapping(i, "n") . " : TooSoon('" . ii . "','n')"
--         endfor
--         for i in g:list_of_visual_keys
--             let ii = substitute(i, "<", "<lt>", "")
--             exec "xnoremap <buffer> <silent> <expr> " . i . " TryKey('" . i . "') ? " . s:RetrieveMapping(i, "x") . " : TooSoon('" . ii . "','x')"
--         endfor
--         for i in g:list_of_insert_keys
--             let ii = substitute(i, "<", "<lt>", "")
--             exec "inoremap <buffer> <silent> <expr> " . i . " TryKey('" . i . "') ? " . s:RetrieveMapping(i, "i") . " : TooSoon('" . ii . "','i')"
--         endfor
--         for i in g:list_of_disabled_keys
--             exec "nnoremap <buffer> <silent> <expr> " . i . " pumvisible()?'" . i . "':''"
--             exec "xnoremap <buffer> <silent> <expr> " . i . " pumvisible()?'" . i . "':''"
--             exec "inoremap <buffer> <silent> <expr> " . i . " pumvisible()?'" . i . "':''"
--         endfor
--     endif
-- endf

-- fun! HardTimeOff()
--     let b:hardtime_on = 0
--     for i in g:list_of_normal_keys
--         exec "silent! nunmap <buffer> " . i
--     endfor
--     for i in g:list_of_visual_keys
--         exec "silent! xunmap <buffer> " . i
--     endfor
--     for i in g:list_of_insert_keys
--         exec "silent! iunmap <buffer> " . i
--     endfor
--     for i in g:list_of_disabled_keys
--         exec "silent! nunmap <buffer> " . i
--         exec "silent! xunmap <buffer> " . i
--         exec "silent! iunmap <buffer> " . i
--     endfor
-- endf

-- fun! HardTimeToggle()
-- 	call s:check_defined("b:hardtime_on", 0)
--     if b:hardtime_on
--         call HardTimeOff()
-- 		if g:hardtime_showmsg
-- 			echo "Hard time off"
-- 		endif
--     else
--         call HardTimeOn()
--         if g:hardtime_showmsg
--             echo "Hard time on"
--         end
--     endif
-- endf

local function get_now()
  return tonumber(vim.fn.reltimestr(vim.fn.reltime())) * 100000
end

local key_history = {
  n = {
    l = {
      -- A list of times from most recent at 1 to least recent
      time_1,
      time_2,
      -- most_recent = "most recent time value of this button press. Reset on each keypress.",
      -- count = "how many times the button has been pushed in this interval. Resets if the button is pushed again after longer than the interva.",
    },
    j = { most_recent = 12, count = 3 },
  },
}

local key_history = {}

local function press_key(key, mode)
  local now = get_now()
  local key_presses = key_history[mode][key]
  table.insert(key_presses, 1, now)
  key_history[mode][key] = { table.unpack(key_presses, 1, M.config.max_key_press_count) }
end

local function long_enough_since_last_press(key, mode)
  key = key_history[mode][key]
  if not key then
    return
  end
  press_key(key, mode)
  -- local count = key.count
  -- local most_recent = key.most_recent
  local max_interval = M.config.timeout
  local oldest_relevant_key_press = key[#key]
  if (now - oldest_relevant_key_press) > max_interval then
    return false
  end

  return true
  -- table.insert(key_history)
  -- local now = get_now()
  -- get current time
  -- get last time for the given key
  -- if diff between is less than the specified timout
  --   false
  -- else
  --   true
  -- end
end
--
-- fun! TryKey(key)
--     if pumvisible()
--         return 1
--     endif
--     let now = GetNow()
--     if (now > s:lasttime + g:hardtime_timeout/1000) || (g:hardtime_allow_different_key && a:key != s:lastkey) ||
--     \ (s:lastcount < g:hardtime_maxcount)
--         if (now > s:lasttime + g:hardtime_timeout/1000) || (g:hardtime_allow_different_key && a:key != s:lastkey)
--             let s:lastcount = 1
--         else
--             let s:lastcount += 1
--         endif
--         let s:lasttime = now
--         let s:lastkey = a:key
--         return 1
--     else
--         return 0
--     endif
-- endf

-- fun! TooSoon(key, mode)
--     if g:hardtime_showmsg
--         echomsg "Hard time is enabled for " . a:key . " in " . a:mode
--     endif
--     if g:hardtime_showerr
--         echoerr "Hard time is enabled for " . a:key . " in " . a:mode
--     endif
--     return ""
-- endf

-- fun! GetNow()
--     return reltimestr(reltime())
-- endf

-- command! HardTimeOn call HardTimeOn()
-- command! HardTimeOff call HardTimeOff()
-- command! HardTimeToggle call HardTimeToggle()
-- main module file
-- "qf" in the ignore_buffer_patterns var represents quickfix lists
local default_values = {
  keys = {
    v = { "h", "j", "k", "l", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" },
    n = { "h", "j", "k", "l", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" },
    i = { "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" },
  },
  disabled_keys = {},
  default_on = false,
  ignore_buffer_patterns = { "qf", "help" },
  timeout = 1000,
  showmsg = false,
  showerr = false,
  allow_different_key = false,
  max_key_press_count = 1,
}

local function current_buffer_should_be_ignored()
  local filetype = vim.bo.filetype
  if filetype == "" then
    filetype = "unnamed"
  end
  return vim.tbl_contains(M.config.ignore_buffer_patterns, filetype)
end

if not M.config then
  M.config = default_values
end

local function setup_default_on_autocommand()
  -- Start hardtime in every buffer
  vim.cmd([[autocmd BufRead,BufNewFile * :lua require("training-weights").auto_start()]])
end

-- local module = require("plugin_name.module")

-- setup is the public method to setup your plugin
M.setup = function(args)
  -- you can define your setup function here. Usually configurations can be merged, accepting outside params and
  -- you can also put some validation here for those.
  M.config = vim.tbl_deep_extend("keep", args, default_values)

  if M.config.default_on then
    setup_default_on_autocommand()
  end
end

M.auto_start = function()
  if not current_buffer_should_be_ignored() then
    M.on()
  end
end
-- "hello" is a public method for the plugin
--
function M.do_rhs(key, mode)
  press_key(key, mode)
  -- if try_key(key) then
  --
  -- else
  -- end
  -- TryKey('w') ? " .. s:RetrieveMapping(i, "i") .. " : TooSoon('w','i')"
  return ":lua require('training_weights').try_key('" .. key .. "')<cr>"
end
return M
