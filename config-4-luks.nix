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
      ];

      initrdFindRealRootCommands = ''
        boot=/dev/sda1
        cryptroot=/dev/sda2
        root=/dev/mapper/drive
        cryptsetup luksOpen "$cryptroot" drive
      '';
    }
  );
in
finalConfiguration.foo
