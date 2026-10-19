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

        # for clevis' shebang
        (builtins.dirOf (builtins.dirOf final.pkgs.runtimeShell))

        # used by clevis
        final.pkgs.tpm2-tools
      ];

      # based on
      # https://github.com/nixos/nixpkgs/blob/nixos-unstable/nixos/modules/system/boot/clevis.nix
      initrdContents = prev.initrdContents ++ [
        {
          source = "${pkgs.tpm-tss}/lib/libtss2-tcti-device.so.0";
          target = "/lib/libtss2-tcti-device.so.0";
        }
      ];

      initrdFindRealRootCommands = ''
        boot=/dev/sda1
        cryptroot=/dev/sda2
        root=/dev/mapper/drive

        if ! clevis luks unlock -d "$cryptroot" -n drive; then
          cryptsetup luksOpen "$cryptroot" drive
          bash # for debugging
        fi
      '';
    }
  );
in
finalConfiguration.foo
