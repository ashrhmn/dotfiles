---
name: build-first-slice
description: Build one complete production-ready path through a larger feature to establish a proven implementation and testing pattern for later gh-agent issues. Use only when the user explicitly asks to build the first slice, create a reference implementation, or implement a foundation before delegating the remaining work.
---

# Build First Slice

Build one narrow, real behavior that proves the pattern later implementation work should follow. Produce production code, not a prototype or scaffold.

## Confirm the preconditions

Read the repository guidance and the settled decisions from the current conversation or supplied specification. Stop and recommend `grill-me` when product or architectural decisions remain unresolved.

Require access to the target repository before claiming an implementation pattern, naming verification commands, or editing. When access is unavailable, identify the missing repository and stop after a tentative behavior-level boundary drawn only from the settled scope.

Inspect the codebase for an existing precedent. If a suitable pattern already exists, explain why a new first slice may be unnecessary and ask whether the user still wants one.

Choose a first slice that:

- Delivers observable behavior on its own
- Crosses every layer genuinely required for that behavior
- Exercises the architecture later issues will repeat
- Fits in the current session
- Can land safely without requiring the rest of the feature

Anchor the slice to the central outcome the user named. Prefer the shortest end-to-end behavior that proves the repeated mechanism. Do not substitute an adjacent feature merely because it is easier to demonstrate.

Choose a behavior that exercises the new capability itself, not an existing behavior with superficial use of it. A slice may span multiple actors when that is how the capability works. For a configurable feature, normally start with one authorized configuration change, persist and validate it, and end with one consumer observing the result.

Avoid infrastructure-only foundations, speculative abstractions, and broad horizontal layers that are unusable until later work lands.

## Propose the slice

Before editing, present:

- The exact behavior the slice will deliver
- The implementation and testing patterns it will establish
- The layers it must touch
- The behavior deliberately left for later issues
- The commands or observations that will verify it

Wait for the user to approve this boundary.

## Implement and verify

Implement the approved behavior as production code. Follow all repository instructions and established conventions.

Test through the highest practical public seam. Run bounded, relevant checks during implementation and the appropriate broader checks at the end. Keep the change limited to what is needed to prove the chosen pattern.

Inspect the completed diff and summarize:

- The working behavior
- The patterns established for data, backend, UI, tests, security, and operations where applicable
- The remaining work that can now follow those patterns
- Any decision that implementation evidence forced the user to revisit

Create no separate planning document unless the user requests one.

## Gate downstream delegation

Downstream gh-agent work can use this slice only after the code is available in a branch its worktrees inherit, normally the repository's default branch.

Do not commit, push, open a pull request, merge, or create gh-agent branches without explicit authorization. If the user intends to dispatch later issues while the slice is still local, state that delegation is not ready and offer two paths:

1. Obtain explicit authorization to land the slice through the repository's normal integration flow.
2. Skip the local slice and make the first gh-agent issue a pilot, then publish the remaining issues after that pilot is reviewed.

Never create `feature/*` or `automation/*` branches manually. Those belong to gh-agent.
