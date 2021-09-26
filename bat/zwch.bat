@echo off
echo ==========================
echo Zoom Web Client helper[ZWCh]
echo ==========================

set ROOMID=%1
set PWDHASH=%2

rem "%n"は引数
IF "%1" EQU "" ( set /P ROOMID="Input Meeting ID:" )
set ROOMID=%ROOMID: =%

rem IF "%2" EQU "" ( set /P PWDHASH="Input Password Hash:" )
set PWDHASH=%PWDHASH: =%

IF "%2" EQU "" (
  set URL=https://zoom.us/wc/join/%ROOMID%
) ELSE (
  set URL=https://zoom.us/j/%ROOMID%?pwd=%PWDHASH%
)

rem /j/以外にpwdを受け入れるURLは?
rem firefoxとzoomの相性が悪いためEdgeを先頭に.
rem https://qiita.com/Q11Q/items/e34af74330c29614cba1

IF exist "\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" (
  start cmd /C "echo starting Microsoft Edge... & C:\PROGRA~2\Microsoft\Edge\Application\msedge.exe --inprivate %URL%"
) else (  
  IF exist "\Program Files\Mozilla Firefox\firefox.exe" (
    "\Program Files\Mozilla Firefox\firefox.exe" -private-window %URL%
  ) else (
    IF exist "\Program Files (x86)\Mozilla Firefox\firefox.exe" (
      "\Program Files (x86)\Mozilla Firefox\firefox.exe" -private-window %URL%
    ) else (
      IF exist "\Program Files\Google\Chrome\Application\chrome.exe" (
        "\Program Files\Google\Chrome\Application\chrome.exe" --incognito %URL%
      ) else (
        IF exist "\Program Files (x86)\Google\Chrome\Application\chrome.exe" (
          "\Program Files (x86)\Google\Chrome\Application\chrome.exe" --incognito %URL%
        ) else (
            echo "ブラウザが見つかりません"
            start %URL%
        )
      )
    )
  )
)
timeout 3
