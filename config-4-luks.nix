let
  configuration = import ./config-2-secureboot.nix;

  finalConfiguration = configuration.extend (
    final: prev:
    {
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
