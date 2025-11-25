#!/bin/bash

###############################################################################
# APK Audit Tool Setup Script
# Downloads jadx and apktool on first use
###############################################################################

TOOLS_DIR="./tools"
JADX_VERSION="1.5.0"
APKTOOL_VERSION="2.9.3"

echo "🔧 APK Audit Tool - Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if tools already exist
if [ -d "$TOOLS_DIR/jadx" ] && [ -f "$TOOLS_DIR/apktool.jar" ]; then
    echo "✅ Tools already installed"
    echo ""
    echo "jadx: $TOOLS_DIR/jadx/bin/jadx"
    echo "apktool: $TOOLS_DIR/apktool.jar"
    echo ""
    exit 0
fi

echo "📦 Downloading decompilation tools..."
echo "This is a one-time setup (~130MB download)"
echo ""

mkdir -p "$TOOLS_DIR"
cd "$TOOLS_DIR"

# Download JADX
if [ ! -d "jadx" ]; then
    echo "⬇️  Downloading jadx v${JADX_VERSION}..."
    curl -L "https://github.com/skylot/jadx/releases/download/v${JADX_VERSION}/jadx-${JADX_VERSION}.zip" -o jadx.zip

    if [ $? -eq 0 ]; then
        echo "📦 Extracting jadx..."
        unzip -q jadx.zip -d jadx
        rm jadx.zip
        echo "✅ jadx installed"
    else
        echo "❌ Failed to download jadx"
        exit 1
    fi
else
    echo "✅ jadx already installed"
fi

echo ""

# Download Apktool
if [ ! -f "apktool.jar" ]; then
    echo "⬇️  Downloading apktool v${APKTOOL_VERSION}..."
    curl -L "https://github.com/iBotPeaches/Apktool/releases/download/v${APKTOOL_VERSION}/apktool_${APKTOOL_VERSION}.jar" -o apktool.jar

    if [ $? -eq 0 ]; then
        echo "✅ apktool installed"
    else
        echo "❌ Failed to download apktool"
        exit 1
    fi
else
    echo "✅ apktool already installed"
fi

cd - > /dev/null

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Tools installed:"
echo "  jadx: $TOOLS_DIR/jadx/bin/jadx"
echo "  apktool: $TOOLS_DIR/apktool.jar"
echo ""
echo "Next step: Install Java (if not already installed)"
echo "  ./INSTALL-JAVA.sh"
echo ""
echo "Then analyze an APK:"
echo "  ./decompile-apk.sh your-app.apk"
echo ""
