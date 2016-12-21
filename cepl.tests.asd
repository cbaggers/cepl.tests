(asdf:defsystem #:cepl.tests
  :description "Tests for CEPL"
  :author "Chris Bagley (Baggers) <techsnuffle@gmail.com>"
  :license "BSD 2 Clause"
  :encoding :utf-8
  :serial t
  :depends-on (#:cepl #:fiveam #:cepl.sdl2)
  :components ((:file "tests/package")
               (:file "tests/tests")))
