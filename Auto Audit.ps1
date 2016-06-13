$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$destinationFolder = "C:\ETCTECH\Audit\"


#test to see if the path exists, create if not
if(!(Test-Path -Path C:\ETCTECH\Audit)){New-Item $destinationFolder -Type Directory}


#detect PS version 
$PSVersion = $PSVersionTable.PSVersion.Major
Write-Host "Detected PowerShell Version $($PSVersion)"

if($PSVersion -lt 3)
{
    #copy file from USB to C:\ETCTECH\Audit
    Copy-Item $scriptPath\ETCTECH\* -Destination $destinationFolder -Recurse -ErrorAction SilentlyContinue

    #detect 32/64-bit and install MBSA 
    if([IntPtr]::Size -eq 4)
    {
        "32-bit MBSA Installation"
        Start-Process "$scriptPath\ETCTECH\Audit Tools\MBSASetup-x86-EN.msi" /qn -Wait
        "Installation complete."
    }
    else
    { 
        "64-bit MBSA Installation"
        Start-Process "$scriptPath\ETCTECH\Audit Tools\MBSASetup-x64-EN.msi" /qn -Wait
        "Installation complete."
    }
}
else
{
    Copy-Item $PSScriptRoot\ETCTECH\* -Destination C:\ETCTECH\Audit -Recurse -ErrorAction SilentlyContinue

    if([IntPtr]::Size -eq 4)
    {
        "32-bit MBSA Installation"
        Start-Process "$PSScriptRoot\ETCTECH\Audit Tools\MBSASetup-x86-EN.msi" /qn -Wait
        "Installation complete."
    }
    else
    { 
        "64-bit MBSA Installation"
        Start-Process "$PSScriptRoot\ETCTECH\Audit Tools\MBSASetup-x64-EN.msi" /qn -Wait
        "Installation complete."
    }
}

#detect if .NET Framework 3.5 is present/install it
if(!(Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5'))
{
    ".NET Framework v3.5 not detected. Installing..."
    Start-Process -FilePath "$PSScriptRoot\ETCTECH\Audit Tools\.NET Framework\dotnetfx35.exe" -ArgumentList "/q /norestart" -Wait -Verb RunAs
    "Installation complete"
}
else
{
    "Sufficient .NET Framework version detected."
}


Read-Host "Press Enter to begin data collection"



invoke-expression 'cmd /c start powershell -windowstyle Hidden -Command "C:\ETCTECH\Audit\Cleanup.ps1"'

#powershell.exe -Command "C:\ETCTECH\Audit\Cleanup.ps1"


exit

