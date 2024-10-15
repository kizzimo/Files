# speeds up powershell startup time by 10x
$env:path = "$([Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory());" + $env:path
[AppDomain]::CurrentDomain.GetAssemblies().Location | ? {$_} | % {
    ngen install $_ | Out-Null
}