hostname := `cat /etc/hostname | tr -d '\n'`

alias s := switch

default: (switch hostname)

switch host=hostname:
  nix run .#{{host}} -- switch

build host=hostname:
  nix run .#{{host}} -- build

repl host=hostname:
  nix run .#{{host}} -- repl

secrets:
  sops modules/secrets/secrets.yaml

