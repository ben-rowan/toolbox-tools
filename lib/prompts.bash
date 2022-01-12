function promptYesOrNo {
    while true; do
        local yn;
        read -p "$* [y/n]: " yn;
        case $yn in
            [Yy]*) echo 'y'; return;;  
            [Nn]*) echo 'n'; return;;
        esac
    done
}

function promptForResponse {
    local response;
    read -p "$*: " response;

    echo "${response}";
}