#warn user of get-loaders deprecation
cobbler() {
    if [[ $@ == "get-loaders" ]]; then
        echo "This feature is deprecated and will be removed see https://github.com/cobbler/cobbler/issues/2587"
    else
       command cobbler "$@"
    fi
}
