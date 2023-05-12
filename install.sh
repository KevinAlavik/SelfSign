#!/bin/bash
sudo rm -rf SelfSign

zsign_url="https://github.com/zhlynn/zsign.git"

echo -e "SelfSign, \e[32mInstall Script\e[0m"
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

generate_site() {
  mkdir site
  cd site
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
    <h2>Upload files to sign</h2>
    <form method="POST" enctype="multipart/form-data">
        <input type="file" name="ipa_file" accept=".ipa" required>Select IPA</input>
        <br>
        <input type="file" name="mobileprovision_file" accept=".mobileprovision" required>Select Mobileprovision</input>
        <br>
        <input type="file" name="p12_file" accept=".p12" required>Select p12 File</input>
        <br>
        <input type="password" name="password" placeholder="Password" required></input>
        <br>
        <button type="submit">Upload .ipa</button>
    </form>
    <?php
      if (\$_SERVER['REQUEST_METHOD'] === 'POST') {
          if (isset(\$_FILES['ipa_file']) && isset(\$_FILES['mobileprovision_file']) && isset(\$_FILES['p12_file']) && isset(\$_POST['password'])) {
              \$ipaFile = \$_FILES['ipa_file'];
              \$mobileprovisionFile = \$_FILES['mobileprovision_file'];
              \$p12File = \$_FILES['p12_file'];
              \$password = \$_POST['password'];
              
              if (\$ipaFile['error'] === UPLOAD_ERR_OK && \$mobileprovisionFile['error'] === UPLOAD_ERR_OK && \$p12File['error'] === UPLOAD_ERR_OK) {
                  \$tempIpaFile = \$ipaFile['tmp_name'];
                  \$tempMobileprovisionFile = \$mobileprovisionFile['tmp_name'];
                  \$tempP12File = \$p12File['tmp_name'];
                  
                  \$targetDir = 'data/';
                  \$targetIpaFile = \$targetDir . \$ipaFile['name'];
                  \$targetMobileprovisionFile = \$targetDir . \$mobileprovisionFile['name'];
                  \$targetP12File = \$targetDir . \$p12File['name'];
                  
                  // Create the target directory if it doesn't exist
                  if (!is_dir(\$targetDir)) {
                      mkdir(\$targetDir, 0777, true);
                  }
                  
                  // Move the uploaded files to the target directory
                  if (move_uploaded_file(\$tempIpaFile, \$targetIpaFile) &&
                      move_uploaded_file(\$tempMobileprovisionFile, \$targetMobileprovisionFile) &&
                      move_uploaded_file(\$tempP12File, \$targetP12File)) {
                      
                      \$zsign = shell_exec("./zsign \$targetIpaFile -k \$targetP12File -m \$targetMobileprovisionFile -o signed/signed.ipa -p \$password");
                      echo 'File uploaded successfully!';
                      echo "<pre>\$zsign</pre>";
                  } else {
                      echo 'Error moving the uploaded files.';
                  }
              } else {
                  echo 'Error uploading files. Please try again.';
              }
          } else {
              echo 'Please upload all required files and provide a password.';
          }
      }
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
  sudo mv build/zsign ../site/zsign
  cd ../
  sudo rm -rf zsign
  echo "Successfully built zsign"
}

main() {
  clone_zsign
  generate_site
  sleep 2
  compile_zsign
}

main
