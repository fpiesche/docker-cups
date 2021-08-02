#!/bin/bash -e

echo "Setting up print admin user..."
# add print user
if [ ! -d /home/admin ]; then
    adduser --home /home/admin --shell /bin/bash --gecos "admin" --disabled-password admin
fi

if [ -z ${ADMIN_PASSWORD} ]; then
    ADMIN_PASSWORD=$(cat /dev/urandom | head -c${1:-8} | base64)
    echo "No admin password given; defaulting to ${ADMIN_PASSWORD}"
fi

adduser admin sudo
adduser admin lp
adduser admin lpadmin
echo -e "${ADMIN_PASSWORD}\n${ADMIN_PASSWORD}" | passwd admin
echo 'admin ALL=(ALL:ALL) ALL' >> /etc/sudoers

echo "Setting up cups to allow remote admin and share printers..."
service cups start
cupsctl --remote-admin --remote-any --share-printers
service cups stop

if [ ! -z ${INSTALL_HP_PLUGIN} ]; then
    echo "Setting up HP drivers..."
    bash /setup_scripts/hp_drivers.sh
fi

echo "Running any custom setup scripts..."
if compgen -G "/setup_scripts/custom/*.sh" > /dev/null; then
    for script in /setup_scripts/*.sh; do
        echo "Running ${script}..."
        bash ${script}
    done
fi

echo "Launching cupsd."
cupsd -f
