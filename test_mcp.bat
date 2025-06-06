@echo off
cd "D:\DEV\projects\agents\anthropic\MCPwithClaudeDesktop\MCPServerwithClaudeDesktop"
echo {"jsonrpc":"2.0","method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}},"id":1} | dotnet run > output.txt 2>&1
type output.txt
