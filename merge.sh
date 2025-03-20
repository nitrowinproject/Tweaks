#!/bin/bash

MERGED_REG_FILE="NitroWin.Tweaks.reg"
MERGED_BAT_FILE="NitroWin.Tweaks.bat"
MERGED_POWERSHELL_FILE="NitroWin.Tweaks.ps1"

if [ -f "$MERGED_REG_FILE" ]; then
    rm "$MERGED_REG_FILE"
fi
echo "Windows Registry Editor Version 5.00" > "$MERGED_REG_FILE"
find . -type f -name "*.reg" -exec sh -c 'tail -n +2 "$1" && echo ""' _ {} \; >> "$MERGED_REG_FILE"

if [ -f "$MERGED_BAT_FILE" ]; then
    rm "$MERGED_BAT_FILE"
fi
first=true
for bat_file in $(find . -type f -name "*.bat"); do
    if [ "$first" = true ]; then
        cat "$bat_file" >> "$MERGED_BAT_FILE"
        first=false
    else
        cat "$bat_file" >> "$MERGED_BAT_FILE"
        echo "" >> "$MERGED_BAT_FILE"
    fi
done

if [ -f "$MERGED_POWERSHELL_FILE" ]; then
    rm "$MERGED_POWERSHELL_FILE"
fi
first=true
for ps1_file in $(find . -type f -name "*.ps1"); do
    if [ "$first" = true ]; then
        cat "$ps1_file" >> "$MERGED_POWERSHELL_FILE"
        first=false
    else
        cat "$ps1_file" >> "$MERGED_POWERSHELL_FILE"
        echo "" >> "$MERGED_POWERSHELL_FILE"
    fi
done