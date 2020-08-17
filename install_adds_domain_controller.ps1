<#
.SYNOPSIS
    Parameterized script for installing additional Domain Controller into existing AD DS forest.
     
.DESCRIPTION
    Custom script with parameters for installing additional Domain Controller into existing AD DS forest.
    The script will install all needed prerequisites before promoting the destination server to Domain Controller. 

.EXAMPLE
    install_adds_domain_controller.ps1 -DomainName "Contoso.com" -DSRMPassword "Pa$$w0rd1234" -DomainAdminPassword "Pa$$w0rd" -DomainAdminUsername "contoso\administrator"

.NOTES
    File Name : install_adds_domain_controller.ps1
    Version   : 1.0
    Author    : Vladimir Stefanovic <vladimir@superadmins.com> 
    Requires  : PowerShell

    --- CHANGELOG ---
    
    v1.0 - 2020-03-18 / Initial version
#>

    [CmdletBinding(SupportsShouldProcess=$True)]
param (
    [Parameter(Mandatory=$true)][string]$DomainName,
    [Parameter(Mandatory=$true)][String]$DSRMPassword,
    [Parameter(Mandatory=$true)][string]$DomainAdminUsername,
    [Parameter(Mandatory=$true)][String]$DomainAdminPassword
)

# Install AD DS feature
Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools

# Define variables and parameters for the new a domain controller
$Password    = ConvertTo-SecureString -String $DomainAdminPassword -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential "$DomainName\$DomainAdminUsername", $Password

$DomainParameters = @{

    DomainName                    = $DomainName
    InstallDns                    = $true
    CreateDnsDelegation           = $false
    DatabasePath                  = "C:\Windows\NTDS"
    LogPath                       = "C:\Windows\NTDS"
    SysvolPath                    = "C:\Windows\SYSVOL"
    NoGlobalCatalog               = $false	    
    NoRebootOnCompletion          = $false
    Force                         = $true
    CriticalReplicationOnly       = $false
    SiteName                      = "Default-First-Site-Name"
    SafeModeAdministratorPassword = ($DSRMPassword | ConvertTo-SecureString -AsPlainText -Force)
    Credential                    = $Credentials

}

# Install an additional domain controller
Import-Module ADDSDeployment
Install-ADDSDomainController @DomainParameters