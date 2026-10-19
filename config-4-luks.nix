let
  configuration = import ./foobar.nix;

  finalConfiguration = configuration.extend (
    final: prev:
    {
      secureBootEnabled = true;
      initrdFindRealRootCommands = ''
        boot=/dev/sda1
        cryptroot=/dev/sda2
        root=/dev/mapper/drive
        cryptsetup luksOpen "$cryptroot" drive
      ''
    }
  );
in
finalConfiguration.foo
