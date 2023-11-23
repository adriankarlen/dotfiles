# ---------------------------------------------------------------------------- #
#                                dotfiles setup                                #
# ---------------------------------------------------------------------------- #
# Create directory if it doesn't exist
$directoryPath = "$env:USERPROFILE\.config"
if (!(Test-Path -Path $directoryPath)) {
    New-Item -ItemType Directory -Path $directoryPath
}

# --------------------------------- Spicetify -------------------------------- #
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/spicetify/spicetify-themes/master/Dribbblish/install.ps1" | Invoke-Expression
spicetify config color_scheme rosepine
spicetify apply

# --------------------------------- Starship --------------------------------- #
# Copy file if it doesn't exist in the destination
$sourceFilePath = ".\dots\starship\starship.toml"
$destinationFilePath = "$env:USERPROFILE\.config\starship.toml"
if (!(Test-Path -Path $destinationFilePath)) {
    Copy-Item -Path $sourceFilePath -Destination $destinationFilePath
}

# ----------------------------- Windows Terminal ----------------------------- #
$windowsTerminalConfigPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Copy-Item -Path ".\dots\windows terminal\settings.json" -Destination $windowsTerminalConfigPath -Force