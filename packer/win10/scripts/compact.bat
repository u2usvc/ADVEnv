REM This script performs Windows disk cleanup and optimization:
REM - Clears Windows Update cache
REM - Disables hibernation to remove hiberfil.sys
REM - Shrinks WinSxS folder to reduce system image size
REM - Installs and runs sdelete to zero free space for better compression

net stop wuauserv
rmdir /S /Q C:\Windows\SoftwareDistribution\Download
mkdir C:\Windows\SoftwareDistribution\Download
net start wuauserv

REM Remove hibernation file
powercfg /h off 

REM Shrink winsxs folder
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

REM Install sdelete in prep for zeroing unused space
choco install sdelete -y

REM zerofill disk for easy shrinking and compression
sdelete.exe /accepteula -z c:

REM compaction finished
