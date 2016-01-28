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
    for line in $(cat "$_env_file"); do
        var=$(echo "$line" | cut -f1 -d"=")
        unset $var
    done

    if [ -n "$_old_ps1" ]; then
        PS1="$_old_ps1"
        export PS1
        unset _old_ps1
        unset ENV_VAR
    fi
}

function __setvars {
    echo "Setting project environment variables..."

    for line in $(cat $_env_file); do
        var="$(echo $line | cut -f1 -d"=")"
        if [ -n ${line} ]; then
            export echo "${line}"
            var="$(echo $line | cut -f1 -d"=")"
            printf "\t${Green}%s${Color_Off}\t%s\n" '[OK]' $var
        else
            printf "\t${Red}%s${Color_Off}\t%s\n" '[FAIL]' $var
        fi
    done

    echo

    _old_ps1="$PS1"
    PS1="\[$BPurple\][ENV]\[$Color_Off\] $PS1"
    export PS1
}

if [ ! -f "$_env_file" ]; then
    echo "Error: Environment variables not found."
elif [ "$ENV_VAR" == 1 ]; then
    echo "Environment variables already set."
else
    __setvars
    export ENV_VAR=1
fi
