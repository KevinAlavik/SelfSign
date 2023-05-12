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
  mkdir signed
  cat <<EOF >index.php
<!DOCTYPE html>
<html>
<head>
    <title>SelfSign Signing Site</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }
        
        h1, h2 {
            color: #333333;
            text-align: center;
        }
        
        form {
            width: 400px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
        }
        
        label {
            display: block;
            margin-top: 10px;
        }
        
        input[type="file"] {
            margin-top: 5px;
        }
        
        input[type="password"] {
            margin-top: 10px;
            width: 100%;
            padding: 5px;
            border: 1px solid #cccccc;
            border-radius: 3px;
            box-sizing: border-box;
        }
        
        button[type="submit"] {
            margin-top: 20px;
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: #ffffff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }
        
        button[type="submit"]:hover {
            background-color: #45a049;
        }
        p {
          text-align: center
        }
                body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }

        h1, h2 {
            color: #333333;
            text-align: center;
        }

        .container {
            width: 400px;
            margin: 0 auto;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
        }

        label {
            display: block;
            margin-top: 10px;
        }

        input[type="file"] {
            margin-top: 5px;
        }

        input[type="password"] {
            margin-top: 10px;
            width: 100%;
            padding: 5px;
            border: 1px solid #cccccc;
            border-radius: 3px;
            box-sizing: border-box;
        }

        button[type="submit"] {
            margin-top: 20px;
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            color: #ffffff;
            border: none;
            border-radius: 3px;
            cursor: pointer;
        }

        button[type="submit"]:hover {
            background-color: #45a049;
        }

        .output-container {
            margin-top: 20px;
            background-color: #f9f9f9;
            padding: 10px;
            border-radius: 5px;
            box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.2);
        }

        .output-text {
            font-family: monospace;
            white-space: pre-wrap;
        }
    </style>
</head>
<body>
    <h1>SelfSign Signing Site</h1>
        <h2>Upload files to sign</h2>
        <form method="POST" enctype="multipart/form-data">
            <label>
                Select IPA:
                <br>
                <input type="file" name="ipa_file" accept=".ipa" required>
            </label>

            <label>
                Select Mobileprovision:
                <br>
                <input type="file" name="mobileprovision_file" accept=".mobileprovision" required>
            </label>

            <label>
                Select p12 File:
                <br>
                <input type="file" name="p12_file" accept=".p12" required>
            </label>

            <label>
                Password:
                <input type="password" name="password" placeholder="Password" required>
            </label>

            <button type="submit">Sign</button>
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

                  \$targetDir = 'site/data/';
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

                      \$zsignOutput = shell_exec("./zsign \$targetIpaFile -k \$targetP12File -m \$targetMobileprovisionFile -o signed/signed.ipa -p \$password");

                        if (\$zsignOutput !== null) {
                            \$bundleId = \`echo "\$zsignOutput" | grep -oP '>>> BundleId:\s+\K.+'\`;
                            \$version = \`echo "\$zsignOutput" | grep -oP '>>> BundleVer:\s+\K.+'\`;
                            \$appName = \`echo "\$zsignOutput" | grep -oP '>>> AppName:\s+\K.+'\`;

                            shell_exec('
                                cat <<EOF > signed/signed.plist
                                <?xml version="1.0" encoding="UTF-8"?>
                                <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
                                <plist version="1.0">
                                <dict>
                                    <key>items</key>
                                    <array>
                                        <dict>
                                            <key>assets</key>
                                            <array>
                                                <dict>
                                                    <key>kind</key>
                                                    <string>software-package</string>
                                                    <key>url</key>
                                                    <string>http://' . \$_SERVER['SERVER_NAME'] . ':1300/signed/signed.ipa</string>
                                                </dict>
                                            </array>
                                            <key>metadata</key>
                                            <dict>
                                                <key>bundle-identifier</key>
                                                <string>' . \$bundleId . '</string>
                                                <key>bundle-version</key>
                                                <string>' . \$version . '</string>
                                                <key>kind</key>
                                                <string>software</string>
                                                <key>title</key>
                                                <string>' . \$appName . '</string>
                                            </dict>
                                        </dict>
                                    </array>
                                </dict>
                                </plist>
                                EOF
                                ');

                            header("Location: itms-services://?action=download-manifest&url=http://" . \$_SERVER['SERVER_NAME'] . ":1300/signed/signed.plist");
                        }
                      ?>

                      <div class="output-container">
                          <h2 align="center">Signing Output</h2>
                          <div class="output-text"><?php echo \$zsignOutput;?></div>
                      </div>
                      
                      <?php
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
}

platform=$(uname)

# Install required packages
install_packages() {
  if [[ "$platform" == "Darwin" ]]; then
    # macOS
    brew update
    brew install openssl@1.1

    # Add OpenSSL paths to environment variables
    export LDFLAGS="-L$(brew --prefix openssl@1.1)/lib"
    export CPPFLAGS="-I$(brew --prefix openssl@1.1)/include -I$(brew --prefix)/include"

    # Update pkg-config paths
    sudo cp $(brew --prefix openssl@1.1)/lib/pkgconfig/*.pc /usr/local/lib/pkgconfig/

  elif [[ "$platform" == "Linux" ]]; then
    # Linux
    if [[ -x "$(command -v apt-get)" ]]; then
      # Debian-based distributions
      sudo apt-get update
      sudo apt-get install -y g++ libssl-dev
    elif [[ -x "$(command -v yum)" ]]; then
      # Red Hat-based distributions
      sudo yum update
      sudo yum install -y gcc-c++ openssl-devel
    elif [[ -x "$(command -v dnf)" ]]; then
      # Fedora distributions
      sudo dnf update
      sudo dnf install -y gcc-c++ openssl-devel
    else
      echo "Package manager not found. Please install the required packages manually. (g++ libssl-dev/openssl-devel)"
      exit 1
    fi

    # Configure OpenSSL library path
    export PKG_CONFIG_PATH=/usr/local/ssl/lib/pkgconfig:$PKG_CONFIG_PATH

  else
    echo "Unsupported platform: $platform"
    exit 1
  fi
}


compile_zsign() {
  cd ../zsign
  g++ *.cpp common/*.cpp -std=gnu++11 -lcrypto -I/usr/local/Cellar/openssl@1.1/1.1.1t/include -L/usr/local/Cellar/openssl@1.1/1.1.1t/lib -O3 -o zsign
  sudo mv zsign ../site/zsign
  cd ..
  sudo rm -rf zsign
  echo "Successfully built zsign"
}

main() {
  clone_zsign
  generate_site
  install_packages
  sleep 1
  compile_zsign
  echo -e "\e[32mSuccessfully installed SelfSign now run ./start.sh\e[0m"
  cd ..
  chmod +xrw start.sh
}
main
