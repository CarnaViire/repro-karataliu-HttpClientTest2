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

#RUN git clone https://github.com/karataliu/HttpClientTest2 && \
#    cd HttpClientTest2/HttpClientTest && \
#    export DOTNET_ROOT=/usr/share/dotnet && \
#    export PATH=$PATH:/usr/share/dotnet:/usr/share/dotnet/tools && \
#    dotnet publish -c release -r linux-x64 -p:PublishSingleFile=true --self-contained ./net7.csproj && \
#    dotnet publish -c release -r linux-x64 -p:PublishSingleFile=true --self-contained ./net8.csproj

COPY . ./HttpClientTest2

RUN cd HttpClientTest2/HttpClientTest && \
    export DOTNET_ROOT=/usr/share/dotnet && \
    export PATH=$PATH:/usr/share/dotnet:/usr/share/dotnet/tools && \
    dotnet publish -c release -r linux-x64 -p:PublishSingleFile=true --self-contained ./net7.csproj && \
    dotnet publish -c release -r linux-x64 -p:PublishSingleFile=true --self-contained ./net8.csproj

COPY ./test.sh .
RUN chmod +x ./test.sh

CMD ./test.sh
