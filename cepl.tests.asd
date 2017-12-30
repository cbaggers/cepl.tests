(asdf:defsystem #:cepl.tests
  :description "Tests for CEPL"
  :author "Chris Bagley (Baggers) <techsnuffle@gmail.com>"
  :license "BSD 2 Clause"
  :encoding :utf-8
  :serial t
  :depends-on (#:cepl #:fiveam #:cepl.sdl2)
  :components ((:file "package")
               (:file "helpers")
               (:file "tests/cepl-internals")
               (:file "tests/buffer-backed-gpu-arrays")
               (:file "tests/structs")
               (:file "tests/single-stage-pipelines")
               (:file "tests/fbos")
               (:file "tests/blending")
               (:file "tests/textures")
               (:file "tests/ssbos")
               (:file "tests/transform-feedback")
               (:file "tests/misc")))
