{
  den.aspects.hardware.igpu-amd = {
    nixos = {pkgs, ...}: {
      boot.kernelParams = [
        "amdgpu.dc=1"
        "amdgpu.accel=1"
        "amdgpu.ppfeaturemask=0xffffffff"
      ];

      hardware = {
        amdgpu.initrd.enable = true;

        graphics.extraPackages = with pkgs; [
          mesa
          libva
        ];
      };

      environment.sessionVariables = {
        AMD_VULKAN_ICD = "RADV";
      };
    };
  };
}
