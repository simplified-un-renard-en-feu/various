@echo off

rem このファイルはANSI形式(CP932)で保存してください
rem Save this file with ANSI (CP932) encoding

echo.
echo ##wslにalpineをwsl --importで導入するスクリプト
echo ##https://dev.to/milolav/manually-installing-wsl2-distributions-41b4 , 
echo ##https://docs.microsoft.com/ja-jp/windows/wsl/use-custom-distro を参照
echo ##2021/10/06作成
rem 21/10/13 VS Codeの拡張機能「C/C++」(cpptools)がalpineのライブラリのせいで使用に難あり 参照: https://stackoverflow.com/questions/66963068/docker-alpine-executable-binary-not-found-even-if-in-path
echo.
echo.

rem 変数を変更してカスタマイズ可能
set ALPINEURL=https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-minirootfs-3.14.2-x86_64.tar.gz
set HASHURL=https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-minirootfs-3.14.2-x86_64.tar.gz.sha256
set HASHTYPE=SHA256
set ALPINEFILE=alpine-minirootfs-3.14.2-x86_64.tar.gz
set DNAME=alpine-3.14
set USRNAME=alpine
set WSLROOT=%USERPROFILE%\WSL


echo Downloading %ALPINEURL%...
powershell Invoke-WebRequest %ALPINEURL% -o %ALPINEFILE%
if errorlevel 1 (echo ファイル取得エラー&&pause&&exit)
start %HASHURL%
echo.
echo ##下記のハッシュが %HASHURL% に記載されている文字列と一致することを確認してください
echo.
CertUtil -hashfile %ALPINEFILE% %HASHTYPE%
pause


echo.
mkdir %WSLROOT%\%DNAME%
wsl --import alpine-3.14 %USERPROFILE%\WSL\%DNAME% .\%ALPINEFILE%
del %ALPINEFILE%
wsl -d %DNAME% /usr/sbin/adduser -D %USRNAME%
wsl -d %DNAME% apk update ^&^& apk add libstdc++ alpine-sdk
wsl -d %DNAME% cd /root; echo "date;cd ~" ^> .profile
wsl -d %DNAME% cd /home/%USRNAME%; echo "date;cd ~" ^> .profile
wsl -d %DNAME% echo -e "[user]\ndefault=%USRNAME%" ^> /etc/wsl.conf 
wsl -d %DNAME% --shutdown

cd %APPDATA%\Microsoft\Windows\Start Menu\Programs
powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell;$Shortcut = $WshShell.CreateShortcut('WSL %DNAME% root.lnk');$Shortcut.TargetPath = 'wsl';$Shortcut.Arguments = '-d %DNAME% -u root';$Shortcut.Save();}"
powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell;$Shortcut = $WshShell.CreateShortcut('WSL %DNAME% normal-user.lnk');$Shortcut.TargetPath = 'wsl';$Shortcut.Arguments = '-d %DNAME% -u %USRNAME%';$Shortcut.Save();}"


echo.
echo ##########################################################
echo ##スタートメニューに「wsl %DNAME%」と%USRNAME%ログインの「WSL %DNAME% normal-user」が追加されました
echo ##次回以降はスタートメニューのショートカットまたはwsl -d %DNAME% -u [%USRNAME%またはroot] で起動できます
echo ##su %USRNAME% をwsl上で実行して管理者シェルから一般ユーザーシェルに移動します
echo ##########################################################
pause