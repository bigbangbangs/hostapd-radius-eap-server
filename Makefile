TAG      := hostap_2_9
CFLAGS   := "-march=native -mtune=generic -O2 -pipe -fno-plt"
LDFLAGS  := "-Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now"
SRC      := hostap
HOSTAPD  := $(SRC)/hostapd/
WPA_SUPP := $(SRC)/wpa_supplicant/

all: sources hostapd eapol_test certificates

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
	cd certs && make
