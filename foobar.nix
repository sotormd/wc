let
  foo = fetchTarball {
    url = "https://github.com/sotormd/foo/archive/07e4db919298ff89b6ed40e0d5e529a60a94b821.tar.gz";
    sha256 = "sha256-ISWx73izvHNyOv+A6oRf8Tc6S1AxrFAD4PZH0tTZvzg=";
  };

  configuration = import "${foo}/foobar/configuration.nix";
in
configuration
