# Spoken script — L02, "AI tools in practice"

Basis for a proper script. Filename starts with `_`, so Quarto neither renders
nor copies it: this stays out of the published site.

Created 19 Sep 2026 when the `.dek` lines were removed from the deck. Each
section below carries the dek text that used to stand under the slide title —
that text is now the *spoken* opening of the slide, not something on screen.
Expand it into full script as you go.

**Timing after the live demo and the poll were cut:** 90 min − 10 (exercise) −
~8 (exercise debrief) ≈ 72 min for 21 content slides ≈ 3.5 min each.

---

## 01 — Why this lecture

### Learning goals

*(no dek; read the four competences as they stand)*

*(The opening poll slide was cut on 20 Sep 2026 — no time, and not essential.
If you still want the warm-up, ask for a show of hands off the learning-goals
slide: who uses one of these weekly, who has never used one for coursework.
Thirty seconds, no slide needed.)*

### The productivity evidence points in both directions

> Careful: "AI makes you faster and better" is an empirical claim, with a
> contested evidence base.

This is the slide that sets the tone for the whole lecture. The point is not
that the evidence is bad; it is that it points both ways, and that the studies
disagree in a structured way — by task, by prior skill, by whether the worker
could tell.

### You are accountable for every claim you submit

> True not only for research; make sure you always check instructor-specific
> requirements.

Say explicitly that this module's rules are not the university's rules, and
that other instructors will differ.

---

## 02 — Capabilities, not products

### The tool list from last year is already wrong

Dek kept on the slide ("Sixteen tools last year; several no longer exist") —
check the number before Monday.

### Four capability classes cover almost everything you need

> Any one product may combine several of these. The relevant question is never
> "which app is best" but "which class am I using right now".

### A and B differ in whether you can check the output

> Both answer questions in fluent prose. Only one of them leaves you a trail
> you can follow back to a source.

### C and D differ in how much judgment you delegate

> In class C you supply the material and keep the reasoning. In class D the
> system also decides the steps — which is exactly where it can go wrong
> unobserved.

### Every task has a matching class — and a characteristic failure

> Read the third column as the thing to check before you use the output.

---

### Cut for 2026: the live demo

The two demo slides ("Live demo: one question, two classes" and "What to watch
in the demo") were removed for time. The run-sheet is kept in `_demo-guide.md`
in case the demo returns.

Its three questions are worth saying aloud at "Verification in four steps",
since that slide now carries the load the demo used to carry:

- Where does the claim come from? A source, or only prose?
- Does the source say it? Open it — you would be surprised how often this fails.
- What was left out? Summaries are confident about what they kept.

Punchline that went with them: **fluency is not evidence.**

---

## 03 — Prompting

### A prompt is a specification, not a wish

> Most disappointing output is the predictable result of an underspecified
> request. Four elements fix the majority of cases.

### The same request, unspecified and specified

> A real task from this module: you need to narrow a term-paper topic on
> remote work.

Note that this is deliberately the same topic as the citation exercise later,
so the two connect.

### Prompting is a conversation, and worth keeping

> The first answer is a draft. Treat it the way you treat your own first draft.

---

## 04 — What can go wrong

### Verification in four steps

> Four checks, in order. The first two catch nearly everything that would
> embarrass you in an examination.

### Verification in four steps

Two sub-points added 20 Sep 2026, because the exercise walks straight into
them: **paywalled is not the same as non-existent**, and the abstract is free
even when the article is not. Say this before the groups start — the QJE
article is closed access, and a group that stops at "I cannot open it" has no
way to tell Bloom et al. from the fabricated reference. The distinction is the
whole skill: absence of *access* versus absence of *record*.

### Exercise: three citations, one of them invented

Group size and time are now printed in the task box. Ten minutes of work, then
allow about eight for the debrief — with the demo gone, this is the practical
core of the lecture.

### The paragraph, and the references it cites

> An assistant, asked for "a short literature-based paragraph on remote work
> and productivity". It reads well, it is properly formatted, it cites three
> sources.

Solutions and debrief questions: `content/lecture/ai-citation-check/index.qmd`
(commented out until after the session).

### Your interview transcripts are not yours to upload

> This is the rule most likely to cause you actual trouble.

### LLMs are never neutral

> The theory-ladenness of observation applies to training data too.

Explicit callback to lecture 1.

Sourced on 20 Sep 2026. The distinction to make out loud: all four studies are
**controlled audits of model output** — name swaps on résumés, simulated
decisions, generated content. None of them watches an employer, a callback or a
promotion. So the honest claim is *demonstrated disparity in model behaviour*
and therefore *credible risk of allocative harm*, not *AI has been shown to
discriminate in hiring*. Worth saying explicitly, because the press coverage of
these papers routinely makes the stronger claim.

Effect sizes are also model-, version-, occupation- and prompt-dependent:
Wilson and Caliskan find White-associated names favoured in 85% of tests over
three million résumé–posting comparisons, while Iso et al. find little
detectable explicit gender or race effect in recent GPT models but a persistent
**education-institution** effect. Promotion is the thinnest part of the record —
avoid claiming it.

### The environmental and political-economy questions are unsettled

> Presented as genuinely open, because it is — and because you will be asked
> about it.

Sourced on 20 Sep 2026, and the wording was tightened twice over:

- **"Projected", not "is rising".** For AI-specific global water demand there is
  no adequate transparent measurement; the IEA's doubling-by-2030 figure is a
  base case for *all* data centres with a wide range around it, and the water
  numbers are models (Li et al. is a preprint; Xiao et al. is a US scenario).
- **"Per comparable workload", not "per query".** Hardware efficiency has
  improved roughly 40% a year since 2008, but the *unit of service* keeps
  changing: a 2023 chatbot reply, a reasoning query, and an agent making many
  tool calls are not the same thing. Oviedo et al. put a conventional frontier
  query at ~0.31 Wh and a long reasoning workload at ~3.91 Wh — a thirteenfold
  jump from the same infrastructure. Efficiency gains and rising totals are not
  in contradiction.

The apparent disagreement between headline figures is usually a difference of
**boundary**, not of fact: all data centres vs. US AI servers vs. global AI
water withdrawal vs. one model's inference. "Widely dispersed and only partly
commensurable" is the accurate summary — and it is itself a methodology point,
which is why the slide stays in a methods lecture.

Note for honesty about provenance: Oviedo et al. is industry-authored
(Microsoft) and production-informed rather than an independent fleet audit.

---

## 05 — Disclosure

### Undocumented AI use is cheating

> Not a moral position but a procedural one: unreported assistance makes the
> work unassessable.

### What a disclosure has to contain

> Five elements. The fillable template and a worked example are on the lecture
> page.

---

## 06 — Summary & outlook

### What to take away / Recap questions

*(no deks; the recap questions are for students to take home, not to work
through in the room)*
