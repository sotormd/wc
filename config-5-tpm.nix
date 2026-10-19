let
  configuration = import ./foobar.nix;

  finalConfiguration = configuration.extend (
    final: prev:
    {
      secureBootEnabled = true;

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
        final.pkgs.clevis
      ];

      initrdFindRealRootCommands = ''
        boot=/dev/sda1
        cryptroot=/dev/sda2
        root=/dev/mapper/drive

        if ! clevis luks unlock -d "$cryptroot" -n drive; then
          cryptsetup luksOpen "$cryptroot" drive
        fi
      '';
    }
  );
in
finalConfiguration.foo
