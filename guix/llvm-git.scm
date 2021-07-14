(define-module (gnu packages llvm-git)
               #:use-module (guix packages)
               #:use-module (guix git-download)
               #:use-module (guix build-system cmake)
               #:use-module (guix licenses)
               #:use-module (gnu packages compression)
               #:use-module (gnu packages gcc)
               #:use-module (gnu packages ncurses)
               #:use-module (gnu packages python)
               #:use-module (gnu packages xml))

(define-public
  llvm-git
  (package
    (name "llvm-git")
    (version "99")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/llvm/llvm-project.git")
               (commit "94210b12d1d6454c6de8ca4c83a82a1148b5cd1a")
               (recursive? #t)))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "18zkv23fp0wh8d482cr004q1hahiv4sffa9hc5sil60idpi2h0sp"))))
    (build-system cmake-build-system)
    (arguments '(#:tests? #f
                 #:build-type "Release"
                 #:configure-flags '("-DLLVM_ENABLE_PROJECTS=clang"
                                     "-DLLVM_ENABLE_TERMINFO=off")
                 #:phases (modify-phases %standard-phases
                                         (add-after 'unpack 'patch-configure
                                                    (lambda _ (chdir "llvm"))))))
    (native-inputs
      `(("gcc@11" ,gcc-11)
        ("python" ,python)
        ("zlib" ,zlib)
        ("libxml2" ,libxml2)
        ("ncurses" ,ncurses)))
    (home-page "https://llvm.org")
    (synopsis "llvm from git HEAD")
    (description "llvm from git HEAD")
    (license asl2.0)))

llvm-git
