# EasySocks5

This is a very simple socks5 proxy tool written in golang
It takes just less than 150 lines code

## Usage

`go run socks5.go`

## Build

`go build socks5.go`

## Check
```
go run socks5.go
curl --proxy "socks5://127.0.0.1:1080" https://blog.xingez.me/ip.php
```

> https://blog.xingez.me/ip.php is an api that obtains the requestor's IP address
