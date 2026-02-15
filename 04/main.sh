#!/bin/bash

chmod +x main.sh
chmod +x color.sh
chmod +x info.sh

. color.sh
. info.sh

print_line() {
  echo -e "${NAME_STYLE}$1${RESET} = ${VAL_STYLE}$2${RESET}"
}

print_line "HOSTNAME" "$HOSTNAME"
print_line "TIMEZONE" "$TIMEZONE"
print_line "USER" "$USER"
print_line "OS" "$OS"
print_line "DATE" "$DATE"
print_line "UPTIME" "$UPTIME"
print_line "UPTIME_SEC" "$UPTIME_SEC"
print_line "IP" "$IP"
print_line "MASK" "$MASK"
print_line "GATEWAY" "$GATEWAY"
print_line "RAM_TOTAL" "$RAM_TOTAL GB"
print_line "RAM_USED" "$RAM_USED GB"
print_line "RAM_FREE" "$RAM_FREE GB"
print_line "SPACE_ROOT" "$SPACE_ROOT MB"
print_line "SPACE_ROOT_USED" "$SPACE_ROOT_USED MB"
print_line "SPACE_ROOT_FREE" "$SPACE_ROOT_FREE MB"

echo ""

if [ "$COL1_BG_IS_DEFAULT" = true ]; then
  echo "Column 1 background = default ($(color_name $COL1_BG))"
else
  echo "Column 1 background = $COL1_BG ($(color_name $COL1_BG))"
fi

if [ "$COL1_FG_IS_DEFAULT" = true ]; then
  echo "Column 1 font color = default ($(color_name $COL1_FG))"
else
  echo "Column 1 font color = $COL1_FG ($(color_name $COL1_FG))"
fi

if [ "$COL2_BG_IS_DEFAULT" = true ]; then
  echo "Column 2 background = default ($(color_name $COL2_BG))"
else
  echo "Column 2 background = $COL2_BG ($(color_name $COL2_BG))"
fi

if [ "$COL2_FG_IS_DEFAULT" = true ]; then
  echo "Column 2 font color = default ($(color_name $COL2_FG))"
else
  echo "Column 2 font color = $COL2_FG ($(color_name $COL2_FG))"
fi
