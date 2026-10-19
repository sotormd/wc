let
  commit = "4c0f66dae627ab6ca48278141ec0c9893b526814";
  hash = "sha256-KiRy+yLyhPIN9yJXWsa/vhKHAFmt4hgner2PBnECFkA=";

  foo = fetchTarball {
    url = "https://github.com/sotormd/foo/archive/${commit}.tar.gz";
    sha256 = hash;
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
        cp ${./config-5-tpm.nix} $out/config-5-tpm.nix
      '';
    in
    {
      activateCommands = builtins.concatStringsSep "\n" [
        prev.activateCommands
        ''
        echo activate: linking configs

        ln -sfn ${configs} /run/configs
        ''
      ];
    }
  );
in
finalConfiguration
