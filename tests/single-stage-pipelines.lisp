(in-package :cepl.tests)
(in-readtable :fn.reader)

;;------------------------------------------------------------

(def-test ssp-0 (:suite cepl.pipelines)
  (ensure-cepl
    (with-free* ((pipeline (pipeline-g ()
                             :vertex (lambda-g ((vert :vec2))
                                       (v! vert 0 1)))))
      (is (not (null pipeline))))))

;;------------------------------------------------------------

(def-test ssp-1 (:suite cepl.pipelines)
  (ensure-cepl
    (with-free* ((pipeline (pipeline-g ()
                             :fragment (lambda-g ((uv :vec2))
                                         (v! 1 0 1 0)))))
      (is (not (null pipeline))))))

;;------------------------------------------------------------

(def-test ssp-2 (:suite cepl.pipelines)
  (ensure-cepl
    (with-free* ((fbo (make-fbo '(0 :dimensions (4 4))))
                 (bs (make-buffer-stream nil :primitive :points))
                 (pipeline (pipeline-g (:points)
                             :fragment (lambda-g ((uv :vec2))
                                         (v! 1 0 0 0)))))
      (map-g-into fbo pipeline bs)
      (let* ((data (pull-g (attachment fbo 0)))
             (elem (caar data)))
        (is (every #'equal (v!uint8 255 0 0 0) elem))))))

;;------------------------------------------------------------

(def-test ssp-3 (:suite cepl.pipelines)
  (ensure-cepl
    (with-free* ((fbo (make-fbo '(0 :dimensions (4 4))))
                 (bs (make-buffer-stream
                      (make-gpu-array (list (v! 1 2 3))
                                      :element-type :vec3)
                      :primitive :points))
                 (dest-arr (make-gpu-array nil :dimensions 1
                                           :element-type :vec3))
                 (pipeline (pipeline-g (:points)
                             :vertex (lambda-g ((uv :vec3))
                                       (values (v! uv 1)
                                               (:feedback uv))))))
      (let ((tfs (make-transform-feedback-stream dest-arr)))
        (with-transform-feedback (tfs)
          (map-g pipeline bs))
        (v3:= (first (pull-g dest-arr))
              (v! 1 2 3))))))

;;------------------------------------------------------------

(def-test ssp-4 (:suite cepl.pipelines)
  (ensure-cepl
    (signals varjo-conditions:args-incompatible
      (with-free* ((pipeline (pipeline-g ()
                               :fragment (lambda-g ()
                                           (v! 1 0 1 0)))))
        nil))))
