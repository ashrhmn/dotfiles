<#
.SYNOPSIS
    TGN - Telegram Notification CLI for Windows
.DESCRIPTION
    Send notifications to Telegram via TGN service.
.PARAMETER Message
    Message text to send (or file path)
.PARAMETER Title
    Title prefix shown in brackets, e.g. [Deploy]
.PARAMETER Level
    Severity level: info, warn, error
.PARAMETER ParseMode
    Telegram parse mode: HTML or MarkdownV2
.PARAMETER Exec
    Run command and send its output as notification
.PARAMETER Interval
    With -Exec, repeat command every N seconds (min: 1)
.PARAMETER Buttons
    Comma-separated button labels for interactive prompt
.PARAMETER FreeInput
    Allow free-form text input (requires -Buttons)
.PARAMETER Zip
    Create zip file from specified paths and send
.PARAMETER ZipArgs
    Files/directories to include in zip
.PARAMETER Timeout
    Timeout for prompt response in seconds (default: 172800 / 48h)
.PARAMETER Debug
    Show debug output (request payload, response)
.PARAMETER Login
    Interactively configure and store token
.PARAMETER Help
    Show help message
.PARAMETER Version
    Show version information
#>

[CmdletBinding(DefaultParameterSetName='Message')]
param(
    [Parameter(ParameterSetName='Message', Position=0, ValueFromPipeline=$true)]
    [string]$Message,

    [Parameter(ParameterSetName='Login')]
    [switch]$Login,

    [Parameter(ParameterSetName='Message')]
    [Alias('t')]
    [string]$Title,

    [Parameter(ParameterSetName='Message')]
    [Alias('l')]
    [ValidateSet('info', 'warn', 'error')]
    [string]$Level,

    [Parameter(ParameterSetName='Message')]
    [Alias('p')]
    [ValidateSet('HTML', 'MarkdownV2', 'Markdown')]
    [string]$ParseMode,

    [Parameter(ParameterSetName='Exec')]
    [Alias('x')]
    [string]$Exec,

    [Parameter(ParameterSetName='Exec')]
    [Alias('i')]
    [int]$Interval,

    [Parameter(ParameterSetName='Prompt')]
    [Alias('b')]
    [string]$Buttons,

    [Parameter(ParameterSetName='Prompt')]
    [Alias('f')]
    [switch]$FreeInput,

    [Parameter(ParameterSetName='Zip')]
    [Alias('z')]
    [string]$Zip,

    [Parameter(ParameterSetName='Zip')]
    [string[]]$ZipArgs,

    [int]$Timeout = 172800,

    [Alias('d')]
    [switch]$Debug,

    [Parameter(ParameterSetName='Help')]
    [Alias('h')]
    [switch]$Help,

    [Parameter(ParameterSetName='Version')]
    [Alias('v')]
    [switch]$Version
)

$ErrorActionPreference = 'Stop'
$script:VERSION = "2.0.0"
$script:TGN_BASE_URL = "https://tgn.ashrhmn.com"
$script:TGN_NOTIFY_URL = "$script:TGN_BASE_URL/v1/notify"
$script:TGN_FILE_URL = "$script:TGN_BASE_URL/v1/file"
$script:TGN_PROMPT_URL = "$script:TGN_BASE_URL/v1/prompt"
$script:CONFIG_DIR = Join-Path $env:APPDATA "tgn"
$script:CONFIG_FILE = Join-Path $script:CONFIG_DIR "config.txt"
$script:MAX_MESSAGE_LENGTH = 3500
$script:DEFAULT_TIMEOUT = 172800

function Write-Debug-Info {
    param([string]$Message)
    if ($Debug) {
        Write-Host "[DEBUG] $Message" -ForegroundColor Yellow
    }
}

function Get-Token {
    if ($env:TGN_TOKEN) {
        Write-Debug-Info "Using token from TGN_TOKEN env var"
        return $env:TGN_TOKEN
    }

    if (Test-Path $script:CONFIG_FILE) {
        $content = Get-Content $script:CONFIG_FILE -Raw
        if ($content -match 'TGN_TOKEN=(.+)') {
            Write-Debug-Info "Using token from $script:CONFIG_FILE"
            return $matches[1].Trim()
        }
    }

    return $null
}

