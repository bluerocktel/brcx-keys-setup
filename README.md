# Pbx3cxKeysSetup

## BlueRockTEL Keys

### Initial Setup

Initial setup is launched from the 3cx host by user "debian":

```
wget -qO - https://raw.githubusercontent.com/bluerocktel/brcx-keys-setup/master/bluerocktel_3cx.sh | bash
```

### Update

It will install the keys we need and remove any deprecated key left on the server.

Update is launched by user "phonesystem" :

```
wget -qO - https://raw.githubusercontent.com/bluerocktel/brcx-keys-setup/master/bluerocktel_3cx_update.sh | bash
```

### Update all

Update all hosts from a distant machine, using a list of hosts to update, one by line.

## CX-Engine Keys

### Initial Setup if 3CX admin user is "debian"

Initial setup is launched from the 3cx host by user "debian":

```
wget -qO - https://raw.githubusercontent.com/bluerocktel/brcx-keys-setup/master/cx_3cx.sh | bash
```

### Initial Setup if 3CX admin user is "root"

Initial setup is launched from the 3cx host by user "root":

```
wget -qO - https://raw.githubusercontent.com/bluerocktel/brcx-keys-setup/master/cx_3cx_via_root.sh | bash

```
