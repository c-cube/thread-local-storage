(lang dune 2.0)
(name thread-local-storage)
(version 0.2)
(generate_opam_files true)

(source
 (github c-cube/thread-local-storage))
(authors "Vesa Karvonen")
(maintainers "Simon Cruanes")
(license MIT)

(documentation https://c-cube.github.io/thread-local-storage)

(package
 (name thread-local-storage)
 (synopsis "Efficient thread local storage for OCaml")
 (depends (ocaml (>= 4.08)) (dune (>= 2.0)))
 (tags
  (topics threads tls)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
