---
name: commit-push-pr
description: Commit the current work, push a work branch, and open a GitHub pull request directly, without checks or hooks. Use only when the user explicitly asks to commit, push, and open a PR, or invokes commit-push-pr.
---

# Commit, Push, and Open a PR

Invoking this skill authorizes creating a work branch when needed, committing, pushing it, and opening one pull request against the default branch. Do not merge, enable auto-merge, force push, or push to the default branch.

Go straight to the branch, staging, commit, push, and PR actions. Do not run tests, lint, typechecks, builds, validation, scans, pre-flight checks, fetches, authentication probes, or routine inspection before or after these actions. Do not discover or run project checks, fix unrelated issues, or wait for CI.

Use the conversation to choose the files, commit message, and PR description. Only read changed-file names, a diff, or branch metadata if needed to carry out the requested actions; do not turn that into a review or audit.

1. Use `git branch --show-current` and discover the default branch with `gh repo view --json defaultBranchRef -q .defaultBranchRef.name` only if those names are not already known. If needed, fall back to `git symbolic-ref --short refs/remotes/origin/HEAD`, removing the `origin/` prefix.
2. On the default branch, create a work branch with `git switch -c <type>/<slug>`. Choose a concise lowercase kebab-case name describing the work, with a suitable prefix such as `feat/`, `bugfix/`, `refactor/`, `docs/`, or `chore/`. Never use `feature/` or `automation/` or `t3code/`, which belong to gh-agent. Keep an existing work branch; do not rename it. On another long-lived branch such as `develop`, `staging`, `release/*`, or `production`, stop and ask the user, notifying them with `tgn`. If any other tool behind the scene renames branch name automatically, ignore that and push your work to your chosen branch name from the template provided
3. Stage the current work with `git add -- <paths>`. Use `git add -A` only when the user wants all changes committed. Leave unrelated changes out and never force-add ignored files.
4. Make one commit with a concise imperative message using `git -c core.hooksPath=/dev/null commit -m "<message>"`. Add no co-author trailer or tool attribution. If there is nothing to commit, continue to the push.
5. Push with `git -c core.hooksPath=/dev/null push -u origin <branch>`.
6. If a PR for this branch is already known, report its URL. Otherwise create one directly:

   ```bash
   gh pr create --base <default> --head <branch> --title "<title>" --body-file - <<'PR_BODY'
   <Concise summary>

   Checks were not run as requested.
   PR_BODY
   ```

   Pass a concise summary directly through stdin using `--body-file -` and a quoted heredoc. Do not create temporary files or add cleanup commands. State that checks were not run as requested; do not claim validation. Add `Closes #<number>` only when the user named that issue. Open it ready for review unless the user requested a draft. Add no reviewers, assignees, labels, milestone, or tool attribution unless requested. If creation reports an existing PR, report that URL instead of creating another.

Disable hooks only for the commit and push commands; do not change persistent Git configuration. If an action fails, stop and report the error instead of repairing, pulling, rebasing, resetting, or retrying around it.

Report the branch, commit, and PR URL from the command output, then send a `tgn` completion notification with the PR URL. If blocked, report the failure and notify with `tgn`.