function Show-Usage {
    @"
Usage: tgn.ps1 [OPTIONS] <message|file>
       tgn.ps1 [OPTIONS] -Exec <command>
       <command> | tgn.ps1 [OPTIONS]
       tgn.ps1 -Login

Send notifications to Telegram via TGN service.

Commands:
    -Login              Interactively configure and store token

Options:
    -Title, -t <text>       Title prefix shown in brackets, e.g. [Deploy]
    -Level, -l <level>      Severity level: info, warn, error
    -ParseMode, -p <mode>   Telegram parse mode: HTML or MarkdownV2
    -Exec, -x <command>     Run command and send its output as notification
    -Interval, -i <secs>    With -Exec, repeat command every N seconds (min: 1)
    -Buttons, -b <list>     Comma-separated button labels for interactive prompt
    -FreeInput, -f          Allow free-form text input (requires -Buttons)
    -Zip, -z <file>         Create zip file and send
    -ZipArgs <paths>        Files/directories to include in zip
    -Timeout <secs>         Timeout for prompt response (default: 48h)
    -Debug, -d              Show debug output (request payload, response)
    -Help, -h               Show this help message
    -Version, -v            Show version information

Environment Variables:
    TGN_TOKEN               Device token (takes priority over config file)

Configuration:
    Token is read from TGN_TOKEN env var, or from $script:CONFIG_FILE
    Run 'tgn.ps1 -Login' to configure token interactively.

Behavior:
    - If argument is an existing file, sends the file
    - If message exceeds $script:MAX_MESSAGE_LENGTH chars, sends as file
    - Pipe support: echo "msg" | tgn.ps1

Examples:
    tgn.ps1 "Build completed"
    tgn.ps1 .\report.log
    Get-Content app.log | tgn.ps1 -Title logs
    tgn.ps1 -Buttons "yes,no" "Deploy to prod?"
    tgn.ps1 -Buttons "approve,reject" -FreeInput "Review?"
    `$response = tgn.ps1 -Buttons "y,n" "Continue?"
    tgn.ps1 -Zip dots.zip -ZipArgs nvim,tmux,zshrc

Setup:
    1. Message @tgnnnn_bot on Telegram
    2. Send /start to register
    3. Send /add mydevice to create a device and get a token
    4. Run: tgn.ps1 -Login
"@
}

function Do-Login {
    Write-Host "TGN Login"
    Write-Host "---------"
    Write-Host ""
    Write-Host "To get a token:"
    Write-Host "  1. Message @tgnnnn_bot on Telegram"
    Write-Host "  2. Send /start to register"
    Write-Host "  3. Send /add <device_name> to create a device"
    Write-Host ""

    $token = Read-Host "Enter your TGN token" -AsSecureString
    $tokenPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($token)
    )

    if ([string]::IsNullOrWhiteSpace($tokenPlain)) {
        Write-Error "Error: Token cannot be empty"
        exit 1
    }

    if (-not (Test-Path $script:CONFIG_DIR)) {
        New-Item -ItemType Directory -Path $script:CONFIG_DIR -Force | Out-Null
    }

    "TGN_TOKEN=$tokenPlain" | Set-Content $script:CONFIG_FILE

    Write-Host ""
    Write-Host "Token saved to $script:CONFIG_FILE"
    Write-Host "You can now send notifications with: tgn.ps1 `"Your message`""
}

function Send-File {
    param(
        [string]$FilePath,
        [string]$Caption,
        [string]$ParseMode
    )

    $token = Get-Token
    if (-not $token) {
        Write-Error "Error: No token configured"
        exit 1
    }

    Write-Debug-Info "Sending file: $FilePath"

    $headers = @{
        "Authorization" = "Bearer $token"
    }

    $form = @{
        file = Get-Item $FilePath
    }

    if ($Caption) {
        $form['caption'] = $Caption
    }

    if ($ParseMode) {
        $normalized = switch ($ParseMode.ToLower()) {
            'html' { 'HTML' }
            'markdownv2' { 'MarkdownV2' }
            'markdown' { 'MarkdownV2' }
            default { $ParseMode }
        }
        $form['parseMode'] = $normalized
    }

    try {
        $response = Invoke-WebRequest -Uri $script:TGN_FILE_URL `
            -Method Post `
            -Headers $headers `
            -Form $form `
            -UseBasicParsing

        Write-Debug-Info "HTTP Status: $($response.StatusCode)"
        Write-Debug-Info "Response: $($response.Content)"

        Handle-Response $response.StatusCode $response.Content
    } catch {
        Handle-Error $_
    }
}

