(in-package :cepl.tests)
(in-readtable :fn.reader)

;;------------------------------------------------------------

(5am:def-suite cepl.misc)
(5am:in-suite cepl.misc)

;;------------------------------------------------------------

(defstruct-g (ssbo-test-data :layout std-430)
  (vals (:int 100)))

;;------------------------------------------------------------

(def-test fbo-0 (:suite cepl.fbos)
  (ensure-cepl
    (with-free* ((data (make-gpu-array nil :dimensions 1
                                       :element-type 'ssbo-test-data))
                 (ssbo (make-ssbo data))
                 (pipeline
                  (pipeline-g ()
                    :compute
                    (lambda-g (&uniform (woop ssbo-test-data :ssbo :std-430))
                      (declare (local-size :x 1 :y 1 :z 1))
                      (setf (aref (ssbo-test-data-vals woop)
                                  (int (x gl-work-group-id)))
                            (int (x gl-work-group-id)))
                      (values)))))
      (map-g pipeline (make-compute-space 100)
             :woop ssbo)
      (wait-on-gpu-fence (make-gpu-fence))
      (with-gpu-array-as-c-array (carr data)
        (let ((0-to-99-inclusive (alexandria:iota 100)))
          (is (equal 0-to-99-inclusive
                     (pull-g (ssbo-test-data-vals (aref-c carr 0))))))))))
