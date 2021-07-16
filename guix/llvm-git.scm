(define-module (llvm-git)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages python)
  #:use-module (gnu packages xml))

(define-public llvm-git
  (package
    (name "llvm-git")
    (version "99")
    (source
      (origin
        (method git-fetch)
        (uri
	  (git-reference
            (url "https://github.com/llvm/llvm-project.git")
            (commit "94210b12d1d6454c6de8ca4c83a82a1148b5cd1a")
            (recursive? #t)))
        (file-name (git-file-name name version))
        (sha256
          (base32
            "18zkv23fp0wh8d482cr004q1hahiv4sffa9hc5sil60idpi2h0sp"))))
    (build-system cmake-build-system)
    (arguments
      '(#:tests? #f
        #:build-type "Release"
        #:configure-flags
          (list
            "-DLLVM_ENABLE_PROJECTS=clang"
            "-DLLVM_ENABLE_TERMINFO=off"
            (string-append
              "-DCMAKE_CXX_FLAGS=-isystem"
              (assoc-ref %build-inputs "linux-libre-headers-5.13")
              "/include"))
        #:phases
          (modify-phases %standard-phases
            (add-after
              'unpack 'patch-configure
              (lambda _ (chdir "llvm"))))))
    (native-inputs
      `(("python" ,python)
        ("zlib" ,zlib)
        ("linux-libre-headers-5.13" ,linux-libre-headers-5.13)
        ("libxml2" ,libxml2)
        ("ncurses" ,ncurses)))
    (home-page "https://llvm.org")
    (synopsis "llvm from git HEAD")
    (description "llvm from git HEAD")
    (license license:asl2.0)))
