#!/bin/bash

echo "Installing OS Packages..."
PKG_LIST=$(grep -v '#' /config/bindep.txt | tr '\n' ' ')
echo "To be installed: $PKG_LIST"
apt-get update && apt-get install -y $PKG_LIST