@echo off

echo ===============================
echo  create shortcut for wca.bat
echo ===============================

set LNKNAME=%1
set SUFFIX=%2
set ISCONFIRM=%3

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

IF "%2" EQU "" ( set /P SUFFIX="Input suffix/argument:" )
rem IF "%3" EQU "" ( set /P ISCONFIRM=" (none for disable):" ) //always enable

set LNKARG=/c .\wca.bat "%SUFFIX%" 1

powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell;$Shortcut = $WshShell.CreateShortcut('%LNKNAME%');$Shortcut.TargetPath = 'C:\Windows\system32\cmd.exe ';$Shortcut.Arguments = '%LNKARG%';$Shortcut.Save();}"
timeout 3

