# curlink skill

When the user provides a curlink shortcode or a curlink URL instead of directly pasting an image/file/screenshot, resolve and fetch the file first, then treat it as if the user had provided it directly.

## When to activate

Activate this skill when the user:
- Provides a 6-character alphanumeric string that looks like a shortcode (e.g. `abc123`, `K9pLmX`)
- Provides a URL matching `https://curlink.ashrhmn.com/<shortcode>`
- Says something like "here's the curlink", "shortcode is ...", "curlink: abc123", or otherwise indicates a curlink reference in place of a file/image

## How curlink works

- **Server**: `https://curlink.ashrhmn.com`
- **Shortcode format**: 6 characters, alphanumeric (a-z, A-Z, 0-9)
- **File URL pattern**: `https://curlink.ashrhmn.com/<shortcode>`
- **CLI tool**: `curlink <shortcode>` — downloads file to current directory; `curlink <shortcode> --tmp` saves to `/tmp/curlink/`

## Resolution steps

### Option A: Use the CLI (preferred for shortcodes)

```bash
curlink <shortcode> --tmp
```

This downloads the file to `/tmp/curlink/<shortcode>.<ext>` and prints the absolute path. Then read/inspect the file at that path.

### Option B: Use curl (for URLs or if CLI unavailable)

```bash
curl -L -o /tmp/curlink_<shortcode> https://curlink.ashrhmn.com/<shortcode>
```

Then inspect `/tmp/curlink_<shortcode>`.

## After fetching

- If the file is an **image or screenshot**: use the Read tool to view it visually (Claude Code is multimodal and can read image files)
- If the file is a **text/code file**: read it with the Read tool
- If the file is a **PDF**: read it with the Read tool (supports PDF)
- Proceed as if the user had pasted or attached the file directly

## Notes

- Files expire after 7 days on the server
- Supported types include: jpg, png, gif, webp, mp4, webm, mp3, ogg, wav, pdf, zip, txt
- The `/tmp/curlink/` directory is created automatically by the CLI
