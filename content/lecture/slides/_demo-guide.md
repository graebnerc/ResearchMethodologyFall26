# Live demo run-sheet — L02, section 2

Instructor notes for the two demo slides ("Live demo: one question, two
classes" and "What to watch in the demo"). Filename starts with `_`, so Quarto
neither renders nor copies it: this stays out of the published site.

**Slot:** between slide 13 and slide 14. **Budget: 6 minutes.** It is the hinge
of the lecture — everything after it refers back — but it is also the part most
likely to overrun. Stop at 6 minutes even if it is going well.

---

## What the demo has to show

One thing only: **the same question, put to a class-A and a class-B system,
produces answers that differ in whether you can check them.**

Not: that AI is unreliable. Not: that one product is better. If students leave
thinking "the AI lies", the lecture has failed — the point is that the two
classes fail *differently*, and that one of them leaves you a trail.

---

## Before the lecture

- [ ] Two browser tabs, logged in, side by side or quick to switch. Tab 1: a
      conversational assistant **with web search switched off**. Tab 2: a
      grounded search tool.
- [ ] **Switch off web search in tab 1.** This is the single most important
      setup step — see "When the demo refuses to misbehave" below.
- [ ] Browser zoom to ~150%. Text that is readable on your laptop is not
      readable from row 12.
- [ ] Clear or hide chat history, and close any window showing personal
      accounts. You are about to teach a confidentiality rule in section 4;
      do not violate it on screen in section 2.
- [ ] **Run it once the morning of the lecture** and screenshot the output.
      Model behaviour changes without notice. The screenshots are your
      fallback and take two minutes to make.

---

## The question

Use one where the literature is real, contested, and close to the students'
own work:

> What does the empirical literature say about the effect of remote work on
> employee productivity? Give me three references.

It is deliberately the same topic as the citation-checking exercise later in
the lecture, so the two connect.

*Backup, if the first is answered too well:*

> Which studies show that transformational leadership improves team
> performance in multinational firms?

---

## Run sheet

**1. Ask tab 1 (conversational, no search). ~90 seconds.**
Read the answer aloud, or a sentence of it. Say nothing critical yet — let it
look good, because it does look good.

**2. Ask the class one question before revealing anything:**
"Would you cite this? What would you need to do first?"
Take two answers. Someone will say "check the sources". That is your cue.

**3. Check one reference live. ~2 minutes.**
Pick **one** — not all three, there is no time. Copy the title into a search
engine in quotation marks. Three outcomes, all of which work:
- *Nothing found* → fabricated. The cleanest case, increasingly rare.
- *Found, but says something different* → the interesting case. Open the
  abstract and read the sentence that contradicts the summary.
- *Found and correct* → say so plainly, then check the **scope**: does the
  study support the general claim the paragraph made from it? This is where
  it usually comes apart.

**4. Ask tab 2 (grounded) the same question. ~90 seconds.**
Point at the citations. Click one. Land the contrast: *"I can follow this. I
could not follow the first one — not because it was wrong, but because there
was nothing to follow."*

**5. Advance to slide 14** and let the three watch-points land as summary.

---

## When the demo refuses to misbehave

Expect this, and plan for it. Current assistants with retrieval enabled often
return real, correctly-attributed references. A demo that fails to produce a
fabrication is not a failed demo *if you have the right fallback*:

- **Primary defence:** switch search off in tab 1 beforehand. An ungrounded
  model asked for references still reconstructs plausible ones.
- **If it still behaves:** pivot from *existence* to *fidelity*. Ask it to
  summarise what one of the papers found, then open the abstract together.
  Mismatch in emphasis, scope or direction is far more common than invention,
  and it is the more important failure anyway — it is the one an examiner
  catches and a reference manager cannot.
- **If everything is correct:** say so. "Today it got this right. You cannot
  know that in advance without checking — that is the entire point." That is
  an honest and sufficient conclusion, and it models the behaviour you want.
- **Last resort:** the screenshots from your morning run.

---

## Debrief — pick one, 60 seconds

- Which of the two answers would you be able to defend in an oral exam?
- What would you have had to do to use the first answer responsibly?
- Which capability class was each tab, and would a different class have helped?

---

## Do not

- Turn it into a model-bashing session. The lecture's claim is that these tools
  are useful *and* need checking.
- Use a real student's term-paper topic without asking them first.
- Paste anything confidential, including your own unpublished work.
- Let it run past six minutes. The citation-checking exercise in section 4 is
  where students do this themselves; that is the part that actually teaches.

---

## Links back into the deck

- Slide 14 ("What to watch in the demo") — the three questions.
- Section 4, verification slide — the four checks, in order.
- The exercise: `content/lecture/ai-citation-check/index.qmd`, whose solution
  stays commented out until after the session.
