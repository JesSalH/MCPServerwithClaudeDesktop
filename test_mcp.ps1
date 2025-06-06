cd "D:\DEV\projects\agents\anthropic\MCPwithClaudeDesktop\MCPServerwithClaudeDesktop"

# Start the dotnet process
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = "dotnet"
$psi.Arguments = "run"
$psi.UseShellExecute = $false
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true

$process = [System.Diagnostics.Process]::Start($psi)

# Send initialize message
$initMessage = '{"jsonrpc":"2.0","method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}},"id":1}'
$process.StandardInput.WriteLine($initMessage)
$process.StandardInput.Flush()

# Wait a bit and read response
Start-Sleep 2
while (-not $process.StandardOutput.EndOfStream) {
    $line = $process.StandardOutput.ReadLine()
    Write-Host "Response: $line"
}

# Send tools/list request
$toolsMessage = '{"jsonrpc":"2.0","method":"tools/list","params":{},"id":2}'
$process.StandardInput.WriteLine($toolsMessage)
$process.StandardInput.Flush()

# Wait and read response
Start-Sleep 2
while (-not $process.StandardOutput.EndOfStream) {
    $line = $process.StandardOutput.ReadLine()
    Write-Host "Response: $line"
}

$process.Kill()
