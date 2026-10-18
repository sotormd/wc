let
  configuration = import ./foobar.nix;

  finalConfiguration = configuration.extend (
    _: _: { secureBootEnabled = true; }
  );
in
finalConfiguration.foo
