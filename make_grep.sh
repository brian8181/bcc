makecheck() {
    make "$@" 2>&1 | tee tmp.txt | grep --color=always -E "error|fail|$"
}