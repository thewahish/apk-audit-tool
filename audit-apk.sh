#!/bin/bash

###############################################################################
# APK Security Audit Script
# Performs automated security checks on decompiled APK
###############################################################################

if [ -z "$1" ]; then
    echo "❌ Usage: ./audit-apk.sh <path-to-apk-file>"
    echo ""
    echo "Note: Run ./decompile-apk.sh first to decompile the APK"
    exit 1
fi

APK_FILE="$1"
APK_NAME=$(basename "$APK_FILE" .apk)
DECOMPILED_DIR="./decompiled/${APK_NAME}"
RESOURCES_DIR="./decompiled/${APK_NAME}_resources"
REPORT_DIR="./reports"
REPORT_FILE="$REPORT_DIR/${APK_NAME}_audit_$(date +%Y%m%d_%H%M%S).txt"

# Check if decompiled directory exists
if [ ! -d "$DECOMPILED_DIR" ]; then
    echo "❌ Error: Decompiled directory not found: $DECOMPILED_DIR"
    echo "Run ./decompile-apk.sh first"
    exit 1
fi

mkdir -p "$REPORT_DIR"

echo "🔒 APK Security Audit Tool"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "APK: $APK_NAME"
echo "Report: $REPORT_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "" | tee "$REPORT_FILE"

# Start audit
echo "APK SECURITY AUDIT REPORT" | tee -a "$REPORT_FILE"
echo "Generated: $(date)" | tee -a "$REPORT_FILE"
echo "APK File: $APK_FILE" | tee -a "$REPORT_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"

# 1. Check for hardcoded API keys and secrets
echo "🔍 1. Scanning for hardcoded secrets..." | tee -a "$REPORT_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$REPORT_FILE"

SECRET_PATTERNS=(
    "api_key"
    "apikey"
    "api-key"
    "secret"
    "password"
    "passwd"
    "token"
    "auth"
    "credentials"
    "private_key"
    "access_key"
    "aws_access"
    "aws_secret"
    "firebase"
)

for pattern in "${SECRET_PATTERNS[@]}"; do
    FINDINGS=$(grep -ri "$pattern" "$DECOMPILED_DIR" 2>/dev/null | head -10)
    if [ -n "$FINDINGS" ]; then
        echo "⚠️  Found potential secret: $pattern" | tee -a "$REPORT_FILE"
        echo "$FINDINGS" | head -3 | tee -a "$REPORT_FILE"
        echo "" | tee -a "$REPORT_FILE"
    fi
done

echo "" | tee -a "$REPORT_FILE"

# 2. Check AndroidManifest.xml permissions
echo "🔍 2. Analyzing permissions..." | tee -a "$REPORT_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$REPORT_FILE"

if [ -f "$RESOURCES_DIR/AndroidManifest.xml" ]; then
    DANGEROUS_PERMS=$(grep -i "uses-permission" "$RESOURCES_DIR/AndroidManifest.xml")
    echo "$DANGEROUS_PERMS" | tee -a "$REPORT_FILE"
else
    echo "⚠️  AndroidManifest.xml not found" | tee -a "$REPORT_FILE"
fi

echo "" | tee -a "$REPORT_FILE"

# 3. Check for insecure network communication
echo "🔍 3. Checking network security..." | tee -a "$REPORT_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$REPORT_FILE"

HTTP_URLS=$(grep -ri "http://" "$DECOMPILED_DIR" 2>/dev/null | grep -v "http://www.w3.org" | grep -v "http://schemas" | head -10)
if [ -n "$HTTP_URLS" ]; then
    echo "⚠️  Found insecure HTTP URLs:" | tee -a "$REPORT_FILE"
    echo "$HTTP_URLS" | head -5 | tee -a "$REPORT_FILE"
else
    echo "✅ No insecure HTTP URLs found" | tee -a "$REPORT_FILE"
fi

echo "" | tee -a "$REPORT_FILE"

# 4. Check for WebView security issues
echo "🔍 4. Checking WebView security..." | tee -a "$REPORT_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$REPORT_FILE"

WEBVIEW=$(grep -ri "setJavaScriptEnabled\|addJavascriptInterface" "$DECOMPILED_DIR" 2>/dev/null | head -10)
if [ -n "$WEBVIEW" ]; then
    echo "⚠️  WebView JavaScript interfaces found (potential XSS risk):" | tee -a "$REPORT_FILE"
    echo "$WEBVIEW" | head -5 | tee -a "$REPORT_FILE"
else
    echo "✅ No obvious WebView security issues" | tee -a "$REPORT_FILE"
fi

echo "" | tee -a "$REPORT_FILE"

# 5. Check for SQL injection vulnerabilities
echo "🔍 5. Checking for SQL injection risks..." | tee -a "$REPORT_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$REPORT_FILE"

SQL_CONCAT=$(grep -ri "rawQuery\|execSQL" "$DECOMPILED_DIR" 2>/dev/null | grep -v "?" | head -10)
if [ -n "$SQL_CONCAT" ]; then
    echo "⚠️  Potential SQL injection (string concatenation):" | tee -a "$REPORT_FILE"
    echo "$SQL_CONCAT" | head -5 | tee -a "$REPORT_FILE"
else
    echo "✅ No obvious SQL injection risks" | tee -a "$REPORT_FILE"
fi

echo "" | tee -a "$REPORT_FILE"

# 6. Check for debuggable flag
echo "🔍 6. Checking if app is debuggable..." | tee -a "$REPORT_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$REPORT_FILE"

if grep -q "debuggable.*true" "$RESOURCES_DIR/AndroidManifest.xml" 2>/dev/null; then
    echo "⚠️  App is debuggable (security risk in production)" | tee -a "$REPORT_FILE"
else
    echo "✅ App is not debuggable" | tee -a "$REPORT_FILE"
fi

echo "" | tee -a "$REPORT_FILE"

# 7. List external libraries/dependencies
echo "🔍 7. External libraries detected..." | tee -a "$REPORT_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$REPORT_FILE"

find "$DECOMPILED_DIR" -type d -name "com" -o -name "org" -o -name "androidx" 2>/dev/null | head -20 | tee -a "$REPORT_FILE"

echo "" | tee -a "$REPORT_FILE"

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$REPORT_FILE"
echo "✅ Audit Complete!" | tee -a "$REPORT_FILE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"
echo "📄 Full report saved to: $REPORT_FILE" | tee -a "$REPORT_FILE"
echo "" | tee -a "$REPORT_FILE"
echo "⚠️  Note: This is an automated audit. Manual review is recommended." | tee -a "$REPORT_FILE"
echo ""
