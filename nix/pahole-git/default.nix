{ lib, stdenv, fetchgit, cmake, elfutils, zlib }:

stdenv.mkDerivation rec {
  name = "pahole";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git";
    rev = "1ef87b26fd268b529b3568f3625d9eb10753a1a8";
    fetchSubmodules = true;
    sha256 = "1xvilz7kzh4cp49yqfwnrrfdq4hhaq4hglakmdl1vr2harh6a62s";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ elfutils zlib ];

  cmakeFlags = [ "-D__LIB=lib" ];
}
