# ---------------------------------------------------------------------------- #
#                                dotfiles setup                                #
# ---------------------------------------------------------------------------- #
# Create directory if it doesn't exist
$directoryPath = "$env:USERPROFILE\.config"
if (!(Test-Path -Path $directoryPath)) {
    New-Item -ItemType Directory -Path $directoryPath
}

# ------------------------------- .config setup ------------------------------ #
$sourceDirectoryPath = ".\dots\.config"
$destinationDirectoryPath = "$env:USERPROFILE\.config"
Copy-Item -Path $sourceDirectoryPath -Destination $destinationDirectoryPath -Recurse -Force

# --------------------------------- Spicetify -------------------------------- #
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/spicetify/spicetify-themes/master/Dribbblish/install.ps1" | Invoke-Expression
spicetify config color_scheme rosepine
spicetify apply

# ----------------------------- Windows Terminal ----------------------------- #
$windowsTerminalConfigPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Copy-Item -Path ".\dots\windows terminal\settings.json" -Destination $windowsTerminalConfigPath -Force

# ------------------------------------ NVM ----------------------------------- #
nvm install lts
nvm install 16.20.2
nvm use lts

# ---------------------------- Gloabl NPM packages --------------------------- #
npm install -g pnpm