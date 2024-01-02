#>>
#   Unless otherwise indicated, released under the MIT license.
#   See: https://opensource.org/license/mit/
#
#   Copyright 2023 David Jopson
#
#   Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the “Software”), to deal
#   in the Software without restriction, including without limitation the rights
#   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#   copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
#
#   The above copyright notice and this permission notice shall be included in
#   all copies or substantial portions of the Software.
#
#   THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#   SOFTWARE.
#
#   VERSION: 0.1 - initial build
#
# @name zeza plugin
# @brief A Z Shell (zsh) plugin for managing and customizing '[eza](https://eza.rocks)'
# @description
#   'eza' is a very colorful replacement for the venerable 'ls' utility.
#
#   While eza needs nothing more than the `EZA_COLORS` environment variable to
#   customize its color configuration, this plugin provides a few extra
#   conveniences for a more complete eza experience, such as:
#       1. an easy to read color configuration file,
#       2. a few sensible aliases, and
#       3. several helpful commands to manage eza
#
#   updated for `eza v0.17.0`
#
#   ### Documentation
#       * [README](../README.md)
#       * [zeza-main](main.md)
#       * [zeza-utils](utils.md)
#
#   ### More About eza
#       * see [eza](https://github.com/eza-community/eza)
#       * see `man eza`
#       * see `man eza_colors`
#       * see `man eza_colors-explanation`

#<<

# use associative array for environment to minimize global pollution
typeset -gA ZEZA;

# colorful tag for plugin-specific console output --> '[zeza]:'
ZEZA[OUTPUT_TAG]="\e[37m[\e[38;5;214mzeza\e[37m]:\e[0m"

# save a lot of keystrokes...
local tag="$ZEZA[OUTPUT_TAG]"

# no sense continuing if eza isn't installed
if (( ! ${+commands[eza]} )); then
    printf "%b %bCommand not found - eza%b\n" "$tag" "\e[31m" "\e[0m" 1>&2
    printf "%b %bVisit %b%bhttps://eza.rocks%b %bfor instructions on how to install it.%b\n\n" \
        "$tag" "\e[37m" "\e[34m" "\e[4m" "\e[24m" "\e[37m" "\e[0m" 1>&2
    return 69
fi

# establish the plugin's 'home' dir ($0)
# https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

#>> plugin directories
# root:         plugin root
# bin:          user-facing commands
# config:       configuration files
# functions:    internally accessed plugin functions
# lib:          internally accessed library functions
# cache:        plugin info that needs to be persistent
#<<
ZEZA[ROOT_DIR]="${0:h}"
ZEZA[BIN_DIR]="$ZEZA[ROOT_DIR]/bin"
ZEZA[CONFIG_DIR]="$ZEZA[ROOT_DIR]/config"
ZEZA[FUNC_DIR]="$ZEZA[ROOT_DIR]/functions"
ZEZA[LIB_DIR]="$ZEZA[ROOT_DIR]/lib"
ZEZA[CACHE_DIR]="${XDG_CACHE_HOME:-$HOME/.cache}/zeza"

#>> add function directory to fpath
fpath=( "$ZEZA[FUNC_DIR]" "${(@)fpath}" )

