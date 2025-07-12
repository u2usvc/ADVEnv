# reconfigure winrm after sysprep
# check with echo '' | openssl s_client -connect 192.168.125.12:5986
#
Set-Service -Name "WinRM" -StartupType Automatic -Status Running
$Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName "192.168.125.12"

Get-ChildItem -Path WSMan:\LocalHost\Listener | Where-Object { $_.Keys -match 'Transport=HTTPS' } | Remove-Item -Recurse -Force
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint -Force

cmd.exe /c 'winrm set winrm/config/service/auth "@{Basic=\"true\"}"'
