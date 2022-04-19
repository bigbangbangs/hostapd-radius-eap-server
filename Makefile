TAG      := hostap_2_9
CFLAGS   := "-march=native -mtune=generic -O2 -pipe -fno-plt"
LDFLAGS  := "-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"
SRC      := hostap
HOSTAPD  := $(SRC)/hostapd/
WPA_SUPP := $(SRC)/wpa_supplicant/
DESTDIR  := bin/

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
	cd $(DESTDIR)certs/ && make

install:
	mkdir -p $(DESTDIR)
	install -Dm755 $(HOSTAPD)hostapd $(DESTDIR)hostapd
	install -Dm755 $(WPA_SUPP)eapol_test $(DESTDIR)eapol_test
