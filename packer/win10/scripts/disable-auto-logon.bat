REM Disables automatic logon by setting AutoAdminLogon registry key to 0
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoAdminLogon /d 0 /f
