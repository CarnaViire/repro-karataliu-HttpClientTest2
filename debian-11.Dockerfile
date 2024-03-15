FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y \
        curl \
        git \
        gnupg \
        libicu-dev \
        software-properties-common \
        vim

RUN curl -sSL https://dot.net/v1/dotnet-install.sh > dotnet-install.sh && \
    chmod +x dotnet-install.sh && \
    ./dotnet-install.sh --channel 7.0.1xx --install-dir /usr/share/dotnet && \
    ./dotnet-install.sh --channel 8.0.1xx --install-dir /usr/share/dotnet

COPY --chmod=777 ./test.sh .
COPY ./HttpClientTest/*.csproj ./src/
COPY ./HttpClientTest/*.cs ./src/

RUN cd src && \
    /usr/share/dotnet/dotnet publish -c release -r linux-x64 -p:PublishSingleFile=true --self-contained ./net7.csproj && \
    /usr/share/dotnet/dotnet publish -c release -r linux-x64 -p:PublishSingleFile=true --self-contained ./net8.csproj && \
    cp -r bin/release/net7.0/linux-x64/publish/ /net7/ && \
    cp -r bin/release/net8.0/linux-x64/publish/ /net8/

CMD ./test.sh
