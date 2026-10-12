{
  den.aspects.hardware.igpu-amd = {
    nixos = {
      boot.kernelParams = [
        "amdgpu.dc=1"
        "amdgpu.accel=1"
      ];

      hardware.amdgpu.initrd.enable = true;

      environment.sessionVariables = {
        AMD_VULKAN_ICD = "RADV";
      };
    };
  };
}
