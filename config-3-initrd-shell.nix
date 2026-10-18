let
  configuration = import ./foobar.nix;

  finalConfiguration = configuration.extend (
    final: prev: let
      inherit (final) pkgs;
    in
    {
      secureBootEnabled = true;
      initrdModules = prev.initrdModules ++ [ "dm_crypt" "dm_mod" ];
      initrdPackages = prev.initrdPackages ++ [ pkgs.cryptsetup pkgs.bashInteractive ];
      initrdCommands = ''
        mkdir -p /proc /sys /dev
        mount -t proc proc /proc
        mount -t sysfs sysfs /sys
        mount -t devtmpfs devtmpfs /dev

        ${final.loadModules final.initrdModules}

        exec bash  # leaving will cause a kernel panic but thats alright :p
      '';
    }
  );
in
finalConfiguration
