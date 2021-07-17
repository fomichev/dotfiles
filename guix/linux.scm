; from
; https://gitlab.com/nonguix/nonguix/-/blob/master/nongnu/packages/linux.scm
(define-module (linux)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages linux)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system linux-module)
  #:use-module (guix build-system trivial))

(define (linux-urls version)
  "Return a list of URLS for Linux VERSION."
  (list (string-append "https://www.kernel.org/pub/linux/kernel/v"
                       (version-major version) ".x/linux-" version ".tar.xz")))

(define extra-config-options
  `(
    ; TODO:
    ; mount cgroup2 /sys/fs/cgroup
    ; (CONFIG_CGROUP_FREEZER, n)

    ; (CONFIG_FYZ, y)
  ))

(define (config->string options)
  (string-join
    (map
      (lambda (opt)
        (string-append
          (symbol->string (car opt)) "="
          (symbol->string (cadr opt))))
      options) "\n"))

(define (corrupt-linux freedo version hash)
  (package
    (inherit freedo)
    (name "linux-latest")
    (version version)
    (source
      (origin
        (method url-fetch)
        (uri (linux-urls version))
        (sha256 (base32 hash))))
    (arguments
      (substitute-keyword-arguments
        (package-arguments freedo)
          ((#:phases phases)
          `(modify-phases ,phases
            (replace 'configure
              (lambda* (#:key inputs native-inputs #:allow-other-keys)
                (let* ((kconfig (assoc-ref inputs "kconfig")))
                  ;; Avoid introducing timestamps
                  (setenv "KCONFIG_NOTIMESTAMP" "1")
                  (setenv "KBUILD_BUILD_TIMESTAMP" (getenv "SOURCE_DATE_EPOCH"))

                  (copy-file kconfig ".config")
                  (chmod ".config" #o666)

                  (let ((port (open-file ".config" "a"))
                        (extra-configuration ,(config->string extra-config-options)))
                    (display extra-configuration port)
                    (close-port port))

                  (invoke "make" "olddefconfig")
                  #t)))))))
     (native-inputs
       `(("gcc@11" ,gcc-11)
         ("kconfig" ,(local-file "kconfig"))
         ,@(package-native-inputs freedo)))))

(define-public linux-latest
  (corrupt-linux linux-libre "5.13"
     "1nc9didbjlycs9h8xahny1gwl8m8clylybnza6gl663myfbslsrz"))

(define-public linux-firmware
  (package
    (name "linux-firmware")
    (version "20210511")
    (source (origin
      (method url-fetch)
      (uri (string-append "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-" version ".tar.gz"))
      (sha256
        (base32
          "1i0ikbs0s9djq6jqg557j8wqw3vjspqh9249c0g93qkmayhycf2c"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (replace 'install
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out")))
               (invoke "make" "install"
                       (string-append "DESTDIR=" out)))))
         (delete 'validate-runpath))))
    (home-page "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git")
    (synopsis "Nonfree firmware blobs for Linux")
    (description "Nonfree firmware blobs for enabling support for various hardware in the Linux kernel.  This is a large package which may be overkill if your hardware is supported by one of the smaller firmware packages.")
    (license gpl2+)))
