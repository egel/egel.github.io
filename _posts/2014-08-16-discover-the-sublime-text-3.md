---
layout: post
title: Discover the Sublime Text 3 editor
category: Discovery
tags: [text-editor, sublime, gui]
date: 2014-08-16 12:31:00
---

Sublime is a just amazing text editor. I've loved it since I've tasted it. However, its uniqueness and some advantage in contrast with other GUI editors, is the versatility of usage and a huge pile of plug-ins that extend user experience.

It is also available with a free trial version for many popular platforms (Mac, Linux, Windows). But in this article, I'll try to focus on the configuration that is suitable for my daily basis with a system from Linux family based on Debian.

---

### The installation of Sublime Text 3

Probably you have already noticed that "beta" in the title of the article. Authors of the editor have made a very stable version of the software, even if it's still in beta! You can fell that it's rock solid editor! I've been very positively surprised by the quality and stability of it.

The best method of installation is download package from [official Sublime Text 3 website][22] and install it.

### Package Control

On the official website of [packagecontrol.io][23] (this is official package manager for Sublime) we can find a code snippet that will activate the package manager into our editor. The only thing we need to do, is to paste it into the sublime console (you can open with <kbd>Ctrl</kbd> + <kbd>~</kbd> key combination) and press enter. After few seconds, you can access to Sublime Package Manager by the combination of <kbd>Shift</kbd> + <kbd>Ctrl</kbd> + <kbd>P</kbd>.

---

### Plug-ins

Plug-ins extend default editor functionality.

#### All Autocomplete

Instalation through Package Manager: Install Package > All Autocomplete

#### Syntax highlight for Sass

Repository of plug-in: [Syntax highlighting for Sass][24]

Installation through Package Manager: Install Package > Syntax highlighting for Sass

#### Less Syntax

Instalation through Package Manager: Install Package > Less Syntax

#### CoffeeScript

Repository of plug-in: [CoffeeScript Sublime Plugin][25]

```sh
cd ~/.config/sublime-text-3/Packages \
  && rm -rf CoffeeScript \
  && git clone https://github.com/Xavura/CoffeeScript-Sublime-Plugin.git CoffeeScript
```

#### Live Loader

Repository of plug-in: [Github repo][26]

```sh
cd ~/.config/sublime-text-3/Packages \
  && rm -rf LiveReload \
  && git clone -b devel https://github.com/dz0ny/LiveReload-sublimetext2.git LiveReload
```

This plug-in also be added as plug-in of your browser [LiveReload][27] and while
saving file into Sublime the content will be automatically reloaded into the browser.

-   [Chrome addon][28]

#### Markdown Extended

Instalation through Package Manager: Install Package > Markdown Extended

#### GitGutter

Instalation through Package Manager: Install Package > GitGutter

#### Git-Status-Bar

Instalation through Package Manager: Install Package > Git-Status-Bar

#### Local History

Instalation through Package Manager: Install Package > Local-history

#### EditorConfig

Instalation through Package Manager: Install Package > EditorConfig

#### Sublime linter (core)

Instalation through Package Manager: Install Package > Sublime linter v3

**Extensions of the plug-in**:

-   [SublimeLinter-annotations][29] - marks in color annotations like: TODO, README, FIXME
-   [SublimeLinter-csslint][30]
-   SublimeLinter-contrib-scss-lint
-   SublimeLinter-php

#### Sidebar Enhancements

Instalation through Package Manager: Install Package > Sidebar Enhancements

#### Djaneiro

Instalation through Package Manager: Install Package > Djaneiro

#### VimL

Instalation through Package Manager: Install Package > VimL

#### Soda Theme

Best theme for the editor I've come across. The website of theme <http://buymeasoda.github.io/soda-theme/>

Installation through Package Manager: Install Package > Theme - Soda

To make it work, you need to add config line to `Settings - User` into Sublime.
More info how to achieve this you can find [Settings - User][21]

#### Gruvbox Dark Theme

Instalation through Package Manager: Install Package > Gruvbox Dark

To activate it go to `Preferences` > `Gruvbox Dark` and choose `gruvbox`.

#### Color Scheme Selector

The website of plug-in: <https://github.com/jugyo/SublimeColorSchemeSelector>

