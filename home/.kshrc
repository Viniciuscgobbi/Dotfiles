# things that are good to add later on:
### direnv

# Colors and vars
GREEN='\033[32;01m'
YELLOW='\033[33;01m'
RED='\033[1;31m'
BLUE='\033[34;01m'
PURPLE='\033[35m'
NORMAL='\033[0m'

git_info() {
    local exit=$?
    local pcmode=no
    local detached=no
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        local branch="$(git branch | grep '*')"
        local status="$(git status --porcelain | sed '/??/d')"
        local untracked="$RED$(git status --porcelain | sed '/??/!D' | cut -b 1 | uniq | tr '?' '#')"
        local staged=""

        [ -n "$(echo ${status%% *} | tr -d '\n')" ] && isstaged=true || isstaged=false
        [ -n "$(echo "$status" | cut -d' ' -f2 | tr -d '\n')" ] && isunstaged=true || isunstaged=false

        if [ "$isstaged" = true ] && [ "$isunstaged" = true ]; then
            staged="$GREEN+$YELLOW%% "
        elif [ "$isstaged" = true ] && [ "$isunstaged" = false ]; then
            staged="$GREEN+ "
        elif [ "$isstaged" = false ] && [ "$isunstaged" = true ]; then
            staged="$YELLOW%% "
        else
            staged=""
        fi
        printf "$PURPLE${branch##* } ${untracked}${staged}"
    fi
}

get_exit() {
    [ "$?" = 0 ] && printf "$GREEN" || printf "$RED"
}

# simple quotes to make git verification work, may need to adapt to others shells
PS1='$BLUE\w $(git_info)\n$(get_exit)>$NORMAL '

#set -o vi
set -o csh-history


# git autocomplete
set -A complete_git_1 -- \
    add am archive \
    br bisect branch bundle \
    co cip cl checkout cherry-pick citool clean clone commit config \
    d ds describe diff \
    fp fetch format-patch \
    gc grep gui \
    init \
    l log \
    merge mv \
    notes \
    pll psh pull push \
    rb range-diff rebase reset restore revert rm \
    st shortlog show sparse-checkout stash status submodule switch \
    tag \
    worktree
# end git autocomplete

PAGER="vimpager"
HISTSIZE="10000"
HISTFILE="$HOME/.okshhistory"

export PS1 HISTSIZE HISTFILE PAGER

# Export bin
export PATH="${PATH}:${HOME}/.local/bin/"

# Set Editor
export EDITOR="nano"

# Man page for nvim
export MANPAGER="nvim -c 'set ft=man' -"

#aliases
alias ls='lsd'
alias obs='LIBGL_ALWAYS_SOFTWARE=1 obs'
alias text='figlet'
alias cat='bat --color always'
alias top='bpytop'
# you can put as many files do you want
0x0() {
for i in "$@"; do
    curl -F file=@$i http://0x0.st
done
}

# download file based on the clipboard (need xclip)
down() {
    aria2c "$(wl-paste 2>/dev/null || xclip -o 2>/dev/null)"
}

# play video based on the clipboard (need mpv)
play() {
    mpv "$(wl-paste 2>/dev/null || xclip -o 2>/dev/null)"
}

# play audio based search
yplay() {
    mpv --ytdl-format=bestaudio ytdl://ytsearch:"$*"
}

# making the life easier and avoiding typing always the password of ssh key
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ -z "$SSH_AUTH_SOCK" ]]; then
    . "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi
