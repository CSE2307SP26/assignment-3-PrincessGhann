
#!/bin/bash

expected=$1
output=$2

while read -r key; do
    [ -z "$key" ] && continue

    url="https://github.com/CSE2307SP26/${key}.git"
    git clone "$url" "$key" 2>/dev/null

    if [ -d "$key" ]; then
        cd "$key" || exit

        git checkout cipher 2>/dev/null

        commit=$(git rev-list -n 1 --before="2026-02-12 10:00:00 -0600" cipher)
        git checkout "$commit" 2>/dev/null

        javac Cipher.java 2>/dev/null
        java Cipher > "$output" 2>/dev/null

        score=0
        if [ -f "$output" ]; then
            if diff -q "$output" "../$expected" > /dev/null; then
                score=1
            else
                score=0
            fi
        else
            score=0
        fi

        echo "${key} ${score}"
        cd ..
        if [ -f "$output" ]; then
                if diff -q "$output" "$expected" > /dev/null; then
                    score=100
                else
                    score=0
