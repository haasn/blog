---
title: Jailing specific processes inside a VPN
author: Niklas Haas
tags: networking, linux, tips
---

I've always wondered how difficult it would be to do something like this, so I
decided to give it a try. Turns out the answer is, since the addition of UID
matching to `ip rule`, not very difficult.

## iproute2 configuration

The basic approach is to give the VPN interface a separate routing table, and
redirect suspect processes to that routing table instead. Since working with
numeric IDs directly is sort of a pain, you can give them friendly names:

```bash
$ cat /etc/iproute2/rt_tables
#
# reserved values
#
255	local
254	main
253	default
0	unspec
#
# local
#
1	vpn
```

## Confining your process to a specific user

Since `ip rule` can only match based on UID, rather than PID (which is more
stable anyway), the first step is making sure your process is running under
some suitable user. For example, suppose you're trying to isolate
`transmission-daemon`, then the appropriate user would be `transmission`,
which (at least on my system) `transmission-daemon` gets run under. If your
program lacks such a convenient user, then you could always add your own and
use something like sudo to switch to it, e.g.:

```bash
$ cat /etc/sudoers.d/rtorrent
joe ALL = (rtorrent) NOPASSWD: /usr/bin/rtorrent
```

Then user `joe` could use `sudo -u rtorrent /usr/bin/rtorrent` to run rtorrent
as a separate user `rtorrent`.

## OpenVPN configuration

The second part of the configuration is making sure to set up the correct
routing table as part of OpenVPN's initialization. For the purposes of this
example, I want to ignore the VPN provider's pushed routes (since they try
overriding my system-wide routing to go through their VPN, whereas I only want
it for certain processes), which the addition of `route-noexec` solves.

```bash
$ cat /etc/openvpn/example/openvpn.conf
...
script-security 2
route-noexec
route-up /etc/openvpn/example/route.sh
route-pre-down /etc/openvpn/example/route-down.sh
```

```bash
$ cat /etc/openvpn/example/route.sh
#!/bin/sh
sudo ip route add default via $route_vpn_gateway table vpn

# Confine transmission and rtorrent to this table (as an example)
for user in rtorrent transmission; do
    uid=$(id -u $user)
    sudo ip rule add uidrange $uid-$uid table vpn
done

```

```bash
$ cat /etc/openvpn/example/route-down.sh
#!/bin/sh
sudo ip route flush table vpn

# Delete all ip rules that mention this table
while sudo ip rule del table vpn; do :; done
```

The magic happens due to the `ip rule` invocation. Basically, it creates a
rule that looks like this:

```bash
$ ip rule list
0:	from all lookup local 
32765:	from all uidrange 141-141 lookup vpn 
32766:	from all lookup main 
32767:	from all lookup default 
```

This means that any packet originating from UID `141-141` (i.e.
`transmission`) will get routed as according to the table `vpn`, which looks
like this: (as an example)

```bash
$ ip route list table vpn
default via 10.128.0.1 dev tun0 
```

### `ip` and root privileges

For these scripts to work, openvpn needs to be able to execute `ip` commands
(with root privilege). You could either accomplish this by preventing
`openvpn` from ever dropping privileges (bad), or, as I prefer, using `sudo`
to re-gain access to `ip` for the openvpn user:

```bash
$ cat /etc/sudoers.d/openvpn
openvpn ALL = (root) NOPASSWD: /bin/ip
```

Note that dropping privileges for OpenVPN is done by adding something like the
following to your `openvpn.conf`:

```bash
persist-key
persist-tun
user openvpn
group openvpn
```

## Linux configuration

It's possible that due to the way source route verification works under Linux,
you will not receive any replies directed your way (and e.g. `ping` as the
confined user will fail). The solution to this is setting `rp_filter` to 2,
e.g.

```bash
$ cat /etc/sysctl.d/20-disable-rp_filter.conf
net.ipv4.conf.default.rp_filter = 2
net.ipv4.conf.all.rp_filter = 2
```
followed by `sysctl -p`.

If it still doesn't work, you may need to flush the routing cache, i.e. `ip
route flush cache`.

## Disclaimer and warning

### A word on DNS

If you use a local DNS server (e.g. one pushed by your DHCP server), then DNS
lookups from the `confined` user will fail, because there's no appropriate
route for the local DNS server. There are several solutions to this:

1. Use a public DNS server that's accessible via the VPN as well.
2. Hard-code domains you care about to `/etc/hosts`.
3. Add an extra route for your local DNS server to the `vpn` table.

While #3 seems the most attractive, this is a privacy risk because DNS
requests will leak your real IP! Only do this if you're sure you know what
you're signing yourself up for.

### Other sources of IP leaks

It's possible that all your effort will be for naught and your client will
find other ways of leaking your ‘real’ IP to the internet. Unless you have
carefully audited and tested your specific program, do **NOT** take this guide as
any sort of guarantee. WebRTC, torrent clients etc. have all found ways to
inadvertently de-anonymize VPN users.

One website you can use for testing these sorts of things is `ipleak.net`,
which includes support for testing torrent clients in particular. Handy if you
just want to make sure your client isn't egregiously advertising your real IP
to trackers.
