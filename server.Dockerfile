FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
        curl \
        git \
        gnupg \
        libicu-dev \
        software-properties-common \
        vim

RUN curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 8.0.1xx --install-dir /usr/share/dotnet 

RUN git clone https://github.com/karataliu/HttpClientTest2 && \
    cd HttpClientTest2/Server && \
    /usr/share/dotnet/dotnet publish -c release -r linux-x64 -p:PublishSingleFile=true --self-contained ./Server.csproj && \
    cp -r bin/release/net8.0/linux-x64/publish/ /Server/

WORKDIR /Server

CMD ./Server
