# =========================================================================
#      NanoPi R6S Specific Configuration
# =========================================================================
{rk3588, ...}: let
  inherit (rk3588) pkgsKernel;
in {
  imports = [
    ./base.nix
  ];

  boot = {
    kernelPackages = pkgsKernel.linuxPackagesFor (pkgsKernel.callPackage ../../pkgs/kernel/vendor.nix {});

    # kernelParams copy from Armbian's /boot/armbianEnv.txt & /boot/boot.cmd
    kernelParams = [
      "rootwait"
      "usbstoragequirks=0x2537:0x1066:u,0x2537:0x1068:u"

      "earlycon" # enable early console, so we can see the boot messages via serial port / HDMI
      "consoleblank=0" # disable console blanking(screen saver)
      "console=both"

      # docker optimizations
      "cgroup_enable=cpuset"
      "cgroup_memory=1"
      "cgroup_enable=memory"
      "swapaccount=1"
    ];
  };

  # add some missing deviceTree in armbian/linux-rockchip:
  # nanopi r6s's deviceTree in armbian/linux-rockchip:
  #    https://github.com/armbian/linux-rockchip/blob/rk-5.10-rkr4/arch/arm64/boot/dts/rockchip/rk3588s-nanopi-r6s.dts
  hardware = {
    deviceTree = {
      name = "rockchip/rk3588s-nanopi-r6s.dtb";
      overlays = [];
    };

    firmware = [];
  };
}
