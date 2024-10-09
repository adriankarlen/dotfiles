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

# ------------------------------------ NVM ----------------------------------- #
nvm install lts
nvm use lts

# ---------------------------- Gloabl NPM packages --------------------------- #
npm install -g pnpm
