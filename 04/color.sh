#!/bin/bash

# --- Цветовая схема по умолчанию ---
# column1: фон=6(чёрный), шрифт=1(белый)
# column2: фон=2(красный), шрифт=4(синий)
DEFAULT_COL1_BG=6
DEFAULT_COL1_FG=1
DEFAULT_COL2_BG=2
DEFAULT_COL2_FG=4

# --- Чтение конфигурационного файла ---
CONFIG_FILE="$(dirname "$0")/config.conf"

COL1_BG=""
COL1_FG=""
COL2_BG=""
COL2_FG=""

if [ -f "$CONFIG_FILE" ]; then
  while IFS='=' read -r key value; do
    # Пропуск пустых строк и комментариев
    [[ -z "$key" || "$key" =~ ^# ]] && continue
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)
    case "$key" in
      column1_background)  COL1_BG="$value" ;;
      column1_font_color)  COL1_FG="$value" ;;
      column2_background)  COL2_BG="$value" ;;
      column2_font_color)  COL2_FG="$value" ;;
    esac
  done < "$CONFIG_FILE"
fi

# --- Флаги: использовался ли конфиг или дефолт ---
COL1_BG_IS_DEFAULT=true
COL1_FG_IS_DEFAULT=true
COL2_BG_IS_DEFAULT=true
COL2_FG_IS_DEFAULT=true

if [[ -n "$COL1_BG" && "$COL1_BG" =~ ^[1-6]$ ]]; then
  COL1_BG_IS_DEFAULT=false
else
  COL1_BG=$DEFAULT_COL1_BG
fi

if [[ -n "$COL1_FG" && "$COL1_FG" =~ ^[1-6]$ ]]; then
  COL1_FG_IS_DEFAULT=false
else
  COL1_FG=$DEFAULT_COL1_FG
fi

if [[ -n "$COL2_BG" && "$COL2_BG" =~ ^[1-6]$ ]]; then
  COL2_BG_IS_DEFAULT=false
else
  COL2_BG=$DEFAULT_COL2_BG
fi

if [[ -n "$COL2_FG" && "$COL2_FG" =~ ^[1-6]$ ]]; then
  COL2_FG_IS_DEFAULT=false
else
  COL2_FG=$DEFAULT_COL2_FG
fi

# --- Таблица цветов ---
# 1-белый, 2-красный, 3-зелёный, 4-синий, 5-фиолетовый, 6-чёрный

color_name() {
  case $1 in
    1) echo "white" ;;
    2) echo "red" ;;
    3) echo "green" ;;
    4) echo "blue" ;;
    5) echo "purple" ;;
    6) echo "black" ;;
  esac
}

get_fg() {
  case $1 in
    1) echo "97" ;;  # белый
    2) echo "31" ;;  # красный
    3) echo "32" ;;  # зелёный
    4) echo "34" ;;  # синий
    5) echo "35" ;;  # фиолетовый
    6) echo "30" ;;  # чёрный
  esac
}

get_bg() {
  case $1 in
    1) echo "107" ;; # белый
    2) echo "41"  ;; # красный
    3) echo "42"  ;; # зелёный
    4) echo "44"  ;; # синий
    5) echo "45"  ;; # фиолетовый
    6) echo "40"  ;; # чёрный
  esac
}

BG_NAME=$(get_bg "$COL1_BG")
FG_NAME=$(get_fg "$COL1_FG")
BG_VAL=$(get_bg "$COL2_BG")
FG_VAL=$(get_fg "$COL2_FG")

NAME_STYLE="\033[${BG_NAME};${FG_NAME}m"
VAL_STYLE="\033[${BG_VAL};${FG_VAL}m"
RESET="\033[0m"
