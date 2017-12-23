(in-package :cepl.tests)

;;------------------------------------------------------------

(5am:def-suite cepl.pipelines)
(5am:in-suite cepl.pipelines)

;;------------------------------------------------------------

(def-test ssp-0 (:suite cepl.pipelines)
  (with-free* ((pipeline (pipeline-g ()
                           :vertex (lambda-g ((vert :vec2))
                                     (v! vert 0 1)))))
    (is (not (null pipeline)))))

;;------------------------------------------------------------

(def-test ssp-1 (:suite cepl.pipelines)
  (with-free* ((pipeline (pipeline-g ()
                           :fragment (lambda-g ()
                                       (v! 1 0 1 0)))))
    (is (not (null pipeline)))))

;;------------------------------------------------------------
