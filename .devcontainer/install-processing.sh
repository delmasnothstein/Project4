#!/usr/bin/env bash

echo "Installing Processing..."

cd /tmp

wget https://download.processing.org/processing-4.3-linux-x64.tgz

tar -xzf processing-4.3-linux-x64.tgz

sudo mv processing-4.3 /opt/processing

sudo ln -s /opt/processing/processing-java /usr/local/bin/processing-java

echo "Processing installed!"