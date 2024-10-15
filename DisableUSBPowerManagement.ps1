# Check administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Disable power management for USB ports and hubs
function Disable-USBPowerManagement {
    param (
        [string]$ClassName
    )

    $hubs = Get-WmiObject -Class $ClassName
    $powerMgmt = Get-WmiObject -Class MSPower_DeviceEnable -Namespace root\wmi

    foreach ($p in $powerMgmt) {
        $IN = $p.InstanceName.ToUpper()
        foreach ($h in $hubs) {
            $PNPDI = $h.PNPDeviceID
            if ($IN -like "*$PNPDI*") {
                Write-Host "info: configuring $IN"
                $p.enable = $False
                $p.psbase.put() | Out-Null
            }
        }
    }
}

# Apply to only hubs and USB drivers, other classes can be added manually
Disable-USBPowerManagement -ClassName 'Win32_USBController'
Disable-USBPowerManagement -ClassName 'Win32_USBControllerDevice'
Disable-USBPowerManagement -ClassName 'Win32_USBHub'
