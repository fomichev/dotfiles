(define-module (iproute-git)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages flex)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pkg-config))

(define-public iproute-git
  (package
    (inherit iproute)
    (name "iproute-git")
    (version "99")
    (source
      (origin
        (method git-fetch)
        (uri
          (git-reference
             (url "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git")
             (commit "115e9870358ba08ec8921ff8f459d379522f0368")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "1gazc2746jkkalg5ks5cdr654n8d0z8wc6lx78l45sm5xsl7kd2q"))))
    (arguments
      (substitute-keyword-arguments (package-arguments iproute)
        ((#:phases phases)
          `(modify-phases ,phases
            (add-after 'unpack 'patch-configure
              (lambda _
                (let ((target ,(%current-target-system)))
                  (substitute* "configure" ((".*") ""))
                  (substitute* "Makefile" (("netem") ""))
                  (with-output-to-file
                    "config.mk"
                    (lambda ()
                      (format
                        #t
                        "CFLAGS+=-DHAVE_SETNS -DHAVE_HANDLE_AT -DNEED_STRLCPY -DNO_SHARED_LIBS
                        HAVE_MNL=n
                        LDFLAGS=-static -lelf -lz
                        SHARED_LIBS=n
                        CC=gcc
                        V=99
                        TC_CONFIG_NO_XT=y")))
                        #t)))))))
  (inputs
    `(("elfutils" ,elfutils)
    ("libc-static" ,glibc "static")
    ("zlib:static" ,zlib "static")))))
