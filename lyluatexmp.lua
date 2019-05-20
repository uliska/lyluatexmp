local err, warn, info, log = luatexbase.provides_module({
    name               = "lyluaxmp",
    version            = '0.1',
    date               = "2019/05/11",
    description        = "Lua module for the lyluaxmp package.",
    author             = "Urs Liska",
    copyright          = "2019- Urs Liska",
    license            = "GPL 3",
})

--[[ Import external functionality --]]

-- general tools
local lib = require(kpse.find_file("lyluatex-lib.lua") or "lyluatex-lib.lua")
-- option handling support (in addition to the xmp_opts object created in
-- lyluatexmp.sty)
local optlib = require(
  kpse.find_file("lyluatex-options.lua") or "lyluatex-options.lua"
)
local xmp_opts = xmp_opts -- defined in lyluatexmp.sty
-- templating support
local templates = require(
  kpse.find_file("lyluatexmp-templates.lua") or "lyluatexmp-templates.lua"
)
-- interacting with the file system
local lfs = require 'lfs' -- not used yet

-- LaTeX code templates.
-- TODO: One day one might want to make this configurable
-- (by parsing a user-provided Lua file with a table and overwrite
--  arbitrary values (using xmp_opts:check_local_options)).
local TEMPLATES = {
  alignment_left = '\\raggedright',
  alignment_center = '\\centering',
  alignment_right = '\\raggedleft',
  lyfile_musicexample = [[
\begin{lymusxmp}<<<placement>>>
<<<alignment>>><<<captionsetup>>>
\lilypondfile<<<lyluatex>>>{<<<filename>>>}
<<<caption>>><<<label>>>
\end{lymusxmp}
  ]],
}

-- namespace for the returned table
local lyluatexmp = {}

function lyluatexmp.lyfile_musicexample(options, file)
--[[
    Music example based on a LilyPond file.
    TODO:
    - add a \captionsetup
    - add a 'within' option for the numbering (and more provided by 'caption'?)
    - make sure missing/failed examples are reported properly (incl. colors)
--]]
    local opts = optlib.merge_options(
        xmp_opts.options, xmp_opts:check_local_options(options)
    )
    local captionsetup = ''
    if opts.captionsetup then
        captionsetup = string.format('\\captionsetup{%s}', opts.captionsetup)
    end
    local latex = templates.replace(TEMPLATES.lyfile_musicexample, {
        alignment = TEMPLATES['alignment_'..opts.align],
        captionsetup = captionsetup,
        filename = file,
        caption = templates.wrap_macro('caption', opts.caption),
        label = templates.wrap_macro('label', opts.label),
        lyluatex = templates.wrap_optional_args(opts.lyluatex),
        placement = templates.wrap_optional_args(opts.placement),
    })
    print(latex)
    tex.print(latex:explode('\n'))
end

return lyluatexmp
