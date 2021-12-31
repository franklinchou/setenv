# SETENV

This project helps manage project-specific environmental variables: There when
you want 'em, gone when you don't.

## Usage

* Clone this repository and copy the `setenv.sh` file to the root of your project.

* (For Python projects only) If installing for the first time - PERFORM INITIAL SETUP OF THE VIRTUAL ENVIRONMENT (by issuing `virtualenv venv`)

* Create a file named `.env` in the project's root directory and list your project specific environmental variables,
e.g., `DATABASE=/path/to/database.db`

* Issue: `source setenv.sh` to set up environment variables (this will also start the virtualenv for Python projects). If the environment variables are 
setup  correctly a `[VENV+]` indicator will appear on the left
hand side of the prompt in bold purple. (For Python projects, issuing `pip -V` should also show the directory of the 
virtual environment's Python interpreter.)

* Issue: `usetenv` to unset all environment variables. (For Python projects this will also exit the virtualenv).

__NOTES__ (For Python projects only):

* This will completely override the builtin `deactivate` command.
* The default venv scripts are not modified; so the canned venv setup script will still work out of
the box if you chose to use it. However, if you launch `setenv` (using `source setenv.sh`), any
interaction with the canned venv scripts will be __disabled__.
