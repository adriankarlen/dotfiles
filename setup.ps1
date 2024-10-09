# ---------------------------------------------------------------------------- #
#                              installation script                             #
# ---------------------------------------------------------------------------- #

# ----------------------------- helper functions ----------------------------- #
function Confirm-Elevated {
    # Get the ID and security principal of the current user account
    $myIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $myPrincipal = new-object System.Security.Principal.WindowsPrincipal($myIdentity)
    # Check to see if we are currently running "as Administrator"
    return $myPrincipal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-CommandExists {
    param ($command)
    $oldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'

    try { 
        if (Get-Command $command) { 
            "$command exists" 
        } 
    }
    catch { 
        "$command does not exist" 
    }
    finally { 
        $ErrorActionPreference = $oldPreference 
    }
}

# -------- check to see if we are currently running "as Administrator" ------- #
if (!(Confirm-Elevated)) {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    $newProcess.Verb = "runas";
    [System.Diagnostics.Process]::Start($newProcess);
    exit
}

# -------------------- check to see that git is installed -------------------- #
if (!(Test-CommandExists "git")) {
    Write-Host "Git is not installed. Please install git and try again." -ForegroundColor "Red"
    exit
}

Write-Host "Configuring System..." -ForegroundColor "Yellow"

# ------------------------------ setup powershell ---------------------------- #
Write-Host "Setting up powershell..." -ForegroundColor "Green"
Set-Content -Path $profile -Value Get-Content ".\dots\.pwsh.ps1"

# --------------------------- setup repos directory -------------------------- #
Write-Host "Setting up repos directory..." -ForegroundColor "Green"
$reposDir = "$env:USERPROFILE\source\repos"
if (!(Test-Path -Path $reposDir)) {
    New-Item -ItemType Directory -Force -Path $reposDir
}

# --------------------------- install applications --------------------------- #
Write-Host "Installing applications..." -ForegroundColor "Green"
Invoke-Expression ".\winget-package-install.ps1"

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
scoop install ".\scoop.json"

# ---------------------------- setup applications ---------------------------- #
Write-Host "Setting up dotfiles..." -ForegroundColor "Green"
Start-Process powershell -ArgumentList "-File `".\applications-setup.ps1`""

# ------------------------------ clone git repos ----------------------------- #
Write-Host "Cloning git repos..." -ForegroundColor "Green"
Invoke-Expression ".\git-clone.ps1"
