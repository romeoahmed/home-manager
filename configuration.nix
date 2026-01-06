{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  # =====================================
  # 1. Boot & Kernel Settings
  # =====================================

  boot = {
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    initrd = {
      systemd = {
        enable = true;
        tpm2.enable = true;
      };
      verbose = false;
    };

    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    consoleLogLevel = 3;

    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "i915.force_probe=!a7a0"
      "xe.force_probe=a7a0"
    ];

    kernel = {
      sysctl = {
        # SysRq
        "kernel.sysrq" = 1;

        # Virtual Memory
        "vm.swappiness" = 180;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.page-cluster" = 0;
        "vm.dirty_ratio" = 3;
        "vm.dirty_background_ratio" = 1;
        "vm.vfs_cache_pressure" = 50;

        # Increasing the size of the receive queue
        "net.core.netdev_max_backlog" = 16384;

        # Increase the maximum connections
        "net.core.somaxconn" = 8192;

        # Increase the memory dedicated to the network interfaces
        "net.ipv4.udp_rmem_min" = 8192;
        "net.ipv4.udp_wmem_min" = 8192;
        "net.ipv4.tcp_rmem" = "4096 131072 16777216";
        "net.ipv4.tcp_wmem" = "4096 16384 16777216";
        "net.core.rmem_default" = 131072;
        "net.core.rmem_max" = 16777216;
        "net.core.wmem_default" = 131072;
        "net.core.wmem_max" = 16777216;
        "net.core.optmem_max" = 65536;

        # Enable TCP Fast Open
        "net.ipv4.tcp_fastopen" = 3;

        # Optimize the pending connection handling
        "net.ipv4.tcp_max_syn_backlog" = 8192;
        "net.ipv4.tcp_max_tw_buckets" = 262144;
        "net.ipv4.tcp_tw_reuse" = 1;
        "net.ipv4.tcp_fin_timeout" = 10;
        "net.ipv4.tcp_slow_start_after_idle" = 0;

        # TCP keepalive
        "net.ipv4.tcp_keepalive_time" = 60;
        "net.ipv4.tcp_keepalive_intvl" = 10;
        "net.ipv4.tcp_keepalive_probes" = 6;

        # Enable MTU probing
        "net.ipv4.tcp_mtu_probing" = 1;

        # TCP SACK & DSACK
        "net.ipv4.tcp_sack" = 1;
        "net.ipv4.tcp_dsack" = 1;

        # Enable BBR
        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_congestion_control" = "bbr";

        # Increase the Ephemeral port range
        "net.ipv4.ip_local_port_range" = "30000 65535";

        # TCP SYN cookie protection
        "net.ipv4.tcp_syncookies" = 1;

        # TCP rfc1337
        "net.ipv4.tcp_rfc1337" = 1;

        # Reverse path filtering
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.conf.default.rp_filter" = 1;

        # Disable ICMP redirects
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.secure_redirects" = 1;
        "net.ipv4.conf.default.secure_redirects" = 1;
        "net.ipv6.conf.all.accept_redirects" = 0;
        "net.ipv6.conf.default.accept_redirects" = 0;
        "net.ipv4.conf.all.send_redirects" = 0;
        "net.ipv4.conf.default.send_redirects" = 0;

        # Ignore ICMP echo requests
        "net.ipv4.icmp_echo_ignore_all" = 1;
        "net.ipv6.icmp.echo_ignore_all" = 1;
      };

      # Transparent HugePage
      sysfs = {
        kernel.mm.transparent_hugepage = {
          enabled = "always";
          defrag = "defer";
          shmem_enabled = "within_size";
        };
      };
    };
  };

  # ====================================
  # 2. Hardware and Graphics (Intel)
  # ====================================

  hardware = {
    facter.reportPath = ./hosts/facter.json;

    enableRedistributableFirmware = lib.mkDefault true;
    cpu.intel.updateMicrocode = lib.mkDefault true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        intel-compute-runtime
      ];
    };

    bluetooth.enable = true;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  # ====================================
  # 3. Desktop Environment (KDE Plasma)
  # ====================================

  services = {
    # Intel Graphics
    xserver.videoDrivers = [ "modesetting" ];

    # SDDM
    displayManager.sddm = {
      enable = true;
      wayland = {
        enable = true;
        compositor = "kwin";
      };
      settings.General.DisplayServer = "wayland";
    };

    # KDE Plasma
    desktopManager.plasma6.enable = true;

    # PipeWire
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    # Chrony
    chrony = {
      enable = true;
      enableNTS = true;
      servers = [ "time.cloudflare.com" ];
    };

    # Thunderbolt
    hardware.bolt.enable = true;

    # CPU Performance Scaling
    thermald.enable = true;
    power-profiles-daemon.enable = lib.mkForce false;

    # Upower
    upower.enable = true;

    # Mouse & Touchpad
    libinput = {
      enable = true;
      mouse.naturalScrolling = false;
      touchpad.naturalScrolling = true;
    };

    # Fingerprint Reader
    fprintd.enable = true;

    # Firmware Update Tool
    fwupd.enable = true;

    # Printing
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };

    # Color Management
    colord.enable = true;

    # v2rayA
    v2raya = {
      enable = true;
      cliPackage = pkgs.xray;
    };
  };

  # ====================================
  # 4. Networking
  # ====================================

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    firewall.enable = true;
    nftables.enable = true;
  };

  # ====================================
  # 5. Zram
  # ====================================

  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "lzo-rle zstd(level=3) (type=idle)";
  };

  # ====================================
  # 6. Power Management
  # ====================================

  powerManagement.powertop.enable = true;

  # ====================================
  # 7. Security Settings (sudo-rs)
  # ====================================
  security = {
    rtkit.enable = true;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };

  # ====================================
  # 8. Localization
  # ====================================

  time.timeZone = "Asia/Shanghai";
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    extraLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  # ====================================
  # 9. System Packages
  # ====================================

  environment.systemPackages = with pkgs; [
    sbctl
    tpm2-tools
    pciutils

    git
    vim
    wget2
  ];

  programs = {
    nix-ld.dev.enable = true;
    auto-cpufreq.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
  };

  # ====================================
  # 10. Nix Settings
  # ====================================

  nix = {
    channel.enable = false;
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    registry.nixpkgs.flake = inputs.nixpkgs;

    settings = {
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://numtide.cachix.org"
        "https://helix.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";

  # ====================================
  # 11. User Settings
  # ====================================

  programs.fish.enable = true;
  users.users.victor = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    initialPassword = "password";
    shell = pkgs.fish;
  };
}
