---
name: commit-push-pr
description: Commit the current work, push a work branch, and open a GitHub pull request directly, without checks or hooks. Use only when the user explicitly asks to commit, push, and open a PR, or invokes commit-push-pr.
---

# Commit, Push, and Open a PR

Invoking this skill authorizes creating a work branch when needed, committing, pushing it, and opening one pull request against the default branch. Do not merge, enable auto-merge, force push, or push to the default branch.

Go straight to the branch, staging, commit, push, and PR actions. Do not run tests, lint, typechecks, builds, validation, scans, pre-flight checks, fetches, authentication probes, or routine inspection before or after these actions. Do not discover or run project checks, fix unrelated issues, or wait for CI.

Use the conversation to choose the files, commit message, and PR description. Only read changed-file names, a diff, or branch metadata if needed to carry out the requested actions; do not turn that into a review or audit.

1. Use `git branch --show-current` and discover the default branch with `gh repo view --json defaultBranchRef -q .defaultBranchRef.name` only if those names are not already known. If needed, fall back to `git symbolic-ref --short refs/remotes/origin/HEAD`, removing the `origin/` prefix.
2. Choose the PR branch name using these rules, in order:

   - On a long-lived branch other than the repository's default, such as `develop`, `staging`, `release/*`, or `production`, stop and ask the user, notifying them with `tgn`.
   - Keep an existing non-default work branch only if its name follows `<type>/<slug>`, where `<type>` is one of `feat`, `bugfix`, `refactor`, `docs`, or `chore`, and `<slug>` describes the work in concise lowercase kebab-case.
   - On the default branch or any other branch, including `feature/*`, `automation/*`, and `t3code/*`, choose an allowed name and create it with `git switch -c <chosen-branch>`. Preserve the original branch; do not rename it.
   - Record the chosen name as `pr_branch` and retain that exact value for the remaining commands, including across separate shell invocations. The allowed-prefix rule takes precedence over preserving the current branch name. An existing or automatically assigned name is never an exception. Never push or open a PR using the reserved `feature/`, `automation/`, or `t3code/` prefixes, which belong to gh-agent.
   - If another tool later renames the local branch, continue using the recorded `pr_branch` as the remote destination and PR head. Do not replace it with a later `git branch --show-current` result.

3. Stage the current work with `git add -- <paths>`. Use `git add -A` only when the user wants all changes committed. Leave unrelated changes out and never force-add ignored files. Keep screenshots and recordings intended for the PR description out of the commit; upload them as attachments instead.
4. Make one commit with a concise imperative message using `git -c core.hooksPath=/dev/null commit -m "<message>"`. Add no co-author trailer or tool attribution. If there is nothing to commit, continue to the push.
5. Push the current commit to the recorded PR branch with `git -c core.hooksPath=/dev/null push -u origin "HEAD:refs/heads/$pr_branch"`.
6. If a PR for the recorded `pr_branch` is already known, attach any intended media as described below and report its URL. Otherwise create one directly:

   ```bash
   gh pr create --base <default> --head "$pr_branch" --title "<title>" --body-file - <<'PR_BODY'
   <Concise summary>

   Checks were not run as requested.
   PR_BODY
   ```

   Pass a concise summary directly through stdin using `--body-file -` and a quoted heredoc. Do not create temporary files or add cleanup commands. State that checks were not run as requested; do not claim validation. Add `Closes #<number>` only when the user named that issue. Open it ready for review unless the user requested a draft. Add no reviewers, assignees, labels, milestone, or tool attribution unless requested. If creation reports an existing PR, report that URL instead of creating another.

## Screenshots and recordings

When the user requests media in the PR description, or the conversation already supplies screenshots or recordings intended as PR evidence, upload those existing files with GitHub CLI's native `--attach` flag (available since `gh` 2.99.0). Use the existing CLI authentication; browser cookies, extensions, and a separate upload API call are unnecessary. Do not generate new evidence or run capture or validation workflows as part of this skill.

- For a new PR, add one `--attach '<path>'` per file to the `gh pr create` command, before the heredoc redirection. Keep the summary and checks statement in the body.
- For an existing PR, append media while preserving its description:

  ```bash
  gh pr edit <PR-URL> --attach './screenshot.png#Updated UI' --attach ./recording.mp4
  ```

- Images render inline and videos render as players using GitHub-hosted `user-attachments/assets/...` URLs. Image alt text follows the path after `#`; omit alt text for videos. Files without a body reference are appended. A local image reference such as `![Updated UI](./screenshot.png)` is rewritten to the uploaded URL when that file is attached.
- Do not commit PR evidence media, create releases, or upload it to external hosting as a fallback. If the installed CLI rejects `--attach` or an upload fails, stop and report the error. A command may publish the PR or update its body with some attachments even when it exits unsuccessfully; report any returned PR URL and partial success, and do not retry automatically.

Disable hooks only for the commit and push commands; do not change persistent Git configuration. If an action fails, stop and report the error instead of repairing, pulling, rebasing, resetting, or retrying around it.

Report the recorded PR branch, commit, and PR URL from the command output, then send a `tgn` completion notification with the PR URL. If blocked, report the failure and notify with `tgn`.
