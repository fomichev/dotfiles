(define-module (pahole-git)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages compression))

(define-public pahole-git
  (package
    (name "pahole-git")
    (version "99")
    (source
      (origin
        (method git-fetch)
        (uri
          (git-reference
            (url "https://git.kernel.org/pub/scm/devel/pahole/pahole.git")
            (commit "1ef87b26fd268b529b3568f3625d9eb10753a1a8")
            (recursive? #t)))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "1xvilz7kzh4cp49yqfwnrrfdq4hhaq4hglakmdl1vr2harh6a62s"))))
    (build-system cmake-build-system)
    (arguments
      '(#:tests? #f
        #:configure-flags '("-D__LIB=lib")))
    (inputs
      `(("elfutils" ,elfutils)
        ("zlib" ,zlib)))
    (home-page "https://git.kernel.org/pub/scm/devel/pahole/pahole.git")
    (synopsis "pahole from git HEAD")
    (description "pahole from git HEAD")
    (license license:gpl2)))
