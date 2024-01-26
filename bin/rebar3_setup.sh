#!/bin/sh
# rebar3 installer
wget https://s3.amazonaws.com/rebar3/rebar3 && chmod +x rebar3
sudo mv -v rebar3 /usr/local/bin/rebar3
