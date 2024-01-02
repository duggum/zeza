# zeza plugin

A Z Shell (`zsh`) plugin for managing and customizing '[eza]', the very colorful '[ls]' replacement. View the [install] guide to
get it for your operating system.

![eza default demo](assets/eza_demo.png "a demo directory listing using eza")

- [Features](#features)
- [Installation](#installation)
- [Aliases](#aliases)
- [Commands](#commands)
- [Customization](#customization)
- [Learn More](#learn-more)
- [Code Documentation](#code-documentation)

## Features

While `eza` needs nothing more than the `EZA_COLORS` environment variable to customize its color configuration, this plugin provides
a few extra conveniences for a more complete `eza` experience, such as:

1. an easy to read color configuration file,
2. a few sensible aliases, and
3. several helpful commands to manage `eza`

## Installation

### Oh My Zsh

1. Clone the repository to `.oh-my-zsh/custom/plugins` or `$ZSH_CUSTOM`

```shell
git clone --depth=1 https://github.com/duggum/zeza.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zeza
```

2. Add `zeza` to the plugins array in your `.zshrc` file:

```shell
plugins=(... zeza)
```

Note: you have to [install] `eza` before using this plugin.

## Aliases

The following aliases are provided which can be overridden in your own `.zshenv`
or `.zshrc` as desired. See: `man eza` for all available options.

```shell
# base implementation with default options
alias e='eza --git --icons --group --group-directories-first --sort=name' 
```
![eza base demo](assets/eza_demo_base.png "a base alias directory listing")

```shell
# mid form implementation (plus -l, -h, and --no-user options)
alias el='e -lh --no-user'
```

![eza mid demo](assets/eza_demo_mid.png "a mid form alias directory listing")

```shell
# long form implementation (plus -l, -a, -g, and -h options)
alias ell='e -lagh'
```

![eza long demo](assets/eza_demo_long.png "a long form alias directory listing")

## Commands

`zeza` provides the following commands

| Command   | Description                                                      |
|:----------|:-----------------------------------------------------------------|
| help      | print a help message                                             |
| configure | generate a customizable configuration file                       |
| default   | setup `eza` to use the default, builtin color configuration        |
| demo      | print color codes and descriptions in their assigned colors      |
| nocolor   | setup `eza` to display completely colorless output                 |
| refresh   | refresh `zeza` to reflect changes made to a configuration          |
| reset     | prepends the 'reset' flag to the EZA_COLORS environment variable |
| restore   | restore a previous custom configuration file                     |
| status    | show the current status of the `zeza` plugin environment           |
| tables    | show formatted color tables using the terminal color scheme      |

For help with individual commands, run `zeza <command> --help`

### Tables

The `tables` command can be especially helpful as it displays a variety of color tables that demonstrate the rendering
behavior of your terminal emulator.

For example:

`zeza tables -nb` displays a color table showing normal foreground colors on bright background colors

![zeza tables demo](assets/zeza_tables_demo.png "a `zeza tables` command demo")

Another useful tool is `zeza tables --test` which will run a simple test to help you determine if your terminal emulator
renders bold text as bold, bright, or both bold and bright. This can be useful as setting your emulator to only render
bold text as bold allows for many more color combinations from among the base 16 color palette.

Feel free to jump down the [rabbit hole] if you wish to know more.

![zeza tables test demo](assets/zeza_tables_test_demo.png "a `zeza tables --test` command demo")

Run `zeza tables --help` for detailed instructions.

## Customization

You may add your own aliases in your `.zshenv` or `.zshrc` files as you see fit. Additionally, the default aliases listed
above may be overriden by providing your own aliases with the same names.

## Code Documentation

Documentation for the main code files can be found at:

* [zeza](docs/zeza.md)
* [zeza-main](docs/main.md)
* [zeza-utils](docs/utils.md)

## Learn More

For `eza` see the following man pages:

- [eza(1)]
- [eza_colors(5)]
- [eza_colors-explanation(5)]

For ANSI colors in terminal emulators:

- [Everything] you ever wanted to know about ANSI escape codes
- A wikipedia article covering the use of [SGR parameters]
- [ECMA 48] 5th edition

[eza]: https://eza.rocks "eza"
[ls]: https://www.gnu.org/software/coreutils/manual/html_node/ls-invocation.html "ls"
[install]: https://github.com/eza-community/eza/blob/main/INSTALL.md "install"
[rabbit hole]: https://www.google.com/search?q=terminal+render+bold+as+bright "Google search about bold terminal color rendering"
[eza(1)]: https://github.com/eza-community/eza/blob/main/man/eza.1.md "man eza"
[eza_colors(5)]: https://github.com/eza-community/eza/blob/main/man/eza_colors.5.md "man eza_colors"
[eza_colors-explanation(5)]: https://github.com/eza-community/eza/blob/main/man/eza_colors-explanation.5.md "man eza_colors-explanation"
[Everything]: https://notes.burke.libbey.me/ansi-escape-codes "everything about ANSI escape codes"
[SGR parameters]: https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters "wikipedia article on sgr parameters"
[ECMA 48]: https://ecma-international.org/wp-content/uploads/ECMA-48_5th_edition_june_1991.pdf "ECMA 48 5th edition PDF"
