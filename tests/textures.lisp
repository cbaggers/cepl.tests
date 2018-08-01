(in-package :cepl.tests)
(in-readtable :fn.reader)

;;------------------------------------------------------------

(def-test textures-0 (:suite cepl.textures)
  (ensure-cepl
    (let ((data (list (v!uint8 255 0 0)
                      (v!uint8 0 255 0)
                      (v!uint8 0 0 255))))
      (with-free* ((tex (make-texture data :element-type :rgb8)))
        (let* ((pulled (pull-g tex))
               (src (mapcar λ(coerce _ 'list) data))
               (dst (mapcar λ(coerce _ 'list) pulled)))
          (is (equal src dst)))))))

;; (def-test textures-1 (:suite cepl.textures)
;;   (let ((data '((255 0 0)
;;                 (0 255 0)
;;                 (0 0 255))))
;;     (with-free* ((tex (make-texture data :element-type :rgb8))
;;                  (pulled (pull-g tex))
;;                  (pulled-lists (mapcar λ(coerce _ 'list) pulled)))
;;       (is (equal data pulled-lists)))))

(defun check-upload-blit-pull-with-alignment (alignment)
  (let* ((data (loop :for i :below 5 :collect
                    (loop :for j :below 5 :collect
                         (if (oddp i)
                             (v!uint8 255 0)
                             (v!uint8 0 0)))))
         (lisp-arr (make-array '(5 5) :initial-contents data)))
    (with-free* ((c-arr (make-c-array lisp-arr :row-alignment alignment
                                      :element-type :uint8-vec2))
                 (tex (make-texture c-arr :element-type :rg8))
                 (sam (sample tex
                              :minify-filter :nearest-mipmap-nearest
                              :magnify-filter :nearest))
                 (pline
                  (pipeline-g (:points)
                    :fragment
                    (lambda-g ((uv :vec2) &uniform (sam :sampler-2d))
                      (texture sam uv))))
                 (bs (make-buffer-stream nil :primitive :points))
                 (fbo (make-fbo (list 0 :element-type :rg8 :dimensions '(5 5)))))
      (map-g-into fbo pline bs :sam sam)
      (let ((pulled (pull-g (attachment fbo 0))))
        (values (equalp data pulled)
                data
                pulled)))))

(def-test textures-2 (:suite cepl.textures)
  (ensure-cepl
    (is-true (check-upload-blit-pull-with-alignment 1))))

(def-test textures-3 (:suite cepl.textures)
  (ensure-cepl
    (is-true (check-upload-blit-pull-with-alignment 2))))

(def-test textures-4 (:suite cepl.textures)
  (ensure-cepl
    (is-true (check-upload-blit-pull-with-alignment 4))))

(def-test textures-5 (:suite cepl.textures)
  (ensure-cepl
    (is-true (check-upload-blit-pull-with-alignment 8))))
