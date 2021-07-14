{ lib, stdenv, fetchgit, buildPackages, bison, flex, pkg-config, db, iptables, libelf, libmnl, zlib, glibc }:

stdenv.mkDerivation rec {
  name = "iproute2";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git";
    rev = "115e9870358ba08ec8921ff8f459d379522f0368";
    sha256 = "1gazc2746jkkalg5ks5cdr654n8d0z8wc6lx78l45sm5xsl7kd2q";
  };

  preConfigure = ''
    # Don't try to create /var/lib/arpd:
    sed -e '/ARPDDIR/d' -i Makefile
    sed -e 's/netem//' -i Makefile
    echo > configure
    echo "CFLAGS += -DHAVE_SETNS -DHAVE_HANDLE_AT -DNEED_STRLCPY -DNO_SHARED_LIBS" > config.mk
    echo "LDFLAGS += -static -lelf -lz" >> config.mk
    echo "SHARED_LIBS=n" >> config.mk
    echo "CC=gcc" >> config.mk
    echo "V=99" >> config.mk
    echo "TC_CONFIG_NO_XT=y" >> config.mk
  '';

  outputs = [ "out" "dev" ];

  makeFlags = [
    "PREFIX=$(out)"
    "SBINDIR=$(out)/sbin"
    "DOCDIR=$(TMPDIR)/share/doc/${name}" # Don't install docs
    "HDRDIR=$(dev)/include/iproute2"
  ];

  buildFlags = [
    "CONFDIR=/etc/iproute2"
  ];

  installFlags = [
    "CONFDIR=$(out)/etc/iproute2"
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ]; # netem requires $HOSTCC
  nativeBuildInputs = [ bison flex pkg-config ];
  buildInputs = [ db iptables libelf libmnl zlib.static glibc.static ];
}