function Send-Notification {
    param(
        [string]$Message,
        [string]$Title,
        [string]$Level,
        [string]$ParseMode
    )

    $token = Get-Token
    if (-not $token) {
        Write-Error "Error: No token configured"
        exit 1
    }

    $payload = @{
        message = $Message
    }

    if ($Title) { $payload['title'] = $Title }
    if ($Level) { $payload['level'] = $Level }

    if ($ParseMode) {
        $normalized = switch ($ParseMode.ToLower()) {
            'html' { 'HTML' }
            'markdownv2' { 'MarkdownV2' }
            'markdown' { 'MarkdownV2' }
            default { $ParseMode }
        }
        $payload['parseMode'] = $normalized
    }

    $jsonPayload = $payload | ConvertTo-Json -Compress

    Write-Debug-Info "URL: $script:TGN_NOTIFY_URL"
    Write-Debug-Info "Payload: $jsonPayload"

    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }

    try {
        $response = Invoke-WebRequest -Uri $script:TGN_NOTIFY_URL `
            -Method Post `
            -Headers $headers `
            -Body $jsonPayload `
            -UseBasicParsing

        Write-Debug-Info "HTTP Status: $($response.StatusCode)"
        Write-Debug-Info "Response: $($response.Content)"

        Handle-Response $response.StatusCode $response.Content
    } catch {
        Handle-Error $_
    }
}

