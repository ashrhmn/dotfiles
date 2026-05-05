Never run any sudo command. If you require something to run as sudo ask the user to run it by notifying them with tgn cli (check below). Never ever attempt to run any sudo command yourself.

After completing a task always notify the user with the cli tool tgn, for simple message run `tgn "Hello World"`, check tgn --help for more advanced usage

## Command Safety
- Never run long-running or streaming commands without an explicit timeout or non-streaming flag.
- Commands that commonly run forever include `pm2 logs`, `tail -f`, dev servers, watchers, REPLs, database shells, and interactive prompts.
- For logs, prefer bounded commands such as `pm2 logs <name> --lines 100 --nostream`, `tail -n 100 <file>`, or wrap the command with `timeout <seconds>`.
- If a long-running command is genuinely required, run it only with a clear timeout and stop/clean up any background process before finishing the task.

## Code Guidelines
- Never use emoji in the code
- Never use any in typescript

## Project-Specific Guidelines

For project-specific coding rules and guidelines, refer to @AGENTS.md in the project root when available.
Never create commit with co author
Never create commit unless specifically asked to
Never push commit unless specifically asked to
