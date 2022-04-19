hostapd RADIUS/EAP server
===

Provides setup to run [hostapd](https://w1.fi/hostapd/) as a RADIUS/EAP server (developmentally).

This is mostly a "knowledge" repository and parts can translate to production but the defaults
within this repository are meant for "quick start" over "proper".

Goals:

- Aggregate information from previous work with RADIUS/EAP systems
- Provide a single source of information/all encompassing place with information on how to use `hostapd` as a RADIUS/EAP server
- Document some undocumented components of getting various parts configured via examples

![build](https://github.com/enckse/hostapd-radius-eap-server/actions/workflows/main.yml/badge.svg)

# build

To build `hostapd` with the necessary settings simply run `make`

```
make
```

_This will build the hostapd server and also the eapol_test utility_

# install

In order to "deploy" (developmentally) one should run:

```
make install
```

which, by default, will create a `bin/` directory with the necessary binaries

## certificates

To run as an EAP server `hostapd` requires certificates which have been boostrapped in this repo and can be created via

```
make certificates
```

_At this point, `hostapd` can be run_

# usage

## hostapd server

To run the server

```
cd bin && ./hostapd hostapd.conf
```

## EAP test client

To test a client can connect

```
cd bin && ./eapol_test -a 127.0.0.1 -c eapol_test.conf -s secretclientkey -M 11:22:33:44:55:66
```

_Notice the MAC here is not the MAB'd one in the config as `eapol_test` is acting like a client and is authenticating as a user via the test config_

## MD4

The MD4s expected for MSCHAPV2 are not ones that can be quickly generated and instead require specific formatting. A small utility has been included to help.

```
cd utils && go run md4.go --password test
```

# contents

## files

- `build.config` contains the minset of build settings for `hostapd` to act as a RADIUS/EAP (PEAP+MSCHAPV2 and MAB methods)
- `clients` is the configuration file used to allow clients (e.g. switches) to talk to the RADIUS server
- `eap_users` is the list of users/MACs for authing
- `eapol_test.conf` is a test configuration file to use with `eapol_test` for EAP-based methods
- `hostapd.conf` is the `hostapd` daemon configuration file required to run as a RADIUS/EAP server

## notes

- As mentioned previously the certs/md4 files are all under the `utils/` area
- The `.github/workflows/main.yml` file contains the CI settings for alpine (e.g. how to build/run in Alpine Linux)
- Check out the [hostapd source/configs](https://w1.fi/cgit/hostap/tree/hostapd/) for more information
