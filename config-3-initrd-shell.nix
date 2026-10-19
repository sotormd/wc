let
  configuration = import ./config-2-secureboot.nix;

  finalConfiguration = configuration.extend (
    final: prev:
    {
      initrdModules = prev.initrdModules ++ [
        "dm_mod"
        "cbc"
        "xts"
        "encrypted_keys"
        "trusted"
        "dm_crypt"
      ];

      initrdPackages = prev.initrdPackages ++ [
        final.pkgs.cryptsetup
        final.pkgs.bashInteractive
      ];

      initrdCommands = ''
        mkdir -p /proc /sys /dev
        mount -t proc proc /proc
        mount -t sysfs sysfs /sys
        mount -t devtmpfs devtmpfs /dev

        ${final.loadModules final.initrdModules}

        exec bash # leaving will cause a kernel
                  # panic but thats alright :p
      '';
    }
  );
in
finalConfiguration.foo
