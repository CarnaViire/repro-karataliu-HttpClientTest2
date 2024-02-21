This repo is setup to compare HttpClient performance between net8 and net7.

Steps:
1. Setup servr:
```
cd Server
dotnet run
```

2. Setup tcpdump:
```
sudo tcpdump 'port 5001' -n -vv -i any -w capture.pcap
```

3. Run from net7:
```
docker run -ti mcr.microsoft.com/dotnet/sdk:7.0 bash
git clone https://github.com/karataliu/HttpClientTest2
cd HttpClientTest2/Client
dotnet run --project net7.csproj
```

4. Run from net8:
```
docker run -ti mcr.microsoft.com/dotnet/sdk:8.0 bash
git clone https://github.com/karataliu/HttpClientTest2
cd HttpClientTest2/Client
dotnet run --project net8.csproj
```

5. Compare the result.
