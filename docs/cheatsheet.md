# Color Code Cheat Sheet

## Introduction

The following serves as a handy reference for creating ANSI escape sequences that
can be used to configure `eza`, `ls`, or anything else that uses them to generate
colorful text output in the terminal.

## ANSI Escape Sequences

For color and text effects, Select Graphic Rendition (SGR) control sequences are
used. The format for such sequences is:

`\e` + `[` + `n[;n]` + `m`

| Component| Description                                                  |
|:---------|:-------------------------------------------------------------|
|` \e`     | is a literal 'escape' (may also be `\x1b` or `\033`)         |
|`n[;n]`   | zero or more numbers from the tables below, separated by ";" |
|`m`       | is the code for the SGR function                             |

A good way to think of such a sequence is as a function call where `\e[` indicates
you are calling a function, `n[;n]` represents the argument(s), and `m` is the
function being called. $^{1}$

$^{1}$ *[Everything you never wanted to know about ANSI escape codes](https://notes.burke.libbey.me/ansi-escape-codes/)*

### Example

`\e[01;04;33mHELLO WORLD\e[0m]`

The example above will result in the words 'HELLO WORLD' printed in bold (`01`),
underlined (`04`), yellow (`33`) text. The sequence `\e[0m` after the text resets
all effects and colors to the system default, which is typically no color and no
effects.

Note that the leading `0` is not required, so `\e[1;4;33m` will yield the same
results.

## Foreground/Background Colors and Resets

| COLOR   | NORMAL FG | NORMAL BG | BRIGHT FG | BRIGHT BG | RESETS              |
|:--------|:---------:|:---------:|:---------:|:---------:|:--------------------|
| Black   | 30        | 40        | 90        | 100       | 00 Reset Everything |
| Red     | 31        | 41        | 91        | 101       | 39 Reset Foreground |
| Green   | 32        | 42        | 92        | 102       | 49 Reset background |
| Yellow  | 33        | 43        | 93        | 103       |                     |
| Blue    | 34        | 44        | 94        | 104       |                     |
| Magenta | 35        | 45        | 95        | 105       |                     |
| Cyan    | 36        | 46        | 96        | 106       |                     |
| White   | 37        | 47        | 97        | 107       |                     |

## Effects and Resets $^{2}$

| CODE | EFFECT           | RESET CODE | NOTES                                   |
|:-----|:-----------------|:----------:|:----------------------------------------|
| --   | All              | 00         | Everything (colors and effects)         |
| 01   | Bold             | 22         | Bold                                    |
| 02   | Dim/Faint        | 22         | Dim (same as reset bold)                |
| 03   | Italic           | 23         | Italic                                  |
| 04   | Underline        | 24         | Underline (single or double, if in use) |
| 05   | Blink            | 25         | Blink                                   |
| 07   | Inverse          | 27         | Inverse                                 |
| 08   | Hidden           | 28         | Hidden                                  |
| 09   | Strikethrough    | 29         | Strikethrough                           |
| 21   | Double Underline | 24         | Underline (single or double, if in use) |

$^{2}$ *Not all color, effect, and/or reset codes are supported by all terminal emulators*

##   256 Colors

To use colors from the 256 color palette available in most modern terminal emulators
you must use the following control sequences:

| Target     | Code     | Note                           |
|:-----------|:---------|:-------------------------------|
| Foreground | 38;5;nnn | nnn = three digit color number |
| Background | 48;5;nnn |                                |

Example: `\e[38;5;197m` results in very bright pink text.

##   RGB Colors

To use colors from the RGB color palette available in terminal emulators that
support the 'true color,' or 16 million color palette, you must use the following
control sequences:

| Target     | Code       | Note                                         |
|:-----------|:-----------|:---------------------------------------------|
| Foreground | 38;2;r;g;b | r/g/b = component numbers in the range 0-255 |
| Background | 48;2;r;g;b |                                              |

Example: `\e[48;2;255;0;0m` results in red text. $^{3}$

$^{3}$ *Effect codes may also be applied to colors from the 256-color and RGB palettes.*

## A Special Note on Bold Text

Some (most?) terminal emulators use the bold effect (`01`) to enable bright,
or 'intense,' colors. Often, this behavior will result in text that is both bold
AND bright. For example: `01;34` (bold blue) would render the same as `01;94`
(bold, bright blue).

This behavior is especially notable when trying to use bold black (`01;30`) as it
will be rendered as bold, bright black (a.k.a. dark gray).

This 'functionality' is a holdover from a time when terminals only had eight
colors and the bold flag was used to render a brighter variant of those eight
colors. $^{4}$ This behavior reduces your overall color options as you will not
be able to render both bold normal text *and* bold bright text. Fortunately, you
may be able to disable/modify such behavior in your terminal emulator settings.$^{5}$

For example, Windows Terminal has a setting for 'Intense text style' that can be
set to 'bold', 'bright', or 'bold AND bright'. Setting it to 'bold' results in
the expected rendering behavior. Similarly, Xterm, can be made to properly render
bold variations by placing `XTerm*boldColors: false` in your .Xdefaults file.
This setting may also work for other emulators, such as rxvt-unicode, that use the
`boldColors` setting.

$^{4}$ *[3-bit and 4-bit SGR](https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit)*  
$^{5}$ *If your color scheme uses the same color for black and the background, any bold black text will still be rendered the same color as normal black text, and it will therefore be invisible.*

## Other Notes

1. An alternative to the bold black problem above is to use a gray from the 256
color palette (`38;5;244`), or you can use dim white (`02;37`).
2. Bright black is dark gray, and bright white is bright gray.
3. Dim bright colors (`02;9#`) are *NOT* the same as normal (`3#`) colors!
(e.g. `31`, `02;31`, `91` and `02;91` all yield different results)
4. Some color, effect, and/or reset codes may not work on all terminal emulators

## Further Reading

- [ECMA 48](https://ecma-international.org/wp-content/uploads/ECMA-48_5th_edition_june_1991.pdf)
- [man console_codes](https://man7.org/linux/man-pages/man4/console_codes.4.html)
- [3-bit and 4-bit SGR](https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit)
- [Everything you never wanted to know about ANSI escape codes](https://notes.burke.libbey.me/ansi-escape-codes/)
