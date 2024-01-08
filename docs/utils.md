# zeza_utils

Utility functions for the zeza plugin

## Overview

This library provides utility functions for the zeza plugin. The functions
are arranged in two categories:
1. command execution and error handling
2. state management

### Documentation
* [README](../README.md#code-documentation)
* [zeza](zeza.md)

## Index

* [.zeza-file-system-error](#zeza-file-system-error)
* [.zeza-run-command](#zeza-run-command)
* [.zeza-load-codes](#zeza-load-codes)
* [.zeza-load-settings](#zeza-load-settings)
* [.zeza-load-ezacolors](#zeza-load-ezacolors)
* [.zeza-cache-backup](#zeza-cache-backup)
* [.zeza-delete-cache-file](#zeza-delete-cache-file)
* [.zeza-enable-mode](#zeza-enable-mode)
* [.zeza-update-eza](#zeza-update-eza)
* [.zeza-256-colors](#zeza-256-colors)
* [.zeza-ansi-colors](#zeza-ansi-colors)

## Command Execution and Error Handling

functions used for command execution and error handling

### .zeza-file-system-error

.zeza-file-system-error - print error messages related to read/write failures

usage: `.zeza-file-system-error OPERATION PATH MESSAGE`

#### Example

```bash
.zeza-file-system-error read "$config_file" "Could not read $config_file"
```

#### Arguments

* **$1** (string): OPERATION - 'read' | 'write'
* **$2** (string): PATH - the file or directory path
* **$3** (string): MESSAGE - the error message to display

#### Exit codes

* **0**: if successful

#### Output on stderr

* error messages formatted as follows:
  * File system <OPERATION> error
  * Unable to <OPERATION> [from | to] <PATH>
  * Error: <MESSAGE>

### .zeza-run-command

.zeza-run-command - runs a command and captures STDOUT, STDERR and the exit
status of the given command

Adapted from [a script](https://gist.github.com/romkatv/605b8ae4499458565e13f715abbd2636)
by [Roman Perepelitsa](https://github.com/romkatv)<br>
Released under the [MIT license](https://opensource.org/license/mit/) per
[this comment](https://gist.github.com/romkatv/605b8ae4499458565e13f715abbd2636?permalink_comment_id=4801935#gistcomment-4801935)

usage: `.zeza-run-command COMMAND [OPTIONS] ARGS`

#### Example

```bash
.zeza-run-command mkdir -p "$dest"
```

#### Arguments

* **$1** (string): COMMAND - the command to run
* **...** (string): OPTIONS/ARGS - the command options/arguments

#### Variables set

* **$ZEZA[CMD_OUT]** (string): STDOUT output
* **$ZEZA[CMD_ERR]** (string): STDERR output

#### Exit codes

* the command exit status

## State Management

functions used to manage the state of the zeza plugin

### .zeza-load-codes

.zeza-load-codes - uses `sed` to parse the eza color code description file
and sets the the ZEZA[CODES] state variable

This only needs to be run at plugin load since the code and description data
only changes when supported codes are added or removed from eza itself

usage: `.zeza-load-codes`

#### Example

```bash
.zeza-load-codes
```

_Function has no arguments._

#### Variables set

* **$ZEZA[CODES]** (string): color code and description data (e.g. `ln=symbolic link`)

#### Exit codes

* **0**: if successful
* **66**: on file read error

#### Output on stderr

* file read error message

#### See also

* [.zeza-file-system-error](#zezafilesystemerror)

### .zeza-load-settings

.zeza-load-settings - uses `sed` to parse an eza configuration file and sets
the ZEZA[SETTINGS] state variable

This should be run whenever changes are made to the configuration file or the
file itself has changed (e.g. switching to default mode)

usage: `.zeza-load-settings`

#### Example

```bash
.zeza-load-settings
```

_Function has no arguments._

#### Variables set

* **$ZEZA[SETTINGS]** (string): color assignment settings (e.g `di=01;34`)

#### Exit codes

* **0**: if successful
* **66**: on file read error

#### Output on stderr

* file read error message

#### See also

* [.zeza-file-system-error](#zezafilesystemerror)

### .zeza-load-ezacolors

.zeza-load-ezacolors - reads a color settings string from the cache and sets
the ZEZA[COLORS] state variable and the EZA_COLORS
environment variable

This should be run whenever changes are made to the configuration file or the
file itself has changed (e.g. switching to default mode)

usage: `.zeza-load-ezacolors`

#### Example

```bash
.zeza-load-ezacolors
```

_Function has no arguments._

#### Variables set

* **$ZEZA[COLORS]** (string): the complete color setting string used to set EZA_COLORS (e.g. `fi=00:di=01;34:ln=36`)

#### Exit codes

* **0**: if successful
* **66**: on file read error

#### Output on stderr

* file read error message

#### See also

* [.zeza-file-system-error](#zezafilesystemerror)

### .zeza-cache-backup

.zeza-cache-backup - performs operations related to the cached configuration
backup file

Three options are available based on the operation requested:
1. no op: move the existing user configuration to the cache directory
2. `delete`: delete the cached backup file
3. `restore`: restore the cached backup file to a given directory

usage: `.zeza-cache-backup [OPERATION] [PATH]`

#### Example

```bash
.zeza-cache-backup
.zeza-cache-backup restore "$dest"
```

#### Arguments

* **$1** (string): OPERATION - the operation to be performed (`delete` | `restore`)
* **$2** (path): PATH - where the backup file should be restored to or deleted from

#### Exit codes

* **0**: if successful
* **73**: on file write error

#### Output on stdout

* confirmation of the requested operation

#### Output on stderr

* file write error message

#### See also

* [.zeza-file-system-error](#zezafilesystemerror)

### .zeza-delete-cache-file

.zeza-delete-cache-file - deletes the requested cache file

The following cache file types are valid:
1. `deafult`: ZEZA[DEFAULT_CACHE] -denotes 'DEFAULT' mode
2. `eza_colors`: ZEZA[EZA_COLORS_CACHE]- maintains the EZA_COLORS variable state
3. `nocolor`: ZEZA[NO_COLOR_CACHE] - denotes 'NO COLOR' mode
4. `user_cfg`: ZEZA[USER_CONFIG_CACHE] - maintains the location of the user configuration file

usage: `.zeza-delete-cache-file TYPE`

#### Example

```bash
.zeza-delete-cache-file default
.zeza-delete-cache-file eza_colors nocolor user_cfg
```

#### Arguments

* **...** (string): TYPE - the file type(s) top be deleted

#### Exit codes

* **0**: if successful

#### Output on stdout

* confirmation of the requested operation

### .zeza-enable-mode

.zeza-enable-mode - creates a cache file to denote the setting of 'DEFAULT'
or 'NO COLOR' mode, or the setting of the 'reset' flag
in the EZA_COLORS environment variable

usage: `.zeza-enable-mode MODE`

#### Example

```bash
.zeza-enable-mode default
.zeza-enable-mode nocolor
.zeza-enable-mode reset
```

#### Arguments

* **$1** (string): MODE - the mode file to create

#### Exit codes

* **0**: if successful
* **73**: on file write error

#### Output on stdout

* confirmation of the requested operation

#### Output on stderr

* file write error message

#### See also

* [.zeza-file-system-error](#zezafilesystemerror)

### .zeza-update-eza

.zeza-update-eza - updates EZA_COLORS and related zeza state variables

The following mode arguments are valid:
1. none: EZA_COLORS is set from the configuration file
2. `nocolor`: reset flag is prepended and all color codes are set to '00'
3. `reset`: reset flag is prepended to the existing EZA_COLORS

usage: `.zeza-update-eza [MODE]`

#### Example

```bash
.zeza-update-eza
.zeza-update-eza reset
.zeza-update-eza nocolor
```

#### Arguments

* **$1** (string): MODE - the mode to set EZA_COLORS for (none | `nocolor` | `reset`)

#### Exit codes

* **0**: if successful
* **73**: on file write error

#### Output on stdout

* confirmation of the requested operation

#### Output on stderr

* file write error message

#### See also

* [.zeza-file-system-error](#zezafilesystemerror)

### .zeza-256-colors

.zeza-256-colors - print a series of color grids covering the 256 color palette

Adapted from [Tim Carry's script](http://blog.pixelastic.com/2012/09/06/spectrum-script-terminal-256-colors/) posted on his blog.

usage: `.zeza-256-colors`

#### Example

```bash
.zeza-256-colors
```

_Function has no arguments._

#### Exit codes

* **0**: if successful

#### Output on stdout

* a series of color grids covering the 256 color palette

### .zeza-ansi-colors

.zeza-ansi-colors - prints an ANSI color table based on provided options

This is a modified version of the script by Daniel Crisman found in the
[Bash Prompt HOWTO](https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html)

usage: `.zeza-ansi-colors LABEL HEADER FG_COLORS BG_COLORS`

#### Example

```bash
.zeza-ansi-colors $label $header fore back
```

#### Arguments

* **$1** (string): LABEL - the label for the table to be printed
* **$2** (string): HEADER - the header for the table to be printed
* **$3** (array): FG_COLORS - the aray of foreground colors to use for the table
* **$4** (array): BG_COLORS - the aray of background colors to use for the table

#### Exit codes

* **0**: if successful

#### Output on stdout

* prints an ANSI color table

