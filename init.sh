#!/bin/bash

set -e
set -x

required_version=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)

do_upgrade()
{
    wget https://chromedriver.storage.googleapis.com/${required_version}/chromedriver_linux64.zip && \
    unzip -o chromedriver_linux64.zip -d /usr/bin && \
    chmod +x /usr/bin/chromedriver && \
    rm chromedriver_linux64.zip

CHROME_SETUP=google-chrome.deb && \
    wget -O $CHROME_SETUP "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" && \
    dpkg -i $CHROME_SETUP && \
    apt-get install -y -f && \
    rm $CHROME_SETUP
}

# Check and upgrade chrome if needed
# Sticking with the latest is in my experience the best way to remain incognito
if ! [ -x /usr/bin/chromedriver ]
then
    echo "First run, installing chrome"
    do_upgrade
else
    local_version=$(dpkg-query --showformat='${Version}' --show google-chrome-stable)
    if dpkg --compare-versions ${required_version} "gt" ${local_version}
    then
        echo "Upgrading chrome to the latest stable version"
        do_upgrade
    else
        echo "Chrome is at the latest version. No upgrade needed."
    fi
fi

/usr/bin/python3 -u /src/InfluxdbComcast.py
