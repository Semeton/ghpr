#!/usr/bin/env bash
# ghpr-logo.sh — Display the ghpr logo with colors

show_logo() {
  cat << 'EOF'

█████████╗ █████╗ ██╗      ██╗███████╗███████╗
██╔═══╗██║██╔══██╗██║      ██║██╔════╝██╔════╝
██║██╗╚╝██║██║  ██║██║█████╗██║███████╗███████╗
██║╚██┗██║██║  ██║██║╚════╝██║╚════██║╚════██║
╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═╝      ╚═╝███████║███████║
                             ╚══════╝╚══════╝

  Version: 0.2.0
  Commit, push, and create PRs in one command

EOF
}

show_logo
