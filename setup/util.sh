################################################################################
# About
#
# Utility functions for the rest of the setup phases, provided by `source`ing
# from `post-init.sh`. Any functions needed by `init.sh` should be copied over
# since it is standalone.
################################################################################

################################################################################
# Logging
################################################################################

# ANSI styling (https://en.wikipedia.org/wiki/ANSI_escape_code#Description).
ANSI_CSI=$'\033['
STYLE_RED="${ANSI_CSI}0;31;1m"
STYLE_GREEN="${ANSI_CSI}0;32;1m"
STYLE_YELLOW="${ANSI_CSI}0;33;1m"
STYLE_MAGENTA="${ANSI_CSI}0;35;1m"
STYLE_CYAN="${ANSI_CSI}0;36;1m"
STYLE_BOLD="${ANSI_CSI}1m"
STYLE_OFF="${ANSI_CSI}0m"

log_fatal() {
    echo "  ${STYLE_RED}fatal:${STYLE_OFF} $@"
    exit 1
}

log_error() {
    echo "  ${STYLE_RED}error:${STYLE_OFF} $@"
}

log_success() {
    echo "${STYLE_GREEN}success:${STYLE_OFF} $@"
}

log_warning() {
    echo "${STYLE_YELLOW}warning:${STYLE_OFF} $@"
}

log_status() {
    echo " ${STYLE_MAGENTA}status:${STYLE_OFF} $@"
}

log_skip() {
    echo "   ${STYLE_CYAN}skip:${STYLE_OFF} $@"
}

log_todo() {
    echo "   ${STYLE_CYAN}todo:${STYLE_OFF} $@"
}

################################################################################
# Reading Input
################################################################################

# Read a single character from the terminal.
read_char() {
    # The variable to write to.
    local OUT_VAR="$@"

    local PREV_STATE
    PREV_STATE="$(/bin/stty -g)"
    /bin/stty raw -echo
    IFS='' read -r -n 1 -d '' "$OUT_VAR"
    /bin/stty "${PREV_STATE}"
}

# Read a return character from the terminal.
read_return() {
    local INPUT
    read_char INPUT

    if ! [[ "${INPUT}" == $'\n' || "${INPUT}" == $'\r' ]]; then
        return 1
    fi
}