```sh
cd ~/.config/sublime-text-3/Packages \
  && rm -rf "ColorSchemeSelector" \
  && git clone https://github.com/jugyo/SublimeColorSchemeSelector.git "ColorSchemeSelector"
```

### Configuration

Here I paste my configurations of the Sublime editor, but it can become outdated in time.

#### Key Bindings - User

```javascript
[
    { keys: ["alt+up"], command: "swap_line_up" },
    { keys: ["alt+down"], command: "swap_line_down" },

    { keys: ["ctrl+shift+up"], command: "duplicate_line" },
    { keys: ["ctrl+shift+down"], command: "duplicate_line" },

    { keys: ["ctrl+shift+x"], command: "swap_case" },

    { keys: ["ctrl+f5"], command: "refresh_folder_list" },

    // Quick rename of current file (require SideBar Enhancements plug-in)
    { keys: ["f2"], command: "side_bar_move" },

    // Toggle side bar
    { keys: ["f9"], command: "toggle_side_bar" },
];
```

#### Settings - User

```json
{
    // Colors + Themes
    "theme": "Soda Dark 3.sublime-theme",
    "color_scheme": "Packages/Tomorrow Color Schemes/Tomorrow-Night.tmTheme",

    // Font
    "font_face": "Ubuntu Mono",
    "font_size": 15.0,
    "line_padding_bottom": 0,
    "line_padding_top": 0,
    "highlight_line": true,
    "font_options": ["subpixel_antialias", "no_bold"],

    // Editor behavior
    "spell_check": false,
    "dictionary": "Packages/Language - English/en_US.dic",
    "open_files_in_new_window": false,
    "highlight_modified_tabs": true,
    "always_show_minimap_viewport": true,
    "bold_folder_labels": true,
    "fade_fold_buttons": false,
    "draw_minimap_border": true,
    "find_selected_text": true,
    "rulers": [79, 100],
    "show_encoding": true,
    "scroll_past_end": false,
    "caret_style": "solid",
    "wide_caret": true,

    // Ignored packages
    "ignored_packages": ["Vintage"],

    // Whitespace - no tabs, trimming, end files with \n
    "tab_size": 4,
    "translate_tabs_to_spaces": true,
    "trim_automatic_white_space": true,
    "trim_trailing_white_space_on_save": true,
    "ensure_newline_at_eof_on_save": true,

    // Sidebar - exclude distracting files and folders
    "file_exclude_patterns": [
        "*.pyc",
        "*.pyo",
        "*.exe",
        "*.dll",
        "*.obj",
        "*.o",
        "*.a",
        "*.lib",
        "*.so",
        "*.dylib",
        "*.ncb",
        "*.sdf",
        "*.suo",
        "*.pdb",
        "*.idb",
        ".DS_Store",
        "*.class",
        "*.psd",
        "*.db"
    ],
    "folder_exclude_patterns": [".git", "__pycache__", "env", "env3"]
}
```

[1]: #instalacja-edytora
[2]: #package-control
[3]: #all-autocomplete
[4]: #syntax-highlight-for-sass
[5]: #less-syntax
[6]: #coffeescript-sublime-plugin
[7]: #live-loader
[8]: #markdown-preview
[9]: #markdown-extended
[10]: #gitgutter
[11]: #git-status​bar
[12]: #sublime-linter
[13]: #sidebar-enhancements
[14]: #djaneiro
[15]: #viml
[16]: #soda-theme
[17]: #tommorow-theme
[18]: #color-scheme-selector
[19]: #vintageous
[20]: #key-bindings-user
[21]: #settings-user
[22]: https://www.sublimetext.com/3
[23]: https://packagecontrol.io/installation
[24]: https://github.com/P233/Syntax-highlighting-for-Sass
[25]: https://github.com/Xavura/CoffeeScript-Sublime-Plugin
[26]: https://github.com/dz0ny/LiveReload-sublimetext2
[27]: http://livereload.com/
[28]: https://chrome.google.com/webstore/detail/livereload/jnihajbhpnppcggbcgedagnkighmdlei
[29]: https://sublime.wbond.net/packages/SublimeLinter-annotations
[30]: https://github.com/SublimeLinter/SublimeLinter-csslint
