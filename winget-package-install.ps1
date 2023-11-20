# ---------------------------------------------------------------------------- #
#                               winget installer                               #
# ---------------------------------------------------------------------------- #

Write-Host "Checking winget..." -ForegroundColor "Yellow"

Try {
    # Check if winget is already installed
    $er = (invoke-expression "winget -v") 2>&1
    if ($lastexitcode) { throw $er }
    Write-Host "winget is already installed." -ForegroundColor "Green"
}
Catch {
    # winget is not installed. Install it from the Github release
    Write-Host "winget is not found, installing..." -ForegroundColor "Yellow"
	
    $repo = "microsoft/winget-cli"
    $releases = "https://api.github.com/repos/$repo/releases"
	
    Write-Host "Determining latest release" -ForegroundColor "Yellow"
    $json = Invoke-WebRequest $releases
    $tag = ($json | ConvertFrom-Json)[0].tag_name
    $file = ($json | ConvertFrom-Json)[0].assets[0].name
	
    $download = "https://github.com/$repo/releases/download/$tag/$file"
    $output = $PSScriptRoot + "\winget-latest.appxbundle"
    Write-Host "Dowloading latest release" -ForegroundColor "Yellow"
    Invoke-WebRequest -Uri $download -OutFile $output
	
    Write-Host "Installing the package" -ForegroundColor "Yellow"
    Add-AppxPackage -Path $output
}
Finally {
    Write-Host "winget is installed." -ForegroundColor "Green"
    # Start installing the packages with winget
    Get-Content .\winget.txt | ForEach-Object {
        iex ("winget install -e " + $_)
    }
}