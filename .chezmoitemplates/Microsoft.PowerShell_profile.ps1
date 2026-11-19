# PowerShell Profile - Nord Theme, Inline History Autosuggestions & Modern CLI Suite
# Pure ASCII encoding so both PowerShell 7 (pwsh) and Windows PowerShell 5.1 load cleanly.

# 1. Non-interactive shells return early
if ([Environment]::GetCommandLineArgs() -contains '-NonInteractive') {
    return
}

# 2. Ensure UTF-8 I/O so Starship, bat, eza, and fzf symbols render properly in PS 5.1 & 7
$OutputEncoding = [System.Text.Encoding]::UTF8
try {
    [Console]::InputEncoding = New-Object System.Text.UTF8Encoding($false)
    [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false)
} catch {}

# 3. PATH Setup (~/.local/bin, ~/bin, WinGet Links)
$extraBins = @(
    (Join-Path $HOME '.local\bin'),
    (Join-Path $HOME 'bin')
)
if ($env:LOCALAPPDATA) {
    $extraBins += (Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links')
}
foreach ($extraBin in $extraBins) {
    if ($extraBin -and (Test-Path $extraBin) -and (($env:PATH -split ';') -notcontains $extraBin)) {
        $env:PATH = "$extraBin;$env:PATH"
    }
}

# 4. PSReadLine: Inline History Ghost-Text Autosuggestions & Prefix Search
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine -ErrorAction SilentlyContinue

    Set-PSReadLineOption -BellStyle None
    Set-PSReadLineOption -MaximumHistoryCount 100000
    Set-PSReadLineOption -HistoryNoDuplicates
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd

    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Chord 'Alt+RightArrow' -Function ForwardWord

    $psrlParams = (Get-Command Set-PSReadLineOption).Parameters
    if ($psrlParams.ContainsKey('PredictionSource')) {
        try {
            Set-PSReadLineOption -PredictionSource History -ErrorAction Stop
            if ($psrlParams.ContainsKey('PredictionViewStyle')) {
                Set-PSReadLineOption -PredictionViewStyle InlineView -ErrorAction Stop
            }
            if ($psrlParams.ContainsKey('Colors')) {
                try {
                    Set-PSReadLineOption -Colors @{ InlinePrediction = '#616E88' } -ErrorAction Stop
                } catch {
                    Set-PSReadLineOption -Colors @{ InlinePrediction = 'DarkGray' } -ErrorAction SilentlyContinue
                }
            }
        } catch {}
    }
}

# 5. Default Editor & Nord Theme Environment for bat / fzf
$env:EDITOR = 'vim'
$env:VISUAL = 'vim'
if (Get-Command bat -ErrorAction SilentlyContinue) {
    $env:BAT_THEME = 'Nord'
}

if (Get-Command fzf -ErrorAction SilentlyContinue) {
    $env:FZF_DEFAULT_OPTS = "--height 45% --layout=reverse --border=rounded --info=inline " +
        "--color=fg:#e5e9f0,bg:#2e3440,hl:#81a1c1 " +
        "--color=fg+:#eceff4,bg+:#3b4252,hl+:#88c0d0 " +
        "--color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac " +
        "--color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b"

    if (Get-Command fd -ErrorAction SilentlyContinue) {
        $env:FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
        $env:FZF_CTRL_T_COMMAND = $env:FZF_DEFAULT_COMMAND
        $env:FZF_ALT_C_COMMAND = 'fd --type d --hidden --follow --exclude .git'
    }
    if (Get-Command bat -ErrorAction SilentlyContinue) {
        $env:FZF_CTRL_T_OPTS = "--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
    }
    if (Get-Command eza -ErrorAction SilentlyContinue) {
        $env:FZF_ALT_C_OPTS = "--preview 'eza --tree --level=2 --color=always {}'"
    }

    if (Get-Module -ListAvailable -Name PSFzf) {
        Import-Module PSFzf -ErrorAction SilentlyContinue
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' `
                        -PSReadlineChordReverseHistory 'Ctrl+r' `
                        -PSReadlineChordSetLocation 'Alt+c'
    }
}

# 6. Modern CLI Aliases & Helpers (matching ~/.bash_aliases)
if (Get-Command eza -ErrorAction SilentlyContinue) {
    Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
    function ls { eza --group-directories-first @args }
    function ll { eza -lh --git --group-directories-first @args }
    function la { eza -lah --git --group-directories-first @args }
    function lt { eza --tree --level=2 --group-directories-first @args }
    function l  { eza -F --group-directories-first @args }
}

if (Get-Command bat -ErrorAction SilentlyContinue) {
    function catp { bat -p @args }
    function bcat { bat @args }
}

function ..   { Set-Location .. }
function ...  { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }

if (Get-Command git -ErrorAction SilentlyContinue) {
    Remove-Item Alias:gc, Alias:gcm, Alias:gl, Alias:gp -Force -ErrorAction SilentlyContinue
    function g   { git @args }
    function gs  { git status -sb @args }
    function ga  { git add @args }
    function gc  { git commit @args }
    function gcm { git commit -m @args }
    function gco { git checkout @args }
    function gd  { git diff @args }
    function gds { git diff --staged @args }
    function gl  { git log --oneline --graph --decorate -n 20 @args }
    function gp  { git push @args }
    function gpl { git pull @args }
}

if (Get-Command chezmoi -ErrorAction SilentlyContinue) {
    function cm   { chezmoi @args }
    function cms  { chezmoi status @args }
    function cmd  { chezmoi diff @args }
    function cma  { chezmoi apply @args }
    function cmcd { Set-Location (chezmoi source-path) }
}

function mkcd {
    param([Parameter(Mandatory)][string]$Path)
    New-Item -ItemType Directory -Force -Path $Path | Out-Null
    Set-Location $Path
}

function extract {
    param([Parameter(Mandatory)][string]$ArchivePath)
    if (-not (Test-Path -Path $ArchivePath -PathType Leaf)) {
        Write-Error "'$ArchivePath' is not a valid file"
        return
    }
    switch -Regex ($ArchivePath) {
        '\.zip$'                       { Expand-Archive -Path $ArchivePath -DestinationPath . -Force }
        '\.(tar\.gz|tgz|tar\.bz2|tbz2|tar\.xz|tar)$' { tar -xf $ArchivePath }
        '\.7z$' {
            if (Get-Command 7z -ErrorAction SilentlyContinue) { 7z x $ArchivePath }
            else { Write-Error "7z is not installed to extract '$ArchivePath'" }
        }
        default { Write-Error "'$ArchivePath' cannot be extracted via extract" }
    }
}

# 7. Zoxide (Smart Directory Jumper)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# 8. Starship Prompt (Pure Minimal Nord Single-Line)
$starshipCfg = Join-Path $HOME '.config\starship.toml'
if (Test-Path $starshipCfg) {
    $env:STARSHIP_CONFIG = $starshipCfg
}
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
