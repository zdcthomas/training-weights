local tw = require("training_weights")

local mock = require("luassert.mock")
local stub = require("luassert.stub")

describe("setup", function()
  it("works with default", function()
    local api = mock(vim.api, true)

    tw.retrieve_mapping("w", "n")
    api.nvim_set_keymap()
    -- assert("my first function with param = Hello!", tw.hello())
  end)
end)
