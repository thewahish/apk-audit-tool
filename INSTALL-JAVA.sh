#!/bin/bash

###############################################################################
# Java Installation Script
# Installs Java JDK needed for jadx and apktool
###############################################################################

echo "☕ Installing Java JDK..."
echo ""

# Check if Java already installed
if /usr/libexec/java_home >/dev/null 2>&1; then
    JAVA_VERSION=$(/usr/libexec/java_home -V 2>&1 | head -2)
    echo "✅ Java already installed:"
    echo "$JAVA_VERSION"
    exit 0
fi

echo "Installing Eclipse Temurin JDK via Homebrew..."
echo "This requires sudo password..."
echo ""

brew install --cask temurin

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Java installed successfully!"
    echo ""
    /usr/libexec/java_home -V
else
    echo ""
    echo "❌ Installation failed"
    echo ""
    echo "Please install Java manually:"
    echo "  Option 1: https://adoptium.net/ (download installer)"
    echo "  Option 2: brew install --cask temurin"
    exit 1
fi
