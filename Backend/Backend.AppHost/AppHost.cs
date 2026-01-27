var builder = DistributedApplication.CreateBuilder(args);

builder.AddProject<Projects.API>("api")
    .WithUrlForEndpoint("https", url => {
        url.Url = "/scalar";
    }).WithUrlForEndpoint("http", url => {
        url.Url = "/scalar";
    });

builder.Build().Run();
