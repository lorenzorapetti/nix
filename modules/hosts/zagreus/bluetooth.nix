{
  den.aspects.zagreus.nixos.services.udev.extraRules = ''
    # Internal Intel Bluetooth radio (hci1, part of the onboard Wi-Fi/BT combo
    # card) is unreliable; a Realtek USB adapter (hci0) is used instead.
    # Deauthorize it so btusb never binds to it.
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="8087", ATTR{idProduct}=="0029", ATTR{authorized}="0"
  '';
}
