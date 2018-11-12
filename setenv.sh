#------------------------------------------------------------------------------
# Setting project specific environmental variables
#
# Franklin Chou
# 11 NOV 2018
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

# Constants

declare _ENV_FILE=.env
declare -i _ENV_VAR
declare _VENV=venv
declare PROJ_ROOT="${PWD}"

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

#------------------------------------------------------------------------------

# Detect proper environment

if [ "$SHELL" != "/bin/bash" ]; then
    printf "${BRed}Error:${Color_Off} ""Improper environment detected.\n"
    printf "  \`setenv\` currently only supports BASH.\n"
    return
fi

#------------------------------------------------------------------------------


function __set_vars {
    printf "Setting project environment variables...\n"

    local key value

    while IFS='=' read -r key value; do
        if [ -n "${key}" ]; then
            export "$key""=""$value"
            printf "\t${Green}%s${Color_Off}\t%s\n" '[OK]' $key
        else
            printf "\t${Red}%s${Color_Off}\t%s\n" '[FAIL]' $key
        fi
    done < "$_ENV_FILE"

    printf "\n"

    _old_ps1="$PS1"
    PS1="\[$BPurple\][VENV+]\[$Color_Off\] $PS1"
    export PS1

    # Issue `ph` to return to project home dir.
    alias ph='cd ${PROJ_ROOT}'

    printf "To deactivate and unset all environment variables, issue \`usetenv\`.\n"
}

#------------------------------------------------------------------------------

function __set_venv {
    # Check venv status
    if [ -z "$VIRTUAL_ENV" ]; then
        # If no venv is running, activate the venv.
        printf "Python environment detected: setting up virtual environment...\n"

        # Override the PS1 used by venv
        _old_ps1="$PS1"
        source "$_VENV""/bin/activate"
        PS1="$_old_ps1"

        # Override the `deactivate` command used by venv
        __override deactivate canned_deactivate

        # Destroy reference to the original deactivate command
        unset deactivate
    else
        printf "${BRed}Error: ${Color_Off} ""A virtual environment has been detected.\n"
        printf "  Deactivate the existing virtual environment and reissue \`source setenv\`.\n"
        return
    fi
}

#------------------------------------------------------------------------------

# Unset

function usetenv {
    if [ -d "$PROJ_ROOT/$_VENV" ]; then
        printf "Deactivating Python virtual environment...\n"
        canned_deactivate
    fi
    
    __unset
}

function __unset {
    printf "Unsetting project specific environment variables.\n"
    local key value
    while IFS="=" read -r key value; do
        unset "$key"
    done < "$PROJ_ROOT/$_ENV_FILE"

    # Reset the command prompt
    if [ -n "$_old_ps1" ]; then
        PS1="$_old_ps1"
        export PS1
        unset _old_ps1
    fi
    
    unset _ENV_VAR
    unset -f usetenv
    unset _ENV_FILE

    unset __unset
    unset PROJ_ROOT
    unalias ph
}

#------------------------------------------------------------------------------

# MAIN

if [ ! -f "$_ENV_FILE" ]; then
    printf "${BRed}Error:${Color_Off} ""Environment variables not found.\n"
    printf "  Create \`.env\` file or execute from project root.\n"
    return
elif [ "$_ENV_VAR" == 1 ]; then
    printf "Environment variables already set. Nothing to do.\n"
    return
elif [ -e "${_VENV}""/bin/activate" ]; then
    __set_venv
    __set_vars
    export _ENV_VAR=1  
else
    __set_vars
    export _ENV_VAR=1  
fi
  
