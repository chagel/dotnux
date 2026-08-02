-- Insert a space at every Chinese<->English boundary as text is committed.
--
-- RIME commits one segment at a time and never revisits what already went to
-- the application, so the space has to be decided *before* a candidate is
-- committed. `commit_history:latest_text()` is what makes that possible: it
-- reports the previous commit, so this filter can look at the character that
-- ended it and prepend a space to the current candidate when the two sides
-- differ in script. Nothing is ever appended -- the trailing space of an
-- English word is really the leading space of the Chinese that follows it.
--
-- Loaded via `lua_filter@*cn_en_space`; the `*` tells librime-lua to read
-- lua/cn_en_space.lua directly instead of going through rime.lua.

local F = {}

-- CJK codepoints U+4E00-U+9FFF encode as three bytes with a \228-\233 lead.
local CJK_TAIL = '[\228-\233][\128-\191][\128-\191]$'
local CJK_HEAD = '^[\228-\233][\128-\191][\128-\191]'

function F.func(input, env)
  local prev = env.engine.context.commit_history:latest_text()
  -- A previous commit ending in whitespace already separates the two scripts.
  local after_cjk = prev and prev:match(CJK_TAIL) ~= nil
  local after_latin = prev and prev:match('[%w]$') ~= nil

  for cand in input:iter() do
    local text = cand.text
    local needs_space =
      (after_cjk and text:match("^[%a][%w'%-]*$") ~= nil) or
      (after_latin and text:match(CJK_HEAD) ~= nil)

    if needs_space then
      yield(cand:to_shadow_candidate(cand.type, ' ' .. text, cand.comment))
    else
      yield(cand)
    end
  end
end

return F
