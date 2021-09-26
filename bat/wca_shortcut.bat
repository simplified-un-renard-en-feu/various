@echo off

echo ===============================
echo  create shortcut for wca.bat
echo ===============================

set ISABSOLUTE=%1
set LNKNAME=%2
set SUFFIX=%3
rem set ISCONFIRM=%3


cd %~dp0

echo absolute path mode: able to execute and move link anywhere but can't move zwch.bat
echo relative path mode: able to move the parent folder but must execute link in the same folder with zwch.bat
echo;

:isabsolute
IF "%1" EQU "" (
set /P ISABSOLUTE=Select Mode^(0^: absolute path mode, 1^: relative path mode^)[0]:
)
IF "%ISABSOLUTE%" EQU "0" ( set BATCHDIR=%~dp0
) ELSE IF "%ISABSOLUTE%" EQU "" ( set BATCHDIR=%~dp0
) ELSE IF "%ISABSOLUTE%" EQU "1" ( set BATCHDIR=.\
) ELSE (goto :isabsolute)


:lnkname
IF "%2" EQU "" (
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

IF "%3" EQU "" ( set /P SUFFIX="Input suffix/argument:" )
set SUFFIX=%SUFFIX: =%
rem IF "%4" EQU "" ( set /P ISCONFIRM=" (none for disable):" ) //always enable

set LNKARG=/c %BATCHDIR%wca.bat "%SUFFIX%" 1

powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell;$Shortcut = $WshShell.CreateShortcut('%LNKNAME%');$Shortcut.TargetPath = 'C:\Windows\system32\cmd.exe ';$Shortcut.Arguments = '%LNKARG%';$Shortcut.Save();}"
timeout 3

