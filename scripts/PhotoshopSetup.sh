#!/usr/bin/env bash
source "sharedFuncs.sh"

function main() {

    mkdir -p $SCR_PATH
    mkdir -p $CACHE_PATH

    setup_log "================| script executed |================"

    RESOURCES_PATH="$SCR_PATH/resources"
    WINEPREFIX="$SCR_PATH/prefix"

    #create new wine prefix for photoshop
    rmdir_if_exist $WINEPREFIX

    #export necessary variable for wine
    export_var

    #config wine prefix and install mono and gecko automatic
    winecfg -v win7
    #create resources directory
    rmdir_if_exist $RESOURCES_PATH

    winetricks --self-update
    winetricks -q atmlib fontsmooth=rgb vcrun2008 vcrun2010 vcrun2012 vcrun2013 atmlib msxml3 msxml6

    #install photoshop

    #wget -O photoshop_cc.exe "https://github.com/shipa-2/photoshopCClinux-Remixed/releases/download/files/uninterestedfile.mp4"

    echo "===============| photoshop CC v19 |===============" >> "$SCR_PATH/wine-error.log"
    echo "install photoshop..."
    echo "Please don't change default Destination Folder"

    wine photoshop_cc.exe &>> "$SCR_PATH/wine-error.log" || error "sorry something went wrong during photoshop installation"

    echo "removing useless things"
    rm "$WINEPREFIX/drive_c/users/$USER/PhotoshopSE/Required/Plug-ins/Spaces/Adobe Spaces Helper.exe"
    rm "$WINEPREFIX/drive_c/users/$USER/PhotoshopSE/Resources/IconResources.idx"
    rm "$WINEPREFIX/drive_c/users/$USER/PhotoshopSE/Resources/PSIconsHighRes.dat"
    rm "$WINEPREFIX/drive_c/users/$USER/PhotoshopSE/Resources/PSIconsLowRes.dat"

    cd replacement
    cp -f * "$WINEPREFIX/drive_c/users/$USER/PhotoshopSE/Resources/" || error "cant copy replacement files..."
    cd ..

    echo "photoshopCC V19 x64 installed..."

    if [ -d $RESOURCES_PATH ];then
        echo "deleting resources folder"
        rm -rf $RESOURCES_PATH
    else
        error "resources folder Not Found"
    fi

    launcher
    echo "when you run photoshop for the first time it may take a while"
    echo "Almost finished..."
    sleep 5
}

save_paths
main
