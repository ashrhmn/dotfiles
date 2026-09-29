---
name: commit-push-pr
description: Name a branch after the work at hand, commit it, push it, and open a GitHub pull request against the default branch, with pre-flight checks along the way. Use only when the user explicitly asks to commit, push, and open a PR, or invokes commit-push-pr.
---

# Commit, Push, and Open a PR

Invoking this skill is the user's explicit authorization to create or rename a branch, commit, push that branch, and open one pull request. It authorizes nothing beyond that: no merge, no auto-merge, no force push, no push to the default branch, no `--no-verify`.

Stop and tell the user at the first failed check instead of working around it.

## Inspect

Read only, before changing anything:

- `git rev-parse --show-toplevel`, `git branch --show-current`, `git status --short`, `git diff`, `git diff --cached`, `git log -n 15 --oneline`
- The remote: prefer `origin`
- The default branch, discovered and never assumed: `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`, falling back to `git symbolic-ref --short refs/remotes/origin/HEAD` without the `origin/` prefix
- `git fetch origin <default>` so comparisons use current remote state

## Pre-flight checks

1. Inside a work tree, not on a detached HEAD, and no merge, rebase, cherry-pick, or revert in progress.
2. A remote exists and `gh auth status` succeeds for its host.
3. There is something to ship: uncommitted changes, or commits not yet in `origin/<default>`. Otherwise stop; there is nothing to do.
4. No unmerged paths, and `git diff --check` reports no conflict markers.
5. Nothing that must not be committed: `.env*`, private keys, credentials, tokens, `*.pem`, dependency directories, build output, logs, or files over about 5 MB. Scan the diff for obvious secrets. Respect `.gitignore` and never use `git add -f`. If any turn up, exclude them or stop and ask.
6. Only this work is committed. Changes clearly unrelated to the work done in this session stay uncommitted and are reported. If it is unclear what belongs, ask.
7. The project's own fast checks pass. Take them from `AGENTS.md`, `CLAUDE.md`, `package.json` scripts, the `Makefile`, or a pre-commit config: lint, typecheck, unit tests. Run each under an explicit `timeout` and do not install dependencies. When a check fails because of the diff, stop and report. When a failure is clearly unrelated to the diff, report it and ask whether to continue. When no checks can be discovered, say so and go on.
8. No open PR already exists for the branch: `gh pr list --head <branch> --state open --json number,url`. If one does, keep the branch, commit, push, and report its URL without creating another.

## Branch

Pick a type from the work itself, not from the current branch name:

| Prefix | Use for |
|---|---|
| `feat/` | new capability or behavior |
| `bugfix/` | fixing a defect |
| `refactor/` | restructuring without behavior change |
| `perf/` | performance improvement |
| `docs/` | documentation only |
| `test/` | tests only |
| `ci/` | pipelines and automation config |
| `chore/` | tooling, config, dependencies, dotfiles, everything else |

The slug is 2 to 5 lowercase kebab-case words naming the outcome, not the files: `feat/user-avatar-upload`, `bugfix/login-redirect-loop`. Use only `[a-z0-9-]`, at most 50 characters in the slug, with no trailing hyphen. When the user named an issue number, put it right after the prefix: `bugfix/123-login-redirect-loop`.

Never use `feature/` or `automation/`; gh-agent owns those prefixes.

Then act on where the work sits:

- **On the default branch**: `git switch -c <name>`. Uncommitted changes and unpushed local commits come along. Do not reset or move the local default branch; report that it still holds those commits.
- **On a personal branch already named `<type>/<slug>` that fits the work**: keep it.
- **On a personal branch with a generic or mismatched name** (`wip`, `tmp`, `patch-1`, or a different subject) **that is not pushed** (no upstream, no remote branch of that name, no PR): rename it with `git branch -m <name>`.
- **On a branch that is already pushed or has a PR**: keep the name. Renaming would orphan the remote branch or PR. Say so in the report.
- **On any other long-lived branch** (`develop`, `staging`, `release/*`, `production`): stop and ask.
- **Name collision** locally or on the remote (`git ls-remote --heads origin <name>`): choose a more specific slug. Never overwrite.

## Commit

Stage explicit paths with `git add -- <paths>`. Use `git add -A` only after reviewing that every changed file belongs. Read `git diff --cached --stat` and the staged diff before committing.

Make one commit per coherent logical change, and do not split artificially. Match the message convention visible in `git log`; when none is evident, use Conventional Commits, `type(scope): subject`, where the type follows the branch prefix (`bugfix/` becomes `fix`). Write the subject in the imperative, at most 72 characters, no trailing period. Add a body only when the reason is not obvious from the diff.

Add no `Co-authored-by` trailer, no "Generated with" footer, and no tool attribution. Never pass `--no-verify` or `--no-gpg-sign`. If a hook rejects the commit, fix the cause and commit again; do not amend anything already pushed.

## Push

`git push -u origin <branch>`. Never force, with `--force` or `--force-with-lease`. If the push is rejected, stop and report; do not rebase or reset to get past it.

## Pull request

Create it against the default branch:

```bash
gh pr create --base <default> --head <branch> --title "<title>" --body-file <file>
```

- **Title**: same style as the commit subject; when the branch holds several commits, describe the whole change.
- **Body**: write it to a temporary file outside the repository and delete it afterwards. If the repository has a pull request template (`.github/pull_request_template.md` or `.github/PULL_REQUEST_TEMPLATE/`), follow its structure. Otherwise use:

  ```markdown
  ## Summary

  <Why this change exists and what it does, in one to three bullets.>

  ## Changes

  <The notable behaviors or files, not a diff dump.>

  ## Testing

  <The checks actually run and their results, or "not run" with the reason.>
  ```

  Add `Closes #<number>` only when the user named that issue. State nothing that was not verified. No tool-attribution footer.
- Open it ready for review. Use `--draft` only when the user asked.
- Add no reviewers, assignees, labels, or milestone unless the user asked.

Verify the result with `gh pr view <url> --json number,url,baseRefName,headRefName,state` and confirm the base is the default branch.

## Report and notify

Report the branch (created, renamed, or kept, and why), each commit hash with its subject, the checks run and their results, the PR URL, and anything left uncommitted or skipped.

Send the configured `tgn` completion notification with the PR URL. When stopping early, send it with what is blocking instead.
