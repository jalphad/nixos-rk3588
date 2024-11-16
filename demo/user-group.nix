let
  username = "admin";
  hostName = "router";
  # To generate a hashed password run `mkpasswd -m scrypt`.
  # this is the hash of the password "rk3588"
  hashedPassword = "$y$j9T$V7M5HzQFBIdfNzVltUxFj/$THE5w.7V7rocWFm06Oh8eFkAKkUFb5u6HVZvXyjekK6";
  publickey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILk9J5Labk84GXRWOUBETbIhEw8kKq/jR5aISL52/HBH joren@nixos";
in {
  # =========================================================================
  #      Users & Groups NixOS Configuration
  # =========================================================================

  networking.hostName = hostName;

  # TODO Define a user account. Don't forget to update this!
  users = {
    users = {
      "${username}" = {
        inherit hashedPassword;
        isNormalUser = true;
        home = "/home/${username}";
        extraGroups = ["users" "wheel"];
        openssh.authorizedKeys.keys = [
          publickey
        ];
      };
      root.openssh.authorizedKeys.keys = [
        publickey
      ];
    };
    groups = {
      "${username}" = {};
      # docker = {};
    };
  };
}
