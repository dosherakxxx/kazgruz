@echo off
setlocal EnableDelayedExpansion

:: === АВТОМАТИЧЕСКИ ПОЛУЧАЕМ ПУТЬ К ПРОЕКТУ ===
set "REPO_PATH=%~dp0"
set "TG_TOKEN=7590659228:AAEz5jSInR7mWXsm0_25PGhkofJ_bNhPxFk"
set "TG_CHAT_ID=7520366041"
set "REPORT_PATH=%REPO_PATH%\report.txt"

:: === ВРЕМЯ НАЧАЛА ===
set "START=%TIME%"
set "TODAY=%DATE%"
echo [INFO] Работа началась: %START%
echo Работа началась: %START% > "%REPORT_PATH%"

:: === ЗАПУСК GITHUB DESKTOP ===
start "" "C:\Users\%USERNAME%\AppData\Local\GitHubDesktop\GitHubDesktop.exe"
timeout /t 5 >nul

:: === ЗАПУСК VS CODE С ПРОЕКТОМ ===
start "" "C:\Users\%USERNAME%\AppData\Local\Programs\Microsoft VS Code\Code.exe" "%REPO_PATH%"

:: === ОЖИДАНИЕ ЗАКРЫТИЯ VS CODE ===
echo [INFO] Ожидание завершения работы в VS Code...
:waitloop
tasklist | find /i "Code.exe" >nul
if not errorlevel 1 (
    timeout /t 5 >nul
    goto waitloop
)

:: === ВРЕМЯ ОКОНЧАНИЯ ===
set "END=%TIME%"
echo Работа завершена: %END% >> "%REPORT_PATH%"
echo [INFO] VS Code закрыт в %END%

:: === СЧЁТ СТРОК КОДА ===
cd /d "%REPO_PATH%"
git diff --shortstat > temp_diff.txt
echo Изменения в коде: >> "%REPORT_PATH%"
type temp_diff.txt >> "%REPORT_PATH%"
del temp_diff.txt

:: === ПОДСЧЁТ ОБЩЕГО ВРЕМЕНИ ===
set /a sh=%START:~0,2%
set /a sm=%START:~3,2%
set /a eh=%END:~0,2%
set /a em=%END:~3,2%
set /a workmin=(eh*60+em)-(sh*60+sm)
set /a wh=workmin/60
set /a wm=workmin%%60
echo Общее рабочее время: !wh! ч !wm! мин >> "%REPORT_PATH%"

:: === ОТПРАВКА ОТЧЁТА В TELEGRAM ===
echo Отправка отчёта в Telegram...
set /p MESSAGE=<"%REPORT_PATH%"
curl -s -X POST "https://api.telegram.org/bot%TG_TOKEN%/sendMessage" -d "chat_id=%TG_CHAT_ID%" -d "text=📋 Отчёт:%0AРабота началась: %START%%0AРабота завершена: %END%%0AВремя: !wh! ч !wm! мин" >nul

for /f "tokens=* delims=" %%i in (%REPORT_PATH%) do (
    set "LINE=%%i"
    curl -s -X POST "https://api.telegram.org/bot%TG_TOKEN%/sendMessage" -d "chat_id=%TG_CHAT_ID%" -d "text=!LINE!" >nul
)

echo Отчёт успешно отправлен в Telegram!
pause
endlocal
