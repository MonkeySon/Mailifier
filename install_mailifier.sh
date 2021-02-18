#!/usr/bin/env bash

# Exit on error of any command
set -e

# Variables / Constants
OVERWRITE_ARG="--overwrite-config"

# Print usage
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "usage: $(basename $0) [ ( -h | --help ) | $OVERWRITE_ARG ]"
    echo "  -h, --help         ... shows this dialog"
    echo "  --overwrite-config ... overwrites the existing configuration"
    exit 1
fi

# Check for root access
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Check if service is running already
if systemctl is-active --quiet mailifier.service; then
    echo "Malifier is active, stopping service to replace it"
    systemctl stop mailifier.service
else
    echo "Malifier is inactive, continuing replacement of service"
fi

# Check if config already exists
if [[ -e /etc/mailifier/mailifier.conf ]]; then
    if [[ "$1" == "$OVERWRITE_ARG" ]]; then
        # With argument, overwrite config
        echo "Configuration already exists, overwriting it"
        cp mailifier.conf /etc/mailifier/
    else
        # By default, keep config but show diff to user
        echo "Configuration already exists, please check diff for changes:"
        echo "#####"
        set +e
        diff mailifier.conf /etc/mailifier/mailifier.conf
        set -e
        echo "#####"
        echo "Press any key to continue"
        read
    fi
else
    echo "Installing configuration"
    mkdir -p /etc/mailifier
    cp mailifier.conf /etc/mailifier/
    echo "Done"
fi

echo "Installing executables"
cp mailifier /usr/sbin/
chmod +x /usr/sbin/mailifier
cp mailifier_notify /usr/bin/
chmod +x /usr/bin/mailifier_notify
echo "Done"

echo "Installing service"
cp mailifier.service /etc/systemd/system/
systemctl enable mailifier.service
systemctl start mailifier.service
echo "Done"

echo "### Installation done ###"
