# Avoid the CachyOS alias named c before defining the directory picker.
unalias c 2>/dev/null

prettylog() {
    git log \
        --graph \
        --all \
        --decorate \
        --date=short \
        --pretty=format:'%C(auto)%h%C(reset) %C(dim white)%ad%C(reset) %C(auto)%d%C(reset) %s %C(dim white)- %an%C(reset)'
}

esp_activate() {
    local export_script="$HOME/git/esp-idf/export.zsh"
    if [[ ! -f "$export_script" ]]; then
        print -u2 "ESP-IDF export script not found: $export_script"
        return 1
    fi
    source "$export_script"
}

c() {
    local dir
    dir="$(sx-dir-pick)" || return
    [[ -n "$dir" ]] && cd "$dir"
}
