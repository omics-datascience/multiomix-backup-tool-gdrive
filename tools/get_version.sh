#!/bin/bash
VERSION=$(head -n1 $SETTINGSFILE | tr -d " ")
echo "VERSION=$VERSION"