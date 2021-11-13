NAME=socks5
BINDIR=bin
GOBUILD=CGO_ENABLED=0 go build -ldflags '-w -s -buildid='
VERSION=1.1.0
# The -w and -s flags reduce binary sizes by excluding unnecessary symbols and debug info
# The -buildid= flag makes builds reproducible

all: linux macos-amd64 macos-arm64 win64 win32

linux:
	GOARCH=amd64 GOOS=linux $(GOBUILD) -o $(BINDIR)/$(NAME)-$@

darwin-amd64:
	GOARCH=amd64 GOOS=darwin $(GOBUILD) -o $(BINDIR)/$(NAME)-$@

darwin-arm64:
	GOARCH=arm64 GOOS=darwin $(GOBUILD) -o $(BINDIR)/$(NAME)-$@

win64:
	GOARCH=amd64 GOOS=windows $(GOBUILD) -o $(BINDIR)/$(NAME)-$@.exe

win32:
	GOARCH=386 GOOS=windows $(GOBUILD) -o $(BINDIR)/$(NAME)-$@.exe

releases: linux darwin-amd64 darwin-arm64 win64 win32
	chmod +x $(BINDIR)/$(NAME)-*
	tar zcf $(BINDIR)/$(NAME)-linux-$(VERSION).tar.gz -C $(BINDIR) $(NAME)-linux
	tar zcf $(BINDIR)/$(NAME)-darwin-amd64-$(VERSION).tar.gz -C $(BINDIR) $(NAME)-darwin-amd64
	tar zcf $(BINDIR)/$(NAME)-darwin-arm64-$(VERSION).tar.gz -C $(BINDIR) $(NAME)-darwin-arm64
	zip -j $(BINDIR)/$(NAME)-win32-$(VERSION).zip $(BINDIR)/$(NAME)-win32.exe
	zip -j $(BINDIR)/$(NAME)-win64-$(VERSION).zip $(BINDIR)/$(NAME)-win64.exe
	rm -f $(BINDIR)/socks5-darwin-amd64 $(BINDIR)/socks5-darwin-arm64 $(BINDIR)/socks5-linux $(BINDIR)/socks5-win32.exe $(BINDIR)/socks5-win64.exe

clean:
	rm $(BINDIR)/*

# Remove trailing {} from the release upload url
GITHUB_UPLOAD_URL=$(shell echo $${GITHUB_RELEASE_UPLOAD_URL%\{*})

upload: releases
	curl -H "Authorization: token $(GITHUB_TOKEN)" -H "Content-Type: application/gzip" --data-binary @$(BINDIR)/$(NAME)-linux.tgz  "$(GITHUB_UPLOAD_URL)?name=$(NAME)-linux.tgz"
	curl -H "Authorization: token $(GITHUB_TOKEN)" -H "Content-Type: application/gzip" --data-binary @$(BINDIR)/$(NAME)-linux.gz  "$(GITHUB_UPLOAD_URL)?name=$(NAME)-linux.gz"
	curl -H "Authorization: token $(GITHUB_TOKEN)" -H "Content-Type: application/gzip" --data-binary @$(BINDIR)/$(NAME)-macos-amd64.gz  "$(GITHUB_UPLOAD_URL)?name=$(NAME)-macos-amd64.gz"
	curl -H "Authorization: token $(GITHUB_TOKEN)" -H "Content-Type: application/gzip" --data-binary @$(BINDIR)/$(NAME)-macos-arm64.gz  "$(GITHUB_UPLOAD_URL)?name=$(NAME)-macos-arm64.gz"
	curl -H "Authorization: token $(GITHUB_TOKEN)" -H "Content-Type: application/zip"  --data-binary @$(BINDIR)/$(NAME)-win64.zip "$(GITHUB_UPLOAD_URL)?name=$(NAME)-win64.zip"
	curl -H "Authorization: token $(GITHUB_TOKEN)" -H "Content-Type: application/zip"  --data-binary @$(BINDIR)/$(NAME)-win32.zip "$(GITHUB_UPLOAD_URL)?name=$(NAME)-win32.zip"
