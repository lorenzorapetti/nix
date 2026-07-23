{
  den.aspects.desktop.sound = {
    nixos = {pkgs, ...}: {
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;

        wireplumber = {
          enable = true;

          extraConfig = {
            "51-rename-devices.conf" = {
              "monitor.alsa.rules" = [
                {
                  matches = [{"node.name" = "alsa_output.usb-Schiit_Audio_Schiit_Modi_3_-00.analog-stereo";}];
                  actions = {
                    update-props = {
                      "node.description" = "Schiit DAC";
                      "node.nick" = "Schiit DAC";
                    };
                  };
                }
                {
                  matches = [{"node.name" = "alsa_output.usb-Logitech_PRO_X_Wireless_Gaming_Headset-00.analog-stereo";}];
                  actions = {
                    update-props = {
                      "node.description" = "Logitech G PRO X Headset";
                      "node.nick" = "Logitech G PRO X Headset";
                    };
                  };
                }
              ];
            };
            "52-fosi-bitperfect.conf" = {
              "monitor.alsa.rules" = [
                {
                  matches = [{"node.name" = "alsa_output.usb-Fosi_Fosi_Audio_ZH3-00.analog-stereo";}];
                  actions = {
                    update-props = {
                      "node.description" = "Fosi Audio ZH3 (Bit-Perfect)";
                      "node.nick" = "Fosi Audio ZH3";
                      "audio.format" = "S32LE";
                      "audio.channels" = 2;
                      "api.alsa.period-size" = 1024;
                      "api.alsa.headroom" = 0;
                      "node.suspend-on-idle" = false;
                      "priority.driver" = 9000;
                      "priority.session" = 9000;
                      "resample.disable" = true;
                      "monitor.channel-volumes" = false;
                    };
                  };
                }
              ];
            };
          };
        };

        extraConfig = {
          pipewire."10-hi-res.conf" = {
            "context.properties" = {
              "default.clock.rate" = 48000;
              "default.clock.allowed-rates" = [44100 48000 88200 96000 176000 192000 352800 384000 705600 768000];
              "default.clock.quantum" = 1024;
              "default.clock.min-quantum" = 32;
              "default.clock.max-quantum" = 8192;
            };
          };
        };
      };

      environment.systemPackages = with pkgs; [
        wiremix
        pwvucontrol
        sone
        easyeffects
      ];
    };

    homeManager = {
      home.file.".config/wiremix/wiremix.toml".text = ''
        tab = "output"
        tabs = [ "output", "playback", "input", "recording", "configuration" ]

        # Friendly device names.
        #
        # This mirrors the wireplumber rename in
        # wireplumber.conf.d/51-rename-devices.conf, which sets friendly node.nick/
        # node.description on the ALSA nodes. wiremix's defaults don't fully use those:
        #
        #   * The Output/Input Devices tabs (endpoint) default to "{device:device.nick}"
        #     first, which is the raw card name (e.g. "HD-Audio Generic"). We reorder it
        #     to prefer the friendly node name set by wireplumber.
        #   * The Configuration tab (device) uses device.nick/device.description, which
        #     wireplumber never renames, so we add per-device overrides below.
        #
        # Devices are matched by their stable device.name (derived from USB/PCI IDs).
        [names]
        # Prefer the friendly wireplumber node name on the Devices tabs.
        endpoint = [ "{node:node.nick}", "{node:node.description}", "{device:device.nick}" ]

        # Friendly names for the Configuration tab, keyed by stable device.name.
        [[names.overrides]]
        types = [ "device" ]
        matches = [ { "device:device.name" = "alsa_card.usb-Schiit_Audio_Schiit_Modi_3_-00" } ]
        templates = [ "Schiit DAC" ]

        [[names.overrides]]
        types = [ "device" ]
        matches = [ { "device:device.name" = "alsa_card.usb-Logitech_PRO_X_Wireless_Gaming_Headset-00" } ]
        templates = [ "Logitech G PRO X Headset" ]

        [[names.overrides]]
        types = [ "device" ]
        matches = [ { "device:device.name" = "alsa_card.usb-Insta360_Insta360_Link_2C-02" } ]
        templates = [ "Webcam" ]
      '';
    };
  };
}
