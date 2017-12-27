(uiop:define-package #:cepl.tests
    (:use #:cl #:cepl #:rtg-math :varjo #:rtg-math.base-maths #:fiveam
          #:named-readtables)
  (:import-from :varjo :glsl-code)
  (:import-from :alexandria
                :with-gensyms)
  (:export))
