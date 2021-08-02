#!/bin/bash

HP_PLUGIN_URL="https://developers.hp.com/sites/default/files/hplip-${HPLIP_PLUGIN_VERSION}-plugin.run"
LOCAL_PLUGIN="/tmp/hplip-${HPLIP_PLUGIN_VERSION}-plugin.run"

echo "Downloading HP printer plugin from ${HP_PLUGIN_URL}..."
wget -O ${LOCAL_PLUGIN} ${HP_PLUGIN_URL}
wget -O ${LOCAL_PLUGIN}.asc ${HP_PLUGIN_URL}.asc
yes | hp-plugin -i -p ${LOCAL_PLUGIN}
