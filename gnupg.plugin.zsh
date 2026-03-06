# -*- mode: sh; eval: (sh-set-shell "zsh") -*-
#
# @name gnupg
# @brief Zsh plugin to set up environment variables for GnuPG.
# @repository https://github.com/johnstonskj/zsh-gnupg-plugin
#

############################################################################
# @section Lifecycle
# @description Plugin lifecycle functions.
#

gnupg_plugin_init() {
    builtin emulate -L zsh

    @zplugins_envvar_save gnupg GNUPGHOME
    export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"

    @zplugins_envvar_save gnupg GPG_TTY
    export GPG_TTY=$(tty)
}

# @internal
gnupg_plugin_unload() {
    builtin emulate -L zsh

    @zplugins_envvar_restore gnupg GNUPGHOME
    @zplugins_envvar_restore gnupg GPG_TTY
}
