⚙️ system

Служебная папка для управления рабочими процессами команды в проекте.

🚗 О проекте

Это внутренняя платформа по продаже автомобилей от грузинских поставщиков.Проект включает:

🌐 Веб-сайт (HTML, CSS, JS, React)

📱 Мобильное приложение (React Native)

☁️ Единый PHP-бэкенд и база данных

👥 Команду разработчиков и менеджера

🔁 CI-like скрипт контроля времени и изменений

Код хранится в одном общем репозитории. Работа ведётся через GitHub Desktop и Visual Studio Code.

🧱 Структура проекта

kazgruz/
├── public/         # Главная директория, с неё запускается PHP-сервер
│   ├── index.html  # Главная точка входа
│   ├── backend/    # PHP-файлы, API, логика (НЕ СОЗДАВАТЬ ПАПКИ ТОЛЬКО ФАЙЛЫ)
│   └── frontend/   # HTML, CSS, JS, подкаталоги
│       ├── html/
│       ├── style/
│       └── js/
│
├── system/         # Служебная папка для запуска и трекинга
│   ├── php_tmp/    # PHP установленный
│   ├── start_work.bat
│   └── README.md

📁 Содержимое system

Файл

Назначение

start_work.bat

🎯 Скрипт контроля рабочего времени. Запускает PHP-сервер, редактор, трекает время и отправляет отчёт.

php_tmp/

💾 Локальный PHP (если отсутствует в системе)

README.md

📘 Инструкция (этот файл)

.gitattributes

⚙️ Git-настройки (по желанию)

🚀 Как начать работу

Каждый разработчик обязан запускать start_work.bat перед началом работы.

Шаги:

Перейди в папку system

Запусти start_work.bat двойным щелчком

Скрипт автоматически:

🔄 Проверит наличие PHP, при необходимости скачает портативную версию

🚀 Запустит PHP-сервер на http://localhost:8000/ из папки public

🌐 Откроет браузер на нужной странице

📁 Откроет GitHub Desktop

🛠 Откроет Visual Studio Code

🕓 Засечёт время начала работы

Работай как обычно: редактируй HTML/CSS/JS, пиши PHP API и т.п.

Делаешь коммит вручную:

В GitHub Desktop: заполни Summary (своё имя) и Description (описание работы)

Нажми Push origin

По завершении — закрой VS Code

Скрипт:

⏹ Засечёт время завершения

🔍 Подсчитает изменения (git diff)

📬 Отправит отчёт в Telegram-чат админа

❌ Остановит PHP-сервер

📬 Пример Telegram-отчёта

🗓 Дата: 29.06.2025
🕒 Отчёт
▶️ Начало: 14:03:55
⏹️ Конец: 16:27:12
⌛ Время: 2 ч 23 мин
📊 Изменения: 5 files changed, 112 insertions(+), 7 deletions(-)

✅ Правила

Работай строго по графику: 5/2, по 4 часа в день

Запускай start_work.bat перед началом

Не пропускай коммиты! — вручную через GitHub Desktop

VS Code закрывается = конец работы

Автоматически отправляется Telegram-отчёт

Не используй сторонние таймеры — всё считает скрипт

Использование GitHub Copilot и AI-помощников разрешено

Автор проекта: @dosherakxxxx
