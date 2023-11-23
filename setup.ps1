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

function Confirm-GitInstalled {
    $32BitPrograms = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
    $64BitPrograms = Get-ItemProperty     HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*
    $programsWithGitInName = ($32BitPrograms + $64BitPrograms) | Where-Object { $null -ne $_.DisplayName -and $_.Displayname.Contains('Git') }
    $isGitInstalled = $null -ne $programsWithGitInName
    return $isGitInstalled
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
if (!(Confirm-GitInstalled)) {
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

# ------------------------------ setup settings ------------------------------ #
Write-Host "Setting up dotfiles..." -ForegroundColor "Green"
Start-Process powershell -ArgumentList "-File `".\settings-setup.ps1`""
