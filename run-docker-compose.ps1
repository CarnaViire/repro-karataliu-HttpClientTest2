param (
    [Parameter(Mandatory=$true)]
    [string]$Distro,

    [Parameter(Mandatory=$true)]
    [string]$Handler,

    [Parameter()]
    [int32]$Iters = -1,

    [Parameter()]
    [switch]$Trace
)

$env:CLIENT_DF = "$Distro.Dockerfile"
$env:CLIENT_ARGS = "$Handler"

if ($Iters -ne -1) {
    if ($Trace) {
        Write-Host "Cannot specify both -Iters and -Trace. Exiting."
        exit 1
    }
    $env:CLIENT_ITERS = "$Iters"
    $env:NET_EVENT_LISTENER = "0"
} else {
    if ($Trace) {
        $env:CLIENT_ITERS = "1"
        $env:NET_EVENT_LISTENER = "1"
    } else {
        $env:CLIENT_ITERS = "10"
        $env:NET_EVENT_LISTENER = "0"
    }
}

docker-compose --file .\docker-compose.yml up --abort-on-container-exit --build