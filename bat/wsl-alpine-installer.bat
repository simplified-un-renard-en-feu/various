@echo off

rem ���̃t�@�C����ANSI�`��(CP932)�ŕۑ����Ă�������
rem Save this file with ANSI (CP932) encoding

echo.
echo ##wsl��alpine��wsl --import�œ�������X�N���v�g
echo ##https://dev.to/milolav/manually-installing-wsl2-distributions-41b4 , 
echo ##https://docs.microsoft.com/ja-jp/windows/wsl/use-custom-distro ���Q��
echo ##2021/10/06�쐬
rem 21/10/13 VS Code�̊g���@�\�uC/C++�v(cpptools)��alpine�̃��C�u�����̂����Ŏg�p�ɓ�� �Q��: https://stackoverflow.com/questions/66963068/docker-alpine-executable-binary-not-found-even-if-in-path
echo.
echo.

rem �ϐ���ύX���ăJ�X�^�}�C�Y�\
set ALPINEURL=https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-minirootfs-3.14.2-x86_64.tar.gz
set HASHURL=https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-minirootfs-3.14.2-x86_64.tar.gz.sha256
set HASHTYPE=SHA256
set ALPINEFILE=alpine-minirootfs-3.14.2-x86_64.tar.gz
set DNAME=alpine-3.14
set USRNAME=alpine
set WSLROOT=%USERPROFILE%\WSL


echo Downloading %ALPINEURL%...
powershell Invoke-WebRequest %ALPINEURL% -o %ALPINEFILE%
if errorlevel 1 (echo �t�@�C���擾�G���[&&pause&&exit)
start %HASHURL%
echo.
echo ##���L�̃n�b�V���� %HASHURL% �ɋL�ڂ���Ă��镶����ƈ�v���邱�Ƃ��m�F���Ă�������
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
echo ##�X�^�[�g���j���[�Ɂuwsl %DNAME%�v��%USRNAME%���O�C���́uWSL %DNAME% normal-user�v���ǉ�����܂���
echo ##����ȍ~�̓X�^�[�g���j���[�̃V���[�g�J�b�g�܂���wsl -d %DNAME% -u [%USRNAME%�܂���root] �ŋN���ł��܂�
echo ##su %USRNAME% ��wsl��Ŏ��s���ĊǗ��҃V�F�������ʃ��[�U�[�V�F���Ɉړ����܂�
echo ##########################################################
pause