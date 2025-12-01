self: super: {
  llvm-arm64ec = super.llvmPackages_18.override {
    targets = ["AArch64" "ARM64EC"];
  };

  mingwArm64ec = super.stdenv.mkDerivation {
    pname = "mingw-w64-arm64ec";
    version = "0.1";

    src = super.fetchFromGitHub {
      owner = "mstorsjo";
      repo = "llvm-mingw";
      rev = "master";
      sha256 = "sha256-PjrXYCHrCfmz/Qn1TX44srepV4i0Bvup1bspuOIVViw=";
    };

    nativeBuildInputs = [
      self.llvm-arm64ec.clang
      self.llvm-arm64ec.lld
      super.cmake
      super.ninja
      super.python3
    ];

    buildPhase = ''
      ./build-toolchain.sh \
        --enable-arm64ec \
        --clang=${self.llvm-arm64ec.clang} \
        --lld=${self.llvm-arm64ec.lld} \
        --prefix=$out
    '';

    installPhase = "mkdir -p $out; cp -r * $out/";
  };
}
