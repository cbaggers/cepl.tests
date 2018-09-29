(in-package :cepl.tests)
(in-readtable :fn.reader)

;;------------------------------------------------------------

(def-test transform-feedback-0 (:suite cepl.transform-feedback)
  (ensure-cepl
    (with-free* ((tri-vert-stream
                  (make-buffer-stream
                   (make-gpu-array (list (v!  0.0   0.5  0.0  1.0)
                                         (v! -0.5  -0.5  0.0  1.0)
                                         (v!  0.5  -0.5  0.0  1.0))
                                   :element-type :vec4
                                   :dimensions 3)))
                 (feedback-vec3
                  (make-gpu-array nil :element-type :vec3 :dimensions 10))
                 (feedback-vec4
                  (make-gpu-array nil :element-type :vec4 :dimensions 10))
                 (pipeline
                  (pipeline-g ()
                    :vertex (lambda-g ((position :vec4) &uniform (pos :vec2))
                              (values ((:feedback 1) (+ position (v! pos 0 0)))
                                      ((:feedback 0) (v! 0.1 0 1))))
                    :fragment (lambda-g ((col :vec3))
                                (v! col 0)))))
      (let ((tfs (make-transform-feedback-stream feedback-vec3
                                                 feedback-vec4))
            (query (make-transform-feedback-primitives-written-query)))
        (with-gpu-query-bound (query)
          (with-transform-feedback (tfs)
            (map-g pipeline tri-vert-stream :pos (v! -0.1 0))
            (map-g pipeline tri-vert-stream :pos (v! -0.1 0))))
        (is (= 2 (pull-gpu-query-result query)))))))

;;------------------------------------------------------------

(def-test transform-feedback-1 (:suite cepl.transform-feedback)
  (ensure-cepl
    (with-free* ((tri-vert-stream
                  (make-buffer-stream
                   (make-gpu-array (list (v!  0.0   0.5  0.0  1.0)
                                         (v! -0.5  -0.5  0.0  1.0)
                                         (v!  0.5  -0.5  0.0  1.0))
                                   :element-type :vec4
                                   :dimensions 3)))
                 (feedback-vec4
                  (make-gpu-array nil :element-type :vec4 :dimensions 10))
                 (pipeline
                  (pipeline-g ()
                    :vertex (lambda-g ((position :vec4) &uniform (pos :vec2))
                              (values (:feedback position)))))
                 (draw-array (make-gpu-array
                              nil
                              :dimensions 2
                              :element-type 'arrays-indirect-command)))
      (let ((tfs (make-transform-feedback-stream feedback-vec4))
            (query (make-transform-feedback-primitives-written-query)))
        (with-gpu-array-as-c-array (carr draw-array)
          (let ((elem (aref-c carr 0)))
            (setf (arrays-indirect-command-count elem) 3
                  (arrays-indirect-command-first elem) 0
                  (arrays-indirect-command-base-instance elem) 0
                  (arrays-indirect-command-instance-count elem) 1))
          (let ((elem (aref-c carr 1)))
            (setf (arrays-indirect-command-count elem) 3
                  (arrays-indirect-command-first elem) 0
                  (arrays-indirect-command-base-instance elem) 0
                  (arrays-indirect-command-instance-count elem) 1)))
        (with-gpu-query-bound (query)
          (with-transform-feedback (tfs)
            (multi-map-g pipeline draw-array tri-vert-stream)))
        (is (= 2 (pull-gpu-query-result query)))))))
