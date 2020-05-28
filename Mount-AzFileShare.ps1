[CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)][string]$StorageAccountName,
        [Parameter(Mandatory = $True)][string]$StorageAccountKey,
        [Parameter(Mandatory = $True)][string]$FileShareName
    )

$connectTestResult = Test-NetConnection -ComputerName "$StorageAccountName.file.core.windows.net" -Port 445

if ($connectTestResult.TcpTestSucceeded) {
    
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"$StorageAccountName.file.core.windows.net`" /user:`"Azure\$StorageAccountName`" /pass:`"$StorageAccountKey`""
    
    # Mount the drive
    net use X: "\\$StorageAccountName.file.core.windows.net\$FileShareName" /p:yes
    
    } else
        {
        Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
    }