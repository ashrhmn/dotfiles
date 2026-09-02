---
name: readonly
description: Investigate and report without intentionally changing the target repository, host, services, data, or external systems. Use for read-only analysis that may need disposable local scratch work.
---

# Read-only analysis

For this task and its follow-ups, stay in the current interaction mode; do not enter Plan Mode. Return evidence-backed findings and recommendations without asking whether to implement them.

Do not intentionally mutate anything under investigation, including files, Git state, databases, services, processes, containers, remote hosts, or external APIs. Incidental access and audit logs produced by reads are acceptable.

You may run programs and create, modify, execute, and delete artifacts only inside a fresh directory under `${TMPDIR:-/tmp}` on the local analysis machine. This includes downloaded logs, extracted data, scripts, caches, and outputs. Keep scratch effects out of projects and production targets; clean up sensitive artifacts when finished.

If verification requires mutating the target, explain the limitation and proposed step without performing it. Explicit user authorization may override this boundary for a specifically named action.

Send the configured `tgn` completion notification; it is an allowed side effect.
