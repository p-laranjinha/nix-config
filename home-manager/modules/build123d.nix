{pkgs, ...}:
with {
  my_toolz = pkgs.python3.pkgs.buildPythonPackage rec {
    pname = "toolz";
    version = "0.10.0";
    pyproject = true;

    src = pkgs.python3.pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-CP3V73yWSArRHBLUct4hrNMjWZlvaaUlkpm1QP66RWA=";
    };

    build-system = [
      pkgs.python3.pkgs.setuptools
    ];

    # has no tests
    doCheck = false;

    meta = {
      homepage = "https://github.com/pytoolz/toolz/";
      description = "List processing tools and functional utilities";
      # [...]
    };
  };
}; {
  home.packages = with pkgs; [
    (python3.withPackages
      (python-pkgs:
        with python-pkgs; [
          my_toolz
          yq
        ]))
  ];
}
