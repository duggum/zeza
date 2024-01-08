# zeza Plugin TODO List

- [X] Create .md file from Color Code Cheat Sheet comment block
- [X] Add ability to get plugin version and supported eza version info
- [X] Use Makefile to generate documentation instead of zsh script???
- [ ] Confirm behavior of 'overline' (\e[53m) in .zeza-ansi-colors
- [ ] Add documentation for the color library file (zeza_colors.lzsh)
- [X] Add a few more ***useful*** aliases
- [X] Ensure consistent comment block formatting
- [X] Ensure consistent use/non-use of double quotes and curly braces
- [ ] Conform as much as possible to the [Zsh Plugin Standard (ZPS)](https://wiki.zshell.dev/community/zsh_plugin_standard)
    - [X] Standardized $0 handling
    - [ ] Functions directory
    - [ ] Binaries directory
    - [ ] Unload function
    - [ ] Plugin manager activity indicator \*
    - [ ] Global parameter holding the plugin manager’s capabilities \*
    - [ ] Standard parameter naming
    - [ ] Standard recommended options
    - [ ] Standard recommended variables
    - [ ] Standard function name-space prefixes ('.', '→', '+', '/', and '@' )
    - [ ] Preventing function pollution
    - [X] Preventing parameter pollution

\* indicates partial implementation, or plugin implementation of plugin manager functionality
