let
  foo = fetchTarball {
    url = "https://github.com/sotormd/foo/archive/1cab6067ae4578d81f1720e70f4f6ef5a323db1e.tar.gz";
    sha256 = "sha256-QAs/QhJBldfvq8+JHd9UG6jheZ4QE37uXocowKrMZPs=";
  };

  configuration = import "${foo}/foobar/configuration.nix";
  
  finalConfiguration = configuration.extend (
    final: prev:
    {
      activateCommands = builtins.concatStringsSep "\n" [
        prev.activateCommands
        ''
        echo activate: linking configs

        ln -s ${./.} /run/configs
        ''
      ];
      diskImageSize = "20G";
    }
  );
in
finalConfiguration
