@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: ==== имя разработчика сохраняется один раз ====
set "NAME_DIR=%USERPROFILE%\kazgruz"
set "NAME_FILE=%NAME_DIR%\name_kazgruz.txt"
if not exist "%NAME_DIR%" mkdir "%NAME_DIR%"
if exist "%NAME_FILE%" (
    set /p DEV_NAME=<"%NAME_FILE%"
) else (
    set /p DEV_NAME=Введите ваше имя: 
    echo %DEV_NAME%>"%NAME_FILE%"
)

:: ==== путь к репозиторию ====
pushd "%~dp0\.."
set "REPO_PATH=%CD%"
popd

:: ==== Telegram ====
set "TG_TOKEN=7590659228:AAEz5jSInR7mWXsm0_25PGhkofJ_bNhPxFk"
set "TG_CHAT_ID=7520366041"

:: ==== время старта ====
for /f "tokens=1-3 delims=:.," %%a in ("%TIME%") do (
    set "START=%%a:%%b:%%c"
    set /a sh=1%%a-100
    set /a sm=1%%b-100
)
echo [INFO] Работа началась: %START%

:: ==== GitHub Desktop ====
start "" "C:\Users\%USERNAME%\AppData\Local\GitHubDesktop\GitHubDesktop.exe"
timeout /t 5 >nul

:: ==== пути к PHP и phpMyAdmin ====
set "PHP_EXE=%~dp0php_tmp\php\php.exe"
set "PUBLIC_PATH=%REPO_PATH%\public"
set "PHPMYADMIN_PATH=%~dp0php_tmp\phpmyadmin"

:: ==== запуск основного сайта (порт 8000) ====
start "php_main" cmd /c ""%PHP_EXE%" -S localhost:8000 -t "%PUBLIC_PATH%""

:: ==== запуск phpMyAdmin (порт 8001) ====
start "php_pma"  cmd /c ""%PHP_EXE%" -S localhost:8001 -t "%PHPMYADMIN_PATH%""

:: ==== VS Code ====
start "" "C:\Users\%USERNAME%\AppData\Local\Programs\Microsoft VS Code\Code.exe" "%REPO_PATH%"

:: ==== открыть браузер ====
start "" http://localhost:8000
start "" http://localhost:8001

:: ==== ожидание закрытия VS Code ====
:wait
tasklist | find /i "Code.exe" >nul
if not errorlevel 1 (
    timeout /t 5 >nul
    goto wait
)

:: ==== время окончания ====
for /f "tokens=1-3 delims=:.," %%a in ("%TIME%") do (
    set "END=%%a:%%b:%%c"
    set /a eh=1%%a-100
    set /a em=1%%b-100
)
echo [INFO] Работа завершена: %END%

:: ==== остановка всех процессов php.exe ====
for /f "tokens=2" %%p in ('tasklist ^| findstr /i "php.exe"') do taskkill /pid %%p /f >nul 2>&1

:: ==== git diff ====
cd /d "%REPO_PATH%"
git diff --shortstat > git_temp.txt
set "DIFF_RESULT=нет изменений"
for /f "tokens=* delims=" %%i in (git_temp.txt) do set "DIFF_RESULT=%%i"
del git_temp.txt

:: ==== расчёт времени ====
set /a workmin=(eh*60+em)-(sh*60+sm)
if !workmin! lss 0 set /a workmin+=1440
set /a wh=workmin/60
set /a wm=workmin%%60

for /f "tokens=1-3 delims=." %%a in ("%DATE%") do (
    set "DAY=%%a"
    set "MONTH=%%b"
    set "YEAR=%%c"
)

:: ==== сообщение ====
set "TEXT=🗓 Дата: !DAY!.!MONTH!.!YEAR!%%0A👤 Разработчик: %DEV_NAME%%%0A🕒 Отчёт%%0A▶️ Начало: %START%%%0A⏹️ Конец: %END%%%0A⌛ Время: !wh! ч !wm! мин%%0A📊 Изменения: %DIFF_RESULT%"

curl -s -X POST ^
  "https://api.telegram.org/bot%TG_TOKEN%/sendMessage" ^
  -d "chat_id=%TG_CHAT_ID%" ^
  -d "text=%TEXT%" >nul

echo [OK] Отчёт отправлен в Telegram.
pause
endlocal
