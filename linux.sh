#!/bin/bash

zsign_url="https://github.com/zhlynn/zsign.git"

echo -e "SelfSign Setup, \e[32mLinux Script\e[0m"
echo "Starting the main process"

clone_zsign() {
  output=$(git clone "$zsign_url" SelfSign/zsign 2>&1)
  lines=$(echo "$output" | wc -l)
  count=0

  while IFS= read -r line; do
    count=$((count + 1))
    percentage=$((count * 100 / lines))
    progress="["
    for ((i = 0; i < percentage; i+=2)); do
      progress+="="
    done
    progress+=">"

    echo -ne "Cloning progress: $progress $percentage% \r"
  done <<<"$output"

  echo "Cloning progress: [==================================================> 100%]"
}

generate_static() {
    mkdir SelfSign/static
    cd SelfSign/static
    echo "echo 'Hello, World!'" > index.php
    touch style.css
}

compile_zsign() {
    cd SelfSign/zsign && chmod +x INSTALL.sh && ./INSTALL.sh
}

clone_zsign
generate_static
compile_zsign
