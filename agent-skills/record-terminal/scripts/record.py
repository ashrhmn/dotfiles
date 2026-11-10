#!/usr/bin/env python3
"""Run an authored VHS tape with bounded, isolated recording processes."""

import argparse
import os
from pathlib import Path
import shlex
import shutil
import signal
import subprocess
import tempfile


def clean_environment():
    environment = os.environ.copy()
    for name in ("BASH_ENV", "ENV", "PROMPT_COMMAND", "TMUX", "TMUX_PANE"):
        environment.pop(name, None)
    environment["PS1"] = "$ "
    return environment


def tmux(socket, *args, check=True):
    return subprocess.run(
        ["tmux", "-S", str(socket), *args],
        check=check, capture_output=True, text=True, timeout=10,
        env=clean_environment(),
    )


def stop_recording(process):
    # VHS, ttyd and Chromium inherit this private process group.
    try:
        os.killpg(process.pid, signal.SIGTERM)
    except ProcessLookupError:
        pass
    try:
        process.wait(timeout=5)
    except subprocess.TimeoutExpired:
        pass
    try:
        os.killpg(process.pid, signal.SIGKILL)
    except ProcessLookupError:
        pass
    process.wait(timeout=5)


def interrupted(signum, _frame):
    raise SystemExit(128 + signum)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("tape", type=Path)
    parser.add_argument("--cwd", type=Path, default=Path.cwd())
    parser.add_argument("--output-dir", type=Path, required=True)
    parser.add_argument("--timeout", type=int, default=120)
    parser.add_argument("--split", action="store_true")
    parser.add_argument("--gif", action="store_true")
    args = parser.parse_args()
    if args.timeout < 1:
        parser.error("--timeout must be positive")
    signal.signal(signal.SIGTERM, interrupted)
    signal.signal(signal.SIGHUP, interrupted)
    tape = args.tape.resolve(strict=True)
    cwd = args.cwd.resolve(strict=True)
    if not cwd.is_dir():
        parser.error("--cwd must be a directory")
    required = ["vhs", "ttyd", "ffmpeg"]
    if args.split:
        required.extend(["tmux", "bash", "timeout"])
    missing = [name for name in required if not shutil.which(name)]
    if missing:
        parser.error("missing tools: " + ", ".join(missing))
    output = args.output_dir.resolve()
    output.mkdir(parents=True, exist_ok=True)
    saved_tape = output / "sample.tape"
    if tape != saved_tape:
        shutil.copyfile(tape, saved_tape)
    command = ["vhs", str(tape), "--output", str(output / "sample.mp4")]
    if args.gif:
        command.extend(["--output", str(output / "sample.gif")])
    environment = clean_environment()
    with tempfile.TemporaryDirectory(prefix="terminal-recording-") as scratch:
        socket = Path(scratch) / "tmux.sock"
        process = None
        try:
            if args.split:
                shell = shlex.join([
                    "env", "PS1=$ ", "timeout", f"{args.timeout + 15}s",
                    "bash", "--noprofile", "--norc",
                ])
                tmux(socket, "-f", "/dev/null", "new-session", "-d",
                     "-s", "recording", "-c", str(cwd), shell)
                tmux(socket, "set-option", "-g", "status", "off")
                tmux(socket, "set-option", "-g", "pane-border-status", "top")
                tmux(socket, "set-option", "-g", "pane-border-format", " #{pane_title} ")
                tmux(socket, "select-pane", "-t", "recording:0.0", "-T", "Server")
                tmux(socket, "split-window", "-h", "-t", "recording:0", "-c", str(cwd), shell)
                tmux(socket, "select-pane", "-t", "recording:0.1", "-T", "Client")
                tmux(socket, "select-pane", "-t", "recording:0.0")
                environment["RECORDING_TMUX_SOCKET"] = str(socket)
            process = subprocess.Popen(command, cwd=cwd, env=environment, start_new_session=True)
            try:
                result = process.wait(timeout=args.timeout)
            except subprocess.TimeoutExpired:
                parser.exit(124, f"Recording exceeded {args.timeout}s.\n")
            if result:
                parser.exit(result, "VHS failed; inspect its output above.\n")
        finally:
            if process is not None:
                stop_recording(process)
            if args.split and socket.exists():
                tmux(socket, "kill-server", check=False)
    print(f"Recording: {output / 'sample.mp4'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
