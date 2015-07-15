#!/bin/bash
# Copyright 2015 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# momcwrapper runs momc and zips up the output.
# This script only runs on darwin and you must have Xcode installed.
#
# $1 OUTZIP - the path to place the output zip file.


set -eu

OUTZIP="$1"
shift 1
TEMPDIR=$(mktemp -d -t ZippingOutput)
trap "rm -rf \"$TEMPDIR\"" EXIT

/usr/bin/xcrun momc "$@" "$TEMPDIR"

# Need to push/pop tempdir so it isn't the current working directory
# when we remove it via the EXIT trap.
pushd "$TEMPDIR" > /dev/null
# Reset all dates to Unix Epoch so that two identical zips created at different
# times appear the exact same for comparison purposes.
find . -exec touch -h -t 197001010000 {} \;
zip --symlinks --recurse-paths --quiet "$OUTZIP" .
popd > /dev/null
