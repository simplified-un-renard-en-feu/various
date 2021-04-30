@echo off
rem "Web Client of Any [WCA]"

set Arg=%1

IF "%1" EQU "" ( set /P Arg="Input Argument:" )

FOR /F %%i in ('type uri.txt') DO @SET Head=%%i

set URL=%Head%%Arg%
echo ===========
echo URL: "%URL%"
echo ===========
IF "%2" EQU "" (
echo Access?
echo ===========
timeout -1
)


IF exist "\Program Files\Mozilla Firefox\firefox.exe" (
  "\Program Files\Mozilla Firefox\firefox.exe" -private-window "%URL%"
) else (
  IF exist "\Program Files (x86)\Mozilla Firefox\firefox.exe" (
    start "\Program Files (x86)\Mozilla Firefox\firefox.exe" -private-window "%URL%"
  ) else (
  IF exist "\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe" (
    powershell.exe start shell:AppsFolder\Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge -ArgumentList "'-private',%URL%"
  ) else (
    IF exist "\Program Files\Google\Chrome\Application\chrome.exe" (
      "\Program Files\Google\Chrome\Application\chrome.exe" --incognito "%URL%"
    ) else (
      IF exist "\Program Files (x86)\Google\Chrome\Application\chrome.exe" (
        "\Program Files (x86)\Google\Chrome\Application\chrome.exe" --incognito "%URL%"
      ) else (
          echo "ブラウザが見つかりません"
          start "%URL%"
          timeout -1
        )
      )
    )
  )
)
timeout 3
