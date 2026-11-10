---
name: record-terminal
description: Create short terminal demo recordings as MP4 or GIF with VHS, including concurrent server and client commands in isolated tmux panes. Use for requested CLI recordings or terminal evidence accompanying a change or PR; browser-only recordings use the available browser recording tools.
---

# Record terminal demos

Record real command execution with VHS. Use tmux when several processes must stay
visible together. Keep clips focused on observable behavior and readable at normal
playback speed; a short clip per distinct flow usually works better than recording
an entire build or test suite.

## Prepare

- Check `vhs`, `ttyd`, `chromium`, `ffmpeg`, and (for split panes) `tmux` on PATH.
  VHS uses ttyd and Chromium to render the terminal, then FFmpeg to encode it.
- If tools are missing, report them. On Arch, the owner can install them with
  `sudo pacman -Syu --needed vhs ttyd chromium tmux ffmpeg`. This also upgrades the
  system. Never execute sudo yourself; notify the owner with `tgn` when input is
  needed. Stale package databases can request package versions mirrors no longer
  carry; do not recommend a database-only refresh followed by a partial upgrade.
- Choose a disposable working directory, or an authorized project fixture. A tape
  executes its commands: do not replay destructive or externally visible actions
  just to improve presentation. Use loopback addresses for local demo services.
- Keep passwords, tokens, private keys, private payloads and sensitive shell startup
  output out of tapes and frames. Use synthetic demo data. Hidden setup commands
  still execute; `Hide` is presentation, not a security boundary.
- Store recordings outside the repository unless the user requests tracked assets.
  Do not commit, push or upload media merely because a recording was requested.

## Single terminal

Copy [assets/single.tape](assets/single.tape) into a temporary directory and replace
its commands with the actual flow. The helper sets the working directory, overrides
output destinations, bounds execution and cleans up its recording processes:

```sh
python /path/to/record-terminal/scripts/record.py /tmp/demo.tape \
  --cwd /path/to/demo --output-dir /tmp/terminal-demo --timeout 90
```

Resolve `/path/to/record-terminal` to this skill's directory. MP4 is the default;
add `--gif` when an animated GIF is useful. Review the tape before execution.

Use a clean shell and a short prompt, visible commands, readable fonts, and brief
pauses after results. Use VHS `Wait` when a meaningful output signal is available;
do not depend on a fixed delay for a slow build or service startup. Give commands
that can wait indefinitely their own timeout. Do not fabricate output with `echo`
or `printf` and present it as evidence that an implementation works.

## Concurrent panes

Copy [assets/split.tape](assets/split.tape) and adapt it. Run the helper with
`--split`. It creates a private tmux socket, ignores the user's tmux configuration,
opens two clean shells in the selected working directory, and supplies
`RECORDING_TMUX_SOCKET` for the tape's attach command. The tape starts the server
in the left pane, then uses `Ctrl+b` followed by `Right` to focus the client pane.

The included example requires Python and curl. In a fresh temporary working
directory, create a small `index.html` containing synthetic text. Choose an unused
loopback port and replace both occurrences of `18765` in the tape if needed. Then:

```sh
python /path/to/record-terminal/scripts/record.py /tmp/split.tape \
  --cwd /tmp/demo-site --output-dir /tmp/split-demo --split --gif --timeout 90
```

Use an explicit server timeout and a readiness signal before sending client
requests. The helper stops only the tmux server on its private socket in `finally`,
including when VHS fails or times out. Never attach to or kill the owner's tmux
server. Services launched outside this helper need their own tracked cleanup.

## Verify and deliver

Inspect MP4 metadata with bounded `ffprobe` and extract a late frame with bounded
`ffmpeg`; view that frame to confirm readable commands and the expected results.
Check that demo listeners and child processes are gone. A valid video container
alone does not prove the demo succeeded. Confirm correctness separately with the
tests appropriate to the implementation.

Return the recording itself, not just a screenshot. Where supported, embed the MP4
using `![Terminal demo](/absolute/path/sample.mp4)` and include clickable absolute
MP4/GIF links. Otherwise provide supported attachments or file links. Keep the tape
available alongside the clip for reproducibility. For a PR, use an authorized
artifact destination and links reviewers can access; local paths will not work for
other GitHub users. Follow the host's PR-linking workflow when available.

Send the configured `tgn` completion notification. Say what the clip demonstrates
and disclose material limitations (for example, a local fixture or edited timing).