function Send-Prompt {
    param(
        [string]$Message,
        [string]$Buttons,
        [bool]$FreeInput,
        [string]$ParseMode,
        [int]$Timeout
    )

    $token = Get-Token
    if (-not $token) {
        Write-Error "Error: No token configured"
        exit 1
    }

    $buttonArray = @()
    if ($Buttons) {
        $buttonArray = $Buttons -split ',' | ForEach-Object { $_.Trim() }
    }

    $payload = @{
        message = $Message
        buttons = $buttonArray
    }

    if ($FreeInput) { $payload['freeInput'] = $true }

    if ($ParseMode) {
        $normalized = switch ($ParseMode.ToLower()) {
            'html' { 'HTML' }
            'markdownv2' { 'MarkdownV2' }
            'markdown' { 'MarkdownV2' }
            default { $ParseMode }
        }
        $payload['parseMode'] = $normalized
    }

    $jsonPayload = $payload | ConvertTo-Json -Compress

    Write-Debug-Info "URL: $script:TGN_PROMPT_URL"
    Write-Debug-Info "Payload: $jsonPayload"

    $headers = @{
        "Authorization" = "Bearer $token"
        "Content-Type" = "application/json"
    }

    try {
        $response = Invoke-WebRequest -Uri $script:TGN_PROMPT_URL `
            -Method Post `
            -Headers $headers `
            -Body $jsonPayload `
            -UseBasicParsing

        Write-Debug-Info "HTTP Status: $($response.StatusCode)"
        Write-Debug-Info "Response: $($response.Content)"

        if ($response.StatusCode -ne 200) {
            Handle-Response $response.StatusCode $response.Content
            return $null
        }

        $responseObj = $response.Content | ConvertFrom-Json
        $promptId = $responseObj.promptId

        if (-not $promptId) {
            Write-Error "Error: Failed to get prompt ID"
            return $null
        }

        Write-Debug-Info "Prompt ID: $promptId"
        Write-Host "Waiting for response..." -ForegroundColor Cyan

        $delay = 1
        $maxDelay = 15
        $elapsed = 0
        $startTime = Get-Date

        while ($true) {
            $now = Get-Date
            $elapsed = ($now - $startTime).TotalSeconds

            if ($elapsed -ge $Timeout) {
                Write-Error "Error: Timeout waiting for response"
                return $null
            }

            $pollResponse = Invoke-WebRequest -Uri "$script:TGN_PROMPT_URL/$promptId" `
                -Method Get `
                -Headers $headers `
                -UseBasicParsing

            Write-Debug-Info "Poll response: $($pollResponse.Content)"

            if ($pollResponse.StatusCode -ne 200) {
                Handle-Response $pollResponse.StatusCode $pollResponse.Content
                return $null
            }

            $pollObj = $pollResponse.Content | ConvertFrom-Json
            $status = $pollObj.status

            switch ($status) {
                'answered' {
                    return $pollObj.response
                }
                'expired' {
                    Write-Error "Error: Prompt expired"
                    return $null
                }
                'pending' {
                    Write-Debug-Info "Still pending, next check in ${delay}s"
                    Start-Sleep -Seconds $delay
                    $delay = [Math]::Min($delay * 2, $maxDelay)
                }
                default {
                    Write-Error "Error: Unknown status: $status"
                    return $null
                }
            }
        }
    } catch {
        Handle-Error $_
        return $null
    }
}

function Handle-Response {
    param(
        [int]$StatusCode,
        [string]$Body
    )

    switch ($StatusCode) {
        200 {
            try {
                $obj = $Body | ConvertFrom-Json
                if ($obj.ok) {
                    Write-Host "Notification sent" -ForegroundColor Green
                } else {
                    Write-Host $Body
                }
            } catch {
                Write-Host $Body
            }
        }
        400 {
            Write-Error "Error: Bad request"
            if ($Body) { Write-Host $Body -ForegroundColor Red }
        }
        401 {
            Write-Error "Error: Invalid or missing token"
        }
        403 {
            Write-Error "Error: Token has been revoked"
        }
        429 {
            Write-Error "Error: Rate limit exceeded"
        }
        502 {
            Write-Error "Error: Telegram API error"
            if ($Body) { Write-Host $Body -ForegroundColor Red }
        }
        default {
            Write-Error "Error: Request failed with status $StatusCode"
            if ($Body) { Write-Host $Body -ForegroundColor Red }
        }
    }
}

function Handle-Error {
    param($ErrorRecord)

    if ($ErrorRecord.Exception.Response) {
        $response = $ErrorRecord.Exception.Response
        $statusCode = [int]$response.StatusCode

        $reader = New-Object System.IO.StreamReader($response.GetResponseStream())
        $body = $reader.ReadToEnd()
        $reader.Close()

        Handle-Response $statusCode $body
    } else {
        Write-Error $ErrorRecord.Exception.Message
    }
}

function Send-MessageOrFile {
    param(
        [string]$Message,
        [string]$Title,
        [string]$Level,
        [string]$ParseMode
    )

    if ($Message.Length -gt $script:MAX_MESSAGE_LENGTH) {
        Write-Debug-Info "Message too long ($($Message.Length) chars), sending as file"

        $tmpFile = [System.IO.Path]::GetTempFileName()
        $txtFile = [System.IO.Path]::ChangeExtension($tmpFile, '.txt')
        Move-Item $tmpFile $txtFile -Force

        $Message | Set-Content $txtFile -NoNewline

        $caption = if ($Title) { $Title } else { "Output" }
        if ($Level) {
            $caption = "[$Level] $caption"
        }

        Send-File -FilePath $txtFile -Caption $caption -ParseMode $ParseMode
        Remove-Item $txtFile -Force
    } else {
        Send-Notification -Message $Message -Title $Title -Level $Level -ParseMode $ParseMode
    }
}

function Create-ZipAndSend {
    param(
        [string]$ZipName,
        [string[]]$Paths
    )

    if (-not $ZipName) {
        Write-Error "Error: -Zip requires a filename"
        exit 1
    }

    if (-not $Paths -or $Paths.Count -eq 0) {
        Write-Error "Error: -Zip requires files/directories to zip"
        exit 1
    }

    $tmpZip = Join-Path $env:TEMP $ZipName
    Write-Debug-Info "Creating zip: $tmpZip with paths: $($Paths -join ', ')"

    try {
        if (Test-Path $tmpZip) {
            Remove-Item $tmpZip -Force
        }

        $items = $Paths | ForEach-Object {
            if (Test-Path $_) {
                Get-Item $_
            } else {
                Write-Warning "Path not found: $_"
            }
        } | Where-Object { $_ -ne $null }

        if ($items.Count -eq 0) {
            Write-Error "Error: No valid paths to zip"
            exit 1
        }

        Compress-Archive -Path $items.FullName -DestinationPath $tmpZip -Force

        Write-Debug-Info "Zip created successfully: $tmpZip"
        Send-File -FilePath $tmpZip -Caption ""

        Remove-Item $tmpZip -Force
        Write-Debug-Info "Removed temporary zip: $tmpZip"
    } catch {
        Write-Error "Error: Failed to create zip file - $($_.Exception.Message)"
        exit 1
    }
}

function Run-CommandAndNotify {
    param(
        [string]$Command,
        [string]$Title,
        [string]$Level,
        [string]$ParseMode,
        [int]$Interval
    )

    if ($Interval -gt 0) {
        if ($Interval -lt 1) {
            Write-Error "Error: Interval must be at least 1 second"
            exit 1
        }

        Write-Debug-Info "Running command every ${Interval}s: $Command"
        Write-Host "Running '$Command' every ${Interval}s (Ctrl+C to stop)" -ForegroundColor Cyan

        while ($true) {
            try {
                $output = Invoke-Expression $Command 2>&1 | Out-String
                $exitCode = $LASTEXITCODE

                $msg = if ($exitCode -ne 0) {
                    "Exit code: $exitCode`n$output"
                } else {
                    $output
                }

                Write-Debug-Info "Command output: $msg"
                Send-MessageOrFile -Message $msg -Title $Title -Level $Level -ParseMode $ParseMode
            } catch {
                Write-Debug-Info "Command error: $($_.Exception.Message)"
            }

            Start-Sleep -Seconds $Interval
        }
    } else {
        Write-Debug-Info "Running command: $Command"

        try {
            $output = Invoke-Expression $Command 2>&1 | Out-String
            $exitCode = $LASTEXITCODE

            $msg = if ($exitCode -ne 0) {
                "Exit code: $exitCode`n$output"
            } else {
                $output
            }

            Write-Debug-Info "Command output: $msg"
            Send-MessageOrFile -Message $msg -Title $Title -Level $Level -ParseMode $ParseMode
        } catch {
            Write-Error "Error executing command: $($_.Exception.Message)"
        }
    }
}

