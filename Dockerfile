FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
  python3 python3-pip \
  firefox-geckodriver \
  xvfb \
  fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 \
  libnspr4 libnss3 lsb-release xdg-utils libxss1 libdbus-glib-1-2 \
  libgbm1 curl unzip wget \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /src

COPY . /src
RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["/usr/bin/bash", "/src/init.sh"]
