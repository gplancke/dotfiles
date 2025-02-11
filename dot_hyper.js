"use strict";

module.exports = {
	config: {
		updateChannel: 'stable',
		disableAutoUpdates: false,

		disableLigatures: false,
		fontFamily: '"FiraCode Nerd Font Mono", "Hack Nerd Font Mono", Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',
		fontSize: 12,
		fontWeight: 'bold',
		fontWeightBold: 'bold',
		lineHeight: 1.05,
		letterSpacing: 0,
		cursorShape: 'BLOCK', // `'BEAM'` for |, `'UNDERLINE'` for _, `'BLOCK'` for █
		cursorBlink: false,
		// custom CSS to embed in the main window
		css: '',
		// custom CSS to embed in the terminal window
		termCSS: '',
		workingDirectory: '',
		showHamburgerMenu: '', // default: `true` on Linux, `true` on Windows, ignored on macOS
		showWindowControls: false, // default: `true` (without backticks and without quotes) on Windows and Linux, ignored on macOS

		padding: '5px 10px 2px 10px',
		catppuccinTheme: 'Macchiato',
		// base16: {
		//     scheme: 'eighties'
		// },

		shell: '',
		shellArgs: ['--login', '-lic', 'sunbeam'],
		// env: {
		// 	"EDITOR": "vim"
		// },
		windowSize: [750, 440],
		modifierKeys: {
			altIsMeta: true // needed for hotkeys to work
		},
		hyperSunbeam: {
			hotkey: 'Shift+Super+K', // setup your hotkey here
		}

		scrollback: 10000,
		bell: false, // 'SOUND' || false
		// bellSoundURL: '/path/to/sound/file',

		copyOnSelect: false,
		defaultSSHApp: true, // if `true`, hyper will be set as the default protocol client for SSH
		quickEdit: false, // if `true` , on right click selected text will be copied or pasted if no

		// choose either `'vertical'`, if you want the column mode when Option key is hold during selection (Default)
		// or `'force'`, if you want to force selection regardless of whether the terminal is in mouse events mode
		// (inside tmux or vim with mouse mode enabled for example).
		macOptionSelectionMode: 'force',
		webGLRenderer: true,

		webLinksActivationKey: ''
	},
	plugins: [
		'hyper-sunbeam',
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
	// localPlugins: [
	// 	"fig-hyper-integration"
	// ],
	keymaps: {
		// Example
		// 'window:devtools': 'cmd+alt+o',
	},
};
//# sourceMappingURL=config-default.js.map
