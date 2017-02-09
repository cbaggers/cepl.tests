(in-package :cepl.tests)

;;------------------------------------------------------------
;; Helper macros

(defmacro ensure-cepl (&body body)
  `(progn
     (unless cepl.context:*gl-context*
       (cepl:repl))
     ,@body))

;;------------------------------------------------------------

(5am:def-suite test-all)

(5am:in-suite test-all)

(def-test g->-test-0 (:suite test-all)
  (ensure-cepl
    (let ((pipeline
           (g-> nil
             (glambda ((vert :vec4))
               vert)
             (glambda nil
               (v! 1 0 0 0)))))
      (is (not (null pipeline))))))