# Main execution
if ($Help) {
    Show-Usage
    exit 0
}

if ($Version) {
    Write-Host "tgn version $script:VERSION"
    exit 0
}

if ($Login) {
    Do-Login
    exit 0
}

# Handle zip mode
if ($Zip) {
    Create-ZipAndSend -ZipName $Zip -Paths $ZipArgs
    exit 0
}

# Handle exec mode
if ($Exec) {
    Run-CommandAndNotify -Command $Exec -Title $Title -Level $Level -ParseMode $ParseMode -Interval $Interval
    exit 0
}

if ($Interval) {
    Write-Error "Error: -Interval requires -Exec"
    exit 1
}

# Read from stdin if no message provided and stdin is available
if (-not $Message -and -not [Console]::IsInputRedirected) {
    if ($PSBoundParameters.Count -eq 0 -or ($PSBoundParameters.Count -eq 1 -and $PSBoundParameters.ContainsKey('Debug'))) {
        Show-Usage
        exit 0
    }
}

if (-not $Message -and [Console]::IsInputRedirected) {
    $Message = @($input) -join "`n"
}

if (-not $Message) {
    Write-Error "Error: Message is required"
    Show-Usage
    exit 1
}

# Handle prompt mode
if ($Buttons -or $FreeInput) {
    $response = Send-Prompt -Message $Message -Buttons $Buttons -FreeInput $FreeInput.IsPresent -ParseMode $ParseMode -Timeout $Timeout
    if ($response) {
        Write-Output $response
    }
    exit 0
}

# Check if message is a file path
if (Test-Path $Message -PathType Leaf) {
    Write-Debug-Info "Argument is a file: $Message"

    $caption = $Title
    if ($Level) {
        $caption = if ($caption) { "[$Level] $caption" } else { "[$Level]" }
    }

    Send-File -FilePath $Message -Caption $caption -ParseMode $ParseMode
    exit 0
}

# Send as message (auto-file if too long)
Send-MessageOrFile -Message $Message -Title $Title -Level $Level -ParseMode $ParseMode
