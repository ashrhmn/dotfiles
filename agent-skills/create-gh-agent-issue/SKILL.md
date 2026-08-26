---
name: create-gh-agent-issue
description: Turn settled work into focused GitHub issues for repositories managed by gh-agent, including approved vertical slicing, the mandatory workstream label, enforced prerequisite labels, and serial publication order. Use when the user explicitly asks to create or publish one or more implementation issues that gh-agent should execute through feature and automation branches.
---

# Create gh-agent Issues

Create agent-ready issues in execution order. Keep each issue independently testable and small enough for one bounded implementation run.

## Confirm authorization and readiness

Treat issue creation, label creation, and issue editing as external writes. Publish only when the user explicitly asks to create or publish issues. If the user asks for a draft, stop before calling write operations.

Identify:

- The target repository
- A lowercase kebab-case workstream name
- The settled source of truth: conversation, specification, decision ledger, or landed first slice

Explore the repository for factual context, existing patterns, and bounded verification commands. Do not ask the user for facts available from the repository or tools.

Do not invent missing product or architectural decisions. If unresolved decisions would materially change the work, list them and recommend `grill-me` before issue creation.

If `build-first-slice` was used, confirm that the slice is available in a branch gh-agent worktrees will inherit. Inspect the landed behavior as precedent and exclude behavior it already completed.

Determine the effective implementation base from remote state before deciding what remains:

- Discover the repository's default branch instead of assuming `main`.
- For a new workstream with no remote `feature/<workstream>` or `automation/<workstream>` branch, treat the default branch as the source gh-agent will seed.
- For an existing workstream, inspect the remote `automation/<workstream>` branch as the cumulative base. Also account for default and feature changes that gh-agent will synchronize into it before the next issue run.
- Inspect open workstream issues and pull requests when concurrent or unfinished work could change that base.

Use remote refs rather than stale local branches. If the inherited state or an unfinished prerequisite is uncertain, resolve that uncertainty before publishing downstream issues.

## Choose one issue or a series

Use one issue when one fresh agent session can deliver and verify the full outcome. Use a series when the work exceeds one bounded run or contains genuine dependency edges.

For a series, draft **vertical slices**:

- Each issue delivers a narrow but complete behavior through all required layers.
- Each issue is independently demonstrable or verifiable.
- Each issue owns the acceptance criteria that grade it.
- Schema, backend, UI, and tests are not separate issues merely because they are separate layers.
- A wide mechanical refactor may use an expand, migrate, contract sequence when no vertical slice can remain green.

Prefer behavior and stable contracts over incidental file paths. Name stable existing modules or a landed first slice when they provide necessary context, but keep every issue understandable to a fresh agent with repository access.

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

<Relevant existing behavior, settled decisions, and landed precedent.>

## Scope

- <Required behavior and important invariants>
- <Data, API, UI, security, compatibility, concurrency, and failure behavior where relevant>

## Non-goals

- <Behavior deliberately deferred or preserved unchanged>

## Acceptance criteria

- [ ] <Observable condition owned by this issue>
- [ ] <Important failure, authorization, or regression condition>

## Verification

- `<bounded command>`

## Dependency

Depends on #<number>
```

Omit the dependency reference for the first issue and state that it has no workstream dependency. Include every finalized decision relevant to the issue, but do not paste the conversation or weaken precise constraints into generic prose.

For every dependency, keep the `Depends on #<number>` prose and its `require-issue-closed:` label in agreement. The prose is the human-readable explanation; the label is the enforced scheduling control.

Check every acceptance criterion before publishing:

- It can be false at the starting commit.
- It is satisfied by this issue rather than a later issue.
- A reviewer can observe whether it passed.

## Publish serially

1. Ensure the `base:<workstream>` label and, as prerequisite numbers become known, every `require-issue-closed:` label required by the approved breakdown exist. Create labels only when publication is authorized.
2. Apply exactly one valid `base:<workstream>` label to every agent-managed issue. Other ordinary labels are allowed.
3. Create prerequisite issues first and record each returned issue number.
4. Add `Depends on #<number>` to every later issue that relies on an earlier issue, and apply the corresponding `require-issue-closed:<number>` label or labels to that dependent issue.
5. Create dependent issues serially. Serial creation is the default scheduling order and the fallback when prerequisite labels are unsupported; where a real dependency exists, `require-issue-closed:` labels are the explicit enforced mechanism. Do not rely on GitHub's native issue-dependency or blocker metadata because gh-agent does not read it.
6. Verify each issue is open and has exactly one `base:*` label. For each dependent issue, also verify that every intended `require-issue-closed:` label is present and agrees with the `Depends on` prose before creating its dependents.
7. Stop on a failed creation or failed verification instead of publishing an unsafe remainder.

Use prerequisite labels according to this grammar and behavior:

- Start the label name with `require-issue-closed:` and follow it with a comma-separated list of references with no whitespace.
- Use a bare decimal number such as `129` for an issue in the same repository. Do not include a leading `#`; `require-issue-closed:#129` is invalid.
- Use `owner/repo#129` for an issue in another repository.
- Multiple `require-issue-closed:` labels on one issue are allowed; gh-agent unions all of their prerequisite sets.
- The prefix consumes 21 characters of GitHub's label-name limit. A qualified reference such as `owner/repo#129` should generally have its own label instead of being packed into a list.
- A prerequisite is satisfied when its issue is closed in any closed state. This does not prove its code reached the workstream branches, and an issue closed through gh-agent's blocker flow still satisfies the label.
- gh-agent skips an issue with an unsatisfied prerequisite instead of stalling its `base:` group. A later issue can therefore run first, so creation order no longer implies implementation order when prerequisite labels are present.
- Builds that predate prerequisite gating ignore these unknown labels and fall back to serial creation order; do not add version gating.
- A mistyped prerequisite value can leave an issue ineligible with a repeating skip line instead of a loud failure. Verify the exact label value after publication.

Use temporary body files outside the repository when calling `gh issue create`. Do not create `feature/*`, `automation/*`, or issue branches. Do not target or merge the default branch. Branch and pull-request ownership belongs to gh-agent.

Finish by reporting the created issues in execution order with their URLs and dependency relationships.
