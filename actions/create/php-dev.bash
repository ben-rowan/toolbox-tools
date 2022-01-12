#!/usr/bin/env bash

. ${scriptRootDir}/lib/commands.bash;
. ${scriptRootDir}/lib/prompts.bash;
. ${scriptRootDir}/lib/vscode/vscode.bash;

name="${3:-php-dev}";

shouldSetupToolbox=$(promptYesOrNo "Do you want to setup toolbox '${name}'?");

if [[ "${shouldSetupToolbox}" == 'n' ]]; then
    echo "Aborting";
    exit;
fi

echo ">>> Setting up toolox";
createToolbox "${name}";

echo ">>> Setting up PHP env";
install "${name}" php-cli git;

echo ">>> Setting up VSCode";
installVsCode "${name}";
setupVSCodeAll "${name}";