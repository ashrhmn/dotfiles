---
name: commit-push
description: Commit the work done on the current branch and push it, with pre-flight checks, without changing branches or opening a pull request. Use only when the user explicitly asks to commit and push, or invokes commit-push.
---

# Commit and Push

Invoking this skill is the user's explicit authorization to commit the current work and push the current branch. It authorizes nothing beyond that: no branch creation, switch, or rename, no pull request, no merge, no force push, no `--no-verify`.

Stop and tell the user at the first failed check instead of working around it.

## Inspect

Read only, before changing anything:

- `git rev-parse --show-toplevel`, `git branch --show-current`, `git status --short`, `git diff`, `git diff --cached`, `git log -n 15 --oneline`
- The remote: the branch's upstream when it has one, otherwise `origin`
- `git fetch` for that remote so comparisons use current remote state

## Pre-flight checks

1. Inside a work tree, not on a detached HEAD, and no merge, rebase, cherry-pick, or revert in progress.
2. A remote exists to push to.
3. There is something to ship: uncommitted changes, or local commits not yet on the remote. When there is nothing to commit but unpushed commits exist, skip to the push. When there is neither, stop.
4. No unmerged paths, and `git diff --check` reports no conflict markers.
5. Nothing that must not be committed: `.env*`, private keys, credentials, tokens, `*.pem`, dependency directories, build output, logs, or files over about 5 MB. Scan the diff for obvious secrets. Respect `.gitignore` and never use `git add -f`. If any turn up, exclude them or stop and ask.
6. Only this work is committed. Changes clearly unrelated to the work done in this session stay uncommitted and are reported. If it is unclear what belongs, ask.
7. The project's own fast checks pass. Take them from `AGENTS.md`, `CLAUDE.md`, `package.json` scripts, the `Makefile`, or a pre-commit config: lint, typecheck, unit tests. Run each under an explicit `timeout` and do not install dependencies. When a check fails because of the diff, stop and report. When a failure is clearly unrelated to the diff, report it and ask whether to continue. When no checks can be discovered, say so and go on.

## Commit

Stay on the current branch, whatever it is, including the default branch. Do not create, switch, or rename branches.

Stage explicit paths with `git add -- <paths>`. Use `git add -A` only after reviewing that every changed file belongs. Read `git diff --cached --stat` and the staged diff before committing.

Make one commit per coherent logical change, and do not split artificially. Match the message convention visible in `git log`; when none is evident, use Conventional Commits, `type(scope): subject`. Write the subject in the imperative, at most 72 characters, no trailing period. Add a body only when the reason is not obvious from the diff.

Add no `Co-authored-by` trailer, no "Generated with" footer, and no tool attribution. Never pass `--no-verify` or `--no-gpg-sign`. If a hook rejects the commit, fix the cause and commit again; do not amend anything already pushed.

## Push

List what will go out with `git log --oneline @{u}..HEAD`, or against the remote's branch of the same name when no upstream is set. Every unpushed commit goes out, not only the new one; tell the user if any predate this work.

Push the current branch: `git push` when it has an upstream, otherwise `git push -u origin <branch>`. Do not push tags. Never force, with `--force` or `--force-with-lease`. If the push is rejected, including by branch protection, stop and report; do not pull, rebase, or reset to get past it.

## Report and notify

Report the branch, each commit hash with its subject, any earlier unpushed commits that went out with them, the checks run and their results, and anything left uncommitted or skipped. Confirm the push landed with `git status -sb` showing the branch level with its upstream.

Send the configured `tgn` completion notification. When stopping early, send it with what is blocking instead.
