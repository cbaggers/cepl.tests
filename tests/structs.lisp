(in-package :cepl.tests)
(in-readtable :fn.reader)

;;------------------------------------------------------------

(5am:def-suite cepl.types)
(5am:in-suite cepl.types)

;;------------------------------------------------------------

(defstruct-g test-struct-0
  (foo :uint)
  (bar (:uint 10)))

(defstruct-g (test-struct-1 :layout std-140)
  (foo :uint)
  (bar (:uint 10)))

(def-test structs-0 (:suite cepl.types)
  (ensure-cepl
    (let ((data (loop :for i :below 3 :collect
                   (list i (loop :for x :below 10 :collect x)))))
      (with-free* ((arr (make-gpu-array data
                                        :dimensions 3
                                        :element-type 'test-struct-0)))
        (is (equal data (pull-g arr)))))))

(def-test structs-1 (:suite cepl.types)
  (ensure-cepl
    (handler-case
        (with-free* ((pipeline
                      (pipeline-g ()
                        :compute
                        (lambda-g (&uniform (woop test-struct-1))
                          (declare (local-size :x 1 :y 1 :z 1))
                          (values)))))
          (fail "should have failed as doesnt specify :ubo or :ssbo"))
      (cepl.errors:invalid-layout-for-inargs ()
        (pass)))))

(def-test structs-2 (:suite cepl.types)
  (ensure-cepl
    (with-free* ((pipeline-0
                  (pipeline-g ()
                    :compute
                    (lambda-g (&uniform (woop test-struct-1 :ssbo))
                      (declare (local-size :x 1 :y 1 :z 1))
                      (values))))
                 (pipeline-1
                  (pipeline-g ()
                    :compute
                    (lambda-g (&uniform (woop test-struct-1 :ubo))
                      (declare (local-size :x 1 :y 1 :z 1))
                      (values)))))
      (pass))))

;;------------------------------------------------------------
