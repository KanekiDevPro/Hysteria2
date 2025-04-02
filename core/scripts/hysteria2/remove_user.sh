#!/bin/bash

source /etc/hysteria/core/scripts/path.sh
source /etc/hysteria/core/scripts/utils.sh
define_colors

remove_user() {
    if [ $# -ne 1 ]; then
        echo "Usage: $0 <username>"
        exit 1
    fi

    local username=$1

    if [ -f "$USERS_FILE" ]; then
        if jq -e "has(\"$username\")" "$USERS_FILE" > /dev/null; then
            jq --arg username "$username" 'del(.[$username])' "$USERS_FILE" > "${USERS_FILE}.temp" && mv "${USERS_FILE}.temp" "$USERS_FILE"

            echo "User $username removed successfully."
        else
            echo -e "${red}Error:${NC} User $username not found."
        fi
    else
        echo -e "${red}Error:${NC} Config file $USERS_FILE not found."
    fi
}
python3 "$CLI_PATH" restart-hysteria2 > /dev/null 2>&1
remove_user "$1"
