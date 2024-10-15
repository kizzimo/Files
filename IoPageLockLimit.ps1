$ram = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory -ErrorAction SilentlyContinue
$IOPageLimit = ((($ram / 1GB) * 1024) * 1024) * 128
Reg.exe Add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "IOPageLockLimit" /t REG_DWORD /d "$IOPageLimit" /f > $null 2>&1
Fsutil behavior set disablelastaccess 1 > $null 2>&1