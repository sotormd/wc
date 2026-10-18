let
  foo = fetchTarball {
    url = "https://github.com/sotormd/foo/archive/1b144122eff5f9c8a727bf306147ff2258c749d0.tar.gz";
    sha256 = "";
  };

  configuration = import "${foo}/foobar/configuration.nix";
in
configuration
