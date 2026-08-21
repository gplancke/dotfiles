#!/usr/bin/env python3
"""Generate hunk's custom-theme config from the scheme tinty is applying.

Run as a tinty hook. On `tinty apply <scheme>`, tinty exports the whole active
palette into the environment (TINTY_SCHEME_PALETTE_BASE0*_HEX_{R,G,B}, plus
TINTY_SCHEME_VARIANT / _NAME / _SYSTEM). We read those, do the color math here,
and write ~/.config/hunk/config.toml directly. No pre-built theme files.

hunk (https://github.com/modem-dev/hunk) reads a `[custom_theme]` table in
config.toml. Its diff-row backgrounds (addedBg/removedBg/...) are whole-row
fills, so we can't feed raw base16 red/green in — that would paint solid bars.
We pre-blend them with the background here instead.

By hand (for debugging): export the TINTY_SCHEME_* vars a hook would see, then
run this script. Outside a tinty apply it exits with a clear message.
"""
import os
import re
import sys
from pathlib import Path

OUT = Path.home() / ".config/hunk/config.toml"

_HEX = re.compile(r'^#[0-9a-fA-F]{6}$')


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


def _lum(hex_str: str) -> float:
    """WCAG relative luminance (0=black .. 1=white)."""
    def lin(c):
        c /= 255
        return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = _rgb(hex_str)
    return 0.2126 * lin(r) + 0.7152 * lin(g) + 0.0722 * lin(b)


def _contrast(a: str, b: str) -> float:
    la, lb = _lum(a), _lum(b)
    hi, lo = max(la, lb), min(la, lb)
    return (hi + 0.05) / (lo + 0.05)


def _sat(hex_str: str) -> float:
    """HSV saturation (0=grey .. 1=fully saturated)."""
    r, g, b = (c / 255 for c in _rgb(hex_str))
    mx, mn = max(r, g, b), min(r, g, b)
    return 0.0 if mx == 0 else (mx - mn) / mx


def surface(bg: str, fg: str, given: str, step: float) -> str:
    """A chrome background one step off `bg` (panels, gutter, note bg).

    Trust the scheme's own color (`given`, i.e. base01/base02) only when it sits
    on the correct side of the background — lighter for dark themes, darker for
    light. Some schemes break the base16 lightness ramp (e.g. Cobalt2's base01 is
    pure black, darker than its navy base00); there we derive the surface by
    nudging `bg` toward `fg`, so panels never collapse into a black/white box.
    """
    want_lighter = _lum(fg) > _lum(bg)
    given_ok = _lum(given) > _lum(bg) if want_lighter else _lum(given) < _lum(bg)
    return given if given_ok else blend(fg, bg, step)


def soften(color: str, toward: str, amount: float = 0.20, sat_min: float = 0.82) -> str:
    """Ease a fully-saturated accent toward `toward`. Solid diff signs/badges in
    a raw #ff0000-class color glare; only very saturated schemes are touched, so
    gentle palettes pass through unchanged."""
    return blend(toward, color, amount) if _sat(color) >= sat_min else color


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

    # Foreground: base05 is meant to be the readable body text, but some ports
    # set it to a dim grey. Lift toward base06 when it's too low-contrast on bg.
    fg = b("05")
    if _contrast(fg, bg) < 7.0 and _contrast(b("06"), bg) > _contrast(fg, bg):
        fg = b("06")

    # Ease harsh full-saturation red/green (base08/base0B) used by solid glyphs.
    red = soften(b("08"), fg)
    green = soften(b("0B"), fg)

    # Raised chrome surfaces, guarded against schemes with an inverted ramp.
    raised1 = surface(bg, fg, b("01"), 0.06)   # panels, gutter, note background
    raised2 = surface(bg, fg, b("02"), 0.13)   # panelAlt, borders

    fields = {
        "base": base_theme,
        "label": f'{meta.get("name", "Tinted")} ({meta.get("system", "base16")})',
        # surfaces / chrome
        "background": bg,
        "panel": raised1,
        "panelAlt": raised2,
        "border": raised2,
        "accent": b("0D"),
        "accentMuted": b("04"),
        "text": fg,
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
        # gutter signs (eased if the scheme's red/green are glaringly saturated)
        "addedSignColor": green,
        "removedSignColor": red,
        "lineNumberBg": raised1,
        "lineNumberFg": b("03"),
        "selectedHunk": blend(b("0D"), bg, sel),
        # badges + file-status colors (git-style)
        "badgeAdded": green,
        "badgeRemoved": red,
        "badgeNeutral": b("04"),
        "fileNew": green,
        "fileDeleted": red,
        "fileRenamed": b("0D"),
        "fileModified": b("0A"),
        "fileUntracked": b("03"),
        # agent notes
        "noteBorder": b("0E"),
        "noteBackground": raised1,
        "noteTitleBackground": blend(b("0E"), bg, note),
        "noteTitleText": fg,
    }

    syntax = {
        "default": fg,
        "keyword": b("0E"),
        "string": green,
        "comment": b("03"),
        "number": b("09"),
        "function": b("0D"),
        "property": fg,
        "type": b("0A"),
        "variable": red,
        "operator": fg,
        "punctuation": fg,
    }

    lines = [
        "# Generated on the fly by tinty-hunk-theme.py from the active tinty scheme.",
        "# Do not edit by hand — it is overwritten on every `tinty apply`.",
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


# --- read the active palette from the tinty hook environment -----------------
def read_meta_from_env() -> dict:
    if "TINTY_SCHEME_PALETTE_BASE00_HEX_R" not in os.environ:
        sys.exit(
            "tinty-hunk-theme: no TINTY_SCHEME_* palette in the environment.\n"
            "Run this via a `tinty apply` hook, not by hand."
        )
    palette = {}
    for c in "0123456789ABCDEF":
        pre = f"TINTY_SCHEME_PALETTE_BASE0{c}"
        try:
            r = os.environ[f"{pre}_HEX_R"]
            g = os.environ[f"{pre}_HEX_G"]
            bl = os.environ[f"{pre}_HEX_B"]
        except KeyError as e:
            sys.exit(f"tinty-hunk-theme: missing env var {e}")
        palette[f"base0{c}"] = f"#{r}{g}{bl}"
    return {
        "palette": palette,
        "variant": os.environ.get("TINTY_SCHEME_VARIANT", "dark"),
        "name": os.environ.get("TINTY_SCHEME_NAME", "Tinted"),
        "system": os.environ.get("TINTY_SCHEME_SYSTEM", "base16"),
    }


def main():
    meta = read_meta_from_env()
    toml = build_theme(meta)

    OUT.parent.mkdir(parents=True, exist_ok=True)
    tmp = OUT.with_name(OUT.name + f".{os.getpid()}.tmp")
    tmp.write_text(toml)
    tmp.replace(OUT)  # atomic; hunk never sees a half-written file
    print(f"tinty-hunk-theme: wrote {OUT}")


if __name__ == "__main__":
    main()
