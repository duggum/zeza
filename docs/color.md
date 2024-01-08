# zeza_color

A general purpose text color and effect library for the zeza plugin

## Overview

This file provides access to most supported ANSI Select Graphic Rendition
(SGR) control sequences used for coloring and formatting terminal text.

All variables are declared as local to minimize global scope pollution.
This file must be sourced in each file or function you wish to use it in,
like so:

```zsh
builtin source "path/to/zeza_color.lzsh"
```

Note the following rules for applying colors and effects:

1. colors of the same mode (fg or bg) will overwrite each other without
the need to reset beforehand
2. colors of opposite modes will NOT overwrite each other; they stack
3. effects will NOT overwrite each other; they stack
4. effect resets only change the targeted effect
5. color resets only change the targeted mode (fg/bg)
6. the master reset (`$rst`) removes all colors and effects
7. 256 and RGB colors are applied using command substitution to call
their respective functions: `$(z256 f 122)` or `$(zRGB b 134 12 47)`

Variables Set:
```zsh
# Notes:
#   'r' = reset (e.g. rbld - reset bold)
#   'b' = bright (e.g. magb - bright magenta)
#   'nb' = normal background (e.g. grnnb - green normal background)
#   'bb' = bright background (e.g. blubb - blue bright background)

# the variables
local rst                                                 # reset everything
local bld dim itl und fla inv hid str dund ovr            # set effects
local rbld rdim ritl rund rfla rinv rhid rstr rdund rovr  # reset effects
local blk red grn ylw blu mag cyn wht                     # set normal fg colors
local blkb redb grnb ylwb blub magb cynb whtb             # set bright fg colors
local blknb rednb grnnb ylwnb blunb magnb cynnb whtnb     # set normal bg colors
local blkbb redbb grnbb ylwbb blubb magbb cynbb whtbb     # set bright bg colors
local rfg rbg                                             # reset fg/bg colors

# reset everything
rst="\e[0m"         # resets everything to defaults (no colors/no effects)

# set effects
bld="\e[1m"         # set bold
dim="\e[2m"         # set dim
itl="\e[3m"         # set italic
und="\e[4m"         # set underline
fla="\e[5m"         # set flash a.k.a. blink
inv="\e[7m"         # set inverse
hid="\e[8m"         # set hidden/not visible
str="\e[9m"         # set strikethrough
dund="\e[21m"       # set double underline
ovr="\e[53m"        # set overline

# reset effects
rbld="\e[22m"       # reset bold
rdim="\e[22m"       # reset dim (same as reset bold)
ritl="\e[23m"       # reset italic
rund="\e[24m"       # reset underline
rfla="\e[25m"       # reset flash a.k.a. blink
rinv="\e[27m"       # reset inverse
rhid="\e[28m"       # reset hidden/invisible
rstr="\e[29m"       # reset strikethrough
rdund="\e[24m"      # reset double underline (same as reset underline)
rovr="\e[55m"       # reset overline

# set normal fg colors
blk="\e[30m"        # black
red="\e[31m"        # red
grn="\e[32m"        # green
ylw="\e[33m"        # yellow
blu="\e[34m"        # blue
mag="\e[35m"        # magenta
cyn="\e[36m"        # cyan
wht="\e[37m"        # white

# set bright fg colors
blkb="\e[90m"
redb="\e[91m"
grnb="\e[92m"
ylwb="\e[93m"
blub="\e[94m"
magb="\e[95m"
cynb="\e[96m"
whtb="\e[97m"

# set normal bg colors
blknb="\e[40m"
rednb="\e[41m"
grnnb="\e[42m"
ylwnb="\e[43m"
blunb="\e[44m"
magnb="\e[45m"
cynnb="\e[46m"
whtnb="\e[47m"

# set bright bg colors
blkbb="\e[100m"
redbb="\e[101m"
grnbb="\e[102m"
ylwbb="\e[103m"
blubb="\e[104m"
magbb="\e[105m"
cynbb="\e[106m"
whtbb="\e[107m"

# reset colors
rfg="\e[39m"        # reset foreground to default
rbg="\e[49m"        # reset background to default
```

Usage Example:

```zsh
local err="${wht}[$(z256 f 214)ERROR${wht}]:$rst"
echo "$err you have made an error!"
```

Example using printf:

```zsh
printf "%b%bBold, red text!%b" "$bld" "$red" "$rst"
```

Notes:
1. Braces (`{ }`) are only required if the color parameter is to be
directly followed by a letter, digit, or underscore that is not to be
interpreted as part of name (e.g. `$red/` -or- `${blu}text`).
2. `%b` has to be used with `printf` instead of `%s` to cause the color
escape sequences to be recognised

### Color Code Cheat Sheet
* [cheatsheet](cheatsheet.md)

### Documentation
* [README](../README.md#code-documentation)
* [zeza](zeza.md)
* [utils](utils.md)

## Index

* [z256](#z256)
* [zRGB](#zrgb)

### z256

z256 - returns a 256-color SGR control sequence (e.g. `\e[38;5;137m`)

must be called using command substitution '$(command)'

usage: `$(z256 MODE COLOR)`

#### Example

```bash
$(z256 f 197)
```

#### Arguments

* **$1** (string): MODE - the color mode to set (f: foreground, b: background)
* **$2** (int): COLOR - the desired color from the 256 color palette (0-255)

#### Output on stdout

* the 256 color SGR control sequence

### zRGB

zRGB - returns an RGB color SGR control sequence (e.g. `\e[38;2;0;255;0m`)

must be called using command substitution '$(command)'

This function will only work under the following conditions:
1. the `$COLORTERM` variable is set to `truecolor` or `24bit`,
2. the `$TERM` variable is set to: `iterm`, `tmux-truecolor`, `linux-truecolor`,
`xterm-truecolor`, or `screen-truecolor`
3. the `$WT_SESSION` variable is set

If either test is false, the function will fail silently and return nothing.

These checks will cover most *nix terminal emulators and, in the case of the
second condition, Windows Terminal. While this detection method is far from
perfect and will almost certainly exclude some terminal emulators that
shouldn't be, it is a simple method that covers most scenarios and prevents
this simple library file from getting way more complex than it needs to be.
If a more accurate means of determining color rendering capabilities comes
along, I will be more than happy to change the tests.

If you want to go down the rabbit hole, be my guest: https://github.com/termstandard/colors

usage: `$(zRGB MODE RED GREEN BLUE)`

#### Example

```bash
$(z256 b 24 192 54)
```

#### Arguments

* **$1** (string): MODE - the color mode to set (f: foreground, b: background)
* **$2** (int): RED - the red component value (0-255)
* **$3** (int): GREEN - the green component value (0-255)
* **$4** (int): BLUE - the blue component value (0-255)

#### Output on stdout

* the RGB color SGR control sequence

