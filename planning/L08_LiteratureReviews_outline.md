# L08 Literature reviews — content and outline (planning note)

Status: agreed outline, materials not yet developed. Not rendered on the website
(`planning/` is outside the render list in `_quarto.yml`).

## Decisions taken

- **Framing:** the systematic literature review (SLR) is taught as the rigorous
  reference model; the payoff is shown as *the literature review section of a
  term paper or thesis*.
- **Format:** video lecture of ~90 min, recorded as separate chapters; one
  Revealjs deck in the L02 EUF style (`content/lecture/slides/RM26_L08_LiteratureReviews.qmd`).
  Old slides are superseded; start from scratch.
- **Database:** Web of Science only.
- **Tutorial:** includes an R extension.
- **Examples:** a management running example; the two own SLRs
  (`aistleitner2021capability`, `graebner2023degrowth`) as real-world cases.
- **Biases, limitations and caveats** and **what a review can and cannot do**
  get dedicated space (not only side remarks).
- **Take-home II** is still open and is designed to fit the lecture and tutorial.

## Revised learning goals (draft)

After this session you can …

1. **choose** a type of review (narrative, integrative, scoping, systematic,
   meta-analysis, bibliometric) that fits a given purpose, and justify the choice;
2. **explain** what a literature review can establish and what it cannot;
3. **translate** a topic into a reviewable question and a concept table, and
   from there into a documented Boolean search string for Web of Science;
4. **assess** a search in terms of precision and recall, and validate it against
   known key publications;
5. **apply** explicit inclusion/exclusion criteria and document the selection in
   a PRISMA 2020 flow diagram;
6. **synthesise** literature with a concept matrix rather than summarising it
   paper by paper;
7. **identify** the main sources of bias in the literature, in your own search
   and in your synthesis, and report them as limitations;
8. **distinguish** keyword-based, semantic (AI) and citation-based search tools,
   and use AI at each stage without giving up reproducibility (see L02).

Goal 8 replaces the old "citation-based vs. syntax-based" wording and aligns
with L02 (`l_02_AITools.qmd`, "finders" vs. "connectors").

## Video lecture — chapter plan (~90 min)

| # | Chapter | min | Core content |
|---|---------|----:|--------------|
| 0 | Intro & running example | 4 | Running question; goals; how the chapters connect to tutorial and take-home |
| 1 | Purpose, types, and what a review can and cannot do | 12 | Functions of reviews; typology and choosing by purpose; review *as method* vs. review *section*; **first pass of can / cannot** |
| 2 | Workflow & question | 9 | Stages: protocol → search → screening → extraction → synthesis → report; concept table (PCC-type, adapted to management); why the protocol comes first |
| 3 | Searching in Web of Science | 17 | Concepts → synonyms → Boolean, truncation, phrase search, field tags; **precision vs. recall**; validating against known papers; backward/forward snowballing; three tool families |
| 4 | Screening & selection | 9 | Criteria; title/abstract then full text; second screener and disagreements; PRISMA flow diagram |
| 5 | From summary to synthesis | 12 | Data extraction; concept matrix (Webster & Watson); thematic synthesis; light-touch quality appraisal; weak vs. strong review paragraph |
| 6 | Biases, limitations, caveats | 13 | Structured along the pipeline (see below) |
| 7 | Reporting, reproducibility, AI | 10 | PRISMA 2020 checklist; PRISMA-S for the search; search log; writing the limitations section; AI per stage (picks up L02 rows "finding literature" and "extracting data from many studies"); disclosure |
| 8 | Wrap-up | 4 | Can / cannot revisited; one-page checklist; pointer to tutorial and take-home |
|   | **Total** | **90** | |

Each chapter ends with one self-check question. Chapter 6 also gets
"bias checkpoints" planted earlier (e.g. coverage bias in ch. 3,
screener bias in ch. 4) so that ch. 6 consolidates rather than introduces.

### Chapter 6 — biases, limitations, caveats (structured by stage)

| Stage | Bias / caveat | Illustration / countermeasure |
|-------|---------------|-------------------------------|
| The literature itself | Publication bias (file drawer), outcome-reporting bias, time-lag bias | Significant results get published more often and faster; a review inherits this. Countermeasure: name it; look for grey literature; funnel plots only mentioned |
| | Citation bias / Matthew effect | Often cited ≠ well supported (L02) |
| The database | Coverage bias of WoS: journals over books, English over other languages, Global North over Global South, uneven coverage of social sciences | Validate against known key papers; state coverage as a limitation |
| The search | Terminology bias: different schools/disciplines use different words for the same thing | Pluralist angle: a string built from one paradigm's vocabulary silently excludes others. Countermeasure: synonym harvesting across communities, test alternative strings |
| | Recall vs. precision trade-off; database ranking and "first 100 results" | Document the full result set, not a relevance-ranked slice |
| Tools | Semantic/AI tools: opaque ranking, non-reproducible results, fabricated or mis-attributed references | Never the primary search; log and verify everything |
| | Citation-based tools reinforce citation clusters (echo chambers) | Use for snowballing from diverse seeds, not as sole source |
| Screening | Confirmation bias, single-screener subjectivity, criteria drift | Criteria fixed in advance; second screener on a sample; log exclusion reasons |
| Synthesis | Vote counting; apples and oranges (heterogeneous studies); treating studies of different quality as equal | Concept matrix; weight by design/quality; report heterogeneity |
| Reporting | Selective reporting; overclaiming from "no study found" | Absence of evidence ≠ evidence of absence |

