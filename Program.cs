using System.Diagnostics;

var watch = new Stopwatch();
watch.Start();
var hc = new HttpClient();
await hc.GetAsync("https://example.org");
watch.Stop();
Console.WriteLine(watch.Elapsed);
