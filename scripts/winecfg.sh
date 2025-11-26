#!/usr/bin/env bash
source "sharedFuncs.sh"

function main() {
    load_paths 
    RESOURCES_PATH="$SCR_PATH/resources"
    WINEPREFIX="$SCR_PATH/prefix"
    winecfg
}

main
