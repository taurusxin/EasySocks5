# EasySocks5

This is a very simple socks5 proxy tool written in golang
It takes just less than 150 lines code

## Build

| System       | Target      |
|--------------|-------------|
| Linux        | linux       |
| macOS(amd64) | macos-amd64 |
| macOS(arm64) | macos-arm64 |
| Windows x86  | win32       |
| Windows X64  | win64       |

`make [target]`

> default target is make all

## Package

`make releases`

## Check
```
bin/socks5-target
curl --proxy "socks5://127.0.0.1:1080" https://blog.xingez.me/ip.php
```

> https://blog.xingez.me/ip.php is an api that obtains the requestor's IP address
