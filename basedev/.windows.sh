#!/bin/sh

# MIT License
#
# Copyright (c) 2019 Quentin McGaw
# https://github.com/qdm12/basedevcontainer
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# As Windows bind mounts do not allow the container to chmod files
# and SSH requires your keys to have not too opened permissions,
# we offer the user to bind mount their SSH directory in /tmp/.ssh
# as read only which we then copy over to /root/.ssh with the right
# permissions
if [ -d "/tmp/.ssh" ]; then
  if [ -d "~/.ssh" ]; then
    echo "~/.ssh already exists, not overriding with files from /tmp/.ssh"
    exit 0
  fi
  cp -rf /tmp/.ssh ~/
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/*
  chmod 644 ~/.ssh/*.pub &>/dev/null
  echo "SSH files copied to ~/.ssh with correct permissions"
fi
