(define-module (gnu packages iproute2-git)
               #:use-module (guix packages)
               #:use-module (guix git-download)
               #:use-module (guix build-system gnu)
               #:use-module (guix licenses)
               #:use-module (gnu packages base)
               #:use-module (gnu packages compression)
               #:use-module (gnu packages elf)
               #:use-module (gnu packages bison)
               #:use-module (gnu packages flex)
               #:use-module (gnu packages pkg-config))

(define-public
  iproute2-git
  (package
    (name "iproute2-git")
    (version "99")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://git.kernel.org/pub/scm/network/iproute2/iproute2.git")
               (commit "115e9870358ba08ec8921ff8f459d379522f0368")))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "1gazc2746jkkalg5ks5cdr654n8d0z8wc6lx78l45sm5xsl7kd2q"))))
    (build-system gnu-build-system)
    (arguments
      `(#:tests? #f
        #:make-flags (let ((out (assoc-ref %outputs "out")))
                       (list "DESTDIR="
                             "CC=gcc"
                             "HOSTCC=gcc"
                             (string-append "BASH_COMPDIR=" out "/etc/bash_completion.d")
                             (string-append "LIBDIR=" out "/lib")
                             (string-append "HDRDIR=" out "/include")
                             (string-append "SBINDIR=" out "/sbin")
                             (string-append "CONFDIR=" out "/etc")
                             (string-append "DOCDIR=" out "/share/doc/"
                                            ,name "-" ,version)
                             (string-append "MANDIR=" out "/share/man")))
        #:phases (modify-phases
                   %standard-phases
                   ;;; (delete 'configure)
                   (add-before
                     'install 'pre-install
                     (lambda _
                       ;; Don't attempt to create /var/lib/arpd.
                       (substitute* "Makefile"
                                    (("^.*ARPDDIR.*$") "")) #t))
                   (add-after
                     'unpack 'patch-configure
                     (lambda _
                       (let ((target ,(%current-target-system)))
                         (substitute* "configure" ((".*") ""))
                         (substitute* "Makefile" (("netem") ""))
                         (with-output-to-file
                           "config.mk"
                           (lambda ()
                             (format #t "CFLAGS += -DHAVE_SETNS -DHAVE_HANDLE_AT -DNEED_STRLCPY -DNO_SHARED_LIBS
                                     LDFLAGS += -static -lelf -lz
                                     SHARED_LIBS=n
                                     CC=gcc
                                     V=99
                                     TC_CONFIG_NO_XT=y")))
                                     #t))))))
    (inputs
      `(("elfutils" ,elfutils)
        ("libc-static" ,glibc "static")
        ("zlib:static" ,zlib "static")))
    (native-inputs
      `(("bison" ,bison)
        ("flex" ,flex)
        ("pkg-config" ,pkg-config)))
    (home-page "https://wiki.linuxfoundation.org/networking/iproute2")
    (synopsis "iroute2 from git HEAD + static")
    (description "iroute2 from git HEAD + static")
    (license gpl2)))

iproute2-git
