TAG      := hostap_2_9
CFLAGS   := "-march=native -mtune=generic -O2 -pipe -fno-plt"
LDFLAGS  := "-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"
SRC      := hostap
HOSTAPD  := $(SRC)/hostapd/
WPA_SUPP := $(SRC)/wpa_supplicant/
CERTKEY  := mysecretkey
DESTDIR  := $(PWD)/bin/

all: sources hostapd eapol_test

sources:
	test -d $(SRC) || git clone git://w1.fi/hostap.git $(SRC)
	git -C $(SRC) reset --hard
	git -C $(SRC) checkout $(TAG)

hostapd:
	ln -sf $(PWD)/build.config $(HOSTAPD).config
	cd $(HOSTAPD) && make

eapol_test:
	ln -sf $(PWD)/build.config $(WPA_SUPP).config
	cd $(WPA_SUPP) && make eapol_test

certificates:
	mkdir -p $(DESTDIR)
	cp -r certs $(DESTDIR)certs
	sed -i "s/{PASSWORD}/$(CERTKEY)/g" $(DESTDIR)certs/*.cnf
	cd $(DESTDIR)certs/ && make

install:
	mkdir -p $(DESTDIR)
	install -Dm600 hostapd.conf $(DESTDIR)
	sed -i "s/{PASSWORD}/$(CERTKEY)/g" $(DESTDIR)hostapd.conf
	sed -i "s#{PATH}#$(DESTDIR)#g" $(DESTDIR)hostapd.conf
	install -Dm755 $(HOSTAPD)hostapd $(DESTDIR)hostapd
	install -Dm755 $(WPA_SUPP)eapol_test $(DESTDIR)eapol_test
	install -Dm600 eap_users $(DESTDIR)eap_users
	install -Dm600 clients $(DESTDIR)clients
	install -Dm600 eapol_test.conf $(DESTDIR)eapol_test.conf
