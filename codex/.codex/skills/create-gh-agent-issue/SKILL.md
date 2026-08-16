---
name: create-gh-agent-issue
description: Create focused GitHub issues for repositories managed by gh-agent, including the mandatory workstream label and dependency order. Use when creating one or more implementation issues that gh-agent should process through feature and automation branches.
---

# Create gh-agent Issues

Create issues in execution order. Keep each issue independently testable and small enough for one agent run.

## Workflow

1. Identify the repository and a lowercase kebab-case workstream name such as `task-management`.
2. Use exactly one `base:<name>` label on every agent-managed issue. Never create an agent issue without it.
3. Ensure the label exists before creating issues. The label maps automatically:
   - `base:<name>` → PR target `feature/<name>`
   - `base:<name>` → cumulative base `automation/<name>`
4. Write a concise title and a body containing scope, acceptance criteria, and verification commands when known.
5. For dependent issues, create prerequisites first and add `Depends on #<number>` to later issue bodies. gh-agent selects eligible issues oldest-first.
6. Create the issue with `gh issue create --repo <owner/repo> --title <title> --body-file <file> --label base:<name>`.
7. Verify the created issue has exactly one `base:*` label.

Do not place unrelated workstreams under the same base label. Do not target `main` or create feature/automation branches manually; gh-agent owns that workflow.
