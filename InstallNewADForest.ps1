<#
.Synopsis
    Parameterized script for installing new AD DS forest.
     
.DESCRIPTION
    Custom script with parameters for installing new AD DS forest.
    Script will install all needed prerequisites, before promote destination server to Domain Controller. 

.EXAMPLE
    InstallNewADForest.ps1 -DomainName <> -DomainNetBiosName <> -DSRMPassword <>
#>

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
    DomainNetbiosName             = $DomainNetBiosName
    ForestMode                    = "WinThreshold"    
    InstallDns                    = $true
    CreateDnsDelegation           = $false
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