(in-package :cepl.tests)

;;------------------------------------------------------------
;; Helper macros

(defmacro ensure-cepl (&body body)
  `(progn
     (when (cepl.lifecycle:uninitialized-p)
       (cepl:repl))
     ,@body))

(defmacro with-free (name thing &body body)
  (let ((name (or name (gensym "thing"))))
    `(let ((,name ,thing))
       (unwind-protect (progn ,@body)
         (free ,name)))))

;;------------------------------------------------------------

(5am:def-suite test-all)

(5am:in-suite test-all)

(def-test g->-test-0 (:suite test-all)
  (ensure-cepl
    (let ((pipeline
           (pipeline-g nil
             (glambda ((vert :vec4))
               vert)
             (glambda nil
               (v! 1 0 0 0)))))
      (is (not (null pipeline))))))

(def-test gpu-array-0 (:suite test-all)
  (let ((data '(1 2 3 4 5)))
    (ensure-cepl
      (with-free arr (make-gpu-array data)
        (is (equal data (pull-g arr)))))))

(def-test gpu-array-1 (:suite test-all)
  (let ((data '(1 2 3 4 5 6)))
    (ensure-cepl
      (with-free arr (make-gpu-array data)
        (with-gpu-array-as-c-array (carr arr)
          (is (equal data (pull-g carr))))))))

(def-test gpu-array-2 (:suite test-all)
  (let ((data '(1 2 3 4 5 6)))
    (ensure-cepl
      (with-free arr (make-gpu-array data)
        (cepl.gpu-arrays:with-gpu-array-range-as-c-array (carr arr 1 3)
          (is (equal (subseq data 1 4) (pull-g carr))))))))
