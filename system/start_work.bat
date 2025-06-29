@echo off
setlocal EnableDelayedExpansion

:: === ПЕРЕХОД К КОРНЮ ПРОЕКТА
pushd "%~dp0\.."
set "REPO_PATH=%CD%"
popd

:: === TELEGRAM НАСТРОЙКИ
set "TG_TOKEN=7590659228:AAEz5jSInR7mWXsm0_25PGhkofJ_bNhPxFk"
set "TG_CHAT_ID=7520366041"

:: === ВРЕМЯ НАЧАЛА
set "START=%TIME%"
echo [INFO] Работа началась: %START%

:: === ЗАПУСК GITHUB DESKTOP
start "" "C:\Users\%USERNAME%\AppData\Local\GitHubDesktop\GitHubDesktop.exe"
timeout /t 5 >nul

:: === ЗАПУСК VS CODE
start "" "C:\Users\%USERNAME%\AppData\Local\Programs\Microsoft VS Code\Code.exe" "%REPO_PATH%"

:: === ОЖИДАНИЕ ЗАКРЫТИЯ VS CODE
echo [INFO] Ожидание завершения работы в VS Code...
:waitloop
tasklist | find /i "Code.exe" >nul
if not errorlevel 1 (
    timeout /t 5 >nul
    goto waitloop
)

:: === ВРЕМЯ ЗАВЕРШЕНИЯ
set "END=%TIME%"
echo [INFO] Работа завершена: %END%

:: === ПОДСЧЁТ ИЗМЕНЕНИЙ GIT
cd /d "%REPO_PATH%"
git diff --shortstat > temp_git.txt
set "DIFF_RESULT=нет изменений"
for /f "tokens=* delims=" %%i in (temp_git.txt) do (
    set "DIFF_RESULT=%%i"
)
del temp_git.txt

:: === ПОДСЧЁТ ВРЕМЕНИ
set /a sh=%START:~0,2%
set /a sm=%START:~3,2%
set /a eh=%END:~0,2%
set /a em=%END:~3,2%
set /a workmin=(eh*60+em)-(sh*60+sm)
if %workmin% lss 0 set /a workmin+=1440
set /a wh=workmin/60
set /a wm=workmin%%60

:: === СОБИРАЕМ СООБЩЕНИЕ В ОДНОЙ ПЕРЕМЕННОЙ
set "MSG=🕒 Отчёт:%%0A▶️ Старт: %START%%%0A⏹️ Конец: %END%%%0A⌛ Время: !wh! ч !wm! мин%%0A📊 Изменения: %DIFF_RESULT%"

:: === СОХРАНЯЕМ ВРЕМЕННЫЙ ФАЙЛ С UTF-8
set "TEMPFILE=%TEMP%\tg_report.txt"
echo %MSG% > "%TEMPFILE%"
powershell -Command "Get-Content '%TEMPFILE%' | Out-File -FilePath '%TEMPFILE%' -Encoding UTF8"
set /p MSG_UTF=<"%TEMPFILE%"
del "%TEMPFILE%"

curl -s -X POST "https://api.telegram.org/bot%TG_TOKEN%/sendMessage" ^
 -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" ^
 --data-urlencode "chat_id=%TG_CHAT_ID%" ^
 --data-urlencode "text=%MSG_UTF%" >nul

echo [OK] Отчёт отправлен в Telegram.
pause
endlocal
