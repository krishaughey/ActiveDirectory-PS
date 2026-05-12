<#
.SYNOPSIS
Prompts for credentials, stores them securely, and joins the local computer to contoso.com.
#>

param(
    [string]$Domain = '<DOMAIN>',
    [string]$CredentialPath = "$env:ProgramData\Contoso\JoinDomainCredential.xml"
)

function Assert-Administrator {
    $currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        Write-Error 'This script must be run as Administrator.'
        exit 1
    }
}

function Get-StoredCredential {
    param([string]$Path)

    if (Test-Path -Path $Path) {
        try {
            return Import-Clixml -Path $Path
        }
        catch {
            Write-Warning "Unable to import stored credential from '$Path'. Prompting for credentials instead."
            return $null
        }
    }
    return $null
}

function Save-Credential {
    param(
        [System.Management.Automation.PSCredential]$Credential,
        [string]$Path
    )

    $directory = Split-Path -Path $Path -Parent
    if (-not (Test-Path -Path $directory)) {
        New-Item -Path $directory -ItemType Directory -Force | Out-Null
    }

    $Credential | Export-Clixml -Path $Path
    Write-Host "Credential stored securely to: $Path"
}

Assert-Administrator

$computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
if ($computerSystem.PartOfDomain) {
    Write-Host "Computer is already joined to domain: $($computerSystem.Domain)"
    return
}

$credential = Get-StoredCredential -Path $CredentialPath
if (-not $credential) {
    $credential = Get-Credential -Message "Enter domain account credentials to join $Domain"
    Save-Credential -Credential $credential -Path $CredentialPath
}

Write-Host "Joining local computer to domain '$Domain'..."
try {
    Add-Computer -DomainName $Domain -Credential $credential -ErrorAction Stop
    Write-Host "Successfully joined computer to '$Domain'."
    Write-Host 'Restarting computer now...'
    Restart-Computer -Force
}
catch {
    Write-Error "Domain join failed: $($_.Exception.Message)"
    exit 1
}
