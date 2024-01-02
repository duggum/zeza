# .zeza_main

User-facing functions for the zeza plugin

## Overview

This file provides all of the user-facing commands for the zeza plugin.

The commands are:
* `configure`
* `default`
* `demo`
* `nocolor`
* `refresh`
* `reset`
* `restore`
* `status`
* `tables`

Note: The exit codes used here are based on those found in 'sysexits.h' from
the Standard C Library. See `man sysexits.h` for more information.

Updated for `eza v0.17.0`

### Documentation
* [README](../README.md)
* [zeza](zeza.md)
* [zeza-utils](utils.md)

## Index

* [zeza](#zeza)
* [.zeza::configure](#zezaconfigure)
* [.zeza::default](#zezadefault)
* [.zeza::demo](#zezademo)
* [.zeza::nocolor](#zezanocolor)
* [.zeza::refresh](#zezarefresh)
* [.zeza::reset](#zezareset)
* [.zeza::restore](#zezarestore)
* [.zeza::status](#zezastatus)
* [.zeza::tables](#zezatables)

## Main

the main zeza command

### zeza

zeza - launches user-facing commands to manage the eza configuration

usage: `zeza COMMAND [OPTIONS]`

#### Example

```bash
zeza restore . /home/config/backup/.zeza_config.eza
```

#### Options

* **-h** | **--help**

  display help text and exit

#### Arguments

* **$1** (string): COMMAND - the command to run
* **...** (string): ARGS - arguments and/or options for the COMMAND

#### Exit codes

* **0**: if successful
* **64**: wrong number of arguments
* **69**: invalid command, or command not available

#### Output on stdout

* help text if -h or --help options were provided

#### Output on stderr

* error message and/or help text

## Commands

commands providing user-facing functionality for zeza

### .zeza::configure

configure - copies the default eza configuration file to the user's home
directory, or to a location of their choosing

usage: `zeza configure [OPTION] | [DESTINATION]`

#### Example

```bash
zeza configure /home/user/config/location
```

#### Options

* **-h** | **--help**

  display help text and exit

#### Arguments

* **$1** (path): DESTINATION - the location where the configuration file will be stored

#### Exit codes

* **0**: if successful or cancelled
* **66**: if color settings and EZA_COLORS fail to load properly
* **73**: if configuration file copy failed
* **77**: if DESTINATION cannot be created or is not writable

#### Input on stdin

* user responses to various prompts

#### Output on stdout

* information regarding the configuration process

#### Output on stderr

* various error messages depending on the error

#### See also

* [.zeza::restore](#zezarestore)

### .zeza::default

default - setup eza to use the default, builtin color configuration

Any user configuration file in use will be backed up to the cache directory
and can be restored using `zeza restore`

usage: `zeza default [OPTION]`

#### Example

```bash
zeza default
```

#### Options

* **-h** | **--help**

  display help text and exit

_Function has no arguments._

#### Variables set

* **EZA_COLORS** (string): the environment variable used by eza for colored output generation

#### Exit codes

* **0**: if successful
* **66**: if color settings and EZA_COLORS fail to load properly
* **73**: if an error occured while backing up the user configuration file

#### Input on stdin

* user response to a confirmation prompt

#### Output on stdout

* information regarding the process of setting default mode and the zeza
  environment status

#### Output on stderr

* various error messages depending on the error

#### See also

* [.zeza::restore](#zezarestore)
* [.zeza::status](#zezastatus)

### .zeza::demo

demo - print eza color codes and their descriptions in their currently assigned colors

usage: `zeza demo [OPTION]`

#### Example

```bash
zeza demo
```

#### Options

* **-h** | **--help**

  display help text and exit

_Function has no arguments._

#### Exit codes

* **0**: if successful
* **66**: if temporary demo file cannot be read
* **73**: if temporary demo file cannot be created
* **78**: if EZA_COLORS is not set

#### Output on stdout

* all eza color codes and custom extensions printed in their corresponding
  colors based on the current configuration

#### Output on stderr

* various error messages depending on where in the function the error occurred

#### See also

* [eza_colors(5)](https://github.com/eza-community/eza/blob/main/man/eza_colors.5.md)

### .zeza::nocolor

nocolor - setup eza to display completely colorless output

Disables all color output from eza by prepending the `reset` code to EZA_COLORS
and setting all color codes to 00. Any user configuration file in use will be
backed up to the cache directory and can be restored using `zeza restore`

**Note**: running this command is NOT the same as setting the 'NO_COLOR'
environment variable as described in the eza man pages.

usage: `zeza nocolor [OPTION]`

#### Example

```bash
zeza nocolor
```

#### Options

* **-h** | **--help**

  display help text and exit

_Function has no arguments._

#### Variables set

* **EZA_COLORS** (string): the environment variable used by eza for colored output generation

#### Exit codes

* **0**: if successful
* **73**: if an error occured while backing up the user configuration file

#### Input on stdin

* user response to a confirmation prompt

#### Output on stdout

* information regarding the process of setting no color mode and the zeza
  environment status

#### Output on stderr

* various error messages depending on the error

#### See also

* [.zeza::status](#zezastatus)
* [eza man pages](https://github.com/eza-community/eza/tree/main/man)

### .zeza::refresh

refresh - refresh zeza to reflect changes made to a configuration file

usage: `zeza refresh [OPTION]`

#### Example

```bash
zeza refresh --demo
```

#### Options

* **-h** | **--help**

  display help text and exit

* **-d** | **--demo**

  display demo output after refresh

_Function has no arguments._

#### Variables set

* **EZA_COLORS** (string): the environment variable used by eza for colored output generation

#### Exit codes

* **0**: if successful
* **64**: if executed while in 'default or 'no color' mode
* **66**: if color settings and EZA_COLORS fail to load properly

#### Output on stdout

* function status updates and the zeza demo if the --demo option was provided

#### Output on stderr

* various error messages depending on the error

#### See also

* [.zeza::demo](#zezademo)

### .zeza::reset

reset - prepends the 'reset' flag to the EZA_COLORS environment variable

This disables eza's color assignments for standard file extensions.

usage: `zeza reset [OPTION]`

#### Example

```bash
zeza reset
zeza reset -u
```

#### Options

* **-h** | **--help**

  display help text and exit

* **-u** | **--unset**

  remove the reset flag from EZA_COLORS

_Function has no arguments._

#### Variables set

* **EZA_COLORS** (string): the environment variable used by eza for colored output generation

#### Exit codes

* **0**: if successful or cancelled
* **69**: if reset flag is already set
* **73**: if an error occured while backing up the user configuration file

#### Input on stdin

* user response to a confirmation prompt

#### Output on stdout

* information regarding the process of setting the 'reset' flag and zeza status

#### Output on stderr

* various error messages depending on the error

#### See also

* [.zeza::status](#zezastatus)
* [eza_colors man page](https://github.com/eza-community/eza/blob/main/man/eza_colors.5.md)

### .zeza::restore

restore - restores a previous eza color configuration from a source file

If no source file is provided, restore will default to using a cached backup

usage: `zeza restore DESTINATION [SOURCE=cached backup]`

#### Example

```bash
zeza restore /home/user /home/user/backup/.zeza_config.eza
```

#### Arguments

* **$1** (path): DESTINATION - the full path to where the configuration will be restored
* **$2** (path): SOURCE - the full path to a configuration file (defaults to cached backup)

#### Exit codes

* **0**: if successful
* **64**: if DESTINATION is not provided
* **66**: if SOURCE is not readable or cached backup is missing
* **73**: if DESTINATION cannot be created
* **77**: if ESTINATION is not writable

#### Input on stdin

* user responses to various prompts

#### Output on stdout

* information regarding the configuration process

#### Output on stderr

* various error messages depending on where in the function the error occurred

### .zeza::status

status - show the current status of the zeza plugin environment

usage: `zeza status [OPTION]`

#### Example

```bash
zeza status
```

#### Options

* **-h** | **--help**

  display help text and exit

_Function has no arguments._

#### Exit codes

* **0**: if successful
* **1**: on error

#### Output on stdout

* prints the following information:
  * eza program version
  * set/unset status of the EZA_COLORS environment variable
  * current color mode
  * reset status
  * current configuration file path
  * cached backup status

#### See also

* [.zeza::configure](#zezaconfigure)
* [.zeza::default](#zezadefault)
* [.zeza::demo](#zezademo)
* [.zeza::nocolor](#zezanocolor)

### .zeza::tables

tables - display one or more color tables representing the color capabilities
of the user's terminal emulator

usage: `zeza tables [OPTION]`

#### Example

```bash
zeza tables
zeza tables --bn
zeza tables --all
zeza tables --test
```

#### Options

* **-h** | **--help**

  display help text and exit

* **-n**

  display the normal on normal color table (default)

* **-b**

  display the bright on bright color table

* **--nb**

  display the normal on bright color table

* **--bn**

  display the bright on normal color table

* **--256**

  display the 256 color table

* **-a** | **--all**

  display all table variations

* **-t** | **--test**

  test if bold text is displayed using bright colors

_Function has no arguments._

#### Exit codes

* **0**: if successful
* **64**: if an invalid option is provided

#### Output on stdout

* displays the following:
  * one or more color tables depending on the option provided
  * a bold/bright color terminal emulator test and information

