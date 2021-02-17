#!/usr/bin/env bash

# Exit on error of any command
set -e

# Check for root access
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Check if service is running already
if systemctl is-active --quiet mailifier.service; then
    echo "Malifier is active"
    echo "Stopping service to replace it"
    systemctl stop mailifier.service
else
    echo "Malifier is inactive"
    echo "Continuing replacement of service"
fi

echo "Installing configuration"
mkdir -p /etc/mailifier
cp mailifier.conf /etc/mailifier/
echo "Done"

echo "Installing executables"
cp mailifier /usr/sbin/
cp mailifier_notify /usr/bin/
echo "Done"

echo "Installing service"
cp mailifier.service /etc/systemd/system/
systemctl enable mailifier.service
systemctl start mailifier.service
echo "Done"

echo "### Installation done ###"