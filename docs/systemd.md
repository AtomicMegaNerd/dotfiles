# Systemd Reference

Some basic reference information on systemd.

## Targets

These are the targts on my NixOS 26.05 machine

```bash
❯ systemctl list-units --type=target
  UNIT                        LOAD   ACTIVE SUB    DESCRIPTION
  basic.target                loaded active active Basic System
  cryptsetup.target           loaded active active Local Encrypted Volumes
  getty.target                loaded active active Login Prompts
  local-fs-pre.target         loaded active active Preparation for Local File Systems
  local-fs.target             loaded active active Local File Systems
  machines.target             loaded active active Virtual Machines and Containers
  multi-user.target           loaded active active Multi-User System
  network-online.target       loaded active active Network is Online
  network-pre.target          loaded active active Preparation for Network
  network.target              loaded active active Network
  nss-lookup.target           loaded active active Host and Network Name Lookups
  nss-user-lookup.target      loaded active active User and Group Name Lookups
  paths.target                loaded active active Path Units
  remote-fs.target            loaded active active Remote File Systems
  slices.target               loaded active active Slice Units
  sockets.target              loaded active active Socket Units
  sound.target                loaded active active Sound Card
  swap.target                 loaded active active Swaps
  sysinit-reactivation.target loaded active active Reactivate sysinit units
  sysinit.target              loaded active active System Initialization
  time-set.target             loaded active active System Time Set
  timers.target               loaded active active Timer Units
  tpm2.target                 loaded active active Trusted Platform Module

Legend: LOAD   → Reflects whether the unit definition was properly loaded.
        ACTIVE → The high-level unit activation state, i.e. generalization of SUB.
        SUB    → The low-level unit activation state, values depend on unit type.

23 loaded units listed. Pass --all to see loaded but inactive units, too.
To show all installed unit files use 'systemctl list-unit-files'.
```

## References

- [Systemd](https://systemd.io/)
- [Systemd on ArchWiki](https://wiki.archlinux.org/title/Systemd)
