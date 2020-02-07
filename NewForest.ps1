    [CmdletBinding()]
param (
    [Parameter(Mandatory=$true)][string]$DomainName,
    [Parameter(Mandatory=$true)][string]$DomainNetBiosName,
    [Parameter(Mandatory=$true)][string]$DSRMPassword
)

# Install AD DS feature
Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools

# Define variables for the new forest 
$DomainParameters = @{

    DomainName                    = $DomainName
    CreateDnsDelegation           = $false
    ForestMode                    = "WinThreshold"
    DomainNetbiosName             = $DomainNetBiosName
    InstallDns                    = $true
    DatabasePath                  = "C:\Windows\NTDS"
    LogPath                       = "C:\Windows\NTDS"
    SysvolPath                    = "C:\Windows\SYSVOL"
    NoRebootOnCompletion          = $false
    Force                         = $true
    SafeModeAdministratorPassword = ($DSRMPassword | ConvertTo-SecureString -AsPlainText -Force)

}

# Install new forest
Import-Module ADDSDeployment
Install-ADDSForest @DomainParameters
