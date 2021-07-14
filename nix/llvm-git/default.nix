{ lib, stdenv, fetchgit, cmake, python3 }: #, elfutils, zlib }:

stdenv.mkDerivation rec {
  name = "llvm";
  src = fetchgit {
    url = "https://github.com/llvm/llvm-project.git";
    rev = "94210b12d1d6454c6de8ca4c83a82a1148b5cd1a";
    fetchSubmodules = true;
    sha256 = "18zkv23fp0wh8d482cr004q1hahiv4sffa9hc5sil60idpi2h0sp";
  };

  nativeBuildInputs = [ cmake ];
  #buildInputs = [ elfutils zlib ];
  buildInputs = [ python3 ];

  preConfigure = ''
    cd llvm
  '';

  cmakeFlags = [ "-DLLVM_ENABLE_PROJECTS=clang" ];
}
