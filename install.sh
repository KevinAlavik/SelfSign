#!/bin/bash
sudo rm -rf SelfSign

zsign_url="https://github.com/zhlynn/zsign.git"

echo -e "SelfSign Setup, \e[32mLinux Script\e[0m"
echo "Starting the main process"

mkdir SelfSign
cd SelfSign

clone_zsign() {
  output=$(git clone "$zsign_url" zsign 2>&1)
  lines=$(echo "$output" | wc -l)
  count=0

  while IFS= read -r line; do
    count=$((count + 1))
    percentage=$((count * 100 / lines))
    progress="["
    for ((i = 0; i < percentage; i += 2)); do
      progress+="="
    done
    progress+=">"

    echo -ne "Cloning progress: $progress $percentage% \r"
  done <<<"$output"

  echo "Cloning progress: [==================================================> 100%]"
}

generate_static() {
  mkdir static
  cd static
  cat <<EOF >index.php
<!DOCTYPE html>
<html lang="eng">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SelfSign</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>SelfSign Signing Site</h1>
    <p>This is under developement.</p>
    <?php
        echo "Soon";
    ?>
</body>
</html>
EOF
  touch style.css
}

compile_zsign() {
  cd ../zsign
  chmod +x INSTALL.sh
  sudo ./INSTALL.sh
  sudo mkdir ../backend
  sudo mv build/zsign ../backend/zsign
  cd ../
  sudo rm -rf zsign
  echo "Successfully built zsign"
}

main() {
  clone_zsign
  generate_static
  sleep 2
  compile_zsign
}

main
