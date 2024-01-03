# zeza Plugin TODO List

- [ ] Create .md file from Color Code Cheat Sheet comment block
- [ ] Add ability to get plugin version from CLI and/or 'zeza status'
- [ ] Use Makefile to generate documentation instead of zsh script???
- [ ] Confirm behavior of '\e[53m' in .zeza-ansi-colors
- [ ] Add a few more ***useful*** aliases
- [X] Ensure consistent comment block formatting
- [ ] Ensure consistent use/non-use of double quotes and curly braces
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
