# Dockerised CUPS service

You will need to run this container in "privileged" mode to be able
to access printers on the host machine.

On startup, the container will automatically create an admin user for cups,
called `admin`. The password for this will be randomly generated unless a
specific password is given via the `ADMIN_PASSWORD` environment variable.

Custom shell scripts required for setup (e.g. to install custom printer
drivers) can be mounted in `/setup_scripts/custom/`. A script to install
the HP printer drivers via `hplip` is included and can be enabled by setting
the `INSTALL_HP_PLUGIN` environment variable.
