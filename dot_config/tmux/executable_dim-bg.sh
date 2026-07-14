#!/bin/bash
CUR="${1}"
MBG=$(tinty info "${CUR}" 2>/dev/null | head -n 3 | tail -n 1 | sed 's/\x1b\[[0-9;]*m//g' | cut -f1)
BG=$(echo "${MBG:-1a1b26}" | tr -d ' #')
R=$(printf "%02x" $((0x${BG:0:2} * 70 / 100)))
G=$(printf "%02x" $((0x${BG:2:2} * 70 / 100)))
B=$(printf "%02x" $((0x${BG:4:2} * 70 / 100)))
echo "#${R}${G}${B}"
