#!/bin/bash

###############################################################################
# APK Decompiler Script
# Decompiles APK files using jadx and apktool
###############################################################################

# Auto-setup tools if not present
if [ ! -d "./tools/jadx" ] || [ ! -f "./tools/apktool.jar" ]; then
    echo "⚠️  Tools not found. Running setup..."
    ./setup-tools.sh || exit 1
    echo ""
fi

# Check for Java
if ! /usr/libexec/java_home >/dev/null 2>&1; then
    echo "⚠️  Java not found. Please install Java:"
    echo "  ./INSTALL-JAVA.sh"
    echo ""
    echo "Or install manually:"
    echo "  brew install --cask temurin"
    exit 1
fi

# Use bundled tools
JADX="./tools/jadx/bin/jadx"
APKTOOL="java -jar ./tools/apktool.jar"

if [ -z "$1" ]; then
    echo "❌ Usage: ./decompile-apk.sh <path-to-apk-file>"
    echo ""
    echo "Example:"
    echo "  ./decompile-apk.sh myapp.apk"
    exit 1
fi

APK_FILE="$1"

if [ ! -f "$APK_FILE" ]; then
    echo "❌ Error: APK file not found: $APK_FILE"
    exit 1
fi

# Get APK filename without extension
APK_NAME=$(basename "$APK_FILE" .apk)
OUTPUT_DIR="./decompiled/${APK_NAME}"
RESOURCES_DIR="./decompiled/${APK_NAME}_resources"

echo "🔍 APK Audit Tool - Decompiler"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "APK File: $APK_FILE"
echo "Output Directory: $OUTPUT_DIR"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create output directories
mkdir -p "./decompiled"

echo "📦 Step 1: Decompiling with JADX (DEX to Java/Kotlin)..."
$JADX -d "$OUTPUT_DIR" "$APK_FILE" --show-bad-code

if [ $? -eq 0 ]; then
    echo "✅ JADX decompilation complete"
else
    echo "❌ JADX decompilation failed"
    exit 1
fi

echo ""
echo "📦 Step 2: Extracting resources with apktool..."
$APKTOOL d "$APK_FILE" -o "$RESOURCES_DIR" -f

if [ $? -eq 0 ]; then
    echo "✅ Resource extraction complete"
else
    echo "❌ Resource extraction failed"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Decompilation Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📁 Source Code: $OUTPUT_DIR"
echo "📁 Resources: $RESOURCES_DIR"
echo ""
echo "Next steps:"
echo "1. Review AndroidManifest.xml: $RESOURCES_DIR/AndroidManifest.xml"
echo "2. Check for hardcoded secrets in source code"
echo "3. Run security audit: ./audit-apk.sh $APK_FILE"
echo ""
