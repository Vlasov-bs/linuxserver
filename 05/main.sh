#!/bin/bash

START_TIME=$(date +%s%N)

# --- Проверка параметра ---
if [ $# -ne 1 ]; then
  echo "Ошибка: необходимо указать ровно один параметр — путь к директории."
  echo "Использование: $0 /path/to/directory/"
  exit 1
fi

DIR="$1"

if [[ "$DIR" != */ ]]; then
  echo "Ошибка: путь должен заканчиваться на '/'"
  exit 1
fi

if [ ! -d "$DIR" ]; then
  echo "Ошибка: директория '$DIR' не существует."
  exit 1
fi

# --- 1. Общее число папок ---
TOTAL_FOLDERS=$(find "$DIR" -type d 2>/dev/null | wc -l)
echo "Total number of folders (including all nested ones) = $TOTAL_FOLDERS"

# --- 2. Топ-5 папок по размеру ---
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
du -h "$DIR" 2>/dev/null | sort -rh | head -5 | awk '{printf "%d - %s, %s\n", NR, $2, $1}'

# --- 3. Общее число файлов ---
TOTAL_FILES=$(find "$DIR" -type f 2>/dev/null | wc -l)
echo "Total number of files = $TOTAL_FILES"

# --- 4. Число файлов по типам ---
CONF_FILES=$(find "$DIR" -type f -name "*.conf" 2>/dev/null | wc -l)
TEXT_FILES=$(find "$DIR" -type f -name "*.txt" 2>/dev/null | wc -l)
EXEC_FILES=$(find "$DIR" -type f -executable 2>/dev/null | wc -l)
LOG_FILES=$(find "$DIR" -type f -name "*.log" 2>/dev/null | wc -l)
ARCHIVE_FILES=$(find "$DIR" -type f \( -name "*.tar" -o -name "*.gz" -o -name "*.zip" -o -name "*.bz2" -o -name "*.xz" -o -name "*.7z" -o -name "*.rar" -o -name "*.tar.gz" \) 2>/dev/null | wc -l)
SYM_LINKS=$(find "$DIR" -type l 2>/dev/null | wc -l)

echo "Number of:"
echo "Configuration files (with the .conf extension) = $CONF_FILES"
echo "Text files = $TEXT_FILES"
echo "Executable files = $EXEC_FILES"
echo "Log files (with the extension .log) = $LOG_FILES"
echo "Archive files = $ARCHIVE_FILES"
echo "Symbolic links = $SYM_LINKS"

# --- 5. Топ-10 файлов по размеру ---
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
find "$DIR" -type f -exec du -h {} + 2>/dev/null | sort -rh | head -10 | awk '{
  file = $2
  size = $1
  n = split(file, parts, ".")
  if (n > 1)
    ext = parts[n]
  else
    ext = "unknown"
  printf "%d - %s, %s, %s\n", NR, file, size, ext
}'

# --- 6. Топ-10 исполняемых файлов по размеру ---
echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
find "$DIR" -type f -executable -exec du -h {} + 2>/dev/null | sort -rh | head -10 | while read -r size file; do
  HASH=$(md5sum "$file" 2>/dev/null | awk '{print $1}')
  echo "$((++i)) - $file, $size, $HASH"
done

# --- Время выполнения ---
END_TIME=$(date +%s%N)
ELAPSED=$(echo "scale=1; ($END_TIME - $START_TIME) / 1000000000" | bc)
echo "Script execution time (in seconds) = $ELAPSED"
