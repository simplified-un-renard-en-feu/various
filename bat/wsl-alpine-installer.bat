@echo off

rem ���̃t�@�C����ANSI�`���ŕۑ����Ă�������

echo.
echo ##wsl��alpine��wsl --import�œ�������X�N���v�g
echo ##https://dev.to/milolav/manually-installing-wsl2-distributions-41b4 , 
echo ##https://docs.microsoft.com/ja-jp/windows/wsl/use-custom-distro ���Q��
echo ##2021/10/06�쐬
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
wsl -d %DNAME% cd /root; echo "date;cd~" \> .profile
wsl -d %DNAME% cd /home/%USRNAME%; echo "date;cd~" \> .profile


cd %APPDATA%\Microsoft\Windows\Start Menu\Programs
echo powershell -Command "& {$WshShell = New-Object -comObject WScript.Shell;$Shortcut = $WshShell.CreateShortcut('wsl %DNAME%');$Shortcut.TargetPath = 'wsl';$Shortcut.Arguments = '-d %DNAME%';$Shortcut.Save();}"


echo.
echo ##########################################################
echo ##�X�^�[�g���j���[��wsl %DNAME%���ǉ�����܂���
echo ##����ȍ~�̓X�^�[�g���j���[�̃V���[�g�J�b�g�܂���wsl -d %DNAME% -u %USRNAME% �ŋN������܂�
echo ##su %USRNAME% ��wsl��Ŏ��s���ĊǗ��҃V�F�������ʃ��[�U�[�V�F���Ɉړ����܂�
echo ## "wsl -d %DNAME% cd ~; echo 'date; su alpine' ^> .profile" �����s���ċN�������O�C������ʃ��[�U�[�ɕύX���܂�
echo ##########################################################
pause