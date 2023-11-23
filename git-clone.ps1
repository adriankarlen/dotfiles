# ---------------------------------------------------------------------------- #
#                        Clone git repos from repos.txt                        #
# ---------------------------------------------------------------------------- #

$repos = Get-Content .\repos.txt
$reposDir = "$env:USERPROFILE\source\repos"

foreach ($repo in $repos) {
    $repoName = $repo.Split("/")[-1].Replace(".git", "")
    $repoPath = "$reposDir\$repoName"

    if (!(Test-Path -Path $repoPath)) {
        Write-Host "Cloning $repoName..." -ForegroundColor "Green"
        git clone $repo $repoPath
    }
    else {
        Write-Host "$repoName already exists." -ForegroundColor "Red"
    }
}