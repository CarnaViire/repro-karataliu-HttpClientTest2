#!/bin/bash

cat /etc/os-release

#wait for the server to start
iter=0
maxiter=50
curl $URI --insecure --silent
while [ $? -ne 0 ] && [ $iter -le $maxiter ]; do
  iter=$((iter + 1))
  sleep 1
  curl $URI --insecure --silent
done

#warmup
for i in $(seq 1 $maxiter); do
  curl $URI --insecure --silent
  if [ $? -ne 0 ]; then
    echo "Failed to connect to $URI"
    exit 1
  fi
done

cd /HttpClientTest2/HttpClientTest/bin/release/

net7total=0
net7max=0
net8total=0
net8max=0
n=$((10#$CLIENT_ITERS))
if [ "$NET_EVENT_LISTENER" = "1" ]; then
  n=1
fi

for i in $(seq 1 $n); do
  echo "--iter $i--"

  echo "net7.0 ($CLIENT_ARGS)"
  ./net7.0/linux-x64/publish/net7 $CLIENT_ARGS > net7.log
  cat net7.log
  ms="$(head -n 1 net7.log | cut -d ' ' -f 3)" # "Elapsed ms: 131"
  net7total=$(($net7total + 10#$ms))
  net7max=$((10#$ms > $net7max ? 10#$ms : $net7max))

  echo "net8.0 ($CLIENT_ARGS)"
  ./net8.0/linux-x64/publish/net8 $CLIENT_ARGS > net8.log
  cat net8.log
  ms="$(head -n 1 net8.log | cut -d ' ' -f 3)"
  net8total=$(($net8total + 10#$ms))
  net8max=$((10#$ms > $net8max ? 10#$ms : $net8max))
  echo
done

if [ "$NET_EVENT_LISTENER" != "1" ]; then
  echo "net7.0 avg: $(($net7total / $n)) ms; max: $net7max ms"
  echo "net8.0 avg: $(($net8total / $n)) ms; max: $net8max ms"
fi
