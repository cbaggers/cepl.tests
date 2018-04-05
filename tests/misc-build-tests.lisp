(in-package :cepl.tests)
(in-readtable :fn.reader)

;;------------------------------------------------------------

(def-test misc-build-0 (:suite cepl.textures)
  (finishes
    (ensure-cepl
      (with-free* ((pipeline
                    (pipeline-g ()
                      (lambda-g ((v :vec2)) (vec4 v 0 1))
                      (lambda-g () (discard)))))
        (map-g pipeline nil)))))
