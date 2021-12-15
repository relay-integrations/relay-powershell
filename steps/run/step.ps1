$ErrorActionPreference = "Stop"

$ScriptUrl = (Relay-Interface get -p '{.scriptUrl}')
$Script = (Relay-Interface get -p '{.script}') 
$GitRepo = (Relay-Interface get -p '{.git.repository}')
$GitScriptPath = (Relay-Interface get -p '{.git.scriptPath}')

$GitBranch = (Relay-Interface get -p '{.git.revision}')
if ($null -eq $GitBranch) { $GitBranch = "main" }

$WorkDir = $env:WORKDIR
if ($null -eq $WorkDir) { $WorkDir = "/workspace" }
New-Item $WorkDir -Force -ItemType Directory | Out-Null

$ScriptName = "script.ps1"
$ScriptPath = "$WorkDir/$ScriptName"
function RunScript {
    param ( 
        [string]$ScriptPath
    )
    Invoke-Expression -Command $ScriptPath 
    exit $LASTEXITCODE
}

if ($null -eq $Script -and $null -eq $ScriptUrl -and $null -eq $GitScriptPath) {
    Write-Host "No script, scriptUrl or git.scriptPath was specified."
    exit 1
}

if ($null -ne $Script -and "" -ne $Script) {
    New-Item -Path $ScriptPath -Type File | Out-Null
    foreach ($line in $Script) {
        Add-Content $ScriptPath $line
    }
    RunScript($ScriptPath)
}

if ($null -ne $ScriptUrl -and "" -ne $ScriptUrl) {
    try
    {
        Invoke-WebRequest -Uri $ScriptUrl -OutFile $ScriptPath
        RunScript($ScriptPath)
    }
    catch
    {
        Write-Host "Script could not be found at $ScriptUrl"
        exit 1
    }
} 

if($null -eq $GitRepo) {
    Write-Host "Need to also specify git.repository if git.scriptPath is specified"
    exit 1
}

$RepoPath = "$WorkDir/repo"
Relay-Interface git clone -d $RepoPath -r $GitBranch
if ($LASTEXITCODE -ne 0) {
    throw "Could not clone $GitRepo"
}
RunScript("$RepoPath/default/$GitScriptPath")
