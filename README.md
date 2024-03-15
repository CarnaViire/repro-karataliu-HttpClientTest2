Script to run repro (client and server) in docker.

Example:
```sh
.\run-docker-compose.ps1 -Distro debian-12 -Handler "SocketsHttpHandler IgnoreCertName"
```
Parameters:

- `-Distro` (required)
    - `debian-11` -- debian-11.Dockerfile
    - `debian-12` -- debian-12.Dockerfile

- `-Handler` (required)
    - `HttpClientHandler`
    - `SocketsHttpHandler`
    - `"SocketsHttpHandler IgnoreCertName"`
        - sets `CertificateChainPolicy.VerificationFlags` to `IgnoreInvalidName`

- `-Iters` (optional, default = 10) -- number of runs to get avg result

- `-Trace` (optional) -- collects traces from networking event sources; incompatible with `-Iters`

- `-ForceOpenSSL11` (optional) -- forces .NET to use "1.1" (sets `CLR_OPENSSL_VERSION_OVERRIDE`)