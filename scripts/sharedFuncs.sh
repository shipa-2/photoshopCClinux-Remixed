
#has tow mode [pkgName] [mode=summary]
function package_installed() {
    which $1 &> /dev/null
    local pkginstalled="$?"

    if [ "$2" == "summary" ];then
        if [ "$pkginstalled" -eq 0 ];then
            echo "true"
        else
            echo "false"
        fi
    else    
        if [ "$pkginstalled" -eq 0 ];then
            show_message "package\033[1;36m $1\e[0m is installed..."
        else
            warning "package\033[1;33m $1\e[0m is not installed.\nplease make sure it's already installed"
            ask_question "would you continue?" "N"
            if [ "$question_result" == "no" ];then
                echo "exit..."
                exit 5
            fi
        fi
    fi
}

function setup_log() {
    echo -e "$(date) : $@" >> $SCR_PATH/setuplog.log
}

function show_message() {
    echo -e "$@"
    setup_log "$@"
}

function error() {
    echo -e "\033[1;31merror:\e[0m $@"
    setup_log "$@"
    exit 1
}

function error2() {
    echo -e "\033[1;31merror:\e[0m $@"
    exit 1
}

function warning() {
    echo -e "\033[1;33mWarning:\e[0m $@"
    setup_log "$@"
}

function warning2() {
    echo -e "\033[1;33mWarning:\e[0m $@"
}

function show_message2() {
    echo -e "$@"
}

function launcher() {
    
    #create launcher script
    local launcher_path="$PWD/launcher.sh"
    local launcher_dest="$SCR_PATH/launcher"
    rmdir_if_exist "$launcher_dest"


    if [ -f "$launcher_path" ];then
        show_message "launcher.sh detected..."
        
        cp "$launcher_path" "$launcher_dest" || error "can't copy launcher"
        
        sed -i "s|pspath|$SCR_PATH|g" "$launcher_dest/launcher.sh" && sed -i "s|pscache|$CACHE_PATH|g" "$launcher_dest/launcher.sh" || error "can't edit launcher script"
        
        chmod +x "$SCR_PATH/launcher/launcher.sh" || error "can't chmod launcher script"
    else
        error "launcher.sh Note Found"
    fi

    #create desktop entry
    local desktop_entry="$PWD/photoshop.desktop"
    local desktop_entry_dest="/home/$USER/.local/share/applications/photoshop.desktop"
    
    if [ -f "$desktop_entry" ];then
        show_message "desktop entry detected..."
       
        #delete desktop entry if exists
        if [ -f "$desktop_entry_dest" ];then
            show_message "desktop entry exist deleted..."
            rm "$desktop_entry_dest"
        fi
        cp "$desktop_entry" "$desktop_entry_dest" || error "can't copy desktop entry"
        sed -i "s|pspath|$SCR_PATH|g" "$desktop_entry_dest" || error "can't edit desktop entry"
    else
        error "desktop entry Not Found"
    fi

    #change photoshop icon of desktop entry
    local entry_icon="../images/AdobePhotoshop-icon.png"
    local launch_icon="$launcher_dest/AdobePhotoshop-icon.png"

    cp "$entry_icon" "$launcher_dest" || error "can't copy icon image"
    sed -i "s|photoshopicon|$launch_icon|g" "$desktop_entry_dest" || error "can't edit desktop entry"
    sed -i "s|photoshopicon|$launch_icon|g" "$launcher_dest/launcher.sh" || error "can't edit launcher script"
    
    #create photoshop command
    show_message "create photoshop command..."
    if [ -f "/usr/local/bin/photoshop" ];then
        show_message "photoshop command exist deleted..."
        sudo rm "/usr/local/bin/photoshop"
    fi
    sudo mkdir -p "/usr/local/bin"
    sudo ln -s "$SCR_PATH/launcher/launcher.sh" "/usr/local/bin/photoshop" || error "can't create photoshop command"

    unset desktop_entry desktop_entry_dest launcher_path launcher_dest
}

function export_var() {
    export WINEPREFIX="$WINEPREFIX"
    show_message "wine variables exported..."
}

function rmdir_if_exist() {
    if [ -d "$1" ];then
        rm -rf "$1"
        show_message "\033[0;36m$1\e[0m directory exists deleting it..."
    fi
    mkdir "$1"
    show_message "create\033[0;36m $1\e[0m directory..."
}

function save_paths() {
    local datafile="$HOME/.psdata.txt"
    echo "$SCR_PATH" > "$datafile"
    echo "$CACHE_PATH" >> "$datafile"
    unset datafile
}

function load_paths() {
    local datafile="$HOME/.psdata.txt"
    SCR_PATH=$(head -n 1 "$datafile")
    CACHE_PATH=$(tail -n 1 "$datafile")
    unset datafile
}
