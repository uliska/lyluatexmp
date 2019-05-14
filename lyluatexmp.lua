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

local lfs = require 'lfs'

local OPTIONS = {}  -- Store package options
local Example = {}  -- Store local options for a single example (?)
local xmp = {}      -- namespace for the returned table


function xmp.declare_package_options(options)
  OPTIONS = options
  lib.declare_package_options(options, 'xmp')
end


function xmp.is_neg(k, _)
  lib.is_neg(OPTIONS, k)
end


function xmp.set_property(k, v)
    k, v = lib.process_options(OPTIONS, k, v)
    if k then Example[k] = v end
end

return xmp
