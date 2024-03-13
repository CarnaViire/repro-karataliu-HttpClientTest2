using System.Collections.Concurrent;
using System.Diagnostics;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using TestUtilities;

bool enableEventListener = Environment.GetEnvironmentVariable("NET_EVENT_LISTENER") == "1";
var logs = new ConcurrentQueue<string>();
TestEventListener logger = null;
if (enableEventListener)
{
    logger = new TestEventListener(logs.Enqueue, TestEventListener.NetworkingEvents);
}

HttpClient hc;

if (args.Contains("SocketsHttpHandler"))
{

    hc = new HttpClient(new SocketsHttpHandler()
    {
        SslOptions = {
            CertificateChainPolicy = new X509ChainPolicy {
                DisableCertificateDownloads = true,
                RevocationMode = X509RevocationMode.NoCheck,
                VerificationFlags = args.Contains("IgnoreCertName") 
                    ? X509VerificationFlags.IgnoreInvalidName
                    : X509VerificationFlags.NoFlag
            },
            RemoteCertificateValidationCallback = delegate { return true; }
        }
    });
}
else if (args.Length == 0 || args.Length == 1 && args[0] == "HttpClientHandler")
{
    HttpClientHandler hch = new()
    {
        ServerCertificateCustomValidationCallback = (_, _, _, _) => true
    };
    hc = new HttpClient(hch);
}
else
{
    throw new ArgumentException("Invalid arguments: " + string.Join(", ", args));
}

var uri = Environment.GetEnvironmentVariable("URI");
if (string.IsNullOrEmpty(uri)) uri = "https://localhost:5001";
new HttpRequestMessage
{
    RequestUri = new Uri(uri),
    VersionPolicy = HttpVersionPolicy.RequestVersionExact,
    Version = HttpVersion.Version20,
};

var watch = Stopwatch.StartNew();
await hc.GetAsync(uri);
watch.Stop();
Console.WriteLine("Elapsed ms: " + watch.ElapsedMilliseconds);

if (enableEventListener)
{
    Console.WriteLine(Environment.NewLine + "---Networking event logs---");
    foreach (var log in logs)
    {
        Console.WriteLine(log);
    }
    Console.WriteLine("---EOF---" + Environment.NewLine);
}
