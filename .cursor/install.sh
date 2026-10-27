#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -qq
sudo apt-get install -y -qq build-essential ruby ruby-dev
sudo gem install --no-document bundler:4.0.23
sudo bundle install --jobs 4 --retry 3
