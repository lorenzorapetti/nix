# Adding a new host

This installs NixOS on a new machine from an already-running Nix machine (the "driver"),
using [`nixos-anywhere`](https://github.com/nix-community/nixos-anywhere) to drive the
whole thing over SSH: it kexecs the target into an installer, runs `nixos-facter` for
hardware detection, partitions the disk with `disko`, builds and installs this flake's
config, copies the sops age key onto the new system, and reboots into it.

## Prerequisites

- Your SSH public key is authorized on GitHub (`https://github.com/lorenzorapetti.keys`).
- Your sops age private key is available locally (default:
  `~/.config/sops/age/keys.txt`) — secrets in this repo are encrypted for it, and the new
  host needs it too.

## 1. Boot the installer on the target

Boot the target machine from a [nixos-images](https://github.com/nix-community/nixos-images)
kexec installer or ISO — these ship with `nixos-facter` built in, which `nixos-anywhere`
needs for hardware detection.

On the target, authorize your key and start SSH:

```sh
sudo su # if you're not root already
mkdir -p ~/.ssh
curl -o ~/.ssh/authorized_keys https://github.com/<your-github-username>.keys
systemctl start sshd
ip a   # note the target's IP
```

## 2. Confirm reachability

From the driver machine:

```sh
ssh root@<target-ip>
```

## 3. Inspect the target's disks and write disko.nix

Still from the driver machine, list the installer's view of the target's disks:

```sh
ssh root@<target-ip> lsblk -o NAME,SIZE,TYPE,MODEL
```

Use this to identify the real disk device to partition (e.g. `/dev/nvme0n1` vs `/dev/sda`)
and sanity-check its size — watch out for USB installer media itself showing up in the
list. `lsblk -f` additionally shows existing filesystems/labels if you need to confirm
you've got the right disk on a machine that's been used before.

**Double-check the device path before continuing** — `disko` will destructively partition
whatever device you put here.

Write `modules/hosts/<hostname>/disko.nix`, following the existing pattern (see
`modules/hosts/zagreus/disko.nix`):

```nix
{inputs, ...}: {
  den.aspects.<hostname>.nixos = {
    imports = [inputs.disko.nixosModules.disko];

    disko.devices = {
      disk.main = {
        device = "/dev/<device-from-lsblk>";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "4G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
```

Adjust the partition layout (filesystem, subvolumes, swap, ...) to what you actually want
for this host — the block above is a minimal starting point, not a fixed template.

## 4. Create the host module

Create `modules/hosts/<hostname>/default.nix`:

```nix
{den, ...}: {
  den.hosts.x86_64-linux.<hostname>.users.<user> = {};

  den.aspects.<hostname> = {
    includes = with den.aspects; [
      base
      # ... other aspects for this host
    ];

    nixos = {
      hardware.facter.reportPath = ./facter.json;
    };
  };
}
```

Seed a placeholder facter report so the flake can evaluate before `nixos-anywhere` has run:

```sh
echo '{}' > modules/hosts/<hostname>/facter.json
```

If `<user>` isn't already a user with the `sops` aspect available to it (the existing
`lorenzo` user pulls it in already), make sure the host or user includes
`den.aspects.sops` so secrets decrypt on this host.

## 5. Stage the sops age key

`nixos-anywhere` can copy arbitrary files onto the target's root filesystem during install
via `--extra-files`, laid out as they should land on disk. Stage the age key **outside the
git repo** — never commit it:

```sh
mkdir -p /tmp/extra-files/var/lib/sops-nix
cp ~/.config/sops/age/keys.txt /tmp/extra-files/var/lib/sops-nix/key.txt
chmod 600 /tmp/extra-files/var/lib/sops-nix/key.txt
```

This matches the path sops-nix expects on the target (see `modules/secrets/sops.nix`'s
`age.keyFile = "/var/lib/sops-nix/key.txt";`), so secrets decrypt on first activation.

## 6. Run nixos-anywhere

```sh
nix run github:nix-community/nixos-anywhere -- \
  --generate-hardware-config nixos-facter ./modules/hosts/<hostname>/facter.json \
  --extra-files /tmp/extra-files \
  --copy-host-keys \
  --flake .#<hostname> \
  root@<target-ip>
```

This kexecs into the installer, runs `nixos-facter` and writes the report back to your
local `facter.json`, keeps the ISO's SSH host keys on the new install, copies the age key
in from `--extra-files`, partitions the disk per `disko.nix`, builds and installs, then
reboots.

## 7. Commit the result

```sh
git add modules/hosts/<hostname>/
git commit -m "add <hostname> host"
git push
```

## 8. Update README

Add a row for the new host to the Hosts table in `README.md`.

## 9. Future changes

Once the host is up, deploy config changes to it remotely:

```sh
nixos-rebuild switch --flake .#<hostname> --target-host root@<target-ip>
```
