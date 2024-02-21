using System.Diagnostics;
using System.Net;

var watch = new Stopwatch();
watch.Start();

HttpClientHandler hch = new()
{
    ServerCertificateCustomValidationCallback = (_, _, _, _) => true
};
var hc = new HttpClient(hch);

var uri = Environment.GetEnvironmentVariable("URI");
if (string.IsNullOrEmpty(uri)) uri = "https://localhost:5001";
new HttpRequestMessage
{
    RequestUri = new Uri(uri),
    VersionPolicy = HttpVersionPolicy.RequestVersionExact,
    Version = HttpVersion.Version20,
};
await hc.GetAsync(uri);
watch.Stop();
Console.WriteLine(watch.Elapsed);
