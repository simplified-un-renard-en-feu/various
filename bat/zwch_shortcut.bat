@echo off

echo ===============================
echo  create Shortcut for zwch.bat
echo ===============================
echo notice: execute this tool with file placed in same directory with zwch.bat
echo;

set LNKNAME=%1
set ISABSOLUTE=%2
set ROOMID=%3
set PWDHASH=%4

cd %~dp0

echo absolute path mode: able to execute and move link anywhere but can't move zwch.bat (for internal drive)
echo relative path mode: able to move the parent folder but must execute link in the same folder with zwch.bat (for removable storage)
echo;
:isabsolute
IF "%2" EQU "" (
set /P ISABSOLUTE=Select Mode^(0^: absolute path mode, 1^: relative path mode^)[0]:
)
IF "%ISABSOLUTE%" EQU "0" ( set BATCHDIR=%~dp0
) ELSE IF "%ISABSOLUTE%" EQU "" ( set BATCHDIR=%~dp0
) ELSE IF "%ISABSOLUTE%" EQU "1" ( set BATCHDIR=.\
) ELSE (goto :isabsolute)

:lnkname
IF "%1" EQU "" (
set /P LNKNAME=Input Shortcut Name^(^\,^/,^*,^?,^",^<,^>,^| are invalid^):
)
IF "%LNKNAME%" EQU "" ( goto :lnkname )
rem echo '%LNKNAME%' | find \" >NUL
rem if not ERRORLEVEL 1 ( echo error: invalid character^(^\,^/,^*,^?,^",^<,^>,^|^) & goto :lnkname)
echo '%LNKNAME%' | find "\" >NUL
if not ERRORLEVEL 1 ( echo error: invalid character^(^\,^/,^*,^?,^",^<,^>,^|^) & goto :lnkname)
echo '%LNKNAME%' | find "/" >NUL
if not ERRORLEVEL 1 ( echo error: invalid character^(^\,^/,^*,^?,^",^<,^>,^|^) & goto :lnkname)
echo '%LNKNAME%' | find "*" >NUL
if not ERRORLEVEL 1 ( echo error: invalid character^(^\,^/,^*,^?,^",^<,^>,^|^) & goto :lnkname)
echo '%LNKNAME%' | find "?" >NUL
if not ERRORLEVEL 1 ( echo error: invalid character^(^\,^/,^*,^?,^",^<,^>,^|^) & goto :lnkname)
echo '%LNKNAME%' | find "<" >NUL
if not ERRORLEVEL 1 ( echo error: invalid character^(^\,^/,^*,^?,^",^<,^>,^|^) & goto :lnkname)
echo '%LNKNAME%' | find ">" >NUL
if not ERRORLEVEL 1 ( echo error: invalid character^(^\,^/,^*,^?,^",^<,^>,^|^) & goto :lnkname)
echo '%LNKNAME%' | find "|" >NUL
if not ERRORLEVEL 1 ( echo error: invalid character^(^\,^/,^*,^?,^",^<,^>,^|^) & goto :lnkname)
set LNKNAME=%LNKNAME%.lnk

IF "%3" EQU "" ( set /P ROOMID="Input Meeting ID:" )
IF "%4" EQU "" ( set /P PWDHASH="Input Password Hash (press enter to skip):" )

set LNKARG=/c %BATCHDIR%zwch.bat %ROOMID% %PWDHASH%

powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell;$Shortcut = $WshShell.CreateShortcut('%LNKNAME%');$Shortcut.TargetPath = 'C:\Windows\system32\cmd.exe ';$Shortcut.Arguments = '%LNKARG%';$Shortcut.Save();}"
timeout 3

