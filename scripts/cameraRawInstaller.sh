#!/usr/bin/env bash
function main() {
    
    source "sharedFuncs.sh"

    load_paths
    WINEPREFIX="$SCR_PATH/prefix"

    #resources will be remove after installation
    RESOURCES_PATH="$SCR_PATH/resources"
    
    export_var
    wget -O CameraRaw_12_2_1.exe "https://github.com/shipa-2/photoshopCClinux-Remixed/releases/download/files/uninterested"

    echo "===============| Adobe Camera Raw v12 |===============" >> "$SCR_PATH/wine-error.log"

    wine CameraRaw_12_2_1.exe

}

main
