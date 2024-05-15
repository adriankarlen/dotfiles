# ---------------------------------------------------------------------------- #
#                                my pwsh profile                               #
# ---------------------------------------------------------------------------- #

# ------------------------------ starship setup ------------------------------ #
Invoke-Expression (&starship init powershell)

# ------------------------------ genaral aliases ----------------------------- #
function touch { Set-Content -Path ($args[0]) -Value ($null) } 
function reload { . $PROFILE }
function x { exit }
function ipcopy { curl ifconfig.me | clip }
function unzip {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ArchiveFileName,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]$TargetPath
    )

    $targetPathParam = if ($TargetPath) { @{ TargetPath = $TargetPath } } else { @{} }

    Expand-7Zip -ArchiveFileName $ArchiveFileName @targetPathParam
}

Register-ArgumentCompleter -CommandName 'touch' -ParameterName args -ScriptBlock ${function:TabComplete}
Register-ArgumentCompleter -CommandName 'unzip'  -ParameterName args -ScriptBlock ${function:TabComplete}

# -------------------------------- git aliases ------------------------------- #
function add {
    git add $args 
    if ($args -eq $null) { git add . } 
}
function commit { git commit -m $args }
function push { git push }
function pull { git pull }
function stat { git status }
function gdiff { git diff HEAD }
function vdiff { git difftool HEAD }
function log { git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit }
function lg { lazygit }

# --------------------------------- komorebi --------------------------------- #
$env:KOMOREBI_CONFIG_HOME = "$env:USERPROFILE\.config\komorebi"
function komostart { komorebic start -c "$env:USERPROFILE\.config\komorebi\config.json" --whkd }
function komo2mstart { komorebic start -c "$env:USERPROFILE\.config\komorebi\config-2M.json" --whkd }

# ----------------------------------- whkd ----------------------------------- #
function whkd-restart { taskkill /f /im whkd.exe && Start-Process whkd -WindowStyle hidden }

# ---------------------------------- glazewm --------------------------------- #
function glaze { glazewm --config="$env:USERPROFILE\.config\glazewm\config.yaml" }

# ---------------------------------- spotify --------------------------------- #
new-alias spt spotify_player

# _-------------------------------- fzf setup -------------------------------- #
$ENV:FZF_DEFAULT_OPTS=@"
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa
"@

# ---------------------------- faster code launch ---------------------------- #
function c { code . }
function n {
  wezterm cli set-tab-title nvim;
  nvim $args
}

# ------------------------------ faster movement ----------------------------- #
function .. { Set-Location ../$args }
function ..2 { Set-Location ../../$args }
function ..3 { Set-Location ../../../$args }
function ..4 { Set-Location ../../../../$args }
function ..5 { Set-Location ../../../../../$args }
function gor { Set-Location /$args }
function goh { Set-Location ~/$args }
function goc { Set-Location ~/.config/$args }
function gon { Set-Location ~/AppData/Local/nvim }
function godev { Set-Location ~/source/repos/$args }

# Register the tab completion function for the movement commands
# Register-ArgumentCompleter -CommandName '..'  -ParameterName args -ScriptBlock ${function:TabComplete}
# Register-ArgumentCompleter -CommandName '..2' -ParameterName args -ScriptBlock ${function:TabComplete}
# Register-ArgumentCompleter -CommandName '..3' -ParameterName args -ScriptBlock ${function:TabComplete}
# Register-ArgumentCompleter -CommandName '..4' -ParameterName args -ScriptBlock ${function:TabComplete}
# Register-ArgumentCompleter -CommandName '..5' -ParameterName args -ScriptBlock ${function:TabComplete}
# Register-ArgumentCompleter -CommandName 'gor'  -ParameterName args -ScriptBlock ${function:TabComplete}
# Register-ArgumentCompleter -CommandName 'goh'  -ParameterName args -ScriptBlock ${function:TabComplete}
# Register-ArgumentCompleter -CommandName 'goc'  -ParameterName args -ScriptBlock ${function:TabComplete}
# Register-ArgumentCompleter -CommandName 'godev'  -ParameterName args -ScriptBlock ${function:TabComplete}

# --------------------------- even faster movement --------------------------- #
function go { Set-Location (Get-Item $(fzf --query=$args)).Directory.FullName }

