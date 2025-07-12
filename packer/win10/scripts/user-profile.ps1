# CreateOnlyUserProfile.ps1

param(
    [Parameter(Mandatory = $true)][string]$Username,
    [string]$Domain = $env:USERDOMAIN
)

& {
    param($Username, $Domain)

    $typeName = 'UserEnvProfileCreator'
    if (-not ([System.Management.Automation.PSTypeName]$typeName).Type) {
        Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;

public static class $typeName {
    [DllImport("userenv.dll", SetLastError=true, CharSet=CharSet.Unicode)]
    public static extern int CreateProfile(
        string pszUserSid,
        string pszUserName,
        StringBuilder pszProfilePath,
        uint cchProfilePath
    );
}
"@
    }

    # Translate username to SID
    try {
        if ($Domain) {
            $account = New-Object System.Security.Principal.NTAccount($Domain, $Username)
        } else {
            $account = New-Object System.Security.Principal.NTAccount($Username)
        }
        $sid = $account.Translate([System.Security.Principal.SecurityIdentifier]).Value
    } catch {
        Write-Error "Could not find SID for $Domain\$Username"
        return
    }

    # Create the profile
    $sb = New-Object System.Text.StringBuilder 260
    $result = [UserEnvProfileCreator]::CreateProfile($sid, $Username, $sb, $sb.Capacity)

    if ($result -eq 0) {
        Write-Host "Profile created for $Domain\$Username at path: $($sb.ToString())" -ForegroundColor Green
    } elseif ($result -eq -2147024713) {
        Write-Host "Profile for $Domain\$Username already exists." -ForegroundColor Yellow
    } else {
        Write-Error "Failed with error code: $result"
    }
} -ArgumentList $Username, $Domain

