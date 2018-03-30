(in-package :cepl.tests)
(in-readtable :fn.reader)

;;------------------------------------------------------------
;; make an incomplete pipeline

(defun-g bake-frag-0 ((uv :vec2)
                      &uniform
                      (foo (function (:vec2) :vec4)))
  (funcall foo uv))

(defpipeline-g bake-pipeline-0 (:points)
  :fragment (bake-frag-0 :vec2))

(defun-g bake-frag-1 ((uv :vec2)
                      &uniform
                      (foo (function (:vec2) :vec4))
                      (blarp :float))
  (* (funcall foo uv) blarp))

(defpipeline-g bake-pipeline-1 (:points)
  :fragment (bake-frag-1 :vec2))

;;------------------------------------------------------------
;; helper functions

(defun-g bake-func-1 ((val :vec2))
  (v! val val))

;;------------------------------------------------------------

(def-test bake-0 (:suite cepl.pipelines)
  (ensure-cepl
    (with-free* ((fbo (make-fbo '(0 :dimensions (4 4) :element-type :vec4)))
                 (pipeline (bake-uniforms #'bake-pipeline-0
                                          :foo (gpu-function (bake-func-1 :vec2))))
                 (bs (make-buffer-stream nil :primitive :points)))
      (with-fbo-bound (fbo)
        (map-g (the function pipeline) bs))
      (let* ((data (car (pull-g (attachment fbo 0)))))
        (loop :for vec :in data :do
           (is (and (= (x vec) (z vec))
                    (= (y vec) (w vec)))))))))

(def-test bake-1 (:suite cepl.pipelines)
  (ensure-cepl
    (let ((glam (lambda-g ((val :vec2))
                  (s~ val :xxyy))))
      (with-free* ((fbo (make-fbo '(0 :dimensions (4 4) :element-type :vec4)))
                   (bs (make-buffer-stream nil :primitive :points))
                   ;;
                   (pipeline (bake-uniforms #'bake-pipeline-0 :foo glam)))
        (with-fbo-bound (fbo)
          (map-g (the function pipeline) bs))
        (let* ((data (car (pull-g (attachment fbo 0)))))
          (loop :for vec :in data :do
             (is (and (= (x vec) (y vec))
                      (= (z vec) (w vec))))))))))

(def-test bake-2 (:suite cepl.pipelines)
  (ensure-cepl
    (let ((glam (lambda-g ((val :vec2))
                  (s~ val :xxyy))))
      (with-free* ((fbo (make-fbo '(0 :dimensions (4 4) :element-type :vec4)))
                   (bs (make-buffer-stream nil :primitive :points))
                   ;;
                   (pipeline (bake-uniforms #'bake-pipeline-1 :foo glam)))
        (with-fbo-bound (fbo)
          (map-g (the function pipeline) bs
                 :blarp 2f0))
        (let* ((data (car (pull-g (attachment fbo 0)))))
          (loop :for vec :in data :do
             (is (and (= (x vec) (y vec))
                      (= (z vec) (w vec))))))))))
