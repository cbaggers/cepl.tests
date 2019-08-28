(in-package :cepl.tests)
(in-readtable :fn.reader)

;;------------------------------------------------------------

(defstruct-g (ssbo-test-data :layout std-430)
  (vals (:int 100)))

(defstruct-g (ssbo-test-data2 :layout std-430)
  (vals (:mat4 100)))

;;------------------------------------------------------------

(def-test ssbos-0 (:suite cepl.fbos)
  (ensure-cepl
   (when (gl>= 4.3)
     (with-free* ((data (make-gpu-array nil :dimensions 1
                                        :element-type 'ssbo-test-data))
                  (ssbo (make-ssbo data))
                  (pipeline
                   (pipeline-g ()
                     :compute
                     (lambda-g (&uniform (woop ssbo-test-data :ssbo))
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
                      (pull-g (ssbo-test-data-vals (aref-c carr 0)))))))))))

(def-test ssbos-1 (:suite cepl.fbos)
  (ensure-cepl
   (when (gl>= 4.3)
     (with-free* ((ssbo (make-ssbo nil 'ssbo-test-data2))
                  (pipeline
                   (pipeline-g ()
                     :compute
                     (lambda-g (&uniform (woop ssbo-test-data2 :ssbo))
                       (declare (local-size :x 1 :y 1 :z 1))
                       (setf (aref (ssbo-test-data2-vals woop)
                                   (int (x gl-global-invocation-id)))
                             (mat4 1))
                       (values)))))
       (map-g pipeline (make-compute-space 100)
              :woop ssbo)
       (wait-on-gpu-fence (make-gpu-fence))
       (let* ((results (first (pull-g ssbo)))
              (id (m4:identity))
              (issues (remove-if (lambda (x) (m4:= x id)) results)))
         (is (null issues)))))))
