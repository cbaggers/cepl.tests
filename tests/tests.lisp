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

(5am:test g->-test-0
  (ensure-cepl
    (let ((pipeline
           (g-> ()
             (glambda ((vert :vec4))
               vert)
             (glambda ()
               (v! 1 0 0 0)))))
      (is (not (null pipeline))))))
