---
name: grill-me
description: Interview the user in rounds without changing the implementation, persist compaction-safe checkpoints under the active project's `./.decision`, and produce a confirmed decision record before implementation. Use only when the user explicitly asks to be grilled, questioned, stress-tested, or wants every ambiguity resolved before any action.
---

# Grill Me

Operate in implementation-read-only discovery. Inspect files, documentation, issues, and external sources when useful, but do not change code, project documentation, trackers, configuration, or external state. The only permitted writes are the decision checkpoints and records beneath `./.decision` described below.

## Establish decision storage

Use the task's current working directory as the project root and store all session state beneath its `./.decision` directory. State the resolved absolute path before the first round. If the working directory is ambiguous or not the intended project, resolve that with the user before writing.

Use this layout, creating only the entries needed for the current session:

```text
.decision/
├── index.md
├── active/
│   └── YYYY-MM-DD-<topic-slug>/
│       ├── state.md
│       └── rounds/
│           ├── 01.md
│           └── ...
└── records/
    └── <area>/
        └── YYYY-MM-DD-<topic-slug>.md
```

Use lowercase kebab-case for `<topic-slug>` and `<area>`; use `general` when no stable area is evident. Never overwrite an unrelated session or record. Resume a matching active session only after checking that its objective matches the user's request.

If the checkpoint cannot be created or updated, disclose that immediately and ask whether to continue without durable state. Do not silently rely on conversation memory.

## Build the decision tree

Map the subject as a tree of decisions. A decision may unlock more specific decisions beneath it. Assign stable IDs to decisions and questions, and never reuse or renumber an ID during the session.

Maintain the **frontier**: every unresolved decision whose prerequisites are already settled. Questions that depend on an unanswered question belong to a later round.

Separate facts from decisions:

- Investigate facts using the available environment and tools. Do not ask the user to retrieve information the agent can find.
- Ask the user to make product choices, tradeoffs, and preference decisions.
- If a fact cannot be established with the available access, state the missing access clearly instead of disguising it as a user decision.

## Maintain the active checkpoint

Before round one, create `state.md` with the session metadata and all known state. Keep it concise but complete enough for an agent with no conversation history to resume correctly. Include:

- Status, topic, area, created and updated dates, current round, and permanent-record target
- Objective and current scope
- Established facts and their evidence
- Settled decisions, including rationale and consequences
- Constraints and invariants
- Explicit non-goals
- Deferred work
- Superseded decisions and their replacements
- Unresolved decision tree and dependencies
- Current frontier
- Pending question IDs

Treat `state.md` as the canonical cumulative session state. Re-read it before computing every round. Preserve every settled decision until the user explicitly changes it; then mark it superseded rather than deleting it.

Use each `rounds/NN.md` file as a recovery checkpoint containing only:

- The complete questions as presented, with their stable IDs
- The user's corresponding answers, recorded faithfully
- The decision and scope changes produced by those answers
- Items that remain unresolved and why

Do not store unrelated conversation, verbose research output, or hidden reasoning. Load older round files only when `state.md` is ambiguous or a prior answer must be verified.

## Work in rounds

Ask the complete current frontier in one numbered round, grouped by theme when useful. Give a concrete recommended answer for every question.

Format each question as:

```text
Q1. <short title>
<question, options, constraints, and consequences>

Recommendation: <recommended answer and brief reason>
```

Before presenting a round, write its complete questions to the next `rounds/NN.md` file and update `state.md` with the round number and pending question IDs. Then present exactly that checkpointed round.

After every user response, make the durable checkpoint the first task:

1. Record the user's answers faithfully in the current round file.
2. Record the decisions the response settled and any remaining ambiguity.
3. Update the tree when the user changes scope or challenges an assumption.
4. Update `state.md`, including superseded decisions and the new frontier.
5. Re-read the resulting canonical state before preparing the next round.

Treat "I don't know" as useful information. Recommend a choice when the tradeoff is decidable. When the answer requires evidence or something concrete to react to, identify the required research or prototype and keep that branch unresolved.

When resuming after context compaction or interruption, reconstruct the session from `state.md` and the current round file before continuing. Do not trust conversation memory when it conflicts with the checkpoint.

## Finish at shared understanding

Finish only when the frontier is empty. Present a concise decision ledger containing:

- Settled decisions
- Invariants and constraints
- Explicit non-goals
- Deferred work
- Unresolved questions, which must say `None`

Ask the user to confirm that this is the shared understanding. Do not create the permanent record before confirmation.

After confirmation:

1. Write the permanent record to `.decision/records/<area>/YYYY-MM-DD-<topic-slug>.md` with `status`, `confirmed_at`, `area`, `scope`, and `supersedes` metadata plus the confirmed ledger.
2. Create or update `.decision/index.md` with one concise entry linking the record. Preserve unrelated entries.
3. Re-read the permanent record and verify that it contains every confirmed decision, invariant, non-goal, deferred item, and `Unresolved questions: None`.
4. Remove only the current `.decision/active/YYYY-MM-DD-<topic-slug>/` directory, including its temporary round files. Preserve all other active sessions and permanent records.
5. Report the permanent record's path to the user.

End the skill after confirmation and archival. Do not begin implementation, edit other documentation, create issues, commit, or push until the user explicitly requests the next phase.
