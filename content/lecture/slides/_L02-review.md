w# Review of `RM26_L02_AITools.qmd` — 19 Sep 2026, two days before the lecture

Deck as reviewed: 32 slides (6 dividers, 24 content, references; the two
exercise slides below were added during this review). Fill in the last column
with what you want changed; I implement the ticked rows.

Line numbers refer to the file *after* the exercise slides were inserted.

**General remark on .dek:**
- Remove the .dek sentences if not otherwise stated
- Move them into a script markdown - if there already is one prepared from the speaker notes, add them, if not create a new one (want to use it as the basis for a proper script)

**General remark:**
- Font size for text after arrows should be at least as large as bullet point text

| # | Prio | Slide / line | What I found | Proposed change | What I want |
|---|------|--------------|--------------|-----------------|-------------|
| 1 | 🔴 | S3 "How do you use AI at the moment?" (l. 80) | `- Live poll: **ADD QR CODE**` is still a placeholder — there is no poll and no QR code two days out | Create the poll, drop the PNG into `assets/`, embed it; or cut the slide and do it by show of hands | |
| 2 | 🔴 | Header comment, ll. 49–58 | "the five entries these slides cite … were written from memory and have NOT been checked". I checked all five against what I know of the published record and they are correct (Noy & Zhang, *Science* 381(6654):187–192; Dell'Acqua et al., HBS WP 24-013; Brynjolfsson/Li/Raymond, NBER WP 31161; METR = Becker, Rush, Barnes, Rein 2025; Darvishi et al., *Computers & Education* 210:104967). Still unverified by clicking. | Click the five DOIs once, then **delete the comment block** — a lecture whose rule is "never cite what you have not read" should not ship with a "cited from memory" note in its source | |
| 3 | 🔴 | S20–22 exercise | The three references existed only on the webpage, not in the deck | **Done:** added S21 "The paragraph" and S22 "The three references, as the assistant supplied them" (both `{.smaller}`, `.nonincremental`). Check legibility from row 12 and whether you want them merged into one slide | Put the refernces diretly below the paragraph, so merge into one slide.|
| 4 | 🟠 | S3 dek (l. 77) | `Two minutes, anonymous. .` — stray second full stop | Delete | yes|
| 5 | 🟠 | S4 arrow 1 (l. 121) | A 40-word full sentence inside an arrow box — the worst full-sentence offender in the deck | → "Assistance can **substitute for** skill — withdrawn, performance drops [@darvishi2024impact]" | → "AI assistance can **substitute for** skill — withdrawn, performance drops further [@darvishi2024impact]"|
| 6 | 🟠 | S4 arrow 2 (l. 125) | "Honest self reflection is key! AI should neither be demonized nor glorified by default!" — two sentences, two exclamation marks; "self reflection" unhyphenated; "demonized" is US spelling while the deck is otherwise British (anonymise, analysing, randomised, modernised) | → "Neither demonised nor glorified — **honest self-assessment** is key" | |
| 7 | 🟠 | S4 whole slide | Densest slide in the deck: dek + 2×3 bulleted columns + **two** arrow boxes, ~10 clicks | Keep one arrow. The de-skilling point already reappears on S30 ("de-skilling is a risk and adds dependence") | No, keep both as corrected above|
| 8 | 🟠 | S17 "Prompting is a conversation" | Five bullets, three of them sentence-shaped ("Good long-term investment: your own skill and prompt repo"; "For complex tasks, have the model draft the prompt with you first") | Cut to four: iterate · flag uncertainty · save what worked · let AI draft the prompt  | yes|
| 9 | 🟠 | S31 "Recap questions" | Seven full-sentence questions, `.nonincremental`, default size — likely to overflow 900 px | Split over two slides, add `{.smaller}`, or cut to five | no thats fine as is|
| 10 | 🟠 | S11 task table | 8 rows × 3 columns with long third-column cells plus a `.source` line — check it does not run off the bottom | `{.smaller}` on the slide, or drop two rows | Not smaller, text should be size of bullets|
| 11 | 🟡 | S8 cap boxes B and C | Full sentences: "Retrieve real sources and cite them. 'Deep research' modes chain many searches into a report." / "You supply the material: PDFs, transcripts, datasets. The system reads what you give it." | → B: "Real sources, cited. 'Deep research' = many searches chained." C: "You supply the material — PDFs, transcripts, datasets." | keep as is|
| 12 | 🟡 | S15 "Context" box | "Who you are, what the work is for, who will read it, what the model should act as." | → "Who you are · purpose · audience · the role it plays" | yes|
| 13 | 🟡 | S5 dek (l. 131) | "True not only for research; make sure you always check instructor-specific requirements!" | → "Not only in research — check each instructor's rules." | |
| 14 | 🟡 | S27 arrow (l. 551) | "Disclosing costs you nothing. Not disclosing can cost you the module/reputation." — two sentences | → "Disclosure costs nothing — non-disclosure can cost you your reputation." | yes|
| 15 | 🟡 | S7 "The tool list from last year is already wrong" | Says the same thing four times: title, three-line dek, bullet 1 ("AI Tools and products change rapidly" — stray capital T), keybox | Cut the dek to one line ("Sixteen tools last year; several no longer exist") and delete bullet 1. Also confirm "sixteen" is the real number | yes|
| 16 | 🟡 | S9 right column (l. 242) | "**Weak**: books, German, social sciences" is indented as a *child* of "Strong", so it renders as level-2 grey | Put both at the same level | yes|
| 17 | 🟡 | S16 right column (ll. 404–410) | "Role, module, level stated" then three bullets indented one level too deep — they are siblings, not children | Flatten by one level | yes|
| 18 | 🟡 | S19 title | "Verification as the key skill" is a topic, not an assertion — against the deck's own convention (l. 41) | → "Four checks, in order" or "Verification is what is actually graded" | Verification in four steps|
| 19 | 🟡 | S24 "LLMs are never neutral", S25 "environmental … unsettled" | Empirical claims (bias by gender/race/age/education; energy and water demand) with no `.source` line, against the convention stated at l. 43 | Add one source line each, or soften the wording to match the "unsettled" framing | leave open and return a search prompt in the chat|
| 20 | 🟡 | S25 (l. 528) | Only three bullets and no closing `.arrow`/`.keybox` — the one content slide without a takeaway; trailing blank line | Add a closing line ("Unsettled — but you will be asked"), or accept as deliberate | Add a box: "AI usage comes with real costs - use it when its worth it."|
| 21 | 🟡 | S2 "Learning goals" | Mixed grammar: "Understand how to…", "Being able to…", "Know how to…", "Being able to…" | One form throughout — "You can …", matching the wording on `l_02_AITools.qmd` | No, these are official competences; keep them.|
| 22 | 🟡 | Front matter, `incremental: true` | Every list reveals item by item, including the two-column comparison slides (S9, S10) where the *contrast* is the point — 6–8 clicks each | Wrap the comparison columns in `::: {.nonincremental}` so both sides stand side by side | yes|
| 23 | 🟢 | S12 divider `.secnum` | Sections run 01, 02, **Demo**, 03, 04, 05, 06 — the demo breaks the count | Number it 03 and shift the rest, or leave if deliberate | yes|
| 24 | 🟢 | S13 "What to watch in the demo", S28 "What a disclosure has to contain", S30 "What to take away" | Topic titles rather than assertions (same convention as row 18), though defensible as section wrap-ups | Keep or reword — your call | Given time constraints I better remove the demo entirely|
| 25 | 🟢 | End comment, ll. 630–632 | "30 slides became 25" — the deck had 30 before this review and has 32 now | Update or delete the comment | delete|
| 26 | 🟢 | l. 165 | Trailing whitespace after "each class" | Strip | yes|
| 27 | 🟢 | Timing | 90 min − 2 (poll) − 6 (demo) − 10 (exercise) − debrief ≈ 55 min for 26 content slides ≈ 2 min each. Feasible, no slack | If you want slack, S7 and one of S4's two arrows are the cheapest cuts | as indicated, demo will be cut|
| 28 | 🟢 | `content/lecture/l_02_AITools.qmd`, ll. 20–26 | The page embeds the deck in an `<iframe>`; for L01 you removed the preview (commit `c455869`, "no preview of slides") | Decide whether L02 should match L01, or keep the preview here | as discussed elsewhere: html slides will be embedded once available; before publishing, there is a placeholder|

## Overall

The deck is in good shape. It is already written in note style almost
throughout — the "no full sentences" rule is broken mainly in the `.arrow` and
`.cap` boxes (rows 5, 6, 11, 12), not in the bullets. The `.dek` lines are prose
by design, so they are not counted as violations.

The two genuine risks for Monday are the missing QR code (row 1) and the
unverified-citations comment (row 2). Everything else is polish.

---

## Applied — 19 Sep 2026

Deck is now **30 slides** (title + 6 dividers + 22 content + references), down
from 32, and re-rendered. Files touched: `RM26_L02_AITools.qmd`,
`euf-slides.scss`, `references/references.bib`, new `_L02-script.md`.

**General remarks**

- All `.dek` blocks removed except the one on "The tool list from last year is
  already wrong" (row 15 states that one explicitly). Their text moved to the
  new `_L02-script.md`, organised by section, as the basis for the spoken
  script. Two deks carried information that belongs on screen, so it was folded
  into the slide body rather than dropped: the poll slide now reads "Live poll —
  **2 minutes, anonymous**", and "Groups of three · ten minutes" is the first
  line of the exercise task box.
- `.arrow` raised from `0.9em` to `1.0em` in `euf-slides.scss`, i.e. exactly
  body/bullet size. `.arrow.lg` (1.05) and `.arrow.xl` (1.2) still sit above it.

**Rows applied:** 3, 4, 5, 6, 7 (both arrows kept), 8, 10, 12, 14, 15, 16, 17,
18, 20, 22, 23 (no renumbering needed — cutting the demo makes 01–06 run
correctly by itself), 24, 25, 26, 27.

**Rows deliberately not changed:** 9 (recap questions), 11 (cap boxes B and C),
21 (learning goals), 28 (`l_02_AITools.qmd` left as is).

**Row 2 — done, and it needed doing.** All five entries were verified against
the published record: Noy & Zhang, *Science* 381(6654):187–192 ✓; Dell'Acqua et
al., HBS WP 24-013 (Sept 2023, forthcoming in *Organization Science*) ✓;
Brynjolfsson/Li/Raymond, NBER WP 31161 ✓; METR = Becker, Rush, Barnes, Rein,
arXiv 2507.09089, 12 July 2025 ✓; Darvishi et al., *Computers & Education*
210:104967 ✓. The "written from memory" note in `references.bib` was replaced by
a verification note, the arXiv URL was added to the METR entry, and the
`TO VERIFY BEFORE PUBLISHING` block was deleted from the deck.

**Row 10 — verified visually, not just applied.** `table.tasks` is now at
`1.0em` with tighter row padding; a headless screenshot at 1600×900 shows all
eight rows and the source line ending at roughly two thirds of the slide
height, so there is no overflow.

**Row 3 — merged, and enlarged.** Paragraph and references are one slide. It
fits at full body size, so the `{.smaller}` was dropped again and a `blockquote`
rule was added to `euf-slides.scss` (EUF blue, steel left rule, not reveal's
italic grey box).

### Still open

1. ~~**Row 1 — the QR code.**~~ **Closed 20 Sep 2026** — the poll slide was cut
   entirely (see below).
2. ~~**Row 15 — "sixteen tools".**~~ **Confirmed by CGR, 20 Sep 2026**; the
   number stands as written.
3. ~~**Row 19 — sourcing the bias and environment claims.**~~ **Closed
   20 Sep 2026** — see below.

### Final revision — right-hand columns on a click

On the three comparison slides ("The productivity evidence points in both
directions", "A and B differ…", "C and D differ…") the **second** column is now
a single fragment: `::: {.column width="50%" .fragment}`. One click brings the
whole right-hand side in at once, bullets included, because the list inside
stays `.nonincremental`. Click order per slide is therefore: right column →
arrow(s).

The column keeps its width while hidden, so nothing reflows on the click and
the left column never sits centred. The vertical hairline of `.columns.divided`
is drawn from the start and so is visible before the right column arrives —
intentional, as a hint that a second side is coming; say the word if you want it
suppressed until the fragment fires.

---

## Row 19 closed — 20 Sep 2026

Both slides now carry a `.source` line and citations, and both claims were
**qualified** rather than merely sourced, because the search that produced the
references showed the original wording was stronger than the evidence.

**"LLMs are never neutral".** The bias bullet was "**gender, race, age,
education** — delicate in hiring and promotion". It now reads that audits find
race, gender and education gaps in résumé ranking and simulated hiring
[@wilson2024gender; @an2024discriminate; @iso2025evaluating] and age–gender
distortion in generated content [@guilbeault2025age], with a sub-bullet marking
the effects as model-, prompt- and task-dependent — "a demonstrated **risk**,
not a measured hiring outcome". The `.source` line says none of the studies
observes employers, callbacks or promotion decisions. **Promotion was dropped
from the claim**: that is the thinnest part of the record.

**"The environmental and political-economy questions are unsettled".** Two
wording changes, both substantive:

- "total demand up" → "aggregate demand **projected** up", with water marked
  **modelled, not metered** [@iea2025energy; @li2023thirsty; @xiao2025environmental].
  There is no adequate transparent measurement of AI-specific global water use.
- "efficiency per query up" → efficiency up **per *comparable* workload**
  [@stanford2025aiindex; @oviedo2026energy], with a sub-bullet giving the reason:
  ≈ 0.3 Wh for a conventional frontier query against ≈ 3.9 Wh for a long
  reasoning workload. The unit of service is not stable, so a per-query trend
  cannot be read on its own.

A third bullet was added — estimates are "widely dispersed and only partly
commensurable" — which is the methodologically interesting point: the headline
figures differ mostly by *boundary* (all data centres / US AI servers / global
AI water withdrawal / one model's inference), not by fact. The `.source` line
flags that Li et al. is a preprint and Oviedo et al. industry-authored.

**Ten entries added to `references/references.bib`** in a dated block with the
same two cautions in the comment header. Armstrong et al. (2024) is in the bib
but not cited on a slide — it is the closest thing to a backup if someone
challenges the GPT-specific result in the discussion.

Rendered and checked at 1600×900: both slides sit well clear of the bottom
edge, and the References slide still holds all fifteen entries without
scrolling. The one change made purely for the slide: the Stanford HAI entry
uses `author = {{Stanford HAI}}`, because the full institute name ran the first
bullet onto a second line; the full name is kept in the `institution` field.

### What remains open for Monday

1. **Row 1 — the QR code** for the opening poll.
2. **Row 15 — "sixteen tools"** is still unverified.

---

## Rows 1 and 15 closed — 20 Sep 2026

**Row 15.** "Sixteen tools" confirmed against the 2025 deck by CGR. No change.

**Row 1.** The poll is **cut**, not fixed: no time to build it, and it is not
essential. The whole slide "How do you use AI at the moment?" is gone, with its
`ADD QR CODE` placeholder and its arrow. The deck now runs title + 6 dividers +
21 content + references = **29 slides**, and no placeholder text remains in it.

The spoken script keeps a note where the slide was: if the warm-up is wanted
after all, it works as a show of hands off the learning-goals slide — who uses
one of these weekly, who has never used one for coursework — in about thirty
seconds and with no slide.

**Timing, both cuts applied:** 90 min − 10 (exercise) − ~8 (debrief) ≈ 72 min
for 21 content slides, i.e. ~3.5 min each. That is the first real slack the
deck has had.

With this, every row of the review table is either applied or deliberately
declined. Nothing is outstanding.

---

## Publication embargo on the deck — 20 Sep 2026

Row 28 is now settled the other way round, and for a reason that outranks the
L01 consistency question: **the deck must not be downloadable before the
lecture is held.** It was, in fact, already live — the pre-review version has
been reachable at `/content/lecture/slides/RM26_L02_AITools.html` since the
last publish.

What changed:

- `_quarto.yml` — the lecture globs now end with
  `- "!content/lecture/slides/*.qmd"`. No deck under `content/lecture/slides/`
  is built into `_site/`, and since `quarto publish netlify` uploads the whole
  of `_site/`, none of them can reach the students by accident.
- Rendering a deck by hand still works and now writes the `.html` **next to its
  `.qmd`** instead of into `_site/` — that is the file to present from.
  `content/lecture/slides/*.html` was added to `.gitignore`.
- `l_02_AITools.qmd` — the iframe and the "Open in a separate tab" button are
  commented out, with the restore recipe in the comment; the section now reads
  *"The slides will be posted here after the lecture."*
- The page carries `strip-comments: true`, so that commented block does not
  survive into the published HTML. Without it the deck URL sits in the page
  source for anyone who looks.
- The stale HTML was deleted from `_site/`, so the next publish **removes** the
  old deck from Netlify rather than leaving it there.

Verified by a full `quarto render`: `_site/content/lecture/slides/` now holds
only `L01-Introduction.pdf`, and the string `RM26_L02` appears nowhere in the
built site.

**To publish the deck after the lecture:** add
`"content/lecture/slides/RM26_L02_AITools.qmd"` to the render list in
`_quarto.yml`, uncomment the block on the session page, drop
`strip-comments: true` if you like, then `./Publish-Website.command --full`.

---

## Citations and base font size — 20 Sep 2026

**Citations were printing as raw `@keys` with an empty reference list.** Cause:
the deck is now excluded from the project render list (see the section above),
so it is rendered *standalone* and no longer inherits `bibliography` and `csl`
from `_quarto.yml`. Fixed by declaring both in the deck's own front matter,
with paths relative to the deck:

```yaml
bibliography: ../../../references/references.bib
csl: ../../../references/jepp.csl
```

That works whether the deck is rendered standalone or, later, as part of the
project — front-matter paths are resolved against the file, and front matter
wins over project metadata. Verified: no raw keys remain, 17 bibliography
entries render, and the reference list holds all fifteen cited works on one
slide without scrolling.

**Base font size raised from 26 px to 28 px** (`$presentation-font-size-root`
in `euf-slides.scss`; only this deck uses that file). 30 px was tried first and
rejected: it pushed the `.source` line of "The paragraph, and the references it
cites" into the footer. At 28 px one slide still needed a change — the closing
key box of "What to take away" lost its `.lg`, so its two-line sentence now
sits on one line clear of the logo.

Checked at 1600×900 with fragments forced visible: productivity comparison,
the four capability cards, A/B and C/D comparisons, the task table, prompt
specification, prompting conversation, verification, the exercise paragraph,
both sourced slides, disclosure contents, take-away, recap questions and
references. All clear of the footer.
