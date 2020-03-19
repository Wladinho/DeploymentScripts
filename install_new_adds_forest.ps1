<#
.SYNOPSIS
    Parameterized script for installing a new AD DS forest.
     
.DESCRIPTION
    Custom script with parameters for installing a new AD DS forest.
    The script will install all needed prerequisites before promoting the destination server to Domain Controller. 

.EXAMPLE
    install_new_adds_forest.ps1 -DomainName "Contoso.com" -DomainNetBiosName "CONTOSO" -DSRMPassword "Pa$$w0rd1234"

.NOTES
    File Name : install_new_adds_forest.ps1
    Version   : 1.1 
    Author    : Vladimir Stefanovic <vladimir@superadmins.com> 
    Requires  : PowerShell

    --- CHANGE LOG ---
    
    v1.1 - 2020-03-19 / Typos has been fixed.
                        Script name has been changed.

    v1.0 - 2020-03-10 / Initial version
#>

    [CmdletBinding()]
param (
    [Parameter(Mandatory=$true)][string]$DomainName,
    [Parameter(Mandatory=$true)][string]$DomainNetBiosName,
    [Parameter(Mandatory=$true)][SecureString]$DSRMPassword
)

# Install AD DS feature
Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools

# Define parameters for the new forest 
$DomainParameters = @{

    DomainName                    = $DomainName
    DomainNetbiosName             = $DomainNetBiosName
    ForestMode                    = "WinThreshold"
    DomainMode                    = "WinThreshold"    
    InstallDns                    = $true
    CreateDnsDelegation           = $false
    DatabasePath                  = "C:\Windows\NTDS"
    LogPath                       = "C:\Windows\NTDS"
    SysvolPath                    = "C:\Windows\SYSVOL"
    NoRebootOnCompletion          = $false
    Force                         = $true
    SafeModeAdministratorPassword = $DSRMPassword

}

# Install new ADDS forest
Import-Module ADDSDeployment
Install-ADDSForest @DomainParameters