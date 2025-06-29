@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: === ПЕРЕХОД К КОРНЮ ПРОЕКТА
pushd "%~dp0\.."
set "REPO_PATH=%CD%"
popd

:: === TELEGRAM НАСТРОЙКИ
set "TG_TOKEN=7590659228:AAEz5jSInR7mWXsm0_25PGhkofJ_bNhPxFk"
set "TG_CHAT_ID=7520366041"

:: === ВРЕМЯ НАЧАЛА (часы:минуты:секунды)
for /f "tokens=1-3 delims=:.," %%a in ("%TIME%") do (
    set "START=%%a:%%b:%%c"
    set /a sh=1%%a - 100
    set /a sm=1%%b - 100
)

echo [INFO] Работа началась: %START%

:: === ЗАПУСК GITHUB DESKTOP
start "" "C:\Users\%USERNAME%\AppData\Local\GitHubDesktop\GitHubDesktop.exe"
timeout /t 5 >nul

:: === ЗАПУСК VS CODE
start "" "C:\Users\%USERNAME%\AppData\Local\Programs\Microsoft VS Code\Code.exe" "%REPO_PATH%"

:: === ОЖИДАНИЕ ЗАКРЫТИЯ VS CODE
:waitloop
tasklist | find /i "Code.exe" >nul
if not errorlevel 1 (
    timeout /t 5 >nul
    goto waitloop
)

:: === ВРЕМЯ ОКОНЧАНИЯ (часы:минуты:секунды)
for /f "tokens=1-3 delims=:.," %%a in ("%TIME%") do (
    set "END=%%a:%%b:%%c"
    set /a eh=1%%a - 100
    set /a em=1%%b - 100
)

echo [INFO] Работа завершена: %END%

:: === ПОДСЧЁТ ИЗМЕНЕНИЙ
cd /d "%REPO_PATH%"
git diff --shortstat > git_temp.txt
set "DIFF_RESULT=нет изменений"
for /f "tokens=* delims=" %%i in (git_temp.txt) do (
    set "DIFF_RESULT=%%i"
)
del git_temp.txt

set /a workmin=(eh*60+em)-(sh*60+sm)
if !workmin! lss 0 set /a workmin+=1440
set /a wh=workmin / 60
set /a wm=workmin %% 60

set "TEXT=🕒 Отчёт%%0A▶️ Начало: %START%%%0A⏹️ Конец: %END%%%0A⌛ Время: !wh! ч !wm! мин%%0A📊 Изменения: %DIFF_RESULT%"

curl -s -X POST ^
  "https://api.telegram.org/bot%TG_TOKEN%/sendMessage" ^
  -d "chat_id=%TG_CHAT_ID%" ^
  -d "text=%TEXT%" >nul

echo [OK] Отчёт отправлен в Telegram.
pause
endlocal
