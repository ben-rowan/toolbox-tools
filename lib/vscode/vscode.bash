#!/usr/bin/bash

. ${scriptRootDir}/lib/commands.bash;

function isVSCodeInstalled {
    local toolboxName="${1}";

    if [[ $(toolbox run --container "${toolboxName}" command -v code | wc -l) -gt 0 ]]; then
        echo 'y';
    else 
        echo 'n';
    fi
}

function installVsCode {
    local toolboxName="${1}";
    local alreadyInstalled=$(isVSCodeInstalled "${toolboxName}");

    if [[ 'y' == "${alreadyInstalled}" ]]; then
        echo 'VSCode is already installed. Skipping install';
        return 0;
    fi

    # How to install vscode:
    # - https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions

    echo 'Importing Microsoft GPG key';
    run "${toolboxName}" sudo rpm --import 'https://packages.microsoft.com/keys/microsoft.asc';
    echo 'Adding VSCode repo';
    cp ${scriptRootDir}/lib/vscode/vscode.repo /tmp; # /tmp contents are available within the toolbox
    run "${toolboxName}" sudo mv /tmp/vscode.repo /etc/yum.repos.d/vscode.repo;
    echo 'Installing VSCode';
    update "${toolboxName}";
    install "${toolboxName}" code;
}

function installVSCodeExtension {
    local toolboxName="${1}";
    local extension="${2}";

    run "${toolboxName}" code --force --install-extension "${extension}";
}

function setupVSCodePhpSupport {
    local toolboxName="${1}";

    local extensions=(
        'bmewburn.vscode-intelephense-client'
        'mehedidracula.php-namespace-resolver'
        'felixfbecker.php-debug'
    )

    for extension in "${extensions[@]}"; do
        installVSCodeExtension "${toolboxName}" "${extension}";
    done    
}

function setupVSCodeBashSupport {
    local toolboxName="${1}";

    local extensions=(
        'mads-hartmann.bash-ide-vscode'
    )

    for extension in "${extensions[@]}"; do
        installVSCodeExtension "${toolboxName}" "${extension}";
    done

    # TODO: try setting up bash language server / explainshell:
    # - https://github.com/bash-lsp/bash-language-server
    # - Ideally this would live in another container.
}

function setupVSCodeAll {
    local toolboxName="${1}";

    local extensions=(
        'vscode-icons-team.vscode-icons'
    )

    for extension in "${extensions[@]}"; do
        installVSCodeExtension "${toolboxName}" "${extension}";
    done

    setupVSCodePhpSupport "${toolboxName}";
    setupVSCodeBashSupport "${toolboxName}";
}