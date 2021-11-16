# powershell

This step runs a PowerShell script using the latest version of PowerShell (7.2).

## Specification

This step expects the following fields in the `spec` section of a workflow step definition that uses it:

| Setting      | Data type | Description                             | Default | Required |
| ------------ | --------- | --------------------------------------- | ------- | -------- |
| `script`     | String    | Inline PowerShell script                |         | \*       |
| `script_url` | String    | The URL of the PowerShell script to run |         | \*       |

*\*Note: Either `script` or `script_url` should be specified.*

## Usage

```yaml
step:
  name: my-powershell-step
  image: relaysh/powershell-step-run
  spec:
    script: |
      Write-Host "Hello World!"
      Write-Host "Hello Puppet!"
```

or

```yaml
step:
  name: my-powershell-step
  image: relaysh/powershell-step-run
  spec:
    script_url: "https://example.com/myscript.ps1"
```

### Notes
* This image has the Relay `ni` utility installed. Because `ni` is an alias for `New-Item` in PowerShell, this image aliases Relay's `ni` tool as `Relay-Interface` for ease of use.
 