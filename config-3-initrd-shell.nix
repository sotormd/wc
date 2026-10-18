let
  configuration = import ./foobar.nix;

  finalConfiguration = configuration.extend (
    final: prev: let
      inherit (final) pkgs lib sh busyboxPATH;
    in
    {
      secureBootEnabled = true;
      initrdModules = prev.initrdModules ++ [ "dm_crypt" "dm_mod" ];
      initrdPackages = prev.initrdPackages ++ [ pkgs.cryptsetup pkgs.bashInteractive ];
      initrdCommands = ''
        echo initrd: starting shell
        bash
      '';
    }
  );
in
finalConfiguration
