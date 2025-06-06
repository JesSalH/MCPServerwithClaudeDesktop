using System.Net.Http.Headers;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

Console.Error.WriteLine("MCP Server starting...");

var builder = Host.CreateEmptyApplicationBuilder(settings: null);

Console.Error.WriteLine("Adding MCP server services...");

builder.Services.AddMcpServer()
    .WithStdioServerTransport()
    .WithToolsFromAssembly();

Console.Error.WriteLine("Adding HTTP client...");

builder.Services.AddSingleton(_ =>
    {
        var client = new HttpClient()
        {
            BaseAddress = new Uri("https://api.weather.gov")
        };
        client.DefaultRequestHeaders.UserAgent.Add(new ProductInfoHeaderValue("weather-tool", "1.0"));
        return client;
    }
);

Console.Error.WriteLine("Building application...");
var app = builder.Build();

Console.Error.WriteLine("Starting MCP server...");
await app.RunAsync();
