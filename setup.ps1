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

# -------- check to see if we are currently running "as Administrator" ------- #
if (!(Confirm-Elevated)) {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    $newProcess.Verb = "runas";
    [System.Diagnostics.Process]::Start($newProcess);
 
    exit
}

# -------------------- check to see that git is installed -------------------- #
if (!(Test-Path "C:\Program Files\Git\cmd\git-cmd.exe")) {
    Write-Host "Git is not installed. Please install git and try again." -ForegroundColor "Red"
    exit
}

Write-Host "Configuring System..." -ForegroundColor "Yellow"

# --------------------------- setup repos directory -------------------------- #
Write-Host "Setting up repos directory..." -ForegroundColor "Green"
$reposDir = "$env:USERPROFILE\source\repos"
if (!(Test-Path )) {
    New-Item -ItemType Directory -Force -Path $reposDir
}

# ----------------------------- install programs ----------------------------- #
Write-Host "Installing programs..." -ForegroundColor "Green"
Invoke-Expression ".\winget-package-install.ps1"

# ----------------------------- setup windows ------------------------------- #
Write-Host "Setting up windows..." -ForegroundColor "Green"
Invoke-Expression ".\windows.ps1"

# ----------------------------- setup dotfiles ------------------------------ #
Write-Host "Setting up dotfiles..." -ForegroundColor "Green"
Start-Process powershell -ArgumentList "-File `".\dotfiles-setup.ps1`""
