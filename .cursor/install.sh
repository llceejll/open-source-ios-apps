#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -qq
sudo apt-get install -y -qq ruby
sudo gem install --no-document parallel:1.20.1 json_schema:0.21.0 awesome_bot:1.20.0
