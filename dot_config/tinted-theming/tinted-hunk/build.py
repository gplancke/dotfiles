#!/usr/bin/env python3
"""Generate hunk custom-theme configs from tinted-theming base16/base24 schemes.

hunk (https://github.com/modem-dev/hunk) reads a `[custom_theme]` table in
config.toml. Its diff-row backgrounds (addedBg/removedBg/...) are whole-row
fills, so we can't feed raw base16 red/green in — that would paint solid bars.
Mustache templates can't blend colors, so we pre-blend here in Python instead.

One output file per scheme, named `<system>-<slug>.toml` (e.g.
`base16-eighties.toml`) so `tinty` can pick the one matching the current scheme.

Run:  python3 build.py            # uses tinty's local schemes clone
      python3 build.py <schemes-dir>
"""
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
DEFAULT_SCHEMES = Path.home() / ".local/share/tinted-theming/tinty/repos/schemes"

# --- tiny parser for the flat scheme YAMLs (avoids a PyYAML dependency) -------
# Values may carry a trailing `# comment`, so capture the token and ignore rest.
_PAL = re.compile(r'^\s*(base[0-9A-Fa-f]{2}):\s*"?(#[0-9a-fA-F]{6})"?')
_META = re.compile(r'^\s*(system|name|variant):\s*"?([^"#\n]+?)"?\s*(?:#.*)?$')
_HEX = re.compile(r'^#[0-9a-fA-F]{6}$')


def parse_scheme(path: Path) -> dict:
    meta = {}
    palette = {}
    in_palette = False
    for line in path.read_text().splitlines():
        if line.strip().startswith("palette:"):
            in_palette = True
            continue
        if in_palette:
            m = _PAL.match(line)
            if m:
                palette[m.group(1)] = m.group(2)
            continue
        m = _META.match(line)
        if m:
            meta[m.group(1)] = m.group(2).strip()
    meta["palette"] = palette
    return meta


# --- color helpers -----------------------------------------------------------
def _rgb(hex_str: str):
    h = hex_str.lstrip("#")
    return int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)


def blend(fg: str, bg: str, alpha: float) -> str:
    """fg over bg at `alpha` opacity -> #rrggbb."""
    fr, fg_, fb = _rgb(fg)
    br, bg_, bb = _rgb(bg)
    r = round(fr * alpha + br * (1 - alpha))
    g = round(fg_ * alpha + bg_ * (1 - alpha))
    b = round(fb * alpha + bb * (1 - alpha))
    return f"#{r:02x}{g:02x}{b:02x}"


# --- base16 slot -> hunk custom_theme mapping --------------------------------
def build_theme(meta: dict) -> str:
    p = meta["palette"]
    for slot in [f"base0{c}" for c in "0123456789ABCDEF"]:
        if slot not in p or not _HEX.match(p[slot]):
            raise ValueError(f"missing/invalid {slot}")

    def b(n):  # b("00") -> "#..."
        return p[f"base{n}"]

    light = meta.get("variant", "dark").lower() == "light"
    base_theme = "github-light-default" if light else "github-dark-default"

    # blend strengths — light backgrounds need a touch more to stay visible
    row = 0.22 if light else 0.16          # whole added/removed row tint
    content = 0.38 if light else 0.32      # changed-word highlight within a row
    sel = 0.26 if light else 0.20          # selected-hunk highlight
    note = 0.30 if light else 0.24         # agent-note title bar

    bg = b("00")
    fields = {
        "base": base_theme,
        "label": f'{meta.get("name", "Tinted")} ({meta.get("system", "base16")})',
        # surfaces / chrome
        "background": bg,
        "panel": b("01"),
        "panelAlt": b("02"),
        "border": b("02"),
        "accent": b("0D"),
        "accentMuted": b("04"),
        "text": b("05"),
        "muted": b("04"),
        # diff row backgrounds (blended so they read as subtle tints)
        "addedBg": blend(b("0B"), bg, row),
        "removedBg": blend(b("08"), bg, row),
        "movedAddedBg": blend(b("0D"), bg, row),
        "movedRemovedBg": blend(b("0E"), bg, row),
        "contextBg": bg,
        "addedContentBg": blend(b("0B"), bg, content),
        "removedContentBg": blend(b("08"), bg, content),
        "contextContentBg": bg,
        # gutter signs stay full-saturation for punch
        "addedSignColor": b("0B"),
        "removedSignColor": b("08"),
        "lineNumberBg": b("01"),
        "lineNumberFg": b("03"),
        "selectedHunk": blend(b("0D"), bg, sel),
        # badges + file-status colors (git-style)
        "badgeAdded": b("0B"),
        "badgeRemoved": b("08"),
        "badgeNeutral": b("04"),
        "fileNew": b("0B"),
        "fileDeleted": b("08"),
        "fileRenamed": b("0D"),
        "fileModified": b("0A"),
        "fileUntracked": b("03"),
        # agent notes
        "noteBorder": b("0E"),
        "noteBackground": b("01"),
        "noteTitleBackground": blend(b("0E"), bg, note),
        "noteTitleText": b("05"),
    }

    syntax = {
        "default": b("05"),
        "keyword": b("0E"),
        "string": b("0B"),
        "comment": b("03"),
        "number": b("09"),
        "function": b("0D"),
        "property": b("05"),
        "type": b("0A"),
        "variable": b("08"),
        "operator": b("05"),
        "punctuation": b("05"),
    }

    lines = [
        "# Generated by tinted-hunk (build.py) from a tinted-theming scheme.",
        "# Do not edit by hand — regenerate with `python3 build.py`.",
        'theme = "custom"',
        "",
        "[custom_theme]",
    ]
    for k, v in fields.items():
        lines.append(f'{k} = "{v}"')
    lines.append("")
    lines.append("[custom_theme.syntax]")
    for k, v in syntax.items():
        lines.append(f'{k} = "{v}"')
    lines.append("")
    return "\n".join(lines)


def main():
    schemes_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_SCHEMES
    if not schemes_dir.exists():
        sys.exit(f"schemes dir not found: {schemes_dir}")
    out_dir = HERE / "themes"
    out_dir.mkdir(exist_ok=True)

    written = 0
    errors = 0
    for system in ("base16", "base24"):
        sysdir = schemes_dir / system
        if not sysdir.is_dir():
            continue
        for yaml in sorted(sysdir.glob("*.yaml")):
            try:
                meta = parse_scheme(yaml)
                meta.setdefault("system", system)
                toml = build_theme(meta)
            except Exception as e:  # skip any malformed scheme, keep going
                errors += 1
                print(f"skip {system}/{yaml.stem}: {e}", file=sys.stderr)
                continue
            (out_dir / f"{system}-{yaml.stem}.toml").write_text(toml)
            written += 1
    print(f"wrote {written} theme files to {out_dir} ({errors} skipped)")


if __name__ == "__main__":
    main()
