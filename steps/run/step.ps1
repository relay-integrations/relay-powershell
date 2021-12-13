$ErrorActionPreference = "Stop"

$ScriptUrl = (Relay-Interface get -p '{.scriptUrl}')
$Script = (Relay-Interface get -p '{.script}') 
$GitRepo = (Relay-Interface get -p '{.git.repository}')
$GitScriptPath = (Relay-Interface get -p '{.git.scriptPath}')

$GitBranch = (Relay-Interface get -p '{.git.revision}')
if ($GitBranch -eq $null) { $GitBranch = "main" }

$WorkDir = $env:WORKDIR
if ($WorkDir -eq $null) { $WorkDir = "/workspace" }

function RunScript {
    param ( 
        [string]$ScriptPath
    )
    Invoke-Expression -Command $ScriptPath 
    exit $LASTEXITCODE

}

if ($Script -eq $null -and $ScriptUrl -eq $null -and $GitScriptPath -eq $null) {
    Write-Host "No script, scriptUrl or git.scriptPath was specified."
    exit 1
}

if ($Script -ne $null -and $Script -ne "") {
    New-Item -Name "script.ps1" -Type File | Out-Null
    foreach ($line in $Script) {
        Add-Content script.ps1 $line
    }
    RunScript("script.ps1")
}

if($ScriptUrl -ne $null -and $ScriptUrl -ne "") {
    try
    {
        Invoke-WebRequest -Uri $ScriptUrl -OutFile script.ps1
        RunScript("script.ps1")
    }
    catch
    {
        Write-Host "Script could not be found at $ScriptUrl"
        exit 1
    }
} 


if($GitRepo -eq $null) {
    Write-Host "Need to also specify git.repository if git.scriptPath is specified"
    exit 1
}

New-Item $WorkDir -Force -ItemType Directory
$RepoPath = "$WorkDir/repo"
Relay-Interface git clone -d "$WorkDir/repo" -r $GitBranch
RunScript("$RepoPath/default/$GitScriptPath")