#>> source func and lib files
builtin source "$ZEZA[FUNC_DIR]/.zeza_main"
local file
for file in $ZEZA[LIB_DIR]/*.leza ; do
    builtin source "$file"
done
unset file
#<<

#>> cached information
# colors     : data used to set 'EZA_COLORS' (fi=00:di=01;34:*.mp3=01;36)
# no_color   : if present indicates 'no color' mode is enabled
# default    : if present indicates 'default' mode is enabled
# reset      : if present indicates 'reset' flag is set in EZA_COLORS
# user_config: the location of the user designated configuration file

# create cache directory if needed
if [[ ! -d "$ZEZA[CACHE_DIR]" ]] || [[ ! -w "$ZEZA[CACHE_DIR]" ]]; then
    .zeza-run-command /usr/bin/mkdir -p -m 700 -- "$ZEZA[CACHE_DIR]"
    if [[ ! $? -eq 0 ]] ; then
        .zeza-file-system-error write "$ZEZA[CACHE_DIR]" "$ZEZA[CMD_ERR]"
        return 1
    fi
fi
ZEZA[EZA_COLORS_CACHE]="$ZEZA[CACHE_DIR]/.eza_colors"
ZEZA[NO_COLOR_CACHE]="$ZEZA[CACHE_DIR]/.no_color_mode"
ZEZA[DEFAULT_CACHE]="$ZEZA[CACHE_DIR]/.default_mode"
ZEZA[RESET_CACHE]="$ZEZA[CACHE_DIR]/.reset_flag"
ZEZA[USER_CONFIG_CACHE]="$ZEZA[CACHE_DIR]/.user_config"
#<<

#>> utility variables
ZEZA[CODES]=""      # color codes used by eza           #! access with "${(@f)ZEZA[CODES]}"
ZEZA[SETTINGS]=""   # color settings from config file   #! access with "${(@f)ZEZA[SETTINGS]}"
ZEZA[COLORS]=""     # string to set the EZA_COLORS environment variable
ZEZA[CMD_ERR]=""    # STDERR from running commands
ZEZA[CMD_OUT]=""    # STDOUT from running commands
#<<

#>> the default configuration filenames and paths
# cfg_filename  : name used for custom configuration files
# codes_file    : codes used to designate color settings (fi, gR, etc.)
# defaults_file : default eza color assignments to codes (di=01;34)
# current_config: configuration file currently in use
# user_config_bu: the file use as a backup of user settings
ZEZA[CFG_FILENAME]=".zeza_custom.eza"
ZEZA[CODES_FILE]="$ZEZA[CONFIG_DIR]/zeza_codes.eza"
ZEZA[DEFAULTS_FILE]="$ZEZA[CONFIG_DIR]/zeza_defaults.eza"
ZEZA[CURRENT_SETTINGS]=""
ZEZA[USER_CONFIG_BU]="$ZEZA[CACHE_DIR]/.zeza_custom.eza.BAK"
#<<

# use user's settings if available, otherwise use plugin defaults
if [[ -f "$ZEZA[USER_CONFIG_CACHE]" ]] ; then

    # read the settings location from cache file
    .zeza-run-command cat "$ZEZA[USER_CONFIG_CACHE]"
    if [[ $? -eq 0 ]] ; then

        # only store if the file contained data
        if [[ -n "$ZEZA[CMD_OUT]" ]] ; then
            ZEZA[CURRENT_SETTINGS]="$ZEZA[CMD_OUT]"
        fi
    else
        .zeza-file-system-error read "$ZEZA[USER_CONFIG_CACHE]" "$ZEZA[CMD_OUT]"
        return $?
    fi

    # make sure previously saved settings still exists and use default if it doesn't
    if ! [[ -f $ZEZA[CURRENT_SETTINGS] ]] ; then
        printf "%b %bThe previously saved configuration file is missing!%b\n" \
            "$tag" "$red" "$rst"
        printf "%b %bWas %b%s%b deleted?%b\n" \
            "$tag" "$wht" "$cyn" "$ZEZA[CURRENT_SETTINGS]" "$wht" "$rst"
        printf "%b %bRun '%b%beza_config [dir]%b%b' to start a new configuration.%b\n" \
            "$tag" "$wht" "$magb" "$itl" "$ritl" "$wht" "$rst"
        printf "%b %bCleaning up and switching to eza defaults...%b\n" "$tag" "$wht" "$rst"

        # enable default mode
        .zeza::default cfg_missing
    fi
else
    ZEZA[CURRENT_SETTINGS]="$ZEZA[DEFAULTS_FILE]"
fi

# set some sensible, default aliases for eza
alias e='eza --git --icons --group-directories-first --sort=name'  # basic implementation
alias el='e -lh'  # mid form without user/group/hidden
alias ell='e -lagh'  # long form with group names and hidden files

# load configs or return error
.zeza-load-codes || return $?
.zeza-load-settings || return $?
.zeza-load-ezacolors || return $?
