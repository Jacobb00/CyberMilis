#!/bin/sh
kill -9 `lsof -Ua | grep  ${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY} | head -n1 | awk '{print $2}'`
