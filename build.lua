#!/usr/bin/env texlua

-- Identify the bundle and module
bundle = ""
module = "rsc"

-- All-in-one .dtx file
unpackfiles  = {"*.dtx"}

-- Only typeset the user part of the .dtx
-- To avoid an issue with the .tex file, a bit of TeX coding
typsetcmds = [[
  \\ifdefined\\OnlyDescription\\AtBeginDocument{\\OnlyDescription}\\fi
]]

-- Detail how to set the version automatically
function setversion_update_line (line, date, version)
  local date = string.gsub(date, "%-", "/")
  -- LaTeX part
  if string.match(
    line, "^  %[%d%d%d%d/%d%d/%d%d v%d%.%d+%w? [^%]]*%]$"
  ) then
    line = string.gsub(line, "%d%d%d%d/%d%d/%d%d", date)
    line = string.gsub(line, "%d%.%d+%w?", version)
  end
  -- BibTeX part
  if string.match(
    line, "^  \"rsc %d%d%d%d/%d%d/%d%d v%d%.%d+%w?\" top%$$"
  ) then
    line = "  \"rsc " .. date .. " v" .. version .. "\" top$"
  end
  return line
end

-- Release a TDS-style zip
packtdszip  = true

-- No tests for this bundle
testfildir = ""

-- Find and run the build system
kpse.set_program_name ("kpsewhich")
dofile (kpse.lookup ("l3build.lua"))
