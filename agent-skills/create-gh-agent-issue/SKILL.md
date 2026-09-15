---
name: create-gh-agent-issue
description: Turn settled work into focused GitHub issues for repositories managed by gh-agent, including approved vertical slicing, the mandatory workstream label, enforced prerequisite labels, and serial publication order. Use when the user explicitly asks to create or publish one or more implementation issues that gh-agent should execute through feature and automation branches.
---

# Create gh-agent Issues

Create agent-ready issues in execution order. Keep each issue independently testable and small enough for one bounded implementation run. The implementing agent executes; it never decides. Every choice is made here, before publishing.

## Confirm authorization and readiness

Treat issue creation, label creation, and issue editing as external writes. Publish only when the user explicitly asks to create or publish issues. If the user asks for a draft, stop before calling write operations.

Identify the target repository, a lowercase kebab-case workstream name, and the settled source of truth: conversation, specification, decision ledger, or landed first slice.

Explore the repository for factual context, existing patterns, and bounded verification commands. Do not ask the user for facts available from the repository or tools.

Do not invent missing product or architectural decisions, and do not hand them to the agent by phrasing them as a choice. If unresolved decisions would materially change the work, list them and recommend `grill-me` before issue creation.

If `build-first-slice` was used, confirm that the slice is available in a branch gh-agent worktrees will inherit. Inspect the landed behavior as precedent and exclude behavior it already completed.

Determine the effective implementation base from remote refs, not stale local branches: discover the default branch instead of assuming `main`; a new workstream (no remote `feature/<workstream>` or `automation/<workstream>`) seeds from the default branch; an existing workstream's base is remote `automation/<workstream>` plus the default and feature changes gh-agent will sync into it. Inspect open workstream issues and pull requests when unfinished work could change that base, and resolve any uncertainty before publishing downstream issues.

## Choose one issue or a series

Use one issue when one fresh agent session can deliver and verify the full outcome. Use a series when the work exceeds one bounded run or contains genuine dependency edges. A run that must touch more than about 25 files, or whose verification takes more than about 30 minutes end to end, is two issues.

For a series, draft **vertical slices**:

- Each issue delivers a narrow but complete behavior through all required layers.
- Each issue is independently demonstrable or verifiable.
- Each issue owns the acceptance criteria that grade it.
- Schema, backend, UI, and tests are not separate issues merely because they are separate layers.
- A wide mechanical refactor may use an expand, migrate, contract sequence when no vertical slice can remain green.

Name every file each issue touches. A shared component or helper that several issues need is its own prerequisite issue with its exact API; later issues consume it by name and never modify it. Keep every issue understandable to a fresh agent with repository access.

## Decide everything before publishing

Read the files the issue lists and settle, per file, what changes. Write the answer down; never describe a rule and let the agent apply it.

- Replace blanket rules ("every list auto-loads") with a per-file table of targets. Files that follow the same rule still get their own rows; a genuine exception names its file and what it does instead.
- Specify literal values: new file paths, component and hook names, props and types, class strings and grid templates, i18n keys with the text for every locale, and the exact tests to add. Decide the what, not the diff: the agent writes the code, tests, and PR.
- List deletions explicitly: strings, classes, files, allowlist entries. Anything not listed stays unchanged, including "unused" code the change exposes. Edits to existing shared components, tests, or docs appear in the table or do not happen.
- Do not write "where possible", "may", "unless", "if needed", "or document an exception", "shared hook or component", "fixes the migration genuinely needs", or "state the choice in the pull request". Each of these produced unplanned work in past runs.

## Approve the breakdown before publishing

For every proposed issue, present:

- **Title**
- **Outcome**: the behavior that becomes usable or observable
- **Blocked by**: genuine prerequisites, or none
- **Verification**: the bounded evidence that will prove it complete

An approved **Blocked by** entry means the user is approving scheduling behavior, not just documentation. When publication is separately authorized, publish it as an enforced `require-issue-closed:` label as well as human-readable dependency prose.

