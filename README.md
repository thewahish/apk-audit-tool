# APK Audit Tool

**Domain:** Business-Tools
**Status:** Active

Comprehensive Android APK analysis, decompilation, and security audit tool.

**Self-contained and automatic!** Tools download on first use.

## Quick Start

### 1. Install Java (One-Time Setup)

```bash
./INSTALL-JAVA.sh
```

Or install manually:
```bash
brew install --cask temurin
```

### 2. Download Tools (One-Time, ~130MB)

```bash
./setup-tools.sh
```

This downloads jadx and apktool. First-time only!

### 3. Analyze an APK

```bash
# Decompile APK (tools auto-download if needed)
./decompile-apk.sh your-app.apk

# Run security audit
./audit-apk.sh your-app.apk

# View report
cat reports/*_audit_*.txt
```

**Even easier:** Just run `./decompile-apk.sh your-app.apk` - it auto-downloads tools if needed!

## Features

- **Decompilation**: Extract and decompile APK files to readable source code
- **Security Audit**: 7-point automated security analysis
  1. Hardcoded secrets detection (API keys, passwords, tokens)
  2. Android permissions analysis
  3. Network security (insecure HTTP URLs)
  4. WebView security issues (XSS risks)
  5. SQL injection vulnerabilities
  6. Debuggable flag check
  7. External library detection
- **Code Analysis**: Review architecture, dependencies, and code quality
- **Automated Reports**: Detailed text reports in `./reports/`

## Project Structure

```
apk-audit-tool/
├── decompile-apk.sh        # Main decompilation script
├── audit-apk.sh            # Security audit script
├── setup-tools.sh          # Tool setup script
├── INSTALL-JAVA.sh         # Java installation helper
├── tools/                  # Downloaded tools (auto)
├── decompiled/             # Decompiled output
└── reports/                # Audit reports
```

## Auto-Downloaded Tools

- **jadx** (v1.5.0) - DEX to Java/Kotlin decompiler
- **apktool** (v2.9.3) - APK resource extraction
- Custom security audit scripts

Tools auto-download on first use (~130MB, one-time).

## Requirements

- **Java JDK** - Run `./INSTALL-JAVA.sh` to install
- macOS (tested on Apple Silicon)

## Tech Stack

- Shell Scripts (Bash)
- Java JDK 17+
- jadx, apktool

## GitHub Repository

[https://github.com/thewahish/apk-audit-tool](https://github.com/thewahish/apk-audit-tool)

## Troubleshooting

**Java not found:**
```bash
./INSTALL-JAVA.sh
# Or manually: brew install --cask temurin
```

**Permission denied:**
```bash
chmod +x *.sh
```

**Tools not working:**
```bash
# Verify Java installation
java -version
# Should show Java 17 or higher
```

---

**Last Updated:** December 23, 2025
