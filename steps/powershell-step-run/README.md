# powershell-step-run

This step runs a PowerShell script using the latest version of PowerShell (7.2).

## Specification

This step expects the following fields in the `spec` section of a workflow step definition that uses it:

| Setting      | Data type | Description                             | Default | Required |
| ------------ | --------- | --------------------------------------- | ------- | -------- |
| `script`     | String    | Inline PowerShell script                |         | \*       |
| `scriptUrl`  | String    | The URL of the PowerShell script to run |         | \*       |
| `git`        | Object    | settings for the git connection to getch the Powershell script from |         | \*       |
| `git.connection`        | Connection    | SSH connection for git repository access. The repository should have a corresponding deploy key. |         | No  |
| `git.repository`        | String    | An URL pointing to a git repository. This can be either an SSH or a HTTPS URL. If an SSH URL is given, the `git.connection` parameter is required.|         | \**  |
| `git.branch`        | String    | The branch of the git repository to clone. If no branch is specified, the default branch is cloned.|         | No  |
| `git.scriptPath`        | String    | The path to the script relative to the root of the git repository. Since the whole repository is cloned, the script has access to all files inside the git repository while running. |         | \*  |

\* Either `script`, `scriptUrl` or `git.scriptPath` should be specified.

\*\* If the `git` parameter is specified, the `git.repository` is required.

## Usage

### Inline script

```yaml
step:
  name: my-powershell-step
  image: relaysh/powershell-step-run
  spec:
    script: |
      Write-Host "Hello World!"
      Write-Host "Hello Puppet!"
```

### Script from an URL

```yaml
step:
  name: my-powershell-step
  image: relaysh/powershell-step-run
  spec:
    scriptUrl: https://example.com/myscript.ps1
```

### Script from a public git repo

```yaml
step:
  name: my-powershell-step
  image: relaysh/powershell-step-run
  spec:
    git:
      repository: https://github.com/someuser/somerepo
      branch: main
      scriptPath: powershell/sample.ps1
```

### Script from a private git repo

```yaml
step:
  name: my-powershell-step
  image: relaysh/powershell-step-run
  spec:
    git:
      connection: ${connections.ssh.'my-ssh-connection'}
      repository: git@github.com:someuser/somerepo
      branch: main
      scriptPath: powershell/sample.ps1
```

### Notes

* This image has the Relay `ni` utility installed. Because `ni` is an alias for `New-Item` in PowerShell, this image aliases Relay's `ni` tool as `Relay-Interface` for ease of use.
