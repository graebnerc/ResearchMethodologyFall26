-- Removes speaker notes (::: {.notes} … :::) from every document.
--
-- Wired in globally by _quarto.yml, so every deck that is built into _site/
-- — and therefore uploaded by `quarto publish netlify` — goes online without
-- its notes. Decks still under embargo are rendered by hand outside the
-- project render list; they do not read _quarto.yml and keep their notes.
--
-- To present a published deck WITH notes, render it with the "present"
-- profile (see _quarto-present.yml), which sets `keep-notes: true` and writes
-- to _present/ instead of _site/:
--     quarto render content/lecture/slides/NAME.qmd --profile present

local keep = false

return {
  {
    Meta = function(meta)
      keep = meta["keep-notes"] == true
    end
  },
  {
    Div = function(div)
      if not keep and div.classes:includes("notes") then
        return {}
      end
    end
  }
}
