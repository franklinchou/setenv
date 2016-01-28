# SETENV

This project helps manage project-specific environmental variables: There when
you want 'em, gone when you don't.

## Usage

* Clone this repository and copy the `setenv.sh` file to the root of your
project.

* Create a file named `.env` and list your project's environmental variables,
e.g., `DATABASE='/path/to/database.db'`

* Issue: `source setenv.sh` to set up environment variables. If all the
variables are correctly setup a `[ENV]` indicator will appear on the left
hand side of the prompt in bold purple. (Draws inspiration from the
virtualenvironment indicator in Python.)

* Issue: `usetenv` to unset all environment variables.
