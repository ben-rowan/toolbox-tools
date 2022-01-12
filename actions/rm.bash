#!/usr/bin/env bash

. ${scriptRootDir}/lib/commands.bash;
. ${scriptRootDir}/lib/prompts.bash;

name="${2}";

shouldRmToolbox=$(promptYesOrNo "Do you want to remove toolbox '${name}'?");

if [[ "${shouldRmToolbox}" == 'n' ]]; then
    echo "Aborting";
    exit;
fi

echo ">>> Stopping container";
podman stop "${name}";

echo ">>> Removing container";
podman rm "${name}";