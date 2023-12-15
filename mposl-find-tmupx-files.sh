#!/bin/bash 

# This script should find all .tmuxp.yml files starting from custom topdir

set -euo pipefail

LCD=$(pwd)

TMUXP_BIN=""
TMUXP_YAML_FILE=".tmuxp.yml"

FIND_BIN=""
FIND_ARGS=""
FIND_TOPDIR="${LCD}"

FZF_BIN=""

# --- MAIN CODE ---

# TODO: Consider convert this to functions
# TODO: Add arg for topdir - and setup default for /home/user

echo ""
echo "Detecting required commands..."
echo -n " - fzf: "
if FZF_BIN=$(which "fzf"); then
    echo "FOUND -> ${FZF_BIN}"
else
    echo "MISSING"
fi

echo -n " - tmuxp: "
if TMUXP_BIN=$(which "tmuxp"); then
    echo "FOUND -> ${TMUXP_BIN}"
else
    echo "MISSING"
fi


expected_cmd="fdfind"
echo -n " - ${expected_cmd}: "
if FIND_BIN=$(which "${expected_cmd}"); then
    echo "FOUND -> ${FIND_BIN}"
    FIND_ARGS="--hidden --type file ${TMUXP_YAML_FILE} ${FIND_TOPDIR}"
else
    echo "MISSING"
fi

if [[ -z "${FIND_BIN}" ]]; then
    expected_cmd="find"
    echo -n " - ${expected_cmd}: "
    if FIND_BIN=$(which "${expected_cmd}"); then
        echo "FOUND -> ${FIND_BIN}"
        FIND_ARGS="${FIND_TOPDIR} -type f -name ${TMUXP_YAML_FILE}"
    else
        echo "MISSING"
    fi
fi

echo ""
echo "Starting searching in: ${FIND_TOPDIR}"
echo "Runnnig: ${FIND_BIN} ${FIND_ARGS}"
${FIND_BIN} ${FIND_ARGS} | \
    fzf --height=40% --layout=reverse --info=inline --border | xargs tmuxp load -y

# TODO: Stop script if no all expected commands are found
