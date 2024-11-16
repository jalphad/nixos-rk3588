{
  pkgs,
  nixpkgs,
  ...
}: {
  # =========================================================================
  #      Base NixOS Configuration
  # =========================================================================

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  nix = {
    settings = {
      # Manual optimise storage: nix-store --optimise
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      auto-optimise-store = true;
      builders-use-substitutes = true;
      # enable flakes globally
      experimental-features = ["nix-command" "flakes"];
    };
    # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
    registry.nixpkgs.flake = nixpkgs;
    nixPath = ["/etc/nix/inputs"];
  };

  # make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  environment = {
    etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
    systemPackages = with pkgs; [
      neovim

      # networking
      mtr # A network diagnostic tool
      iperf3 # A tool for measuring TCP and UDP bandwidth performance
      nmap # A utility for network discovery and security auditing
      ldns # replacement of dig, it provide the command `drill`
      socat # replacement of openbsd-netcat
      tcpdump # A powerful command-line packet analyzer

      # archives
      zip
      xz
      unzip
      p7zip
      zstd
      gnutar

      # misc
      file
      which
      tree
      gnused
      gawk
      tmux
    ];
    # replace default editor with neovim
    variables.EDITOR = "nvim";
  };

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password"; # disable root login with password
      PasswordAuthentication = false; # disable password login
    };
  };

  system.stateVersion = "23.11";
}
