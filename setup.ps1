# ---------------------------------------------------------------------------- #
#                              installation script                             #
# ---------------------------------------------------------------------------- #

# -------- check to see if we are currently running "as Administrator" ------- #
if (!(Verify-Elevated)) {
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
$reposDir = "$env:USERPROFILE/source/repos"
if (!(Test-Path )) {
    New-Item -ItemType Directory -Force -Path $reposDir
}

# ----------------------------- install programs ----------------------------- #
Write-Host "Installing programs..." -ForegroundColor "Green"
Invoke-Expression "./winget-package-install.ps1"
