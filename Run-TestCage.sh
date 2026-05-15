#!/usr/bin/env bash
set -euo pipefail

CAGE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WINEPREFIX_DIR="$CAGE/.wineprefix"

export WINEPREFIX="$WINEPREFIX_DIR"
export WINEDEBUG="-all"

mkdir -p "$CAGE/Temp" "$CAGE/Logs"
mkdir -p "$CAGE/Drives/S" "$CAGE/Drives/W/Windows" "$CAGE/Drives/Z"
mkdir -p "$WINEPREFIX_DIR/dosdevices"

if ! command -v wine >/dev/null 2>&1; then
    echo "ERROR: wine was not found."
    echo "Install Wine through your distribution package manager."
    exit 1
fi

# Initialize Wine prefix if needed.
wineboot -u >/dev/null 2>&1 || true

ln -sfn "$CAGE/Drives/S" "$WINEPREFIX_DIR/dosdevices/s:"
ln -sfn "$CAGE/Drives/W" "$WINEPREFIX_DIR/dosdevices/w:"
ln -sfn "$CAGE/Drives/Z" "$WINEPREFIX_DIR/dosdevices/z:"
ln -sfn "$CAGE" "$WINEPREFIX_DIR/dosdevices/p:"
ln -sfn "$CAGE/Temp" "$WINEPREFIX_DIR/dosdevices/t:"

TARGET="${1:-}"

# Convert Linux relative paths to Wine paths when the target exists locally.
if [[ -n "$TARGET" ]]; then
    if [[ -f "$TARGET" ]]; then
        TARGET="P:\\${TARGET//\//\\}"
    elif [[ -f "$CAGE/$TARGET" ]]; then
        rel="${TARGET#./}"
        TARGET="P:\\${rel//\//\\}"
    fi
fi

cat <<EOF

==========================================
 PE-TestCage Linux/Wine Runner
==========================================

Cage root:
$CAGE

Wine prefix:
$WINEPREFIX_DIR

Fake drives:
S: = $CAGE/Drives/S
W: = $CAGE/Drives/W
Z: = $CAGE/Drives/Z
P: = $CAGE
T: = $CAGE/Temp

Dangerous commands are mocked through:
P:\\MockBin

EOF

if [[ -z "$TARGET" ]]; then
    echo "Starting interactive cage shell. Type exit to close."
    echo
    wine cmd /k "set PATH=P:\\MockBin;%PATH% && set TEMP=T:\\ && set TMP=T:\\ && set LOGDIR=P:\\Logs && P: && cd \\"
else
    echo "Target script: $TARGET"
    echo
    wine cmd /c "set PATH=P:\\MockBin;%PATH% && set TEMP=T:\\ && set TMP=T:\\ && set LOGDIR=P:\\Logs && call \"$TARGET\""
fi
