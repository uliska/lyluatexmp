---
documentclass: lyluatexmanual
title: "\\lyluatexmp"
subtitle: "0.1"
author:
- Urs Liska
toc: yes
header-includes:
- \usepackage{lyluatexmp}
---

# Introduction

\lyluatexmp\ is a \LaTeX\ package that manages the inclusion of music examples
in \LaTeX\ documents.  It is designed for use with \lyluatex\ and the GNU
LilyPond^[\url{http://lilypond.org}] score writer but can also handle (with
limitations) examples created by arbitrary programs and provided as image files.
The package's basic purpose is managing the inclusion of floating environments
and the list of music examples, which may not seem much. The area where the use
of the package provides significant advantages over basic \LaTeX\ tools is the
handling of missing examples (errors or deliberate placeholders) and that of
full- or multipage scores (something that should be handled differently from
regular floating elements like figures or tables).

As the name implies this package relies on the Lua capabilities of
\LuaLaTeX\ and is therefore not compatible with other \TeX\ engines. This is
because I am convinced that using \lyluatex\ is the single best solution to
incorporating music example in text documents where this is a prerequisite
anyway.

\lyluatexmp's main features include:

* Using \lyluatex\ for perfect integration of musical scores' sources and
  resulting images in \LaTeX\ documents
* Managing missing music examples
* Managing full-page scores with captions
* Comprehensive configuration through global and per-score options

## Dependencies

\lyluatexmp\ depends on \lyluatex\ being installed, and for creating music
examples through \lyluatex\  GNU LilyPond has to be installed too. Please refer
to the \lyluatex\ manual for details on setting things up to work with LilyPond.
**NOTE**: During development of this package updates may be applied to
\lyluatex\ as well, so currently you should use the latest version from Github
to ensure compatibility.

## Installation

### For a single document

Copy `lyluatexmp.sty` and `lyluatexmp.lua` into the folder containing the
document you wish to typeset.

### For all documents compiled with your LaTeX distribution

#### TeXLive version

\lyluatexmp\ is not included in \TeX\ Live yet.

#### Latest version

Copy `lyluatexmp.sty` and `lyluatexmp.lua` from this repository into your
`TEXMFHOME` tree, or clone this repostory into your `TEXMFHOME` tree using Git.
In many cases this will be `$HOME/texmf`, and \lyluatex\ should be located below
`$TEXMFHOME/tex/luatex`. It is important that this is the `luatex` tree:
otherwise \LuaLaTeX\ will still find a version from TeXLive first and use that
instead of your local clone.

# Usage

\lyluatexmp\ is loaded with the command `\usepackage{lyluatexmp}` which also accepts
a number of `key=value` options.  Their general use is described in the [Option
Handling](#option-handling) section below.

\lyIssue{Note:} \lyluatexmp\ can only be used with \LuaLaTeX, and compiling with
any other \LaTeX\ engine will fail.

\lyIssue{NOTE:} For creating scores with LilyPond \lyluatex\ requires that
\LuaLaTeX\ is started with the `--shell-escape` command line option, which is of
course also valid for using \lyluatexmp\ with \lyluatex\ and LilyPond. For
security considerations implied by this issue please refer to the \lyluatex\
manual.

\lyluatexmp\ will implicitly load \lyluatex\ without options if it is not
already loaded. So if \lyluatex\ should be given any options that package has to
be loaded *before* \lyluatexmp.
