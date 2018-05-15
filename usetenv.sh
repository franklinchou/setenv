function usetenv {
    if [ -z "$VIRTUAL_ENV" ]; then
        # Unexpected error
        return
    elif [ -z "$ENV_VAR" ]; then
        printf "No project specific environment variables set."
    else
        printf "asdfasdfsa\n"
        canned_deactivate
        __unset
    fi
}



function __unset {
    local key value
    while IFS="=" read -r key value; do
        unset "$key"
    done < "$PROJ_ROOT/$_env_file"

    # Reset the command prompt
    if [ -n "$_old_ps1" ]; then
        PS1="$_old_ps1"
        export PS1
        unset _old_ps1
    fi
    
    unset ENV_VAR
    unset -f usetenv
    unset _env_file
    unset __unset
    unset PROJ_ROOT
    unalias ph
}