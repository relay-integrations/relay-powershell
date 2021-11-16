$ScriptUrl = (Relay-Interface get -p '{.scriptUrl}')
$Script = (Relay-Interface get -p '{.script}') 

if ($Script -ne $null -and $Script -ne "") {
    New-Item -Name "script.ps1" -Type File | Out-Null
    foreach ($line in $Script) {
        Add-Content script.ps1 $line
    }
}
elseif($ScriptUrl -ne $null -and $ScriptUrl -ne "") {
    try
    {
        Invoke-WebRequest -Uri $ScriptUrl -OutFile script.ps1
    }
    catch
    {
        Write-Host "Script could not be found at $ScriptUrl"
        exit 1
    }
} else {
    Write-Host "No script or scriptUrl was specified."
    exit 1
}

# Run the script
Invoke-Expression -Command ./script.ps1
exit $LASTEXITCODE
