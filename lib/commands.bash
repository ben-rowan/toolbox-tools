#!/usr/bin/env bash

function run {
    local toolboxName="${1}";
    shift;

    toolbox run --container "${toolboxName}" $@;
}

function doesToolboxExist {
    local toolboxName="${1}";

    # Using grep here in place of podmans --filter as --filter allows partial matches.
    if [[ $(podman ps -a --format "{{.Names}}" | grep "^${toolboxName}\$" | wc -l) -gt 0 ]]; then
        echo 'y';
    else 
        echo 'n';
    fi
}

function createToolbox {
    local toolboxName="${1}";

    toolboxExists=$(doesToolboxExist "${toolboxName}");

    if [[ "${toolboxExists}" == 'y' ]]; then
        echo "Toolbox '${toolboxName}' already exists, skipping toolbox create";
    else
        echo "Creating new toolbox '$toolboxName'";

        toolbox create "${toolboxName}";
        update "${toolboxName}";
    fi
}

function install {
    local toolboxName="${1}";
    shift;

    run "${toolboxName}" sudo dnf install -y $@;
}

function update {
    local toolboxName="${1}";

    run "${toolboxName}" sudo dnf update -y;
}