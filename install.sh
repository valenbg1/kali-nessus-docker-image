#!/usr/bin/env bash

# These variables probably need to be changed
NESSUS_ACTIVATION_CODE="AAAA-BBBB-CCCC-DDDD"
NESSUS_DEB_NAME="Nessus-10.1.2-debian6_amd64.deb"
NESSUS_PASSWORD="root"
NESSUS_URL='https://www.tenable.com/downloads/api/v1/public/pages/nessus/downloads/16111/download?i_agree_to_tenable_license_agreement=true'
NESSUS_USERNAME="toor"

# Other config variables with suitable default values
INSTALL_EXTRA_PACKAGES="bash-completion testssl.sh gobuster curl nano httpx-toolkit"
INSTALL_KALI_PACKAGES="kali-linux-core kali-linux-headless kali-tools-fuzzing kali-tools-top10 kali-tools-vulnerability kali-tools-web kali-tools-exploitation kali-tools-sniffing-spoofing"
NESSUS_NESSUSCLI_PATH="/opt/nessus/sbin/nessuscli"
NESSUS_PROXY_HOST="127.0.0.1"
NESSUS_PROXY_PORT="12345"
NESSUS_SET_PROXY=false
TIMEZONE_FILE="/etc/localtime"
TIMEZONE_ZONEINFO_FILE="/usr/share/zoneinfo/Europe/Madrid"

# Output colors
COLOR_DARK_YELLOW='\033[2m\033[0;33m'
COLOR_RESET='\033[0m'

# APT environment variables
export DEBIAN_FRONTEND="noninteractive"


echo_dark_yellow() {
    echo -e "$COLOR_DARK_YELLOW$1$COLOR_RESET"
}


echo_dark_yellow "Linking \"$TIMEZONE_FILE\" to \"$TIMEZONE_ZONEINFO_FILE\"...\n"
rm -rf "$TIMEZONE_FILE"
ln -s "$TIMEZONE_ZONEINFO_FILE" "$TIMEZONE_FILE"
echo -e "\n"

echo_dark_yellow "Installing Kali repository necessary packages: $INSTALL_KALI_PACKAGES"
echo_dark_yellow "Installing Kali repository extra packages: $INSTALL_EXTRA_PACKAGES"
echo_dark_yellow "This will take a while...\n"
apt update
apt install -y $INSTALL_KALI_PACKAGES $INSTALL_EXTRA_PACKAGES
echo -e "\n"

echo_dark_yellow "Downloading Nessus DEB package \"$NESSUS_DEB_NAME\" from the URL \"$NESSUS_URL\"...\n"
curl "$NESSUS_URL" -o "$NESSUS_DEB_NAME"
echo -e "\n"

echo_dark_yellow "Installing Nessus DEB package \"$NESSUS_DEB_NAME\"...\n"
apt install -y "./$NESSUS_DEB_NAME"
rm "$NESSUS_DEB_NAME"
echo -e "\n"

echo_dark_yellow "Adding user \"$NESSUS_USERNAME\" to Nessus...\n"
echo -ne "$NESSUS_PASSWORD\n$NESSUS_PASSWORD\ny\n\ny\n" | "$NESSUS_NESSUSCLI_PATH" adduser "$NESSUS_USERNAME"
echo -e "\n"

echo_dark_yellow "Registering and updating Nessus online...\n"
"$NESSUS_NESSUSCLI_PATH" fetch --register "$NESSUS_ACTIVATION_CODE"
echo -e "\n"

if [ "$NESSUS_SET_PROXY" = true ]; then
    echo_dark_yellow "Setting Nessus proxy to $NESSUS_PROXY_HOST:$NESSUS_PROXY_PORT...\n"
    "$NESSUS_NESSUSCLI_PATH" fix --secure --set proxy="$NESSUS_PROXY_HOST"
    "$NESSUS_NESSUSCLI_PATH" fix --secure --set proxy_port="$NESSUS_PROXY_PORT"
    echo -e "\n"
fi

echo_dark_yellow "The next time Nessus is started it will compile the plugins, which will take a long time.\n"
echo_dark_yellow "The installation is finished. The Docker image will now be generated..."
