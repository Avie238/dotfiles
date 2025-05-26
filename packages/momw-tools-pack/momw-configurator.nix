{
  buildGoModule,
  fetchFromGitLab,
}:
buildGoModule rec {
  name = "momw-configurator";
  version = "1.18";
  src = fetchFromGitLab {
    owner = "modding-openmw";
    repo = "momw-configurator";
    rev = version;
    hash = "sha256-kOtm0QnCXDllXxJfUxCgbtnsF4wmooDvT4ilSM/a35Q=";
  };
  vendorHash = "sha256-Pu16/2qZvAkLVb1D3uQt3XrcfBn9lBGY5UVjAGsLKag=";
}
