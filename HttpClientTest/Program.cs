using System.Collections.Concurrent;
using System.Diagnostics;
using System.Net;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using TestUtilities;

if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
{
    // 3.0+ are M_NN_00_PP_p (Major, Minor, 0, Patch, Preview)
    // 1.x.y are 1_XX_YY_PP_p
    long version = SafeEvpPKeyHandle.OpenSslVersion;
    long major = (version >> 28) & 0xff;
    long minor = (version >> 20) & 0xff;
    Console.WriteLine($"OpenSSL {major}.{minor}");
}

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
