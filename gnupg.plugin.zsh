# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name: gnupg
# @brief: Set up environment variables for GnuPG.
# @repository: https://github.com/johnstonskj/zsh-gnupg-plugin
# @version: 0.1.1
# @license: MIT AND Apache-2.0
#
# Public variables:
#
# * `GNUPGHOME`; path to the GnuPG home/data directory.
# * `GPG_TTY`; the terminal device for GPG to use.
#

############################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
#

gnupg_plugin_init() {
    builtin emulate -L zsh

    @zplugins_envvar_save gnupg GNUPGHOME
    typeset -g GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"

    @zplugins_envvar_save gnupg GPG_TTY
    typeset -g GPG_TTY=$(tty)
}

# @internal
gnupg_plugin_unload() {
    builtin emulate -L zsh

    @zplugins_envvar_restore gnupg GNUPGHOME
    @zplugins_envvar_restore gnupg GPG_TTY
}
