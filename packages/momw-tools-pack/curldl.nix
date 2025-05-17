{
  python312,
  fetchFromPyPi,
  python312Packages,
}:
python312.pkgs.buildPythonPackage rec {
  pname = "curldl";
  version = "1.0.1 ";
  src = fetchFromPyPi {
    inherit pname version;
    url = "https://files.pythonhosted.org/packages/f9/39/a88f895a856c479105ee0d915caf7456a607427bfc96f808b7c16ceb2147/curldl-1.0.1-py3-none-any.whl";
    sha256 = "";
  };

  format = "wheel";
}
