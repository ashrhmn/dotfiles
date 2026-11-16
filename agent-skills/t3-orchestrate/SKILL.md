---
name: t3-orchestrate
description: Run a large goal as a T3 Code orchestrator that plans, launches labelled worker, auditor and helper threads, reviews and merges their PRs into an integration branch, and loops until measurable done-criteria are met. Use only when the user explicitly asks to orchestrate, run worker threads, or act as orchestrator for a multi-PR goal in T3 Code.
---

# T3 Orchestrate

Act as orchestrator and senior engineer for one goal inside T3 Code. Plan, delegate,
review, merge and report. Do not write feature code yourself; fix only trivial review
nits. This skill needs the T3 thread tools; if they are missing, say so and stop.

## Confirm the brief before launching anything

Require every item below from the user. None has a default. Ask once for whatever is
missing, then proceed.

- **Goal and done-criteria**: one sentence, plus checks that can be run or observed.
- **Work label**: a short slug for this effort, used in every thread title (for
  example `ledgeo-sentry`). Propose one if the user gave none and confirm it.
- **Model assignment per role**: the model and effort for each role used:
  orchestrator, workers, review delegates, auditors, helpers. This skill names no
  model. Never pick one yourself and never substitute when one is unavailable; say so
  and wait. Record the assignment in the status note and pass it on every launch.
- **Status cadence**: how often to send the user a status update, in minutes. It is
  also the heartbeat that keeps the orchestrator thread alive, so it must come from
  the user.
- **Branch rules**: the integration branch, which branches are forbidden (default
  branch, anything that deploys), and what the single final PR targets.
- **Authority**: whether you may merge into the integration branch, whether workers
  may commit and push, and what still needs the owner (migrations, deploys, contract
  changes).
- **Host limits**: how many workers may run at once, build and test parallelism, and
  other work on the machine to stay clear of.

Authority does not extend: each new target (a deploy, a merge somewhere new) needs
its own instruction.

## Set up

1. Read the repository guidance and the area the goal touches.
2. Write an inventory: independent slices, each sized for one PR, with dependencies
   and the files each will touch. Slices that touch the same files run in sequence.
3. Create the integration branch from the current default branch and push it.
4. Write a shared ground-rules file under `~/.cache/` (not a worktree or a temp
   directory, which get wiped). Every brief points at it. It holds the branch rules,
   test isolation, commit rules, project limits and the hand-back line.
5. Write helper scripts to the same place: one that verifies a PR head (build plus
   focused tests in an isolated environment) and one that exits when open PR heads
   change or a cap in seconds passes. Run them with `bash <script>`.
6. Save a status note to memory: inventory, thread ids, PR states, model assignment,
   cadence, lessons. Update it at every merge so a new orchestrator can resume from it.

## Launch threads

Use `t3_thread_launch`, one thread per slice:

- **Title**: `[<role letter>-<work label>] <what this thread does>`. Role letters:

  | Letter | Role | Example |
  | --- | --- | --- |
  | `w` | worker that implements a slice and opens a PR | `[w-ledgeo-sentry] SMS provider failure reporting` |
  | `a` | auditor that reads the code and reports gaps, read-only | `[a-ledgeo-sentry] Audit 2 from code` |
  | `r` | reviewer of one PR, when the review runs as its own thread | `[r-ledgeo-sentry] Review PR 1296` |
  | `h` | helper for anything else (end-to-end harness, benchmarks, investigation) | `[h-ledgeo-sentry] Fake Sentry end-to-end check` |

  Use one letter per thread and keep it for the life of the thread, even if the
  thread later does other work.
- **Workspace**: `workspaceStrategy` of type `worktree`, `baseRef` the integration
  branch on the remote, `startFromOrigin: true`.
- **Model**: `modelSelection` from the user's assignment for that role.
- **Runtime mode**: no broader than your own.

Run independent slices in parallel up to the host limit. A brief contains:

- the goal of the slice, why it exists, and what is already ruled out;
- where to start reading (paths, not pasted code);
- what must be decided and reported, not only done;
- stop conditions: what the thread must ask about first (migrations, API changes,
  anything outside the slice);
- required checks, and the instruction to report what was not verified;
- the exact final line: `PR <url>, head <sha>, checks <state>`.

Tell workers to reproduce a bug with a failing test before fixing it. Link every
worker PR you merge and the final PR with `link_pull_request`.

## The merge gate

For each PR, in this order, each as its own step:

1. Read the PR body and the non-test diff yourself.
2. For anything beyond a small change, get an independent review from a fresh
   reviewer on the assigned review model, given the code and pointed questions, not
   your conclusion. Ask it to separate must-fix, should-fix and notes, and to say
   what it could not verify.
3. Send must-fix and cheap should-fix items to the same worker with
   `t3_thread_send`. Repeat until clean.
4. Verify the exact head yourself: build, focused tests in an isolated environment,
   and that the PR contains the current integration head.
5. Read the results. Only then merge, pinned to the verified commit
   (`gh pr merge N --merge --match-head-commit <sha>`). Never chain the merge after
   a test command.
6. Tell every thread with an open PR to merge the new integration head (merge, not
   rebase) and re-verify.

Read the worker thread (`t3_thread_read`, activity view) when a worker reports that
the owner approved something. If you did not see the owner approve it, say so in
your report instead of repeating the claim.

## Staying alive and reporting on cadence

An orchestrator that ends its turn with nothing to wake it stops for good.

- Never end a turn while work is outstanding. Wait with `t3_thread_wait`, or start
  the watcher script in the background and mark it with `t3_background_wait`.
- Cap every wait at the status cadence. When it returns, with or without a change,
  send the status update, then wait again.
- A status update says: merged, in review, blocked, next, and host load. Send it
  with `tgn`. Send one immediately whenever a decision is needed.
- Do not poll in a tight loop and do not sleep in the foreground.
- Check load and memory at each wake. Lower parallelism before the machine is
  saturated, and keep clear of other work the user named.
- Remove every container, process and temp resource you start, even on failure.
- Keep a list of things found but out of scope. Report them; do not fix them.

## Finishing

1. Launch a fresh audit thread (`a-` prefix) told to audit from the code, not from
   your inventory or docs. Fix what it finds and audit again until no must-fix item
   remains.
2. Run the full suite and the end-to-end check on the final head. Compare any
   failure against the default branch before calling it pre-existing.
3. If the default branch moved, merge it into the integration branch through a
   reviewed PR and rerun the checks.
4. Open the single final PR. Do not merge it. Its body lists what changed, behaviour
   changes a reviewer should look at, how it was verified, and known gaps.
5. Settle the finished threads, update the status note, and notify the user.

## Final report

Lead with the outcome. State plainly: what was verified and on which commit, what
was not verified, any criterion met differently from how it was written, any slip in
your own process, and the decisions left for the owner. Leave worktrees and branches
in place and say so.
