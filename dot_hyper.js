"use strict";
// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.
module.exports = {
    config: {
        // choose either `'stable'` for receiving highly polished,
        // or `'canary'` for less polished but more frequent updates
        updateChannel: 'stable',
        // font family with optional fallbacks
        fontFamily: '"Hack Nerd Font Mono", Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',
        // default font size in pixels for all tabs
        fontSize: 12,
        // default font weight: 'normal' or 'bold'
        fontWeight: 'bold',
        // font weight for bold characters: 'normal' or 'bold'
        fontWeightBold: 'bold',
        // line height as a relative unit
        lineHeight: 1.2,
        // letter spacing as a relative unit
        letterSpacing: 0,
        // `'BEAM'` for |, `'UNDERLINE'` for _, `'BLOCK'` for █
        cursorShape: 'BLOCK',
        // set to `true` (without backticks and without quotes) for blinking cursor
        cursorBlink: false,
        // custom CSS to embed in the main window
        css: '',
        // custom CSS to embed in the terminal window
        termCSS: '',
        // set custom startup directory (must be an absolute path)
        workingDirectory: '',
        // if you're using a Linux setup which show native menus, set to false
        // default: `true` on Linux, `true` on Windows, ignored on macOS
        showHamburgerMenu: '',
        // set to `false` (without backticks and without quotes) if you want to hide the minimize, maximize and close buttons
        // additionally, set to `'left'` if you want them on the left, like in Ubuntu
        // default: `true` (without backticks and without quotes) on Windows and Linux, ignored on macOS
        showWindowControls: false,
        // custom padding (CSS format, i.e.: `top right bottom left`)
        padding: '5px 10px 2px 10px',
        // base16: {
        //     scheme: 'eighties'
        // },
        catppuccinTheme: 'Macchiato',
        // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
        // if left empty, your system's login shell will be used by default
        //
        // Windows
        // - Make sure to use a full path if the binary name doesn't work
        // - Remove `--login` in shellArgs
        //
        // Windows Subsystem for Linux (WSL) - previously Bash on Windows
        // - Example: `C:\\Windows\\System32\\wsl.exe`
        //
        // Git-bash on Windows
        // - Example: `C:\\Program Files\\Git\\bin\\bash.exe`
        //
        // PowerShell on Windows
        // - Example: `C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe`
        //
        // Cygwin
        // - Example: `C:\\cygwin64\\bin\\bash.exe`
        shell: '',
        shellArgs: ['--login'],
        scrollback: 10000,
        env: {}, // Env vars to inject into terminal
        bell: false, // 'SOUND' || false
        // bellSoundURL: '/path/to/sound/file',

        // if `true` selected text will automatically be copied to the clipboard
        copyOnSelect: false,
        // if `true`, hyper will be set as the default protocol client for SSH
        defaultSSHApp: true,
        // if `true` , on right click selected text will be copied or pasted if no
        // selection is present (`true` by default on Windows and disables the context menu feature)
        quickEdit: false,
        // choose either `'vertical'`, if you want the column mode when Option key is hold during selection (Default)
        // or `'force'`, if you want to force selection regardless of whether the terminal is in mouse events mode
        // (inside tmux or vim with mouse mode enabled for example).
        macOptionSelectionMode: 'force',
        // Whether to use the WebGL renderer. Set it to false to use canvas-based
        // rendering (slower, but supports transparent backgrounds)
        webGLRenderer: true,
        // keypress required for weblink activation: [ctrl|alt|meta|shift]
        // todo: does not pick up config changes automatically, need to restart terminal :/
        webLinksActivationKey: '',
        // if `false` (without backticks and without quotes), Hyper will use ligatures provided by some fonts
        disableLigatures: true,
        // set to true to disable auto updates
        disableAutoUpdates: false,
        // for advanced config flags please refer to https://hyper.is/#cfg
    },
    // a list of plugins to fetch and install from npm
    // format: [@org/]project[#version]
    // examples:
    //   `hyperpower`
    //   `@company/project`
    //   `project#1.0.1`
    plugins: [
        'hypersixteen',
        'hyper-quit',
        'hyperfull',
        'hyperminimal',
        'hyperborder',
        "hyper-pane",
        "hypurr#latest"
    ],
    // in development, you can create a directory under
    // `~/.hyper_plugins/local/` and include it here
    // to load it and avoid it being `npm install`ed
    localPlugins: [
  "fig-hyper-integration"
],
    keymaps: {
    // Example
    // 'window:devtools': 'cmd+alt+o',
    },
};
//# sourceMappingURL=config-default.js.map
