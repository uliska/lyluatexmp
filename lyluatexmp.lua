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
<<<alignment>>>
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
    local latex = templates.replace(TEMPLATES.lyfile_musicexample, {
        alignment = TEMPLATES['alignment_'..opts.align],
        filename = file,
        caption = templates.wrap_macro('caption', opts.caption),
        label = templates.wrap_macro('label', opts.label),
        lyluatex = templates.wrap_optional_args(opts.lyluatex),
        placement = templates.wrap_optional_args(opts.placement),
    })
    tex.print(latex:explode('\n'))
end

function lyluatexmp.set_cref_names()
--[[
    This function is called when -- after loading lyluatexmp --
    it is detected that 'cleveref' has already been loaded.
    Look up the crefname and Crefname options and use them.
    If the option is not formatte properly (both crefname and
    Crefname must be formatted as singular/plural names separated
    by a "|" pipe smybol) the English fallback values are chosen
--]]
    local crefname = xmp_opts.crefname
    local Crefname = xmp_opts.Crefname
    local cref_sing, cref_plur = crefname:match('(.-)%s-|%s-([^%s]*)')
    local Cref_sing, Cref_plur = Crefname:match('(.-)%s-|%s-([^%s]*)')
    if not (cref_sing and Cref_sing) then
        err(string.format([[
Malformated option 'crefname' or 'Crefname'
(expected: two elements separated by "|").
crefname={%s},
Crefname={%s}]],
        crefname, Crefname))
    end
    tex.print(string.format(
        '\\crefname{lymusxmp}{%s}{%s}',
        cref_sing or 'ex.',
        cref_plur or 'ex.'
    ))
    tex.print(string.format(
        '\\Crefname{lymusxmp}{%s}{%s}',
        Cref_sing or 'Music example',
        Cref_plur or 'Music examples'
    ))
end

return lyluatexmp
