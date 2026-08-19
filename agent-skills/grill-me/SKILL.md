---
name: grill-me
description: Interview the user in read-only rounds to resolve a plan, design, product decision, or technical approach before implementation. Use only when the user explicitly asks to be grilled, questioned, stress-tested, or wants every ambiguity resolved before any action.
---

# Grill Me

Operate in read-only discovery. Inspect files, documentation, issues, and external sources when useful, but leave code, documents, trackers, and configuration unchanged throughout the grilling session.

## Build the decision tree

Map the subject as a tree of decisions. A decision may unlock more specific decisions beneath it.

Maintain the **frontier**: every unresolved decision whose prerequisites are already settled. Questions that depend on an unanswered question belong to a later round.

Separate facts from decisions:

- Investigate facts using the available environment and tools. Do not ask the user to retrieve information the agent can find.
- Ask the user to make product choices, tradeoffs, and preference decisions.
- If a fact cannot be established with the available access, state the missing access clearly instead of disguising it as a user decision.

## Work in rounds

Ask the complete current frontier in one numbered round, grouped by theme when useful. Give a concrete recommended answer for every question.

Format each question as:

```text
Q1. <short title>
<question, options, constraints, and consequences>

Recommendation: <recommended answer and brief reason>
```

Wait for the user's answers before asking the next round. After every response:

1. Record the decisions the response settled.
2. Update the tree when the user changes scope or challenges an assumption.
3. Recompute the frontier.
4. Ask the next round.

Treat "I don't know" as useful information. Recommend a choice when the tradeoff is decidable. When the answer requires evidence or something concrete to react to, identify the required research or prototype and keep that branch unresolved.

## Finish at shared understanding

Finish only when the frontier is empty. Present a concise decision ledger containing:

- Settled decisions
- Invariants and constraints
- Explicit non-goals
- Deferred work
- Unresolved questions, which must say `None`

Ask the user to confirm that this is the shared understanding. End the skill after confirmation. Do not begin implementation, edit documentation, or create issues until the user explicitly requests the next phase.
