# ─[ my pwsh profile ]────────────────────────────────────────────────────

# ─[ prompt ]─────────────────────────────────────────────────────────────
Invoke-Expression (&starship init powershell)

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


# ─[ genaral aliases ]────────────────────────────────────────────────────
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

# ─[ git aliases ]────────────────────────────────────────────────────────
function add {
    git add $args 
    if ($args -eq $null) { git add . }
}
function clone { git clone $args }
function checkout { git checkout $args }
function commit { git commit -m $args }
function push { git push }
function pull { git fetch && git pull }
function stat { git status }
function gdiff { git diff HEAD }
function vdiff { git difftool HEAD }
function log { git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit }
function lg { lazygit }


# ─[ fzf setup ]──────────────────────────────────────────────────────────
$ENV:FZF_DEFAULT_OPTS = @"
    --color=fg:#908caa,bg:#232136,hl:#ea9a97
    --color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
    --color=border:#44415a,header:#3e8fb0,gutter:#232136
    --color=spinner:#f6c177,info:#9ccfd8
    --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa
"@

# ─[ faster code launch ]─────────────────────────────────────────────────
function c { code . }
function vim { nvim $args }
function n { nvim $args }

# ─[ faster movement ]────────────────────────────────────────────────────
Remove-Item alias:cd -Force
Invoke-Expression (& { (zoxide init powershell | Out-String) })

function cd {
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$args
    )

    if ($args -eq "") { z } else { z $args }

    $curr_dir = GetCurrentDir(Get-Location)
    $title = " " + $curr_dir
    wezterm cli set-tab-title $title;
}

function .. { cd ../$args }
function ..2 { cd ../../$args }
function ..3 { cd ../../../$args }
function ..4 { cd ../../../../$args }
function ..5 { cd ../../../../../$args }
function gor { cd /$args }
function goc { cd ~/.config/$args }
function gon { cd ~/AppData/Local/nvim }
function godev { cd ~/source/repos/$args }

─[ even faster movement ]───────────────────────────────────────────────
function t { cd (Get-Item $(fzf --query=$args)).Directory.FullName }

# ─[ eza aliases ]────────────────────────────────────────────────────────
Remove-Item alias:ls -Force
function ls { eza --icons=always --color=always --group-directories-first $args }
function la { eza --icons=always --color=always --group-directories-first -a $args }
function ll { eza --icons=always --color=always --group-directories-first -la --no-time $args }
function lt { eza --icons=always --color=always --group-directories-first -T $args }

# ─[ lf ]─────────────────────────────────────────────────────────────────
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

# ─[ azure ]──────────────────────────────────────────────────────────────
Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    $completion_file = New-TemporaryFile
    $env:ARGCOMPLETE_USE_TEMPFILES = 1
    $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
    $env:COMP_LINE = $wordToComplete
    $env:COMP_POINT = $cursorPosition
    $env:_ARGCOMPLETE = 1
    $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
    $env:_ARGCOMPLETE_IFS = "`n"
    $env:_ARGCOMPLETE_SHELL = 'powershell'
    az 2>&1 | Out-Null
    Get-Content $completion_file | Sort-Object | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
    }
    Remove-Item $completion_file, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS, Env:\_ARGCOMPLETE_SHELL
}

 # ─[ roslyn nvim update ]─────────────────────────────────────────────────
function roslyn() {
  if ($args -eq "update") {
    $file = New-Guid
    Invoke-WebRequest https://github.com/Crashdummyy/roslynLanguageServer/releases/latest/download/microsoft.codeanalysis.languageserver.win-x64.zip -OutFile ~/Downloads/$file.zip
    Expand-Archive ~/Downloads/$file.zip -DestinationPath ~/AppData/Local/nvim-data/roslyn/ -Force
    rm ~/Downloads/$file.zip
  }
}

# ─[ yazi ]───────────────────────────────────────────────────────────────
function yy {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
}

# ─[ symbolic link ]──────────────────────────────────────────────────────
function make-link ($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target
}

# ─[ helper functions ]───────────────────────────────────────────────────
# TODO: FIX THIS FUNCTION (IT ALWAYS RETURNS AS IF $destination is pwd)
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

function GetCurrentDir {
    param (
      [string]$path = ""
    )
    if ($path -eq "") {
      $path = Get-Location
    }

    if ($path -eq "$env:USERPROFILE") {
      return "~"
    }

    return Split-Path ($path) -Leaf 
}

