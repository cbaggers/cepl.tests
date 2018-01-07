(in-package :cepl.tests)
(in-readtable :fn.reader)

;;------------------------------------------------------------

(def-test blending-0 (:suite cepl.blending)
  (ensure-cepl
    (with-free* ((fbo (make-fbo '(0 :dimensions (4 4))))
                 (pipeline (pipeline-g (:points)
                             :fragment (lambda-g ((uv :vec2))
                                         (v! 0.2 0 0 1))))
                 (bs (make-buffer-stream nil :primitive :points)))
      (let ((bp (make-blending-params :source-rgb :one
                                      :source-alpha :zero
                                      :destination-rgb :one
                                      :destination-alpha :zero
                                      :mode-rgb :func-add
                                      :mode-alpha :func-add)))
        (with-blending bp
          (with-fbo-bound (fbo)
            (clear-fbo fbo)
            (map-g pipeline bs)
            (map-g pipeline bs))))
      (let* ((data (pull-g (attachment fbo 0)))
             (elem (caar data))
             ;; 102 = (* 255 0.2 2)
             (target (v!uint8 102 0 0 0)))
        (is (every #'equal elem target))))))
;;------------------------------------------------------------
