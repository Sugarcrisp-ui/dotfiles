#!/bin/bash

# This script should be run with root privileges via su
main_kernel_pattern="arch1-1.conf"

echo "Please enter root password to change kernel settings:"
su -c "
    # Change to the directory where bootctl operates
    cd /boot/efi/loader/entries/

    # List available kernel entries
    echo \"Available kernel entries:\"
    ls *.conf

    # Find the main kernel entry
    main_kernel_conf=\$(ls | grep -E '$main_kernel_pattern' | head -n 1)

    if [ -n \"\$main_kernel_conf\" ]; then
        echo \"Setting \$main_kernel_conf as the default kernel.\"
        bootctl set-default \"\$main_kernel_conf\"
    else
        echo \"No main kernel configuration file found matching '$main_kernel_pattern'.\"
        exit 1
    fi
"
