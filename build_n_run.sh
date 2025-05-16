#!/usr/bin/env bash

# Script intented to run *INSIDE* a docker container ti builds and runs mkdotenv inside an arch linux container
set -euo pipefail

#!/usr/bin/env bash

sudo chown $(whoami) ${PWD}

updpkgsums 
makepkg -si --noconfirm 

if [[ $# -gt 0 ]]; then
    echo "Running post-install command: $*"
    exec "$@"
fi