# -------------------------------- eza aliases ------------------------------- #
Remove-Item alias:ls -Force
function ls { eza --icons=always --color=always --group-directories-first $args }
function la { eza --icons=always --color=always --group-directories-first -a $args }
function ll { eza --icons=always --color=always --group-directories-first -la --no-time $args }
function lt { eza --icons=always --color=always --group-directories-first -T $args }

# ------------------------------------ lf ------------------------------------ #

Register-ArgumentCompleter -Native -CommandName 'lf' -ScriptBlock {
    param($wordToComplete)
    $completions = @(
        [CompletionResult]::new('-command ', '-command', [CompletionResultType]::ParameterName, 'command to execute on client initialization')
        [CompletionResult]::new('-config ', '-config', [CompletionResultType]::ParameterName, 'path to the config file (instead of the usual paths)')
        [CompletionResult]::new('-cpuprofile ', '-cpuprofile', [CompletionResultType]::ParameterName, 'path to the file to write the CPU profile')
        [CompletionResult]::new('-doc', '-doc', [CompletionResultType]::ParameterName, 'show documentation')
        [CompletionResult]::new('-last-dir-path ', '-last-dir-path', [CompletionResultType]::ParameterName, 'path to the file to write the last dir on exit (to use for Set-Location)')
        [CompletionResult]::new('-log ', '-log', [CompletionResultType]::ParameterName, 'path to the log file to write messages')
        [CompletionResult]::new('-memprofile ', '-memprofile', [CompletionResultType]::ParameterName, 'path to the file to write the memory profile')
        [CompletionResult]::new('-print-last-dir', '-print-last-dir', [CompletionResultType]::ParameterName, 'print the last dir to stdout on exit (to use for Set-Location)')
        [CompletionResult]::new('-print-selection', '-print-selection', [CompletionResultType]::ParameterName, 'print the selected files to stdout on open (to use as open file dialog)')
        [CompletionResult]::new('-remote ', '-remote', [CompletionResultType]::ParameterName, 'send remote command to server')
        [CompletionResult]::new('-selection-path ', '-selection-path', [CompletionResultType]::ParameterName, 'path to the file to write selected files on open (to use as open file dialog)')
        [CompletionResult]::new('-server', '-server', [CompletionResultType]::ParameterName, 'start server (automatic)')
        [CompletionResult]::new('-single', '-single', [CompletionResultType]::ParameterName, 'start a client without server')
        [CompletionResult]::new('-version', '-version', [CompletionResultType]::ParameterName, 'show version')
        [CompletionResult]::new('-help', '-help', [CompletionResultType]::ParameterName, 'show help')
    )

    if ($wordToComplete.StartsWith('-')) {
        $completions.Where{ $_.CompletionText -like "$wordToComplete*" } | Sort-Object -Property ListItemText
    }
}

# ----------------------------- helper functions ----------------------------- #
# TODO: FIX THIS FUNCTION (IT ALWAYS RETURNS AS IF )
function TabComplete {
    param (
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameter
    )

    # Determine the intended destination based on the command
    switch ($commandName) {
        '..' { $destination = '..' }
        '..2' { $destination = '../..' }
        '..3' { $destination = '../../..' }
        '..4' { $destination = '../../../..' }
        '..5' { $destination = '../../../../..' }
        'gor' { $destination = '/' }
        'goh' { $destination = '~' }
        'goc' { $destination = '~/.config' }
        'godev' { $destination = '~/source/repos' }
        default { $destination = '' }
    }

    # Get the list of directories and files in the intended destination
    $items = Get-ChildItem $destination


    # Filter items based on the word to complete
    $filteredItems = $items | Where-Object { $_.Name -like "$wordToComplete*" }

    # Provide the filtered items for tab completion
    $filteredItems | ForEach-Object {
        $itemPath = $_.FullName.Substring($destination.Length + 1)
        $itemPath
    }
}

prompt = ""
function Invoke-Starship-PreCommand {
    $current_location = $executionContext.SessionState.Path.CurrentLocation
    if ($current_location.Provider.Name -eq "FileSystem") {
        $ansi_escape = [char]27
        $provider_path = $current_location.ProviderPath -replace "\\", "/"
        $prompt = "$ansi_escape]7;file://${env:COMPUTERNAME}/${provider_path}$ansi_escape\"
    }
    $host.ui.Write($prompt)
}

Invoke-Expression (&starship init powershell)

Invoke-Expression (& { (zoxide init powershell | Out-String) })
