# ---------------------------------------------------------------------------- #
#                                my pwsh profile                               #
# ---------------------------------------------------------------------------- #

# ------------------------------ starship setup ------------------------------ #
Invoke-Expression (&starship init powershell)

# ------------------------------ genaral aliases ----------------------------- #
function touch { Set-Content -Path ($args[0]) -Value ($null) } 
function reload { . $PROFILE }
function x { exit }

# -------------------------------- git aliases ------------------------------- #
function add { git add $args 
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
$Env:KOMOREBI_CONFIG_HOME = 'Env:USERPROFILE\.config\komorebi'
function komostart { komorebic start -c "$Env:USERPROFILE\.config\komorebi\config.json" --whkd }
function komo2mstart { komorebic start -c "$Env:USERPROFILE\.config\komorebi\config-2M.json" --whkd }

# ----------------------------------- yasb ----------------------------------- #
function yasb { python "$ENV:USERPROFILE\source\repos\utility\yasb\src\main.py" }

# ---------------------------------- glazewm --------------------------------- #
function glaze { glazewm --config="$Env:USERPROFILE\.config\glazewm\config.yaml" }

# ---------------------------- faster code launch ---------------------------- #
function c { code . }

# ------------------------------ faster movement ----------------------------- #
function .. { Set-Location .. }
function ..2 { Set-Location ../.. }
function ..3 { Set-Location ../../.. }
function ..4 { Set-Location ../../../.. }
function ..5 { Set-Location ../../../../.. }
function gor { Set-Location / }
function goh { Set-Location ~ }
function goc { Set-Location ~/.config/ }
function god { Set-Location ~/Documents/ }
function godl { Set-Location ~/Downloads/ }
function gop { Set-Location ~/Pictures/ }
function gov { Set-Location ~/Videos/ }
function godev { Set-Location ~/source/repos/$args}

# --------------------------- even faster movement --------------------------- #
function go { Set-Location "$(find . -type d -print | fzf)" }
function gofo { Set-Location "$(find ~ -type d -print | fzf)" }

# -------------------------------- eza aliases ------------------------------- #
Remove-Item alias:ls -Force
function ls { eza --icons=always --color=always --group-directories-first }
function la { eza --icons=always --color=always --group-directories-first -a }
function ll { eza --icons=always --color=always --group-directories-first -la --no-time }
function lt { eza --icons=always --color=always --group-directories-first -T }

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