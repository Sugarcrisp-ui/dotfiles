# PATH setting
export PATH="$PATH:/opt/someApp/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:~/.bin-personal"

# Default editor
export EDITOR='micro'
export VISUAL='micro'

# System update
#alias update='sudo apt update && sudo apt upgrade && flatpak update'
alias update='sudo aptitude update && sudo aptitude safe-upgrade && flatpak update'

# Micro editor
alias mbp='micro ~/.bashrc-personal'

# Bash
alias bashup='source ~/.bashrc'

# Python
alias transfer='python /home/brett/.bin-personal/transfer.py'
alias backup='python ~/.bin-personal/file-backup-with-time.py'

# Configuration backup
alias topersonal='sudo /home/brett/.bin-personal/config-backup-to-personal.sh'
alias togithub='config-backup-github.sh'
alias toexternal='config-backup-to-external.sh'

# System information
alias sysinfo='inxi -Fxxxrz'

# Bluetooth
alias blue='bluetoothctl'

# Run previous command as sudo
alias s='sudo $(history -p !!)'
