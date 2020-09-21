# SETENV

This project helps manage project-specific environmental variables: There when
you want 'em, gone when you don't.

## Usage

* Clone this repository and copy the `setenv.sh` file to the root of your project.

* If installing for the first time - PERFORM INITIAL SETUP OF THE VIRTUAL ENVIRONMENT (by issuing `virtualenv venv`)

* Create a file named `.env` and list your project's environmental variables,
e.g., `DATABASE=/path/to/database.db`

* Issue: `source setenv.sh` to set up environment variables _AND_ start the virutalenv. If the venv
and environment variables are correctly setup a `[VENV+]` indicator will appear on the left
hand side of the prompt in bold purple. (Issuing `pip -V` should also show the directory of the 
virtual environment's python interpreter.)

* Issue: `usetenv` to exit the virtual environment _AND_ unset all environment variables.

__NOTES__:

* This will completely override the builtin `deactivate` command.
* The default venv scripts are not modified; so the canned venv setup script will still work out of
the box if you chose to use it. However, if you launch `setenv` (using `source setenv.sh`), any
interaction with the canned venv scripts will be __disabled__.
