let
  foo = fetchTarball {
    url = "https://github.com/sotormd/foo/archive/1cab6067ae4578d81f1720e70f4f6ef5a323db1e.tar.gz";
    sha256 = "sha256-QAs/QhJBldfvq8+JHd9UG6jheZ4QE37uXocowKrMZPs=";
  };

  configuration = import "${foo}/foobar/configuration.nix";
  
  finalConfiguration = configuration.extend (
    final: prev: let
      configs = final.pkgs.runCommand "configs" { } ''
        mkdir -p $out
        cp ${./foobar.nix} $out/foobar.nix
        cp ${./config-1-install.nix} $out/config-1-install.nix
        cp ${./config-2-secureboot.nix} $out/config-2-secureboot.nix
        cp ${./config-3-initrd-shell.nix} $out/config-3-initrd-shell.nix
        cp ${./config-4-luks.nix} $out/config-4-luks.nix
      '';
    in
    {
      activateCommands = builtins.concatStringsSep "\n" [
        prev.activateCommands
        ''
        echo activate: linking configs

        ln -s ${configs} /run/configs
        ''
      ];
    }
  );
in
finalConfiguration
