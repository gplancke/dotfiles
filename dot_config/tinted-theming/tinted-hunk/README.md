# tinted-hunk

Local [tinty](https://github.com/tinted-theming/tinty) template that themes
[hunk](https://github.com/modem-dev/hunk) (terminal diff viewer) from any
base16 / base24 color scheme.

There is no official tinted-theming template for hunk, so this one is built
locally. hunk's diff-row backgrounds are whole-row fills, so raw base16
red/green can't be used directly — `build.py` pre-blends them with the
background (mustache can't do color math), then writes one `[custom_theme]`
config per scheme into `themes/`.

## How it plugs into tinty

`~/.config/tinted-theming/tinty/config.toml`:

```toml
[[items]]
path = "~/.config/tinted-theming/tinted-hunk"
name = "tinted-hunk"
themes-dir = "themes"
hook = "mkdir -p ~/.config/hunk && cp -f %f ~/.config/hunk/config.toml"
supported-systems = ["base16", "base24"]
```

On `tinty apply <scheme>`, tinty copies `themes/<scheme>.toml` to
`~/.config/hunk/config.toml`. hunk reads it on next launch (`theme = "custom"`).

## Regenerating

Scheme palettes come from tinty's local clone
(`~/.local/share/tinted-theming/tinty/repos/schemes`). After `tinty update`
pulls new schemes, rebuild the theme files:

```sh
python3 build.py
```

## Notes / limits

- `~/.config/hunk/config.toml` is fully owned by this hook. hunk's other
  settings (mode, vcs, line_numbers, …) keep their defaults; to change a
  global setting, add it near the top of `build.py`'s output. Per-repo
  overrides still work via `<repo>/.hunk/config.toml` (hunk merges it on top).
- The mapping inherits from hunk's `github-dark-default` / `github-light-default`
  built-in theme (chosen by the scheme's `variant`) and overrides chrome,
  diff colors, badges, file-status and syntax from the scheme.