When decomposing new multi-issue work, wait for the user to approve the granularity, ordering, and dependencies before creating anything. For one already-scoped issue, show the final title and body, then proceed when the user's request already explicitly authorized creation.

## Write self-contained issue bodies

Use this structure:

```markdown
## Outcome

<The single result this issue must deliver and why it matters.>

## Context

<Relevant existing behavior, settled decisions, landed precedent, and reference files.>
Implement exactly what Scope says. Do not choose other files, widths, names, or behavior.

## Scope

1. `<path>`: <exact edit, with the literal code, class string, prop, or locale text where it matters>
2. Create `<path>` exporting `<name>` with <exact props and slots>

| File | Target |
|---|---|
| `<path>` | <decided width, mode, component, or "unchanged"> |

## Non-goals

- <Files and behavior that stay unchanged, including tempting adjacent cleanups>

## Acceptance criteria

- [ ] <Observable condition owned by this issue>
- [ ] <Important failure, authorization, or regression condition>

## Verification

- `<test command with an explicit timeout>`
- `<grep for a literal decided value>` and `! grep` for what must be gone

## Dependency

Depends on #<number>
```

Omit the dependency reference for the first issue and state that it has no workstream dependency. Include every finalized decision relevant to the issue, but do not paste the conversation or weaken precise constraints into generic prose. Keep the `Depends on #<number>` prose and its `require-issue-closed:` label in agreement: the prose explains, the label enforces.

Check every acceptance criterion before publishing:

- It can be false at the starting commit.
- It is satisfied by this issue rather than a later issue.
- A reviewer can observe whether it passed; at least one criterion per decided value is checkable by a literal grep, not only by the suite passing.
- The agent can run the check itself in its worktree. Do not require a browser, a live backend, or "sized appropriately" timeouts; give the command and the timeout.

To amend a published issue, append a section headed `## Correction (supersedes any conflicting text above)` with the same per-file table form. The agent reads the full body and comments in order; a later explicit maintainer decision wins.

## Publish serially

1. Ensure the `base:<workstream>` label and, as prerequisite numbers become known, every `require-issue-closed:` label required by the approved breakdown exist. Create labels only when publication is authorized.
2. Apply exactly one valid `base:<workstream>` label to every agent-managed issue. Other ordinary labels are allowed.
3. Create prerequisite issues first and record each returned issue number.
4. Add `Depends on #<number>` to every later issue that relies on an earlier issue, and apply the corresponding `require-issue-closed:<number>` label or labels to that dependent issue.
5. Create dependent issues serially. Serial creation is the default scheduling order and the fallback when prerequisite labels are unsupported; where a real dependency exists, `require-issue-closed:` labels are the explicit enforced mechanism. Do not rely on GitHub's native issue-dependency or blocker metadata because gh-agent does not read it.
6. Verify each issue is open and has exactly one `base:*` label. For each dependent issue, also verify that every intended `require-issue-closed:` label is present and agrees with the `Depends on` prose before creating its dependents.
7. Stop on a failed creation or failed verification instead of publishing an unsafe remainder.

Prerequisite label grammar and behavior:

- `require-issue-closed:` followed by a comma-separated list with no whitespace: bare `129` for the same repository (never `#129`), `owner/repo#129` for another repository. Multiple labels on one issue are unioned. The prefix uses 21 of GitHub's label characters, so give a qualified reference its own label.
- A prerequisite is satisfied when its issue is closed in any state, including through gh-agent's blocker flow; closure orders the queue but proves nothing about code reaching the workstream branches.
- gh-agent skips an issue with an unsatisfied prerequisite rather than stalling its `base:` group, so creation order no longer implies implementation order. Builds that predate gating ignore the labels and fall back to creation order.
- A mistyped value leaves an issue silently ineligible with a repeating skip line. Verify the exact label value after publication.

Use temporary body files outside the repository when calling `gh issue create`. Do not create `feature/*`, `automation/*`, or issue branches. Do not target or merge the default branch. Branch and pull-request ownership belongs to gh-agent.

Finish by reporting the created issues in execution order with their URLs and dependency relationships.
