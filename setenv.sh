#------------------------------------------------------------------------------
# Setting project specific environmental variables
#
# Franklin Chou
# 05 APR 2016
#
# Usage:
# To set project environment variables, issue `source setenv`
# To clean up, issue `usetenv`
#------------------------------------------------------------------------------

BPurple='\e[1;35m'      # Bold Purple
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green

BRed='\e[1;31m'         # Bold Red

Color_Off='\e[0m'       # Text Reset

#------------------------------------------------------------------------------

# Internal functions

# Takes two parameters, the first being the original function name,
#   the second being the replacement function name.

# See http://mivok.net/2009/09/20/bashfunctionoverrist.html
__override() {
    local orig_func=$(declare -f $1)
    local new_func="$2${orig_func#$1}"
    eval "$new_func"
}


# Sanitizing variables draws inspiration from:
#   https://github.com/rbenv/rbenv-vars
__sanitize() {
    :
}

#------------------------------------------------------------------------------

# Detect proper environment

if [ "$SHELL" != "/bin/bash" ]; then
    printf "${BRed}Error:${Color_Off} ""Improper environment detected.\n"
    printf "  \`setenv\` currently only supports BASH.\n"
    return
fi

#------------------------------------------------------------------------------

# Interact (& override) the default behaviour bundled w/the virtualenv
#   bash scripts

declare _venv=venv

if [ ! -e "${_venv}""/bin/activate" ]; then
    printf "${BRed}Error:${Color_Off} ""Improperly configured virtual environment.\n"
    printf "  Virtual environment directory at \`"${_venv}"\` not detected.\n"
    return
fi

# Check venv status
if [ -z "$VIRTUAL_ENV" ]; then
    # If no venv is running, activate the venv.
    printf "Setting up virtual environment...\n"

    # Override the PS1 used by venv
    _old_ps1="$PS1"
    source "$_venv""/bin/activate"
    PS1="$_old_ps1"

    # Override the `deactivate` command used by venv
    __override deactivate canned_deactivate

    # Destroy reference to the original deactivate command
    unset deactivate
else
    printf "${BRed}Error: ${Color_Off} ""A virtual environment has been detected.\n"
    printf "  Deactivate the existing virutal environment and reissue \`source setenv\`.\n"
    return
fi

#------------------------------------------------------------------------------

declare _env_file=.env
declare -i ENV_VAR

function usetenv {

    # As per [issue 3], call deactivate (venv) from setenv

    # Check venv status
    if [ -z "$VIRTUAL_ENV" ]; then
        # unexpected error
        return
    else
        # If a virtual environment is detected, shut it down
        canned_deactivate
    fi

    local key value
    while IFS='=' read -r key value; do
        unset "$key"
    done < "$PROJ_ROOT/$_env_file"

    if [ -n "$_old_ps1" ]; then
        PS1="$_old_ps1"
        export PS1
        unset _old_ps1
    fi

    unset ENV_VAR
    unset -f usetenv
    unset _env_file
    unset PROJ_ROOT

    unalias ph
}

function __setvars {
    printf "Setting project environment variables...\n"

    local key value

    while IFS='=' read -r key value; do
        if [ -n "${key}" ]; then
            export "$key""=""$value"
            printf "\t${Green}%s${Color_Off}\t%s\n" '[OK]' $key
        else
            printf "\t${Red}%s${Color_Off}\t%s\n" '[FAIL]' $key
        fi
    done < "$_env_file"

    printf "\n"

    _old_ps1="$PS1"
    PS1="\[$BPurple\][VENV+]\[$Color_Off\] $PS1"
    export PS1

    # Issue `ph` to return to project home dir.
    alias ph='cd ${PROJ_ROOT}'

    printf "To deactivate and unset all environment variables, issue \`usetenv\`.\n"
}

if [ ! -f "$_env_file" ]; then
    printf "${BRed}Error:${Color_Off} ""Environment variables not found.\n"
    printf "  Execute from project root.\n"
elif [ "$ENV_VAR" == 1 ]; then
    printf "Environment variables already set. Nothing to do.\n"
else
    __setvars
    declare PROJ_ROOT="${PWD}"
    export ENV_VAR=1
fi
