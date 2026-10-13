---
name: commit-push
description: Commit the current work and push the current branch directly, without checks or hooks. Use only when the user explicitly asks to commit and push, or invokes commit-push.
---

# Commit and Push

Invoking this skill authorizes committing the current work and pushing the current branch. Stay on that branch; do not create, switch, or rename branches, open a pull request, merge, or force push.

Go straight to staging, committing, and pushing. Do not run tests, lint, typechecks, builds, validation, scans, pre-flight checks, fetches, or routine inspection before or after these actions. Do not discover or run project checks, fix unrelated issues, or wait for CI.

Use the conversation to choose the files and commit message. Only read changed-file names, a diff, or branch/upstream metadata if needed to carry out the requested actions; do not turn that into a review or audit.

1. Stage the current work with `git add -- <paths>`. Use `git add -A` only when the user wants all changes committed. Leave unrelated changes out and never force-add ignored files.
2. Make one commit with a concise imperative message using `git -c core.hooksPath=/dev/null commit -m "<message>"`. Add no co-author trailer or tool attribution. If there is nothing to commit, continue to the push.
3. Push with `git -c core.hooksPath=/dev/null push`, or `git -c core.hooksPath=/dev/null push -u origin <branch>` when no upstream is configured. Do not push tags or force push.

Disable hooks only for these commands; do not change persistent Git configuration. If an action fails, stop and report the error instead of repairing, pulling, rebasing, resetting, or retrying around it.

Report the branch and commit from the command output, then send a `tgn` completion notification. If blocked, report the failure and notify with `tgn`.
