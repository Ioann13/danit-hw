#!/bin/bash

# Путь к каталогу
WATCH_DIR="/home/ivan/Downloads"

# Бесконечный цикл
while true; do
    # Проверка всех файлов в каталоге
    for FILE in "$WATCH_DIR"/*; do
        # Проверка, является ли объект файлом и не имеет ли расширение .back
        if [ -f "$FILE" ] && [[ "$FILE" != *.back ]]; then
            # Выводим информацию о новом файле
            echo "[$(date)] Новый файл: $(basename "$FILE")"

            # Выводим содержимое файла
            cat "$FILE"

            # Переименовываем файл в формат *.back
            mv "$FILE" "${FILE}.back"
            echo "[$(date)] Переименован в: $(basename "$FILE").back"
        fi
    done

    # Задержка в 2 секунды, чтобы избежать перегрузки CPU
    sleep 2
done
