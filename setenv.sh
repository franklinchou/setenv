#------------------------------------------------------------------------------
# Setting project specific environmental variables
#
# Franklin Chou
# 28 JAN 2016
#
# Usage:
# To set project environment variables, issue `source setenv`
# To clean up, issue `usetenv`
#------------------------------------------------------------------------------

BPurple='\e[1;35m'      # Bold Purple
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Color_Off='\e[0m'       # Text Reset

declare _env_file=.env
declare -i ENV_VAR

# Sanitizing variables draws inspiration from:
#   https://github.com/rbenv/rbenv-vars
__sanitize() {
    :
}

function usetenv {
    local key value
    while IFS='=' read -r key value; do
        unset "$key"
    done < "$_env_file"

    if [ -n "$_old_ps1" ]; then
        PS1="$_old_ps1"
        export PS1
        unset _old_ps1
    fi

    unset ENV_VAR
    unset -f usetenv
    unset _env_file
}

function __setvars {
    echo "Setting project environment variables..."

    local key value

    while IFS='=' read -r key value; do
        if [ -n ${key} ]; then
            export "$key""=""$value"
            printf "\t${Green}%s${Color_Off}\t%s\n" '[OK]' $key
        else
            printf "\t${Red}%s${Color_Off}\t%s\n" '[FAIL]' $key
        fi
    done < "$_env_file"

    printf "\n"

    _old_ps1="$PS1"
    PS1="\[$BPurple\][ENV]\[$Color_Off\] $PS1"
    export PS1
}

if [ ! -f "$_env_file" ]; then
    printf "Error: Environment variables not found.\n"
elif [ "$ENV_VAR" == 1 ]; then
    printf "Environment variables already set.\n"
else
    __setvars
    export ENV_VAR=1
fi