### What a review can and cannot do (ch. 1, revisited in ch. 8)

**Can:** map a field and its debates; establish what is known and how robustly;
identify gaps, contradictions and under-studied contexts; build or refine a
conceptual framework; justify a research question; show where evidence is thin.

**Cannot:**
- produce better evidence than the primary studies it rests on (garbage in, garbage out);
- prove that something has not been studied — only that the documented search did not find it;
- be objective just by being systematic — every review rests on choices
  (question, database, terms, criteria) that shape the result;
- settle causal questions the underlying studies could not settle;
- be complete or permanent — it is a dated snapshot;
- turn the frequency of a claim into evidence for it;
- replace reading the key works.

## Tutorial — "A mini systematic review in 8 steps"

Companion page in the style of the L02 resources:
`content/lecture/lit-review-tutorial/index.qmd` (html + pdf + docx downloads),
templates as separate downloads. Uses a different topic than the take-home.

1. From topic to concept table
2. Harvesting terms: synonyms, key papers' keywords, a semantic tool to widen
   the net — and checking for terminology bias
3. Building and testing the string in WoS (field tags, truncation, phrase
   search); validating with 3–5 known key papers; logging each iteration
4. Search log template: what someone needs to re-run your search
5. Export (WoS tab-delimited / plain text), deduplication, title/abstract
   screening in a spreadsheet with a criteria sheet and exclusion reasons
6. Snowballing from 2–3 seed papers (WoS "cited references" / "times cited",
   optionally a citation-based tool)
7. Concept matrix template and a short worked synthesis paragraph
8. PRISMA flow diagram and a reporting checklist, including a limitations
   paragraph that names concrete biases of *this* search

**R extension** (builds on lab sessions 6–8):
- import the WoS export with `data.table::fread()` (as taught in the lab);
- deduplicate by DOI, count records per year and per journal, plot with ggplot2;
- produce the flow diagram with the `PRISMA2020` package;
- pointer only: `bibliometrix` for those who want more.

**Biases made tangible in the tutorial:** compare hit counts of two
strings built from different vocabularies; check how many known key papers WoS
finds; look at language and country distribution of the result set in R.

## Take-home II — proposal (to be finalised)

Given a short research question (different from the tutorial's), students
submit: concept table; final search string with search log; WoS result count
and export; screening of titles/abstracts against stated criteria (capped, e.g.
≤ 50 records); PRISMA flow diagram; concept matrix for 5 included papers;
a ~300-word reflection on the biases and limitations of their own search;
AI disclosure. Pass/fail.

## Readings (proposal — verify bibliographic details before adding to the bib)

- **Mandatory:** Page et al. 2021, PRISMA 2020 statement (`page2021prisma`);
  Snyder 2019, *Literature review as a research methodology: An overview and
  guidelines*, J. Business Research 104.
- **Further:** Page et al. 2021 E&E (`page2021prismaexplanation`, as reference);
  Tranfield, Denyer & Smart 2003, BJM 14(3); Webster & Watson 2002, MIS
  Quarterly 26(2) (concept matrix); Grant & Booth 2009 (typology of review
  types); Rethlefsen et al. 2021, PRISMA-S; Haddaway et al. 2022, PRISMA2020
  R package; own SLRs as examples.

## Running examples (proposal)

- **Lecture:** CSR / ESG and financial performance — large, contested
  literature with documented meta-analyses and publication-bias debates; good
  for chapters 1, 5 and 6.
- **Tutorial:** four-day week / reduced working time — manageable result set,
  strongly varying terminology ("four-day week", "compressed work week",
  "working time reduction"), ideal for showing terminology bias.
- **Take-home:** a third topic.

Hit counts and screenshots must be produced with EUF WoS access (not available
from the development environment).

## Housekeeping

- Mark L08 as "(video)" in `content/lecture/index.qmd`, `content/index.qmd`,
  `content/SeminarDescription.qmd`.
- Rewrite `content/lecture/l_08_LiteratureReviews.qmd`: goals, chapter video
  embeds, slides iframe, resources, readings.
- Align tool terminology in `l_02_AITools.qmd` with goal 8 if needed.
