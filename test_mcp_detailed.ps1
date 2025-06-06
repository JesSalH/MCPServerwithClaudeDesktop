$ErrorActionPreference = "Continue"

Write-Host "Testing MCP Server..."

# Change to the project directory
Set-Location "D:\DEV\projects\agents\anthropic\MCPwithClaudeDesktop\MCPServerwithClaudeDesktop"

# Create a process start info
$startInfo = New-Object System.Diagnostics.ProcessStartInfo
$startInfo.FileName = "dotnet"
$startInfo.Arguments = "run"
$startInfo.UseShellExecute = $false
$startInfo.RedirectStandardInput = $true
$startInfo.RedirectStandardOutput = $true
$startInfo.RedirectStandardError = $true
$startInfo.CreateNoWindow = $true
$startInfo.WorkingDirectory = "D:\DEV\projects\agents\anthropic\MCPwithClaudeDesktop\MCPServerwithClaudeDesktop"

# Start the process
$process = New-Object System.Diagnostics.Process
$process.StartInfo = $startInfo

try {
    Write-Host "Starting MCP server..."
    $process.Start() | Out-Null
    
    # Give it a moment to start
    Start-Sleep -Seconds 2
    
    Write-Host "Sending initialize message..."
    $initMessage = '{"jsonrpc":"2.0","method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}},"id":1}'
    $process.StandardInput.WriteLine($initMessage)
    $process.StandardInput.Flush()
    
    # Wait for response
    Start-Sleep -Seconds 3
    
    # Try to read any output
    Write-Host "Checking for responses..."
    $timeout = 5000 # 5 seconds
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    
    while ($sw.ElapsedMilliseconds -lt $timeout -and !$process.HasExited) {
        if ($process.StandardOutput.Peek() -ne -1) {
            $response = $process.StandardOutput.ReadLine()
            Write-Host "STDOUT: $response"
        }
        if ($process.StandardError.Peek() -ne -1) {
            $error = $process.StandardError.ReadLine()
            Write-Host "STDERR: $error"
        }
        Start-Sleep -Milliseconds 100
    }
    
    if ($process.HasExited) {
        Write-Host "Process exited with code: $($process.ExitCode)"
    } else {
        Write-Host "Process is still running"
    }
    
} catch {
    Write-Host "Error: $($_.Exception.Message)"
} finally {
    if (!$process.HasExited) {
        Write-Host "Killing process..."
        $process.Kill()
    }
    $process.Dispose()
}
