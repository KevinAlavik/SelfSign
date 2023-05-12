#!/bin/bash

zsign_url="https://github.com/zhlynn/zsign.git"

echo -e "SelfSign Setup, \e[32mLinux Script\e[0m"
echo ""
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

clone_zsign
