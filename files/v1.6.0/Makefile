NAME=keadm
VERSION=1.6.0

.PHONY: package
package:
	rm -rf *.tar.gz
	wget https://github.com/kubeedge/kubeedge/releases/download/v$(VERSION)/keadm-v$(VERSION)-linux-amd64.tar.gz
	wget https://github.com/kubeedge/kubeedge/releases/download/v$(VERSION)/keadm-v$(VERSION)-linux-arm64.tar.gz
	wget https://github.com/kubeedge/kubeedge/releases/download/v$(VERSION)/keadm-v$(VERSION)-linux-arm.tar.gz
	tar -xzvf keadm-v$(VERSION)-linux-amd64.tar.gz
	tar -xzvf keadm-v$(VERSION)-linux-arm64.tar.gz
	tar -xzvf keadm-v$(VERSION)-linux-arm.tar.gz
	fpm -s dir -t deb -n $(NAME) -v $(VERSION) -a amd64 keadm-v$(VERSION)-linux-amd64/keadm/keadm=/usr/local/bin/keadm
	fpm -s dir -t deb -n $(NAME) -v $(VERSION) -a arm64 keadm-v$(VERSION)-linux-arm64/keadm/keadm=/usr/local/bin/keadm
	fpm -s dir -t deb -n $(NAME) -v $(VERSION) -a arm keadm-v$(VERSION)-linux-arm/keadm/keadm=/usr/local/bin/keadm
