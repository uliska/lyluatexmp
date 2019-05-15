local err, warn, info, log = luatexbase.provides_module({
    name               = "lyluaxmp",
    version            = '0.1',
    date               = "2019/05/11",
    description        = "Lua module for the lyluaxmp package.",
    author             = "Urs Liska",
    copyright          = "2019- Urs Liska",
    license            = "GPL 3",
})

local lib = require(kpse.find_file("lyluatex-lib.lua") or "lyluatex-lib.lua")
local optlib = require(kpse.find_file("lyluatex-options.lua") or "lyluatex-options.lua")

local lfs = require 'lfs'

local OPTIONS = {}  -- Store package options
local xmp = {}      -- namespace for the returned table
xmp.Example = {}  -- Store local options for a single example (?)


function xmp.set_property(k, v)
    k, v = optlib.sanitize_option('xmp', k, v)
    if k then xmp.Example[k] = v end
end

return xmp
