#!/bin/sh

test $(id -u) = 0 && alias wsudo= || alias wsudo=sudo

dep() {
  dpkg -s $1 >/dev/null 2>&1 || wsudo apt-get install $1
}

cmd() {
  which $1 >/dev/null
}

dep curl
dep python3-virtualenv

test -d .venv || virtualenv --python=python3 .venv

. .venv/bin/activate

cmd miniterm.py || pip install pyserial
cmd esptool.py || pip install esptool

curl -sSL https://api.github.com/repos/arendst/Tasmota/releases/latest | \
  grep -E "browser_download_url.*tasmota-sensors.bin\"$" | \
  cut -d\" -f4 | \
  xargs curl -sSLo tasmota-sensors.bin
