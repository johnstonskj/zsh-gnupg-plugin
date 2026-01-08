# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# Plugin Name: gnupg
# Repository: https://github.com/johnstonskj/zsh-gnupg-plugin
#
# Description:
#
#   Zsh plugin to set up environment variables for GnuPG.
#
# Public variables:
#
# * `GNUPG`; plugin-defined global associative array with the following keys:
#   * `_ALIASES`; a list of all aliases defined by the plugin.
#   * `_FUNCTIONS`; a list of all functions defined by the plugin.
#   * `_PLUGIN_DIR`; the directory the plugin is sourced from.
# * `GNUPGHOME`; path to the GnuPG home/data directory.
# * `GPG_TTY`; the terminal device for GPG to use.
#

############################################################################
# Standard Setup Behavior
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#zero-handling
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# See https://wiki.zshell.dev/community/zsh_plugin_standard#standard-plugins-hash
declare -gA GNUPG
GNUPG[_PLUGIN_DIR]="${0:h}"
GNUPG[_FUNCTIONS]=""

# Saving the current state for any modified global environment variables.
GNUPG[_OLD_HOME]="${GNUPGHOME:-}"
GNUPG[_OLD_TTY]="${GPG_TTY:-}"

############################################################################
# Internal Support Functions
############################################################################

#
# This function will add to the `GNUPG[_FUNCTIONS]` list which is
# used at unload time to `unfunction` plugin-defined functions.
#
# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
# See https://wiki.zshell.dev/community/zsh_plugin_standard#the-proposed-function-name-prefixes
#
.gnupg_remember_fn() {
    builtin emulate -L zsh

    local fn_name="${1}"
    if [[ -z "${GNUPG[_FUNCTIONS]}" ]]; then
        GNUPG[_FUNCTIONS]="${fn_name}"
    elif [[ ",${GNUPG[_FUNCTIONS]}," != *",${fn_name},"* ]]; then
        GNUPG[_FUNCTIONS]="${GNUPG[_FUNCTIONS]},${fn_name}"
    fi
}
.gnupg_remember_fn .gnupg_remember_fn

#
# This function does the initialization of variables in the global variable
# `GNUPG`. It also adds to `path` and `fpath` as necessary.
#
gnupg_plugin_init() {
    builtin emulate -L zsh
    builtin setopt extended_glob warn_create_global typeset_silent no_short_loops rc_quotes no_auto_pushd

    export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"
    export GPG_TTY=$(tty)
}
.gnupg_remember_fn gnupg_plugin_init

############################################################################
# Plugin Unload Function
############################################################################

# See https://wiki.zshell.dev/community/zsh_plugin_standard#unload-function
gnupg_plugin_unload() {
    builtin emulate -L zsh

    # Remove all remembered functions.
    local plugin_fns
    IFS=',' read -r -A plugin_fns <<< "${GNUPG[_FUNCTIONS]}"
    local fn
    for fn in ${plugin_fns[@]}; do
        whence -w "${fn}" &> /dev/null && unfunction "${fn}"
    done

    # Remove the global data variable.
    unset GNUPG

    export GNUPGHOME="${GNUPG[_OLD_HOME]}"
    export GPG_TTY="${GNUPG[_OLD_TTY]}"

    # Remove this function.
    unfunction gnupg_plugin_unload
}

############################################################################
# Initialize Plugin
############################################################################

gnupg_plugin_init

true
